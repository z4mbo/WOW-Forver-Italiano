"""Approve only mechanically obvious unchanged UI literals; list the rest for review."""

import importlib.util
import json
import os
import re
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("luna", root / "tools" / "translate-luna-batch.py")
luna = importlib.util.module_from_spec(spec)
spec.loader.exec_module(luna)
base = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-luna-batch" / "ui-global"
memory = json.loads((base / "memory.json").read_text(encoding="utf-8"))
approved = {}
unresolved = []
for source, record in memory.items():
    if record.get("status") != "verified" or record.get("it") != source:
        continue
    if re.fullmatch(r"/[A-Za-z][A-Za-z0-9_]*", source):
        reason = "Slash command token; translating it would break the command."
    elif re.fullmatch(r"https?://\S+", source):
        reason = "URL must stay byte-for-byte identical."
    elif re.fullmatch(r"[\W\d_]+", source, flags=re.UNICODE):
        reason = "Numeric or punctuation-only literal."
    else:
        stripped = luna.FORMAT.sub("", source)
        stripped = luna.REFERENCE.sub("", stripped)
        stripped = luna.MARKUP.sub("", stripped)
        if re.fullmatch(r"[\W\d_]*", stripped, flags=re.UNICODE):
            reason = "Formatting/template-only string without lexical words."
        else:
            unresolved.append(source)
            continue
    approved[source] = reason
output = root / "tools" / "reviewed-identical-ui.json"
output.write_text(json.dumps(approved, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
review = base / "identical-needs-review.json"
review.write_text(json.dumps(unresolved, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
queue = base / "identical-reconsider-queue.json"
queue.write_text(json.dumps([{"en": source, "ids": []} for source in unresolved],
                            ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"approved={len(approved)} needs_review={len(unresolved)} output={output} review={review} queue={queue}")
