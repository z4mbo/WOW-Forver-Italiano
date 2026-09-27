"""Validate the final UI gap table against a local SavedVariables audit.

This is a local-only check. It is intentionally not wired into CI because the
SavedVariables input comes from a private client installation.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import re
import sys


DATA_FILE = Path(__file__).resolve().parents[1] / "Addon" / "Data" / "VerifiedUIGapsFinal.lua"
TOC_FILE = Path(__file__).resolve().parents[1] / "Addon" / "WOWForverItaliano.toc"

LUA_STRING = r'"((?:[^"\\]|\\.)*)"'
GLOBAL_ENTRY = re.compile(r'^\["[A-Z][A-Z0-9_]*"\]\s*=\s*' + LUA_STRING + r",?$", re.M)
UI_PAIR = re.compile(r'\["((?:[^"\\]|\\.)*)"\]\s*=\s*"(?:[^"\\]|\\.)*"')
UI_ASSIGNMENT = re.compile(r'ns\.data\.ui\s*\[\s*"((?:[^"\\]|\\.)*)"\s*\]\s*=')
FINAL_ASSIGNMENT = re.compile(
    r'ns\.data\.ui\s*\[\s*"((?:[^"\\]|\\.)*)"\s*\]\s*=\s*"((?:[^"\\]|\\.)*)"'
)


def lua_unescape(value: str) -> str:
    """Decode the simple Lua escapes used in the captured labels and tables."""
    escapes = {"a": "\a", "b": "\b", "f": "\f", "n": "\n", "r": "\r", "t": "\t", "v": "\v", "\\": "\\", '"': '"'}
    result: list[str] = []
    index = 0
    while index < len(value):
        if value[index] != "\\" or index + 1 >= len(value):
            result.append(value[index])
            index += 1
            continue
        index += 1
        char = value[index]
        if char in escapes:
            result.append(escapes[char])
            index += 1
        elif char.isdigit():
            end = index
            while end < min(index + 3, len(value)) and value[end].isdigit():
                end += 1
            result.append(chr(int(value[index:end], 10)))
            index = end
        elif char == "z":
            index += 1
            while index < len(value) and value[index].isspace():
                index += 1
        else:
            # Lua accepts escaped punctuation as the punctuation itself.
            result.append(char)
            index += 1
    return "".join(result)


def read_globals(path: Path) -> set[str]:
    try:
        saved = path.read_text(encoding="utf-8-sig", errors="replace")
    except OSError as exc:
        raise ValueError("SavedVariables input could not be read") from exc
    marker = '["globals"] = {'
    if marker not in saved:
        raise ValueError('No WFI_DB.audit.globals table found')
    block = saved.split(marker, 1)[1]
    block = re.split(r"^\s*\},\s*$", block, maxsplit=1, flags=re.M)[0]
    return {lua_unescape(value) for value in GLOBAL_ENTRY.findall(block)}


def load_final_entries() -> list[tuple[str, str]]:
    try:
        data = DATA_FILE.read_text(encoding="utf-8-sig")
    except OSError as exc:
        raise ValueError("Final UI data file could not be read") from exc
    return [(lua_unescape(key), lua_unescape(value)) for key, value in FINAL_ASSIGNMENT.findall(data)]


def earlier_ui_keys() -> set[str]:
    try:
        toc = TOC_FILE.read_text(encoding="utf-8-sig")
    except OSError as exc:
        raise ValueError("Addon TOC could not be read") from exc

    addon_dir = TOC_FILE.parent
    keys: set[str] = set()
    found_final = False
    for raw_line in toc.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("##"):
            continue
        rel_path = line.replace("\\", "/")
        if rel_path == "Data/VerifiedUIGapsFinal.lua":
            found_final = True
            break
        if not rel_path.lower().endswith(".lua"):
            continue
        source_path = addon_dir / rel_path
        if not source_path.is_file():
            continue
        try:
            source = source_path.read_text(encoding="utf-8-sig")
        except OSError:
            continue
        # Only inspect files that write to the UI table. The key/value pattern
        # also covers local translation maps later copied into ns.data.ui.
        if "ns.data.ui" not in source:
            continue
        keys.update(lua_unescape(key) for key in UI_PAIR.findall(source))
        keys.update(lua_unescape(key) for key in UI_ASSIGNMENT.findall(source))
    if not found_final:
        raise ValueError("VerifiedUIGapsFinal.lua is not listed in the addon TOC")
    return keys


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("saved_variables", type=Path, help="local SavedVariables file containing WFI_DB.audit.globals")
    args = parser.parse_args()

    try:
        globals_seen = read_globals(args.saved_variables)
        entries = load_final_entries()
        earlier = earlier_ui_keys()
    except ValueError as exc:
        print(f"UI validation error: {exc}", file=sys.stderr)
        return 2

    errors: list[str] = []
    sources = [source for source, _ in entries]
    if len(entries) != 140:
        errors.append(f"expected 140 UI entries; found {len(entries)}")
    duplicates = sorted({source for source in sources if sources.count(source) > 1})
    errors.extend(f"duplicate UI key: {source!r}" for source in duplicates)

    matched = 0
    conflicts = 0
    for source, translated in entries:
        if source in globals_seen:
            matched += 1
        else:
            errors.append(f"UI key absent from client globals: {source!r}")
        if source in earlier:
            conflicts += 1
            errors.append(f"UI key already loaded before final table: {source!r}")
        if not translated or translated == source:
            errors.append(f"UI key has no Italian translation: {source!r}")

    print(
        f"UI entries: {len(entries)}; distinct: {len(set(sources))}; "
        f"client-global matches: {matched}; prior-key conflicts: {conflicts}; errors: {len(errors)}"
    )
    for error in errors:
        print(f"ERROR: {error}")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
