"""Compare addon UI source labels with globals captured from a live beta client.

Run locally after `/wfi audit globals` and `/reload` in the game. This script
does not write or copy SavedVariables and prints only addon source labels.
"""

import argparse
from pathlib import Path
import re


GLOBAL = re.compile(r'^\["[A-Z][A-Z0-9_]+"\]\s*=\s*"((?:[^"\\]|\\.)*)",?$', re.M)
ENTRY = re.compile(r'\["((?:[^"\\]|\\.)*)"\]\s*=\s*"(?:[^"\\]|\\.)*"')
UI_FILES = (
    "UI.lua", "UIExtra.lua", "LiveUI.lua", "MapUI.lua", "Professions.lua",
    "SpellbookUI.lua", "CharacterPanels.lua", "GuildCollections.lua",
    "Settings.lua", "GeneralUIExact.lua",
)


def unescape(value: str) -> str:
    # Lua's ordinary quoted strings in these files use only these escapes.
    return value.replace(r'\"', '"').replace(r'\\', '\\').replace(r'\n', '\n')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("saved_variables", type=Path)
    parser.add_argument("--list-missing", action="store_true")
    args = parser.parse_args()

    source = args.saved_variables.read_text(encoding="utf-8-sig", errors="replace")
    globals_text = source.split('["globals"] = {', 1)
    if len(globals_text) != 2:
        raise SystemExit("No WFI_DB.audit.globals found; run /wfi audit globals then /reload")
    # `visible` may follow the globals table; it does not contain uppercase keys.
    verified = {unescape(value) for value in GLOBAL.findall(globals_text[1])}
    data_dir = Path(__file__).resolve().parents[1] / "Addon" / "Data"
    for filename in UI_FILES:
        path = data_dir / filename
        if not path.exists():
            continue
        keys = [unescape(value) for value in ENTRY.findall(path.read_text(encoding="utf-8-sig"))]
        missing = sorted(set(keys) - verified)
        print(f"{filename}: {len(keys)} entries, {len(keys) - len(missing)} client matches, {len(missing)} unmatched")
        if args.list_missing:
            for value in missing:
                print(f"  {value}")


if __name__ == "__main__":
    main()
