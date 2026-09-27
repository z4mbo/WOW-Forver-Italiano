"""Build exact-ID corrections for mismapped nonblank beta item descriptions."""

import argparse
import json
from pathlib import Path


root = Path(__file__).resolve().parents[1]
data = root / "Addon" / "Data"


def lua_string(value):
    return json.dumps(value, ensure_ascii=False)


parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--queue", type=Path, required=True)
parser.add_argument("--memory", type=Path, required=True)
parser.add_argument("--allow-identical-file", type=Path, required=True)
parser.add_argument("--chunk-size", type=int, default=400)
args = parser.parse_args()
queue = json.loads(args.queue.read_text(encoding="utf-8"))
memory = json.loads(args.memory.read_text(encoding="utf-8"))
reviewed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
rows = []
seen = set()
for group in queue:
    source = group["en"]
    translation = memory.get(source)
    if not translation or translation.get("status") != "verified":
        raise ValueError(f"Missing verified translation: {source!r}")
    italian = translation["it"]
    if source == italian and source not in reviewed:
        raise ValueError(f"Unreviewed identical item description: {source!r}")
    for row in group["rows"]:
        identifier = int(row["id"])
        if identifier in seen:
            raise ValueError(f"Duplicate item description ID {identifier}")
        seen.add(identifier)
        rows.append({**row, "enDescription": source, "description": italian})
rows.sort(key=lambda row: row["id"])
paths = []
for offset in range(0, len(rows), args.chunk_size):
    path = data / f"CompleteCorruptItemDescription{offset // args.chunk_size + 1:03d}.lua"
    lines = [
        "-- Exact beta item ID, English source, and wrong itIT source guarded correction.",
        "local _, ns = ...",
        "if not ns then return end",
        "ns.data = ns.data or {}",
        "ns.data.itemDescriptionOverrides = ns.data.itemDescriptionOverrides or {}",
        "local records = {",
    ]
    for row in rows[offset:offset + args.chunk_size]:
        it_name = (f", itName = {lua_string(row['itName'])}"
                   if row.get("itName") and row["itName"] != row["enName"] else "")
        lines.append(
            f"    [{row['id']}] = {{ enName = {lua_string(row['enName'])}{it_name}, "
            f"enDescription = {lua_string(row['enDescription'])}, "
            f"badIt = {lua_string(row['badIt'])}, "
            f"description = {lua_string(row['description'])} }},"
        )
    lines += [
        "}",
        "for id, record in pairs(records) do",
        "    local current = ns.data.itemDescriptionOverrides[id]",
        "    if current == nil then",
        "        ns.data.itemDescriptionOverrides[id] = record",
        "    elseif type(current) == \"table\" and current.enName == record.enName and",
        "           current.enDescription == record.enDescription then",
        "        if current.description == nil or current.description == current.enDescription or",
        "           current.description == record.badIt then",
        "            current.description = record.description",
        "        end",
        "        if current.badIt == nil then current.badIt = record.badIt end",
        "        if current.itName == nil then current.itName = record.itName end",
        "    end",
        "end",
    ]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    paths.append(str(path))
print(json.dumps({"selected_ids": len(rows), "packs": paths}, ensure_ascii=False))
