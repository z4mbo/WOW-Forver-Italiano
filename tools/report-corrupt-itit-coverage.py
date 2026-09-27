"""Check exact catalogue corrections for proven nonblank beta itIT collisions."""

import argparse
import importlib.util
import json
import os
import tempfile
from collections import Counter
from pathlib import Path


root = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("db2coverage", root / "tools" / "report-local-db2-coverage.py")
db2 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(db2)


def text(value):
    return isinstance(value, str) and bool(value.strip())


def lookup(table, identifier):
    return None if table is None else table[identifier]


def covered(data, row):
    table, field, identifier = row["table"], row["field"], row["id"]
    en, bad = row["en"], row["it"]
    if table == "ItemSparse" and field == "Display_lang":
        record = lookup(data["items"], identifier)
        return record is not None and record.en == en and record.itSource == bad and text(record.name)
    if table == "ItemSparse" and field == "Description_lang":
        record = lookup(data.itemDescriptionOverrides, identifier)
        return (record is not None and record.enDescription == en and record.badIt == bad and
                text(record.description))
    if table == "SpellName" and field == "Name_lang":
        record = lookup(data.spells, identifier)
        return record is not None and record.en == en and record.itSource == bad and text(record.name)
    if table in ("AreaTable", "Faction"):
        records = lookup(data.extraClientTexts, table + "." + field)
        record = lookup(records, identifier)
        return record is not None and record.en == en and record.badIt == bad and text(record.it)
    if table == "GlobalStrings" and field == "TagText_lang":
        record = lookup(data.globalStringCorrections, identifier)
        return record is not None and record.en == en and record.badIt == bad and text(record.it)
    raise ValueError(f"Unexpected corrupt audit field {table}.{field}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-complete", action="store_true")
    args = parser.parse_args()
    path = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit" / "corrupt-itit-review.json"
    rows = json.loads(path.read_text(encoding="utf-8"))
    data = db2.load_catalogue()
    totals = Counter()
    matched = Counter()
    for row in rows:
        key = row["table"] + "." + row["field"]
        totals[key] += 1
        if covered(data, row):
            matched[key] += 1
    remaining = 0
    for key, total in sorted(totals.items()):
        missing = total - matched[key]
        remaining += missing
        print(f"{key}: corrupt_ids={total} exact_catalogue_ids={matched[key]} remaining={missing}")
    print(f"CORRUPT_ITIT_COVERAGE ids={len(rows)} remaining={remaining}")
    if args.require_complete and remaining:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
