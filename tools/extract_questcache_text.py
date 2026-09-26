#!/usr/bin/env python3
"""Extract verbatim NUL-terminated text values from a WoW questcache.wdb.

The output intentionally labels strings by payload order, not semantic field
name: field schemas differ across client generations and are not inferred here.
"""

from __future__ import annotations

import argparse
import csv
import struct
import sys
from pathlib import Path


HEADER_SIZE = 24
RECORD_HEADER_SIZE = 8
EOF_SIZE = 8
MAGIC = b"TSQW"  # reversed on disk: WQST


def extract(path: Path) -> list[tuple[int, int, str]]:
    data = path.read_bytes()
    if len(data) < HEADER_SIZE + EOF_SIZE:
        raise ValueError("file is too short to be a quest cache")
    if data[:4] != MAGIC:
        raise ValueError(f"unexpected signature {data[:4]!r}; expected reversed WQST")

    rows: list[tuple[int, int, str]] = []
    offset = HEADER_SIZE
    end = len(data) - EOF_SIZE
    if data[end:] != b"\0" * EOF_SIZE:
        raise ValueError("expected the documented eight-byte zero terminator")

    while offset < end:
        if end - offset < RECORD_HEADER_SIZE:
            raise ValueError(f"truncated record header at offset {offset}")
        quest_id, payload_size = struct.unpack_from("<II", data, offset)
        offset += RECORD_HEADER_SIZE
        payload_end = offset + payload_size
        if payload_end > end:
            raise ValueError(
                f"record {quest_id} at offset {offset - RECORD_HEADER_SIZE} "
                f"claims {payload_size} payload bytes beyond file"
            )

        payload = data[offset:payload_end]
        # Preserve the ordinal among every NUL-delimited component, including
        # empty/binary components, so positions are reproducible and auditable.
        for ordinal, raw in enumerate(payload.split(b"\0")):
            if not raw:
                continue
            try:
                text = raw.decode("utf-8", errors="strict")
            except UnicodeDecodeError:
                continue
            if not any(char.isalnum() for char in text):
                continue
            if any(ord(char) < 32 and char not in "\t\r\n" for char in text):
                continue
            rows.append((quest_id, ordinal, text))
        offset = payload_end

    if offset != end:
        raise ValueError(f"record stream ended at {offset}, expected {end}")
    return rows


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("cache", type=Path, help="path to Cache/WDB/<locale>/questcache.wdb")
    parser.add_argument("-o", "--output", type=Path, help="CSV output (default: stdout)")
    args = parser.parse_args()
    try:
        rows = extract(args.cache)
        out = args.output.open("w", encoding="utf-8-sig", newline="") if args.output else sys.stdout
        try:
            writer = csv.writer(out, lineterminator="\n")
            writer.writerow(("quest_id", "payload_string_ordinal", "source_text"))
            writer.writerows(rows)
        finally:
            if args.output:
                out.close()
    except (OSError, ValueError) as exc:
        parser.error(str(exc))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
