"""Syntax-check addon Lua and verify the TOC's local file references."""

from pathlib import Path
import sys

from luaparser import ast


ROOT = Path(__file__).resolve().parent.parent
ADDON = ROOT / "Addon"
TOC = ADDON / "WOWForverItaliano.toc"


def main() -> int:
    errors: list[str] = []
    entries: list[Path] = []
    for raw in TOC.read_text(encoding="utf-8-sig").splitlines():
        entry = raw.strip()
        if not entry or entry.startswith("#"):
            continue
        path = ADDON / entry.replace("\\", "/")
        entries.append(path)
        if not path.is_file():
            errors.append(f"TOC missing file: {entry}")
    for path in sorted(ADDON.rglob("*.lua")):
        if path not in entries:
            errors.append(f"Lua file is not loaded by TOC: {path.relative_to(ADDON)}")
        try:
            ast.parse(path.read_text(encoding="utf-8-sig"))
        except Exception as exc:
            errors.append(f"Lua syntax: {path.relative_to(ADDON)}: {exc}")
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Validated {len(entries)} TOC files and {len(list(ADDON.rglob('*.lua')))} Lua files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
