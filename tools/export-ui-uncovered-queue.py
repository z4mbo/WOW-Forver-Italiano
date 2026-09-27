"""Filter beta GlobalStrings gaps to sources missing from the addon UI dictionary."""

import importlib.util
import json
import os
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
module_path = root / "tools" / "report-local-db2-coverage.py"
spec = importlib.util.spec_from_file_location("report_local_db2_coverage", module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
data = module.load_catalogue()
base = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit"
queue = json.loads((base / "globalstrings-complete-queue.json").read_text(encoding="utf-8"))
remaining = [row for row in queue if data.ui[row["en"]] is None]
remaining.sort(key=lambda row: (-len(row["ids"]), row["en"]))
output = base / "globalstrings-uncovered-queue.json"
output.write_text(json.dumps(remaining, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"unique={len(remaining)} ids={sum(len(row['ids']) for row in remaining)} output={output}")
