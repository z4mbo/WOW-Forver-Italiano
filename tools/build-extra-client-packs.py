"""Build guarded UI and creature translations for the six extra local DB2 tables.

The queue is made by the read-only enUS/itIT CASC audit. Each record remains
associated with its table, field, numeric ID and exact beta English source.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "Addon" / "Data"


def lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def emit(path: Path, groups: list[dict]) -> None:
    lines = [
        "-- Generated from exact Forever beta DB2 sources and GPT Luna low translations.",
        "-- ID/field/source guards are retained for catalogue verification and runtime use.",
        "local _, ns = ...",
        "if not ns then return end",
        "ns.data = ns.data or {}",
        "ns.data.ui = ns.data.ui or {}",
        "ns.data.npcs = ns.data.npcs or {}",
        "ns.data.extraClientTexts = ns.data.extraClientTexts or {}",
        "local records = {",
    ]
    for group in groups:
        source = lua_string(group["en"])
        translated = lua_string(group["it"])
        places = ", ".join(
            "{ " + lua_string(field) + ", " + str(identifier) + " }"
            for field, identifier in zip(group["sources"], group["ids"])
        )
        lines.append(f"    {{ en = {source}, it = {translated}, places = {{ {places} }} }},")
    lines += [
        "}",
        "for _, record in ipairs(records) do",
        "    if ns.data.ui[record.en] == nil then",
        "        ns.data.ui[record.en] = record.it",
        "    end",
        "    for _, place in ipairs(record.places) do",
        "        local field, id = place[1], place[2]",
        "        local entries = ns.data.extraClientTexts[field]",
        "        if entries == nil then",
        "            entries = {}",
        "            ns.data.extraClientTexts[field] = entries",
        "        end",
        "        if entries[id] == nil then",
        "            entries[id] = { en = record.en, it = record.it }",
        "        end",
        "        if field == \"Creature.Name_lang\" then",
        "            local npc = ns.data.npcs[id]",
        "            if npc == nil then",
        "                ns.data.npcs[id] = { en = record.en, name = record.it }",
        "            elseif type(npc) == \"table\" and npc.en == record.en and",
        "                   (npc.name == nil or npc.name == npc.en) then",
        "                npc.name = record.it",
        "            end",
        "        end",
        "    end",
        "end",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--queue", type=Path, required=True)
    parser.add_argument("--memory", type=Path, required=True)
    parser.add_argument("--allow-identical-file", type=Path, required=True)
    parser.add_argument("--chunk-size", type=int, default=300)
    args = parser.parse_args()
    if args.chunk_size < 1:
        parser.error("chunk-size must be positive")
    queue = json.loads(args.queue.read_text(encoding="utf-8"))
    memory = json.loads(args.memory.read_text(encoding="utf-8"))
    reviewed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
    if not isinstance(reviewed, dict) or not all(
            isinstance(source, str) and isinstance(reason, str) and reason.strip()
            for source, reason in reviewed.items()):
        raise ValueError("Identical review file must map each source to a reason")
    groups = []
    for row in queue:
        source = row["en"]
        record = memory.get(source)
        if record is None or record.get("status") != "verified":
            raise ValueError(f"Missing verified translation for {source!r}")
        italian = record["it"]
        if italian == source and source not in reviewed:
            raise ValueError(f"Unreviewed English-identical result: {source!r}")
        if len(row["sources"]) != len(row["ids"]):
            raise ValueError(f"Misaligned field and ID lists for {source!r}")
        groups.append({**row, "it": italian})
    paths = []
    for offset in range(0, len(groups), args.chunk_size):
        path = DATA / f"CompleteExtraClientUI{offset // args.chunk_size + 1:03d}.lua"
        emit(path, groups[offset:offset + args.chunk_size])
        paths.append(str(path))
    print(json.dumps({"groups": len(groups),
                      "field_ids": sum(len(row["ids"]) for row in groups),
                      "packs": paths}, ensure_ascii=False))


if __name__ == "__main__":
    main()
