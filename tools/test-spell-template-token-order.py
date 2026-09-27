"""Exercise verified spell templates whose Italian text reorders DB2 values."""

import importlib.util
from pathlib import Path
import sys
import unittest

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
sys.path.insert(0, str(ROOT / "tools"))
spec = importlib.util.spec_from_file_location(
    "spell_renderability_checker", Path(__file__).with_name("check-spell-renderability.py")
)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class ReorderedSpellTemplateTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.ns = self.lua.table()
        self.lua.execute(
            """
            WFI_DB = {}
            issecretvalue = function() return false end
            InCombatLockdown = function() return false end
            UnitName = function() return "Testplayer" end
            UnitClass = function() return "Warrior", "WARRIOR" end
            UnitRace = function() return "Human", "HUMAN" end
            CreateFrame = function()
                local frame = { RegisterEvent=function() end,
                    UnregisterEvent=function() end,
                    SetScript=function(self, event, callback) self[event]=callback end }
                lastFrame = frame
                return frame
            end
            TooltipDataProcessor = {
                AddTooltipPostCall=function(_, callback) spellCallback=callback end,
            }
            Enum = { TooltipDataType = { Spell=2 } }
            makeText = function(value)
                return { text=value, GetText=function(self) return self.text end,
                    SetText=function(self, value) self.text=value end,
                    IsProtected=function() return false end }
            end
            fireSpell = function(id, name, body)
                ProbeTooltipTextLeft1=makeText(name)
                ProbeTooltipTextLeft2=makeText(body)
                spellCallback({GetName=function() return "ProbeTooltip" end}, {id=id})
                return ProbeTooltipTextLeft2.text
            end
            """
        )
        toc = (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig")
        for row in toc.splitlines():
            name = row.strip()
            if name == "Core.lua" or (name.startswith("Data\\") and name.endswith(".lua")):
                self.lua.execute(
                    (ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                    "WOWForverItaliano",
                    self.ns,
                )
        self.lua.execute(
            (ADDON / "Modules/Spells.lua").read_text(encoding="utf-8"),
            "WOWForverItaliano",
            self.ns,
        )
        self.lua.execute('lastFrame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')

    def test_reordered_numeric_duration_and_conditional_tokens(self):
        spell_ids = (
            1219557, 415405, 417157, 1310076, 1292142, 1259907, 467329,
            473399, 1219552, 470246, 470240, 439745, 426490, 408248,
        )
        for spell_id in spell_ids:
            with self.subTest(spell_id=spell_id):
                entry = self.ns.data.spellDescriptionOverrides[spell_id]
                source = checker.render_source(spell_id, entry.en)
                self.assertIsNotNone(source)
                spell = self.ns.data.spells[spell_id]
                name = spell.en if spell is not None else "Unmapped spell"
                result = self.lua.globals().fireSpell(spell_id, name, source)
                self.assertNotEqual(result, source)
                self.assertNotIn("$", result)


if __name__ == "__main__":
    unittest.main()
