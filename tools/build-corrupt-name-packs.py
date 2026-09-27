"""Correct high-confidence beta itIT name collisions with exact-ID/source guards."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "Addon" / "Data"
FIELDS = {
    "item-name": ("ItemSparse", "Display_lang", "items", "CompleteCorruptItemName"),
    "spell-name": ("SpellName", "Name_lang", "spells", "CompleteCorruptSpellName"),
}


def lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def emit(path: Path, category: str, rows: list[dict]) -> None:
    _, _, table, _ = FIELDS[category]
    lines = [
        "-- High-confidence wrong itIT collision from the exact Forever beta DB2 row.",
        "-- English source and known bad Italian are both guarded at load time.",
        "local _, ns = ...",
        "if not ns then return end",
        "ns.data = ns.data or {}",
        f"ns.data.{table} = ns.data.{table} or {{}}",
        "local records = {",
    ]
    for row in rows:
        lines.append(f"    [{row['id']}] = {{ en = {lua_string(row['en'])}, badIt = {lua_string(row['it'])}, name = {lua_string(row['name'])} }},")
    new_entry = "{ en = record.en, name = record.name, itSource = record.badIt }"
    lines += [
        "}",
        "for id, record in pairs(records) do",
        f"    local current = ns.data.{table}[id]",
        "    if current == nil then",
        f"        ns.data.{table}[id] = {new_entry}",
        "    elseif type(current) == \"table\" and current.en == record.en and",
        "           (current.name == nil or current.name == record.en or",
        "            current.name == record.badIt) then",
        "        current.name = record.name",
    ]
    lines += [
        "        if current.itSource == nil then current.itSource = record.badIt end",
        "    elseif type(current) == \"table\" and current.en == record.en and",
        "           current.itSource == nil then",
        "        current.itSource = record.badIt",
    ]
    lines += ["    end", "end"]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--category", choices=tuple(FIELDS), required=True)
    parser.add_argument("--queue", type=Path, required=True)
    parser.add_argument("--memory", type=Path, required=True)
    parser.add_argument("--allow-identical-file", type=Path, required=True)
    parser.add_argument("--chunk-size", type=int, default=400)
    args = parser.parse_args()
    table, field, _, prefix = FIELDS[args.category]
    queue = json.loads(args.queue.read_text(encoding="utf-8"))
    memory = json.loads(args.memory.read_text(encoding="utf-8"))
    reviewed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
    if not isinstance(reviewed, dict) or not all(
            isinstance(key, str) and isinstance(value, str) and value.strip()
            for key, value in reviewed.items()):
        raise ValueError("Identical review must map source to a nonempty reason")
    rows = []
    seen = set()
    for entry in queue:
        if entry["table"] != table or entry["field"] != field:
            continue
        identifier = int(entry["id"])
        if identifier in seen:
            raise ValueError(f"Duplicate corrupt {args.category} ID {identifier}")
        seen.add(identifier)
        source = entry["en"]
        translation = memory.get(source)
        if not translation or translation.get("status") != "verified":
            raise ValueError(f"Missing verified translation for ID {identifier}: {source!r}")
        italian = translation["it"]
        if italian == source and source not in reviewed:
            raise ValueError(f"Unreviewed unchanged translation for ID {identifier}: {source!r}")
        rows.append({"id": identifier, "en": source, "it": entry["it"], "name": italian})
    rows.sort(key=lambda row: row["id"])
    paths = []
    for offset in range(0, len(rows), args.chunk_size):
        path = DATA / f"{prefix}{offset // args.chunk_size + 1:03d}.lua"
        emit(path, args.category, rows[offset:offset + args.chunk_size])
        paths.append(str(path))
    print(json.dumps({"category": args.category, "selected_ids": len(rows), "packs": paths},
                     ensure_ascii=False))


if __name__ == "__main__":
    main()
