"""Build tag/source-guarded corrections for mismapped beta GlobalStrings."""

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
queue = json.loads(args.queue.read_text(encoding="utf-8"))
memory = json.loads(args.memory.read_text(encoding="utf-8"))
reviewed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
rows = []
for group in queue:
    source = group["en"]
    translation = memory.get(source)
    if not translation or translation.get("status") != "verified":
        raise ValueError(f"Missing verified translation: {source!r}")
    italian = translation["it"]
    if source == italian and source not in reviewed:
        raise ValueError(f"Unreviewed identical result: {source!r}")
    rows.extend({"en": source, "it": italian, **row} for row in group["rows"])
rows.sort(key=lambda row: row["id"])
path = data / "CompleteCorruptGlobalStrings001.lua"
lines = [
    "-- Exact beta GlobalStrings ID, tag and known wrong itIT value corrections.",
    "local _, ns = ...",
    "if not ns then return end",
    "ns.data = ns.data or {}",
    "ns.data.ui = ns.data.ui or {}",
    "ns.data.globalStrings = ns.data.globalStrings or {}",
    "ns.data.globalStringCorrections = ns.data.globalStringCorrections or {}",
    "local records = {",
]
for row in rows:
    lines.append(
        f"    [{row['id']}] = {{ tag = {quoted(row['tag'])}, flags = {row['flags']}, "
        f"en = {quoted(row['en'])}, badIt = {quoted(row['badIt'])}, "
        f"it = {quoted(row['it'])} }},"
    )
lines += [
    "}",
    "for id, record in pairs(records) do",
    "    if ns.data.globalStringCorrections[id] == nil then",
    "        ns.data.globalStringCorrections[id] = record",
    "    end",
    "    if ns.data.ui[record.en] == nil then",
    "        ns.data.ui[record.en] = record.it",
    "    end",
    "    if record.flags % 2 == 1 then",
    "        local current = ns.data.globalStrings[record.tag]",
    "        if current == nil then",
    "            ns.data.globalStrings[record.tag] = record",
    "        elseif type(current) == \"table\" and current.en == record.en and",
    "               current.badIt == nil then",
    "            current.badIt = record.badIt",
    "        end",
    "    end",
    "end",
]
path.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(json.dumps({"selected_ids": len(rows), "flagged": sum(row["flags"] & 1 for row in rows),
                  "pack": str(path)}, ensure_ascii=False))
