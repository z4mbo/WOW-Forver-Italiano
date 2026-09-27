"""Mock the beta's empty spell-description API and spellbook tooltip."""

import unittest
from pathlib import Path

from lupa import LuaRuntime


ADDON = Path(__file__).resolve().parent.parent / "Addon"


class MissingSpellBodyTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.ns = self.lua.table()
        self.lua.execute(
            """
            WFI_DB = {}
            issecretvalue = function() return false end
            locked = false
            InCombatLockdown = function() return locked end
            clientDescription = ""
            C_Spell = { GetSpellDescription = function() return clientDescription end }
            CreateFrame = function()
                local frame = {
                    RegisterEvent = function() end,
                    UnregisterEvent = function() end,
                    SetScript = function(self, event, callback) self[event] = callback end,
                }
                lastFrame = frame
                return frame
            end
            callbacks = {}
            TooltipDataProcessor = {
                AddTooltipPostCall = function(kind, callback) callbacks[kind] = callback end,
            }
            Enum = {
                TooltipDataType = { Spell = 2, SpellBookItem = 3 },
                SpellBookSpellBank = { Player = 1 },
            }
            C_SpellBook = {
                GetSpellBookItemInfo = function(slot, bank)
                    if slot == 12 and bank == 1 then return { spellID = bookSpellID } end
                end,
            }
            makeLine = function(value, red, green, blue)
                return {
                    text = value, red = red, green = green, blue = blue,
                    GetText = function(self) return self.text end,
                    SetText = function(self, text) self.text = text end,
                    GetTextColor = function(self) return self.red, self.green, self.blue end,
                    IsProtected = function() return false end,
                }
            end
            tooltip = {
                count = 0, added = 0,
                GetName = function() return "GameTooltip" end,
                NumLines = function(self) return self.count end,
                GetOwner = function(self) return self.owner end,
                IsShown = function() return true end,
                HookScript = function(self, event, callback) self[event] = callback end,
                AddLine = function(self, text, red, green, blue)
                    self.count = self.count + 1
                    self.added = self.added + 1
                    _G["GameTooltipTextLeft" .. self.count] =
                        makeLine(text, red, green, blue)
                end,
            }
            GameTooltip = tooltip
            local book = {}
            PlayerSpellsFrame = { SpellBookFrame = book }
            local item = { slotIndex = 12, spellBank = 1,
                GetParent = function() return book end }
            local button = { GetParent = function() return item end }
            item.Button = button
            tooltip.owner = button
            bookItem = item
            bookButton = button
            fire = function(kind, id, name, body, actualBookID, footer)
                tooltip.count, tooltip.added = 3, 0
                bookSpellID = actualBookID or id
                item.spellBookItemInfo = { spellID = bookSpellID }
                GameTooltipTextLeft1 = makeLine(name, 1, 1, 1)
                GameTooltipTextLeft2 = makeLine("Instant", 1, 1, 1)
                GameTooltipTextLeft3 = makeLine("2 min cooldown", 1, 1, 1)
                if body then
                    tooltip.count = 4
                    GameTooltipTextLeft4 = makeLine(body, 1, 0.82, 0)
                end
                if footer then
                    tooltip.count = tooltip.count + 1
                    _G["GameTooltipTextLeft" .. tooltip.count] =
                        makeLine("Press F6 to submit an issue for this Spell", 1, 0.82, 0)
                end
                callbacks[kind](tooltip, { id = id })
                return tooltip.added
            end
            """
        )
        for name in (
            "Core.lua",
            "Data/SpellsClasses.lua",
            "Data/VerifiedSpellDescriptionsBatch.lua",
            "Modules/Spells.lua",
        ):
            self.lua.execute((ADDON / name).read_text(encoding="utf-8"),
                             "WOWForverItaliano", self.ns)
        self.lua.execute('lastFrame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')

    def test_missing_static_body_is_added_without_changing_metadata(self):
        g = self.lua.globals()
        # TooltipData's ID can be a slot index; the stock item resolves 7744.
        self.assertEqual(g.fire(3, 12, "Will of the Forsaken", None, 7744), 1)
        self.assertEqual(g.GameTooltipTextLeft2.text, "Instant")
        self.assertEqual(g.GameTooltipTextLeft3.text, "2 min cooldown")
        self.assertEqual(g.GameTooltipTextLeft4.text,
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        self.assertEqual(g.GameTooltipTextLeft4.green, 0.82)
        # A second callback on the same tooltip must not append a duplicate.
        g.callbacks[2](g.tooltip, self.lua.table(id=7744))
        self.assertEqual(g.tooltip.added, 1)

    def test_present_body_and_client_description_block_insertion(self):
        g = self.lua.globals()
        source = "Instantly removes all Charm, Fear and Sleep effects."
        self.assertEqual(g.fire(2, 7744, "Will of the Forsaken", source), 0)
        self.assertEqual(g.GameTooltipTextLeft4.text,
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        g.clientDescription = source
        self.assertEqual(g.fire(2, 7744, "Will of the Forsaken", None), 0)
        self.assertEqual(g.tooltip.count, 3)

    def test_id_name_and_dynamic_template_guards(self):
        g = self.lua.globals()
        self.assertEqual(g.fire(3, 20577, "Cannibalize", None), 0)
        self.assertEqual(g.fire(3, 7744, "Unrelated spell", None), 0)
        self.assertEqual(g.fire(3, 99999, "Will of the Forsaken", None), 0)
        self.assertEqual(g.fire(3, 7744, "Will of the Forsaken", None, 99999), 0)
        g.locked = True
        self.assertEqual(g.fire(3, 7744, "Will of the Forsaken", None), 0)

    def test_yellow_issue_reporter_footer_is_not_a_description(self):
        g = self.lua.globals()
        self.assertEqual(g.fire(3, 12, "Will of the Forsaken", None, 7744, True), 1)
        self.assertEqual(g.GameTooltipTextLeft4.text,
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        self.assertEqual(g.GameTooltipTextLeft5.text,
                         "Press F6 to submit an issue for this Spell")

    def test_game_tooltip_observer_handles_italian_title_without_data_postcall(self):
        g = self.lua.globals()
        g.bookSpellID = 7744
        g.bookItem.spellBookItemInfo = self.lua.table(spellID=7744)
        g.tooltip.count = 4
        g.tooltip.added = 0
        g.GameTooltipTextLeft1 = g.makeLine("Volontà dei Reietti", 1, 1, 1)
        g.GameTooltipTextLeft2 = g.makeLine("Instantaneo", 1, 1, 1)
        g.GameTooltipTextLeft3 = g.makeLine("", 1, 1, 1)
        g.GameTooltipTextLeft4 = g.makeLine(
            "Press F6 to submit an issue for this Spell", 1, 0.82, 0)
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 1)
        self.assertEqual(g.GameTooltipTextLeft4.text,
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        self.assertEqual(g.GameTooltipTextLeft5.text,
                         "Press F6 to submit an issue for this Spell")
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 1)

        # A later update must not change a tooltip with a different owner.
        g.tooltip.count = 4
        g.tooltip.added = 0
        g.tooltip.owner = None
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 0)

    def test_game_tooltip_observer_requires_verified_owner_and_slot(self):
        g = self.lua.globals()
        g.bookSpellID = 99999
        g.bookItem.spellBookItemInfo = self.lua.table(spellID=99999)
        g.tooltip.count = 4
        g.GameTooltipTextLeft1 = g.makeLine("Volontà dei Reietti", 1, 1, 1)
        g.GameTooltipTextLeft2 = g.makeLine("Instantaneo", 1, 1, 1)
        g.GameTooltipTextLeft3 = g.makeLine("", 1, 1, 1)
        g.GameTooltipTextLeft4 = g.makeLine(
            "Press F6 to submit an issue for this Spell", 1, 0.82, 0)
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 0)
        g.bookSpellID = 7744
        g.bookItem.spellBookItemInfo = self.lua.table(spellID=7744)
        g.tooltip.owner = None
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 0)

    def test_game_tooltip_observer_ignores_yellow_spacer(self):
        g = self.lua.globals()
        self.ns.data.ui = self.lua.table()
        self.ns.data.ui["Press F6 to submit an issue for this Spell"] = (
            "Premi F6 per segnalare un problema con questo incantesimo")
        g.bookSpellID = 7744
        g.bookItem.spellBookItemInfo = self.lua.table(spellID=7744)
        g.tooltip.count = 4
        g.tooltip.added = 0
        g.GameTooltipTextLeft1 = g.makeLine("Volontà dei Reietti", 1, 1, 1)
        g.GameTooltipTextLeft2 = g.makeLine("Istantaneo", 1, 1, 1)
        # Live beta renders the cooldown elsewhere; left line 3 is yellow " ".
        g.GameTooltipTextLeft3 = g.makeLine(" ", 1, 0.8235294, 0)
        g.GameTooltipTextLeft4 = g.makeLine(
            "|cff3b82f6Press F6 to submit an issue for this Spell", 1, 0.82, 0)
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 1)
        self.assertEqual(g.GameTooltipTextLeft3.text, " ")
        self.assertEqual(g.GameTooltipTextLeft4.text,
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        self.assertEqual(g.GameTooltipTextLeft5.text,
                         "|cff3b82f6Premi F6 per segnalare un problema con questo incantesimo")

    def test_game_tooltip_observer_does_not_duplicate_unknown_yellow_body(self):
        g = self.lua.globals()
        g.bookSpellID = 7744
        g.bookItem.spellBookItemInfo = self.lua.table(spellID=7744)
        g.tooltip.count = 4
        g.tooltip.added = 0
        g.GameTooltipTextLeft1 = g.makeLine("Volontà dei Reietti", 1, 1, 1)
        g.GameTooltipTextLeft2 = g.makeLine("Istantaneo", 1, 1, 1)
        g.GameTooltipTextLeft3 = g.makeLine("Other description", 1, 0.8235294, 0)
        g.GameTooltipTextLeft4 = g.makeLine(
            "Press F6 to submit an issue for this Spell", 1, 0.82, 0)
        g.tooltip.OnUpdate(g.tooltip, 0.11)
        self.assertEqual(g.tooltip.added, 0)


if __name__ == "__main__":
    unittest.main()
