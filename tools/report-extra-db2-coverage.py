"""Report exact-source coverage for the six additional beta DB2 tables."""

import argparse
import importlib.util
import json
import os
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
AUDIT = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit"
SOURCE = AUDIT / "extra-locale-verified"
TABLES = ("Creature", "AreaTable", "Faction", "Achievement", "ChrRaces", "Map")


def load_catalogue():
    path = ROOT / "tools" / "report-local-db2-coverage.py"
    spec = importlib.util.spec_from_file_location("local_db2_coverage", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.load_catalogue()


def nonblank(value):
    return isinstance(value, str) and bool(value.strip())


def field_records(data, field_key, identifier):
    table = data.extraClientTexts
    if table is None:
        return None
    by_id = table[field_key]
    if by_id is None:
        return None
    return by_id[identifier] or by_id[str(identifier)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-complete", action="store_true",
                        help="exit nonzero if any DB2 gap lacks an exact-source translation")
    args = parser.parse_args()
    data = load_catalogue()
    remaining_total = 0
    gap_total = 0
    print("Exact ID and English-source matches; this measures catalogue coverage, not runtime display or translation quality.")
    for table in TABLES:
        entries = json.loads((SOURCE / f"{table}.json").read_text(encoding="utf-8"))["entries"]
        fields = sorted({key for row in entries for key in row if key != "id"})
        for field in fields:
            gaps = []
            for row in entries:
                value = row.get(field)
                if not isinstance(value, dict):
                    continue
                english, italian = value.get("enUS"), value.get("itIT")
                if nonblank(english) and (not nonblank(italian) or english == italian):
                    gaps.append((row["id"], english))
            if not gaps:
                continue
            covered = 0
            for identifier, english in gaps:
                record = field_records(data, f"{table}.{field}", identifier)
                if (record is not None and record.en == english and
                        nonblank(record.it)):
                    covered += 1
                elif table == "Creature" and field == "Name_lang":
                    npc = data.npcs[identifier]
                    if (npc is not None and npc.en == english and
                            nonblank(npc.name)):
                        covered += 1
            missing = len(gaps) - covered
            gap_total += len(gaps)
            remaining_total += missing
            print(f"{table}.{field}: db2_gaps={len(gaps)} exact_catalogue_ids={covered} remaining={missing}")
    print(f"EXTRA_DB2_COVERAGE db2_gaps={gap_total} covered={gap_total-remaining_total} remaining={remaining_total}")
    if args.require_complete and remaining_total:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
