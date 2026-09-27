"""Focused checks for exact-tag, exact-source GlobalStrings replacement."""

import unittest
from pathlib import Path

from lupa import LuaRuntime


SOURCE = (Path(__file__).resolve().parents[1] / "Addon" / "Modules" /
          "GlobalStrings.lua").read_text(encoding="utf-8")


class GlobalStringsTests(unittest.TestCase):
    def test_exact_source_and_combat_guard(self):
        lua = LuaRuntime(unpack_returned_tuples=True)
        lua.execute("""
            MANA_COLON = "Mana:"
            NO = "Already localized"
            CORRUPT = "Wrong beta Italian"
            VOICEMACRO_15_Hu_0_FEMALE = "Voice line"
            IN_COMBAT = false
            InCombatLockdown = function() return IN_COMBAT end
            CreateFrame = function()
                local frame = {
                    RegisterEvent = function() end,
                    SetScript = function(self, _, callback) self.OnEvent = callback end,
                }
                lastFrame = frame
                return frame
            end
        """)
        ns = lua.table()
        ns.data = lua.table(globalStrings=lua.table())
        ns.data.globalStrings.MANA_COLON = lua.table(en="Mana:", it="Mana:")
        ns.data.globalStrings.NO = lua.table(en="No", it="No")
        ns.data.globalStrings.CORRUPT = lua.table(
            en="Correct English", badIt="Wrong beta Italian", it="Italiano corretto")
        ns.data.globalStrings.VOICEMACRO_15_Hu_0_FEMALE = lua.table(
            en="Voice line", it="Battuta")
        ns.safeText = lua.eval('function(value) return type(value) == "string" and value ~= "" and value or nil end')
        ns.enabled = lua.eval('function() return true end')
        lua.execute(SOURCE, "WOWForverItaliano", ns)
        frame = lua.globals().lastFrame
        frame.OnEvent(frame, "ADDON_LOADED", "OtherAddon")
        self.assertEqual(lua.globals().MANA_COLON, "Mana:")
        # The same-value fixture is replaced with a visible Italian value.
        ns.data.globalStrings.MANA_COLON.it = "Mana locale:"
        lua.execute("IN_COMBAT = true")
        frame.OnEvent(frame, "ADDON_LOADED", "WOWForverItaliano")
        self.assertEqual(lua.globals().MANA_COLON, "Mana:")
        lua.execute("IN_COMBAT = false")
        frame.OnEvent(frame, "PLAYER_REGEN_ENABLED")
        self.assertEqual(lua.globals().MANA_COLON, "Mana locale:")
        self.assertEqual(lua.globals().NO, "Already localized")
        self.assertEqual(lua.globals().CORRUPT, "Italiano corretto")
        self.assertEqual(lua.globals().VOICEMACRO_15_Hu_0_FEMALE, "Battuta")


if __name__ == "__main__":
    unittest.main()
