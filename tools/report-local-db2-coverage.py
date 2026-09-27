"""Report catalogue coverage of exact local DB2 text gaps, not visible game coverage."""

import json
import os
from collections import defaultdict
from pathlib import Path

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified"


def load_catalogue():
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute("WFI_DB = {}; SlashCmdList = {}; CreateFrame = function() return { RegisterEvent=function() end, SetScript=function() end } end")
    namespace = lua.table()
    for row in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig").splitlines():
        name = row.strip()
        if name == "Core.lua" or (name.startswith("Data\\") and name.endswith(".lua")):
            lua.execute((ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                        "WOWForverItaliano", namespace)
    return namespace.data


def gap_sources(entries, field):
    return {entry["id"]: entry[field]["enUS"] for entry in entries
            if field in entry and entry[field].get("enUS") and
            (not entry[field].get("itIT") or
             entry[field]["enUS"] == entry[field]["itIT"])}


def report(label, gap, catalogue_sources):
    covered = {identifier for identifier, english in gap.items()
               if english in catalogue_sources.get(identifier, ())}
    print(f"{label}: local_db2_gaps={len(gap)} catalogue_ids={len(covered)} "
          f"remaining_db2_ids={len(gap) - len(covered)}")


def add_source(table, identifier, source):
    if source is not None:
        table[identifier].add(source)


def main():
    data = load_catalogue()
    spells = json.loads((SOURCE / "Spell.json").read_text(encoding="utf-8"))["entries"]
    spell_names = json.loads((SOURCE / "SpellName.json").read_text(encoding="utf-8"))["entries"]
    items = json.loads((SOURCE / "ItemSparse.json").read_text(encoding="utf-8"))["entries"]
    spell_name_sources = defaultdict(set)
    spell_description_sources = defaultdict(set)
    spell_aura_sources = defaultdict(set)
    item_name_sources = defaultdict(set)
    item_description_sources = defaultdict(set)
    for spell_id, entry in data.spells.items():
        if entry.name is not None:
            add_source(spell_name_sources, spell_id, entry.en)
        if entry.description is not None:
            add_source(spell_description_sources, spell_id, entry.enDescription)
    for spell_id, entry in data.spellDescriptionOverrides.items():
        add_source(spell_description_sources, spell_id, entry.en)
    for spell_id, entry in data.spellAuraDescriptionOverrides.items():
        add_source(spell_aura_sources, spell_id, entry.en)
    for item_id, entry in data["items"].items():
        if entry.name is not None:
            add_source(item_name_sources, item_id, entry.en)
        if entry.description is not None:
            add_source(item_description_sources, item_id, entry.enDescription)
    for item_id, entry in data.itemDescriptionOverrides.items():
        add_source(item_description_sources, item_id, entry.enDescription)
    print("Exact ID and English-source catalogue matches; runtime display is not measured.")
    report("SpellName.Name_lang", gap_sources(spell_names, "Name_lang"), spell_name_sources)
    report("Spell.Description_lang", gap_sources(spells, "Description_lang"), spell_description_sources)
    report("Spell.AuraDescription_lang", gap_sources(spells, "AuraDescription_lang"), spell_aura_sources)
    report("ItemSparse.Display_lang", gap_sources(items, "Display_lang"), item_name_sources)
    report("ItemSparse.Description_lang", gap_sources(items, "Description_lang"), item_description_sources)


if __name__ == "__main__":
    main()
