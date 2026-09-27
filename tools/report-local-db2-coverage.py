"""Report catalogue coverage of exact local DB2 text gaps, not visible game coverage."""

import argparse
import json
import os
import sys
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
    missing = len(gap) - len(covered)
    print(f"{label}: local_db2_gaps={len(gap)} catalogue_ids={len(covered)} "
          f"remaining_db2_ids={missing}")
    return missing


def add_source(table, identifier, source):
    if source is not None:
        table[identifier].add(source)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-complete", action="store_true",
                        help="exit nonzero if any local DB2 ID remains uncovered")
    args = parser.parse_args()
    data = load_catalogue()
    spells = json.loads((SOURCE / "Spell.json").read_text(encoding="utf-8"))["entries"]
    spell_names = json.loads((SOURCE / "SpellName.json").read_text(encoding="utf-8"))["entries"]
    items = json.loads((SOURCE / "ItemSparse.json").read_text(encoding="utf-8"))["entries"]
    quest_lines = json.loads((SOURCE / "QuestLine.json").read_text(encoding="utf-8"))["entries"]
    quest_info = json.loads((SOURCE / "QuestInfo.json").read_text(encoding="utf-8"))["entries"]
    skill_lines = json.loads((SOURCE / "SkillLine.json").read_text(encoding="utf-8"))["entries"]
    spell_name_sources = defaultdict(set)
    spell_description_sources = defaultdict(set)
    spell_aura_sources = defaultdict(set)
    spell_subtext_sources = defaultdict(set)
    item_name_sources = defaultdict(set)
    item_description_sources = defaultdict(set)
    for spell_id, entry in data.spells.items():
        if entry.name is not None:
            add_source(spell_name_sources, spell_id, entry.en)
        if entry.description is not None:
            add_source(spell_description_sources, spell_id, entry.enDescription)
    if data.spellNameOverrides is not None:
        for spell_id, entry in data.spellNameOverrides.items():
            add_source(spell_name_sources, spell_id, entry.en)
    for spell_id, entry in data.spellDescriptionOverrides.items():
        add_source(spell_description_sources, spell_id, entry.en)
    if data.spellDescriptionBetaOverrides is not None:
        for spell_id, entry in data.spellDescriptionBetaOverrides.items():
            add_source(spell_description_sources, spell_id, entry.en)
    for spell_id, entry in data.spellAuraDescriptionOverrides.items():
        add_source(spell_aura_sources, spell_id, entry.en)
    if data.spellSubtextOverrides is not None:
        for spell_id, entry in data.spellSubtextOverrides.items():
            add_source(spell_subtext_sources, spell_id, entry.en)
    for item_id, entry in data["items"].items():
        if entry.name is not None:
            add_source(item_name_sources, item_id, entry.en)
        if entry.description is not None:
            add_source(item_description_sources, item_id, entry.enDescription)
    for item_id, entry in data.itemDescriptionOverrides.items():
        add_source(item_description_sources, item_id, entry.enDescription)
    def ui_sources(entries, field):
        return {entry["id"]: {entry[field]["enUS"]} for entry in entries
                if field in entry and entry[field].get("enUS") and
                data.ui[entry[field]["enUS"]] is not None}
    print("Exact ID and English-source catalogue matches; runtime display is not measured.")
    remaining = [
        report("SpellName.Name_lang", gap_sources(spell_names, "Name_lang"), spell_name_sources),
        report("Spell.Description_lang", gap_sources(spells, "Description_lang"), spell_description_sources),
        report("Spell.AuraDescription_lang", gap_sources(spells, "AuraDescription_lang"), spell_aura_sources),
        report("Spell.NameSubtext_lang", gap_sources(spells, "NameSubtext_lang"), spell_subtext_sources),
        report("ItemSparse.Display_lang", gap_sources(items, "Display_lang"), item_name_sources),
        report("ItemSparse.Description_lang", gap_sources(items, "Description_lang"), item_description_sources),
        report("QuestLine.Name_lang", gap_sources(quest_lines, "Name_lang"),
               ui_sources(quest_lines, "Name_lang")),
        report("QuestInfo.InfoName_lang", gap_sources(quest_info, "InfoName_lang"),
               ui_sources(quest_info, "InfoName_lang")),
        report("SkillLine.DisplayName_lang", gap_sources(skill_lines, "DisplayName_lang"),
               ui_sources(skill_lines, "DisplayName_lang")),
        report("SkillLine.Description_lang", gap_sources(skill_lines, "Description_lang"),
               ui_sources(skill_lines, "Description_lang")),
    ]
    if args.require_complete and any(remaining):
        print(f"LOCAL_DB2_COVERAGE_INCOMPLETE total_remaining={sum(remaining)}", file=sys.stderr)
        raise SystemExit(1)


if __name__ == "__main__":
    main()
