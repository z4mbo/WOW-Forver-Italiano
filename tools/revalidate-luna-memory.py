"""Apply the latest placeholder checks to a completed Luna memory file."""

import argparse
import importlib.util
import json
from pathlib import Path


module_path = Path(__file__).with_name("translate-luna-batch.py")
spec = importlib.util.spec_from_file_location("translate_luna_batch", module_path)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--category", required=True)
parser.add_argument("--memory", required=True, type=Path)
args = parser.parse_args()
memory = json.loads(args.memory.read_text(encoding="utf-8"))
changed = 0
for source, record in memory.items():
    problem = module.verify(source, record["it"], args.category)
    status = "review" if problem else "verified"
    if record["status"] != status or record.get("reason") != (problem or ""):
        changed += 1
        record["status"] = status
        record["reason"] = problem or ""
module.save_memory(args.memory, memory)
print(f"category={args.category} checked={len(memory)} changed={changed} "
      f"review={sum(row['status'] == 'review' for row in memory.values())}")
