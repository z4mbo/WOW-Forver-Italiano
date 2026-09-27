"""Group missing local Spell.NameSubtext_lang strings by exact English source."""

import json
import os
import tempfile
from collections import defaultdict
from pathlib import Path


source = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit" / "locale-verified" / "Spell.json"
output = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "spell-subtext-queue.json"
groups = defaultdict(list)
for entry in json.loads(source.read_text(encoding="utf-8"))["entries"]:
    field = entry.get("NameSubtext_lang") or {}
    english, italian = field.get("enUS"), field.get("itIT")
    if english and (not italian or english == italian):
        groups[english].append(entry["id"])
queue = [{"en": english, "ids": identifiers} for english, identifiers in groups.items()]
queue.sort(key=lambda row: (-len(row["ids"]), row["en"]))
output.write_text(json.dumps(queue, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"unique={len(queue)} ids={sum(len(row['ids']) for row in queue)} output={output}")
