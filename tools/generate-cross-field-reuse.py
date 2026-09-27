"""Reuse exact spell text translated in another field of the same beta DB2.

Donors are low-ID records only: higher itIT records in this beta sometimes
contain unrelated strings. Targets may have any ID. An entry is emitted only
when its own field has no known Italian source for that English text, the other
field has exactly one, and all spell placeholders are compatible.
"""

from __future__ import annotations

import argparse
import json
import os
from collections import defaultdict
from pathlib import Path

from lupa import LuaRuntime

from generate_spell_reuse import TRUSTED_DONOR_MAX_ID, lua_string, tokens_compatible


ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified" / "Spell.json"
KINDS = {
    "description": ("Description_lang", "AuraDescription_lang",
                    "spellDescriptionOverrides", "SpellCrossFieldTranslationMemory.lua"),
    "aura": ("AuraDescription_lang", "Description_lang",
             "spellAuraDescriptionOverrides", "SpellAuraCrossFieldTranslationMemory.lua"),
}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kind", choices=KINDS)
    arguments = parser.parse_args()
    target_field, donor_field, registry, output_name = KINDS[arguments.kind]
    entries = json.loads(SOURCE.read_text(encoding="utf-8"))["entries"]

    own: dict[str, set[str]] = defaultdict(set)
    donor: dict[str, set[str]] = defaultdict(set)
    for entry in entries:
        if entry["id"] >= TRUSTED_DONOR_MAX_ID:
            continue
        for field_name, index in ((target_field, own), (donor_field, donor)):
            field = entry.get(field_name) or {}
            english, italian = field.get("enUS"), field.get("itIT")
            if english and italian and english != italian and "\ufffd" not in italian:
                index[english].add(italian)

    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute("WFI_DB = {}; SlashCmdList = {}; CreateFrame = function() return { RegisterEvent=function() end, SetScript=function() end } end")
    namespace = lua.table()
    for row in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig").splitlines():
        name = row.strip()
        if name in ("Data\\SpellTranslationAliases.lua", "Data\\" + output_name):
            continue
        if name == "Core.lua" or (name.startswith("Data\\") and name.endswith(".lua")):
            lua.execute((ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                        "WOWForverItaliano", namespace)
    existing = namespace.data[registry]

    selected = []
    for entry in entries:
        field = entry.get(target_field) or {}
        english, italian = field.get("enUS"), field.get("itIT")
        options = donor.get(english or "", ())
        if (not english or (italian and italian != english) or
                existing[entry["id"]] is not None or own.get(english) or
                len(options) != 1):
            continue
        target = next(iter(options))
        if (not tokens_compatible(english, target) or
                len(english) > 1600 or len(target) > 1600):
            continue
        selected.append((entry["id"], english, target))

    lines = [
        f"-- Generated from exact {donor_field} translations in trusted Spell.db2 records.",
        f"-- Applied only to source-matched {target_field} IDs.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        f"ns.data.{registry} = ns.data.{registry} or {{}}",
        "local reused = {",
    ]
    for identifier, english, italian in selected:
        lines.append(f"    [{identifier}] = {{ en = {lua_string(english)}, "
                     f"description = {lua_string(italian)} }},")
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        f"    if ns.data.{registry}[id] == nil then",
        f"        ns.data.{registry}[id] = record",
        "    end",
        "end",
    ]
    output = ADDON / "Data" / output_name
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"{arguments.kind}_cross_field_reused={len(selected)} output={output}")


if __name__ == "__main__":
    main()
