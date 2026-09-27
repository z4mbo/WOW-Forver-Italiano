"""Keep exact beta CRLF spell sources alongside earlier LF-normalized records."""

import importlib.util
import json
import os
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("db2coverage", root / "tools" / "report-local-db2-coverage.py")
db2 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(db2)
data = db2.load_catalogue()
temp = Path(os.environ.get("TEMP", tempfile.gettempdir()))
queue = json.loads((temp / "spell-complete-grouped.json").read_text(encoding="utf-8"))
memory = json.loads((temp / "wfi-luna-batch" / "spell-description" /
                     "memory.json").read_text(encoding="utf-8"))
rows = []
for group in queue:
    source = group["en"]
    for identifier in group["ids"]:
        current = data.spellDescriptionOverrides[identifier]
        if current is None or current.en == source:
            continue
        if current.en.replace("\r\n", "\n") != source.replace("\r\n", "\n"):
            raise ValueError(f"Unexpected different spell source for ID {identifier}")
        translation = memory[source]
        if translation["status"] != "verified":
            raise ValueError(f"Unverified translation for ID {identifier}")
        rows.append((int(identifier), source, translation["it"]))
rows.sort()
path = root / "Addon" / "Data" / "CompleteSpellDescriptionAliases001.lua"
lines = [
    "-- Exact CRLF source variants from Forever beta Spell.db2.",
    "local _, ns = ...",
    "if not ns then return end",
    "ns.data = ns.data or {}",
    "ns.data.spellDescriptionBetaOverrides = ns.data.spellDescriptionBetaOverrides or {}",
    "local rows = {",
]
for identifier, english, italian in rows:
    lines.append(f"    [{identifier}] = {{ en = {json.dumps(english, ensure_ascii=False)}, description = {json.dumps(italian, ensure_ascii=False)} }},")
lines += [
    "}",
    "for id, record in pairs(rows) do",
    "    if ns.data.spellDescriptionBetaOverrides[id] == nil then",
    "        ns.data.spellDescriptionBetaOverrides[id] = record",
    "    end",
    "end",
]
path.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(json.dumps({"selected_ids": len(rows), "pack": str(path)}, ensure_ascii=False))
