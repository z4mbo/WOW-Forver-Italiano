"""Build exact-ID records for proven wrong AreaTable and Faction itIT text."""

import argparse
import json
from pathlib import Path


data = Path(__file__).resolve().parents[1] / "Addon" / "Data"


def quoted(value):
    return json.dumps(value, ensure_ascii=False)


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--queue", type=Path, required=True)
parser.add_argument("--memory", type=Path, required=True)
parser.add_argument("--allow-identical-file", type=Path, required=True)
args = parser.parse_args()
review = json.loads(args.queue.read_text(encoding="utf-8"))
memory = json.loads(args.memory.read_text(encoding="utf-8"))
allowed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
rows = []
for row in review:
    if row["table"] not in ("AreaTable", "Faction"):
        continue
    source = row["en"]
    translation = memory.get(source)
    if not translation or translation.get("status") != "verified":
        raise ValueError(f"Missing verified translation: {source!r}")
    italian = translation["it"]
    if italian == source and source not in allowed:
        raise ValueError(f"Unreviewed identical source: {source!r}")
    rows.append({**row, "translated": italian})
rows.sort(key=lambda row: (row["table"], row["field"], row["id"]))
path = data / "CompleteCorruptExtraClientUI001.lua"
lines = [
    "-- Proven wrong beta itIT collisions, guarded by DB2 table, field, ID and English.",
    "local _, ns = ...",
    "if not ns then return end",
    "ns.data = ns.data or {}",
    "ns.data.ui = ns.data.ui or {}",
    "ns.data.extraClientTexts = ns.data.extraClientTexts or {}",
    "local rows = {",
]
for row in rows:
    field = f"{row['table']}.{row['field']}"
    lines.append(
        f"    {{ field = {quoted(field)}, id = {row['id']}, en = {quoted(row['en'])}, "
        f"badIt = {quoted(row['it'])}, it = {quoted(row['translated'])} }},"
    )
lines += [
    "}",
    "for _, row in ipairs(rows) do",
    "    local entries = ns.data.extraClientTexts[row.field]",
    "    if entries == nil then entries = {}; ns.data.extraClientTexts[row.field] = entries end",
    "    if entries[row.id] == nil then",
    "        entries[row.id] = { en = row.en, it = row.it, badIt = row.badIt }",
    "    end",
    "    if ns.data.ui[row.en] == nil then ns.data.ui[row.en] = row.it end",
    "end",
]
path.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(json.dumps({"selected_ids": len(rows), "pack": str(path)}, ensure_ascii=False))
