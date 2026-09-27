"""Queue untranslated local quest-line, quest-type, and profession labels."""

import importlib.util
import json
import os
import tempfile
from collections import defaultdict
from pathlib import Path


root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("coverage", root / "tools" / "report-local-db2-coverage.py")
coverage = importlib.util.module_from_spec(spec)
spec.loader.exec_module(coverage)
ui = coverage.load_catalogue().ui
source = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit" / "locale-verified"
targets = {
    "QuestLine": ("Name_lang",),
    "QuestInfo": ("InfoName_lang",),
    "SkillLine": ("DisplayName_lang", "Description_lang"),
}
groups = defaultdict(lambda: {"ids": [], "sources": [], "tags": [], "flags": []})
for table, fields in targets.items():
    entries = json.loads((source / f"{table}.json").read_text(encoding="utf-8"))["entries"]
    for row in entries:
        for field in fields:
            value = row.get(field) or {}
            english, italian = value.get("enUS"), value.get("itIT")
            if english and (not italian or english == italian) and ui[english] is None:
                group = groups[english]
                group["ids"].append(row["id"])
                group["sources"].append(f"{table}.{field}")
queue = [{"en": english, **group} for english, group in groups.items()]
queue.sort(key=lambda row: (-len(row["ids"]), row["en"]))
output = source.parent / "extra-db2-ui-queue.json"
output.write_text(json.dumps(queue, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"unique={len(queue)} ids={sum(len(row['ids']) for row in queue)} output={output}")
