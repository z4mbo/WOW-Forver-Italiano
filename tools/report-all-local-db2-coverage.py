"""Fail if any extracted beta DB2 text gap is outside a verified catalogue gate."""

import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
audit = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit"
base = audit / "locale-verified"
extra = audit / "extra-locale-verified"
base_fields = {
    "SpellName": {"Name_lang"},
    "Spell": {"Description_lang", "AuraDescription_lang", "NameSubtext_lang"},
    "ItemSparse": {"Display_lang", "Description_lang"},
    "QuestLine": {"Name_lang"},
    "QuestInfo": {"InfoName_lang"},
    "SkillLine": {"DisplayName_lang", "Description_lang"},
    "ChrClasses": {"Name_lang", "Name_male_lang"},
}
extra_tables = {"Creature", "AreaTable", "Faction", "Achievement", "ChrRaces", "Map"}


def gap_fields(path):
    entries = json.loads(path.read_text(encoding="utf-8"))["entries"]
    counts = {}
    for row in entries:
        for field, pair in row.items():
            if not isinstance(pair, dict):
                continue
            english, italian = pair.get("enUS"), pair.get("itIT")
            if isinstance(english, str) and english and (
                    not isinstance(italian, str) or not italian.strip() or
                    english == italian):
                counts[field] = counts.get(field, 0) + 1
    return counts


def run_gate(script, *args):
    result = subprocess.run([sys.executable, str(root / "tools" / script), *args],
                            cwd=root, text=True, capture_output=True,
                            encoding="utf-8", check=False)
    if result.returncode:
        print(result.stdout, end="")
        print(result.stderr, end="", file=sys.stderr)
        raise SystemExit(f"Failed catalogue gate: {script}")
    return result.stdout


def main():
    base_count = 0
    for table, supported in base_fields.items():
        counts = gap_fields(base / f"{table}.json")
        unreviewed = set(counts) - supported
        if unreviewed:
            raise SystemExit(f"Unreviewed {table} fields: {sorted(unreviewed)}")
        base_count += sum(counts.values())
    extra_count = 0
    for table in extra_tables:
        extra_count += sum(gap_fields(extra / f"{table}.json").values())
    if len(base_fields) + len(extra_tables) + 1 != 14:
        raise SystemExit("Expected 14 extracted localized DB2 tables")

    run_gate("report-local-db2-coverage.py", "--require-complete")
    global_report = run_gate("report-globalstrings-coverage.py", "--require-complete")
    run_gate("report-extra-db2-coverage.py", "--require-complete")
    run_gate("report-chrclasses-coverage.py")
    corrupt_report = run_gate("report-corrupt-itit-coverage.py", "--require-complete")
    global_count = int(re.search(r"local_db2_gaps=(\d+)", global_report).group(1))
    total = base_count + extra_count + global_count
    if total != 53845:
        raise SystemExit(f"Unexpected beta gap count {total}; audit/review the changed extraction")
    corrupt_count = int(re.search(r"CORRUPT_ITIT_COVERAGE ids=(\d+)", corrupt_report).group(1))
    if corrupt_count != 1765:
        raise SystemExit(f"Unexpected corrupt itIT count {corrupt_count}")
    print(f"LOCAL_DB2_ALL tables=14 field_id_gaps={total} remaining=0 "
          f"corrupt_itIT_reviewed={corrupt_count} corrupt_remaining=0")


if __name__ == "__main__":
    main()
