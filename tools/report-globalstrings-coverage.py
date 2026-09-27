"""Report exact English-source coverage of the installed beta GlobalStrings gaps."""

import argparse
import importlib.util
import json
import os
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("db2coverage", root / "tools" / "report-local-db2-coverage.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-complete", action="store_true")
    args = parser.parse_args()
    path = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit" / "globalstrings-complete-queue.json"
    queue = json.loads(path.read_text(encoding="utf-8"))
    ui = module.load_catalogue().ui
    matched = [row for row in queue if ui[row["en"]] is not None]
    total_ids = sum(len(row["ids"]) for row in queue)
    matched_ids = sum(len(row["ids"]) for row in matched)
    print(f"GlobalStrings.Value: local_db2_gaps={total_ids} catalogue_ids={matched_ids} "
          f"remaining_db2_ids={total_ids - matched_ids} unique_remaining={len(queue)-len(matched)}")
    if args.require_complete and total_ids != matched_ids:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
