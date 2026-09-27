"""Prefer one trusted in-client Italian subtext over a conflicting AI draft."""

import json
import os
import tempfile
from collections import defaultdict
from pathlib import Path


base = Path(os.environ.get("TEMP", tempfile.gettempdir()))
spell = base / "wfi-casc-audit" / "locale-verified" / "Spell.json"
memory_path = base / "wfi-luna-batch" / "spell-subtext" / "memory.json"
memory = json.loads(memory_path.read_text(encoding="utf-8"))
donors = defaultdict(set)
for entry in json.loads(spell.read_text(encoding="utf-8"))["entries"]:
    if entry["id"] >= 100_000:
        continue
    field = entry.get("NameSubtext_lang") or {}
    english, italian = field.get("enUS"), field.get("itIT")
    if english and italian and english != italian:
        donors[english].add(italian)
changed = []
for english, translations in donors.items():
    if english in memory and len(translations) == 1:
        italian = next(iter(translations))
        if memory[english]["it"] != italian:
            changed.append((english, memory[english]["it"], italian))
            memory[english] = {"it": italian, "status": "verified",
                               "reason": "unique low-ID Italian client donor"}
memory_path.write_text(json.dumps(memory, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"reconciled={len(changed)}")
for record in changed:
    print(repr(record))
