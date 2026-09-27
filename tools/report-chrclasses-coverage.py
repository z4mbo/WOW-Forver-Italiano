"""Report exact-source coverage for the 18 audited ChrClasses DB2 gaps."""

import json
import os
import sys
import tempfile
from pathlib import Path

from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
AUDIT = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit" / "locale-verified"
TABLE = "ChrClasses"
FIELDS = ("Name_lang", "Name_male_lang")
PACK = ROOT / "Addon" / "Data" / "CompleteChrClasses001.lua"


def load_pack():
    lua = LuaRuntime(unpack_returned_tuples=True)
    namespace = lua.table()
    lua.execute(PACK.read_text(encoding="utf-8-sig"), "WOWForverItaliano", namespace)
    return namespace.data.extraClientTexts


def nonblank(value):
    return isinstance(value, str) and bool(value.strip())


def main():
    source = json.loads((AUDIT / f"{TABLE}.json").read_text(encoding="utf-8"))
    if source.get("source") != TABLE:
        raise ValueError(f"Unexpected audit source: {source.get('source')!r}")
    entries = source["entries"]
    catalogue = load_pack()
    remaining_total = 0
    gap_total = 0
    print("Exact ID and English-source matches; runtime display is not measured.")
    for field in FIELDS:
        gaps = []
        for row in entries:
            value = row.get(field)
            if not isinstance(value, dict):
                continue
            english, italian = value.get("enUS"), value.get("itIT")
            if nonblank(english) and (not nonblank(italian) or english == italian):
                gaps.append((row["id"], english))
        by_id = catalogue[f"{TABLE}.{field}"]
        covered = 0
        for identifier, english in gaps:
            record = by_id[identifier] if by_id is not None else None
            if (record is not None and record.en == english and nonblank(record.it)):
                covered += 1
        missing = len(gaps) - covered
        gap_total += len(gaps)
        remaining_total += missing
        print(f"{TABLE}.{field}: db2_gaps={len(gaps)} exact_catalogue_ids={covered} remaining={missing}")
    print(f"CHRCLASSES_COVERAGE db2_gaps={gap_total} covered={gap_total-remaining_total} remaining={remaining_total}")
    if gap_total != 18:
        print(f"Expected 18 audited gaps, found {gap_total}.", file=sys.stderr)
        raise SystemExit(2)
    if remaining_total:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
