"""Check that an item description can translate without changing its name."""

import unittest
from pathlib import Path

from lupa import LuaRuntime


ADDON = Path(__file__).resolve().parents[1] / "Addon"


class ItemDescriptionOverrideTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.ns = self.lua.table()
        self.lua.execute(
            """
            WFI_DB = {}
            issecretvalue = function() return false end
            InCombatLockdown = function() return false end
            CreateFrame = function()
                local frame = {
                    RegisterEvent = function() end,
                    UnregisterEvent = function() end,
                    SetScript = function(self, event, callback) self[event] = callback end,
                }
                lastFrame = frame
                return frame
            end
            TooltipDataProcessor = {
                AddTooltipPostCall = function(_, callback) itemCallback = callback end,
            }
            Enum = { TooltipDataType = { Item = 1 } }
            makeText = function(value)
                return { text = value,
                    GetText = function(self) return self.text end,
                    SetText = function(self, nextValue) self.text = nextValue end,
                    IsProtected = function() return false end }
            end
            showItem = function(id, name, body)
                ItemTooltipTextLeft1 = makeText(name)
                ItemTooltipTextLeft2 = makeText(body)
                itemCallback({ GetName = function() return "ItemTooltip" end }, { id = id })
                return ItemTooltipTextLeft1.text, ItemTooltipTextLeft2.text
            end
            """
        )
        for name in ("Core.lua", "Modules/Items.lua"):
            self.lua.execute((ADDON / name).read_text(encoding="utf-8"),
                             "WOWForverItaliano", self.ns)
        self.ns.data.itemDescriptionOverrides = self.lua.table()
        self.ns.data.itemDescriptionOverrides[25] = self.lua.table(
            enName="Worn Shortsword", itName="Spada Corta Consunta",
            enDescription="A battered sword.", description="Una spada malridotta."
        )
        self.lua.execute('lastFrame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')

    def test_exact_item_id_and_source_name(self):
        show = self.lua.globals().showItem
        self.assertEqual(show(25, "Worn Shortsword", "A battered sword."),
                         ("Worn Shortsword", "Una spada malridotta."))
        self.assertEqual(show(25, "Spada Corta Consunta", "A battered sword."),
                         ("Spada Corta Consunta", "Una spada malridotta."))
        self.assertEqual(show(26, "Worn Shortsword", "A battered sword."),
                         ("Worn Shortsword", "A battered sword."))
        self.assertEqual(show(25, "Different sword", "A battered sword."),
                         ("Different sword", "A battered sword."))
        self.assertEqual(show(25, "Worn Shortsword", "A different sword."),
                         ("Worn Shortsword", "A different sword."))
        self.ns.data["items"] = self.lua.table()
        self.ns.data["items"][25] = self.lua.table(
            en="Worn Shortsword", itSource="Unrelated beta label",
            name="Spada Corta Consunta",
        )
        self.assertEqual(show(25, "Unrelated beta label", "A battered sword."),
                         ("Spada Corta Consunta", "Una spada malridotta."))
        self.assertEqual(show(26, "Unrelated beta label", "A battered sword."),
                         ("Unrelated beta label", "A battered sword."))

    def test_official_item_name_reuse(self):
        self.lua.execute(
            (ADDON / "Data/ItemNameTranslationMemory.lua").read_text(encoding="utf-8"),
            "WOWForverItaliano", self.ns)
        show = self.lua.globals().showItem
        self.assertEqual(show(2444, "Ornate Buckler", "Unchanged body"),
                         ("Brocchiero Decorato", "Unchanged body"))
        self.assertEqual(show(2444, "Other shield", "Unchanged body"),
                         ("Other shield", "Unchanged body"))

    def test_corrupt_beta_italian_body_requires_exact_item_and_name(self):
        self.ns.data.itemDescriptionOverrides[25].badIt = "Descrizione di un altro oggetto."
        self.ns.data["items"] = self.lua.table()
        self.ns.data["items"][25] = self.lua.table(
            en="Worn Shortsword", itSource="Nome errato della beta",
            name="Spada Corta Consunta",
        )
        show = self.lua.globals().showItem
        self.assertEqual(show(25, "Nome errato della beta", "Descrizione di un altro oggetto."),
                         ("Spada Corta Consunta", "Una spada malridotta."))
        self.assertEqual(show(26, "Nome errato della beta", "Descrizione di un altro oggetto."),
                         ("Nome errato della beta", "Descrizione di un altro oggetto."))
        self.assertEqual(show(25, "Nome di un altro oggetto", "Descrizione di un altro oggetto."),
                         ("Nome di un altro oggetto", "Descrizione di un altro oggetto."))

    def test_exact_item_alias_checks_name_and_id(self):
        self.lua.execute(
            (ADDON / "Data/ItemTranslationAliases.lua").read_text(encoding="utf-8"),
            "WOWForverItaliano", self.ns)
        show = self.lua.globals().showItem
        source = "Teaches Nullify Disease (Rank 1)."
        translated = "Insegna Neutralizzazione delle Malattie (Grado 1)."
        self.assertEqual(show(1089, "Codex of Nullify Disease", source),
                         ("Codex of Nullify Disease", translated))
        self.assertEqual(show(1090, "Codex of Nullify Disease", source),
                         ("Codex of Nullify Disease", source))


if __name__ == "__main__":
    unittest.main()
