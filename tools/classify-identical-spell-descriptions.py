"""Document unchanged spell text that consists of engine tokens or onomatopoeia."""

import json
import os
import re
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
base = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-luna-batch" / "spell-description"
memory = json.loads((base / "memory.json").read_text(encoding="utf-8"))
token = re.compile(r"\$[@?]?[A-Za-z0-9_<>]+")
reviewed = {}
unresolved = []
for source, record in memory.items():
    if record.get("status") != "verified" or source != record.get("it"):
        continue
    if source == "Boom.":
        reason = "Onomatopoeia is the same in Italian."
    else:
        remaining = token.sub("", source).replace("\\r", "").replace("\\n", "")
        if re.search(r"[A-Za-z]{2,}", remaining):
            unresolved.append(source)
            continue
        reason = "Only a WoW engine reference, selector, formatting code, or punctuation; no lexical English to translate."
    reviewed[source] = reason
output = root / "tools" / "reviewed-identical-spell-descriptions.json"
output.write_text(json.dumps(reviewed, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
review = base / "identical-needs-review.json"
review.write_text(json.dumps(unresolved, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"approved={len(reviewed)} needs_review={len(unresolved)} review={review}")
