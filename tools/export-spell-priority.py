"""Export frequent untranslated, exact client spell text for Luna review."""

from __future__ import annotations

import json
import os
from collections import Counter, defaultdict
from pathlib import Path

from lupa import LuaRuntime

from generate_spell_reuse import tokens


ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified" / "Spell.json"
OUTPUT = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "spell-priority.jsonl"


def main() -> None:
    entries = json.loads(SOURCE.read_text(encoding="utf-8"))["entries"]
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute("WFI_DB = {}; SlashCmdList = {}; CreateFrame = function() return { RegisterEvent=function() end, SetScript=function() end } end")
    namespace = lua.table()
    for row in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig").splitlines():
        name = row.strip()
        if name == "Core.lua" or (name.startswith("Data\\") and name.endswith(".lua")):
            lua.execute((ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                        "WOWForverItaliano", namespace)
    covered = set(namespace.data.spellDescriptionOverrides.keys())
    covered.update(spell_id for spell_id, record in namespace.data.spells.items()
                   if record.description is not None)
    known_english = {record.en for _, record in
                     namespace.data.spellDescriptionOverrides.items()}
    candidates = defaultdict(list)
    for entry in entries:
        field = entry.get("Description_lang") or {}
        english, italian = field.get("enUS"), field.get("itIT")
        if (not english or (italian and italian != english) or
                entry["id"] in covered or english in known_english or
                len(english) > 500 or "$?" in english or "$@" in english or
                "@$" in english or "$/" in english or
                tokens(english) is None or len(tokens(english)) > 8):
            continue
        candidates[english].append(entry["id"])
    ranked = sorted(candidates.items(), key=lambda item: (-len(item[1]), min(item[1])))
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT.open("w", encoding="utf-8") as stream:
        for rank, (english, ids) in enumerate(ranked, 1):
            stream.write(json.dumps({"rank": rank, "representative_id": min(ids),
                                     "count": len(ids), "en": english},
                                    ensure_ascii=False) + "\n")
    print(f"unique_candidates={len(ranked)} remaining_ids={sum(map(len, candidates.values()))} "
          f"top_100_ids={sum(len(ids) for _, ids in ranked[:100])} output={OUTPUT}")


if __name__ == "__main__":
    main()
