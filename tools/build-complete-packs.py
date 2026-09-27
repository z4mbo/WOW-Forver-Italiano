"""Turn validated Luna translation memory into exact-ID guarded Lua data packs."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "Addon" / "Data"
REGISTRY = {
    "spell-name": ("spells", "name", "CompleteSpellName"),
    "spell-subtext": ("spellSubtextOverrides", "subtext", "CompleteSpellSubtext"),
    "item-name": ("items", "name", "CompleteItemName"),
    "spell-description": ("spellDescriptionOverrides", "description", "CompleteSpellDescription"),
    "aura-description": ("spellAuraDescriptionOverrides", "description", "CompleteAuraDescription"),
    "item-description": ("itemDescriptionOverrides", "description", "CompleteItemDescription"),
    "ui-global": ("ui", "value", "CompleteGlobalStrings"),
}


def string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def source_of(row: dict) -> str:
    for key in ("en", "english", "enDescription"):
        if isinstance(row.get(key), str):
            return row[key]
    raise ValueError(f"Missing exact source: {row!r}")


def targets(row: dict, category: str) -> list[tuple[int, str | None, str | None]]:
    if category == "item-description":
        return [(int(item["id"]), item["enName"], item.get("itName")) for item in row["rows"]]
    return [(int(identifier), None, None) for identifier in row["ids"]]


def entry(category: str, source: str, italian: str, en_name: str | None,
          it_name: str | None) -> str:
    if category == "item-description":
        if not en_name:
            raise ValueError("Item description requires exact English item name")
        variants = ", itName = " + string(it_name) if it_name and it_name != en_name else ""
        return ("{ enName = " + string(en_name) + variants + ", enDescription = " +
                string(source) + ", description = " + string(italian) + " }")
    if category.endswith("name"):
        return "{ en = " + string(source) + ", name = " + string(italian) + " }"
    if category == "spell-subtext":
        return "{ en = " + string(source) + ", subtext = " + string(italian) + " }"
    return "{ en = " + string(source) + ", description = " + string(italian) + " }"


def emit(path: Path, category: str, records: list[tuple[int, str]]) -> None:
    registry, key, _ = REGISTRY[category]
    lines = [
        "-- Generated from exact local beta DB2 English sources and GPT Luna low translations.",
        "-- Each runtime match is also gated by the original ID and source text.",
        "local _, ns = ...",
        "if not ns then return end",
        "ns.data = ns.data or {}",
        f"ns.data.{registry} = ns.data.{registry} or {{}}",
        "local records = {",
    ]
    for identifier, lua_entry in records:
        lines.append(f"    [{identifier}] = {lua_entry},")
    lines += ["}", "for id, record in pairs(records) do",
              f"    local current = ns.data.{registry}[id]",
              "    if current == nil then",
              f"        ns.data.{registry}[id] = record"]
    if category.endswith("name"):
        lines += ["    elseif type(current) == \"table\" and",
                  "           (current.name == nil or current.name == record.en) and",
                  "           (current.en == nil or current.en == record.en) then",
                  "        current.en = current.en or record.en",
                  "        current.name = record.name"]
    lines += ["    end", "end"]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def emit_ui(path: Path, records: list[tuple[str, str, list[str]]]) -> None:
    lines = [
        "-- Exact English strings from local Forever beta GlobalStrings.db2; translated with GPT Luna low.",
        "local _, ns = ...",
        "if not ns then return end",
        "ns.data = ns.data or {}",
        "ns.data.ui = ns.data.ui or {}",
        "ns.data.globalStrings = ns.data.globalStrings or {}",
        "local records = {",
    ]
    for english, italian, _ in records:
        lines.append(f"    [{string(english)}] = {string(italian)},")
    lines += ["}", "for source, translated in pairs(records) do",
              "    if ns.data.ui[source] == nil then ns.data.ui[source] = translated end",
              "end", "local globalTags = {"]
    for english, italian, tags in records:
        for tag in tags:
            lines.append(f"    [{string(tag)}] = {{ en = {string(english)}, it = {string(italian)} }},")
    lines += ["}", "for tag, record in pairs(globalTags) do",
              "    if ns.data.globalStrings[tag] == nil then ns.data.globalStrings[tag] = record end",
              "end"]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--category", required=True, choices=tuple(REGISTRY))
    parser.add_argument("--queue", required=True, type=Path)
    parser.add_argument("--memory", required=True, type=Path)
    parser.add_argument("--chunk-size", type=int, default=400)
    parser.add_argument("--first-index", type=int, default=2)
    parser.add_argument("--output-prefix", help="use a distinct validated pack prefix")
    parser.add_argument("--allow-identical-source", action="append", default=[],
                        help="explicitly reviewed proper name or technical literal")
    parser.add_argument("--allow-identical-file", type=Path,
                        help="JSON object mapping reviewed identical sources to a reason")
    args = parser.parse_args()
    if args.chunk_size < 1 or args.first_index < 1:
        parser.error("chunk-size and first-index must be positive")
    queue = json.loads(args.queue.read_text(encoding="utf-8"))
    memory = json.loads(args.memory.read_text(encoding="utf-8"))
    allowed_identical = set(args.allow_identical_source)
    if args.allow_identical_file:
        reviewed = json.loads(args.allow_identical_file.read_text(encoding="utf-8"))
        if not isinstance(reviewed, dict) or not all(
                isinstance(source, str) and isinstance(reason, str) and reason.strip()
                for source, reason in reviewed.items()):
            raise ValueError("Identical review file must map each source to a nonempty reason")
        allowed_identical.update(reviewed)
    registry, _, prefix = REGISTRY[args.category]
    if args.output_prefix:
        if not re.fullmatch(r"[A-Za-z][A-Za-z0-9]*", args.output_prefix):
            parser.error("output-prefix must be alphanumeric and start with a letter")
        prefix = args.output_prefix
    if args.category == "ui-global":
        selected_ui: list[tuple[str, str, list[str]]] = []
        skipped_ui = {"pending": 0, "review": 0, "unchanged": 0}
        for group in queue:
            source = source_of(group)
            record = memory.get(source)
            if record is None:
                skipped_ui["pending"] += 1
            elif record.get("status") != "verified":
                skipped_ui["review"] += 1
            elif source == record.get("it") and source not in allowed_identical:
                skipped_ui["unchanged"] += 1
            else:
                tags = [tag for tag, flags in zip(group.get("tags", []), group.get("flags", []))
                        if isinstance(tag, str) and isinstance(flags, int) and flags & 1]
                selected_ui.append((source, record["it"], tags))
        paths_ui: list[Path] = []
        for offset in range(0, len(selected_ui), args.chunk_size):
            number = args.first_index + offset // args.chunk_size
            path = DATA / f"{prefix}{number:03d}.lua"
            emit_ui(path, selected_ui[offset:offset + args.chunk_size])
            paths_ui.append(path)
        print(json.dumps({"category": args.category, "selected_sources": len(selected_ui),
                          "packs": [str(path) for path in paths_ui], "skipped": skipped_ui},
                         ensure_ascii=False))
        return
    selected: list[tuple[int, str]] = []
    skipped: dict[str, int] = {"pending": 0, "review": 0, "unchanged": 0}
    visited: set[int] = set()
    for group in queue:
        source = source_of(group)
        record = memory.get(source)
        rows = targets(group, args.category)
        if record is None:
            skipped["pending"] += len(rows)
            continue
        if record.get("status") != "verified":
            skipped["review"] += len(rows)
            continue
        italian = record.get("it")
        if source == italian and source not in allowed_identical:
            skipped["unchanged"] += len(rows)
            continue
        for identifier, en_name, it_name in rows:
            if identifier in visited:
                raise ValueError(f"Duplicate ID in queue: {identifier}")
            visited.add(identifier)
            selected.append((identifier, entry(args.category, source, italian, en_name, it_name)))
    selected.sort(key=lambda pair: pair[0])
    paths: list[Path] = []
    for offset in range(0, len(selected), args.chunk_size):
        number = args.first_index + offset // args.chunk_size
        path = DATA / f"{prefix}{number:03d}.lua"
        emit(path, args.category, selected[offset:offset + args.chunk_size])
        paths.append(path)
    print(json.dumps({"category": args.category, "registry": registry,
                      "selected_ids": len(selected), "packs": [str(path) for path in paths],
                      "skipped": skipped}, ensure_ascii=False))


if __name__ == "__main__":
    main()
