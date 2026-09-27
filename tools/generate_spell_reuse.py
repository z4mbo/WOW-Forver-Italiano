"""Reuse unambiguous Italian spell text already present in this beta's DB2 dump.

The input is the local, read-only extract produced by extract-db2-locales.cjs.
Only an exact English Description_lang match with one existing Italian value is
accepted. Dynamic placeholders must be identical and in the same order.
"""

from __future__ import annotations

import argparse
import json
import os
import re
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified" / "Spell.json"
DEFAULT_OUTPUT = ROOT / "Addon" / "Data" / "SpellTranslationMemory.lua"
# Above this range, the Forever beta has itIT fields reused from unrelated
# records. These entries may be targets but cannot establish a translation.
TRUSTED_DONOR_MAX_ID = 100_000


def tokens(value: str) -> list[str] | None:
    found: list[str] = []
    index = 0
    while index < len(value):
        if value[index] != "$":
            index += 1
            continue
        start = index
        index += 1
        if index >= len(value):
            return None
        if value[index] == "{":
            depth = 0
            while index < len(value):
                if value[index] == "{":
                    depth += 1
                elif value[index] == "}":
                    depth -= 1
                    if depth == 0:
                        index += 1
                        break
                index += 1
            if depth != 0:
                return None
        elif value[index] == "*":
            index += 1
            first = index
            while index < len(value) and value[index].isdigit():
                index += 1
            if index == first or index >= len(value) or value[index] != ";":
                return None
            index += 1
            if index >= len(value) or not value[index].isalpha():
                return None
            index += 1
            first = index
            while index < len(value) and value[index].isdigit():
                index += 1
            if index == first:
                return None
        elif value[index] in ("l", "L"):
            index += 1
            first = index
            while index < len(value) and value[index] not in ":;":
                index += 1
            if index == first or index >= len(value) or value[index] != ":":
                return None
            index += 1
            first = index
            while index < len(value) and value[index] not in ":;":
                index += 1
            if index == first or index >= len(value) or value[index] != ";":
                return None
            index += 1
        elif value[index] in ("g", "G"):
            index += 1
            first = index
            while index < len(value) and value[index] not in ":;":
                index += 1
            if index == first or index >= len(value) or value[index] != ":":
                return None
            index += 1
            second = index
            while index < len(value) and value[index] != ";":
                index += 1
            if index == second or index >= len(value):
                return None
            index += 1
        else:
            while index < len(value) and value[index].isdigit():
                index += 1
            if index >= len(value) or not value[index].isalpha():
                return None
            while index < len(value) and value[index].isalpha():
                index += 1
            while index < len(value) and value[index].isdigit():
                index += 1
        found.append(value[start:index])
    return found


def tokens_compatible(english: str, italian: str) -> bool:
    english_tokens, italian_tokens = tokens(english), tokens(italian)
    if english_tokens is None or italian_tokens is None or len(english_tokens) != len(italian_tokens):
        return False
    plural = re.compile(r"\$[lL][^:;]+:[^:;]+;")
    gender = re.compile(r"\$[gG][^:;]+:[^;]+;")
    return all(source == target or
               (plural.fullmatch(source) and plural.fullmatch(target)) or
               (gender.fullmatch(source) and gender.fullmatch(target))
               for source, target in zip(english_tokens, italian_tokens))


def lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=DEFAULT_SOURCE)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--field", choices=("Description_lang", "AuraDescription_lang"),
                        default="Description_lang")
    parser.add_argument("--registry", choices=("spellDescriptionOverrides",
                                                "spellAuraDescriptionOverrides"),
                        default="spellDescriptionOverrides")
    arguments = parser.parse_args()

    entries = json.loads(arguments.source.read_text(encoding="utf-8"))["entries"]
    known: dict[str, set[str]] = defaultdict(set)
    for entry in entries:
        if entry["id"] >= TRUSTED_DONOR_MAX_ID:
            continue
        field = entry.get(arguments.field) or {}
        english, italian = field.get("enUS"), field.get("itIT")
        if english and italian and english != italian:
            known[english].add(italian)

    selected: list[tuple[int, str, str]] = []
    skipped_ambiguous = skipped_tokens = 0
    for entry in entries:
        field = entry.get(arguments.field) or {}
        english, current = field.get("enUS"), field.get("itIT")
        if not english or (current and current != english) or english not in known:
            continue
        italian_values = known[english]
        if len(italian_values) != 1:
            skipped_ambiguous += 1
            continue
        italian = next(iter(italian_values))
        if (not tokens_compatible(english, italian) or
                len(english) > 1600 or len(italian) > 1600):
            skipped_tokens += 1
            continue
        selected.append((entry["id"], english, italian))

    lines = [
        f"-- Generated by tools/generate_spell_reuse.py from Spell.db2 {arguments.field}.",
        "-- Each English description has one Italian match from a trusted low-ID record.",
        "-- The enUS text and all dynamic placeholders match exactly; no guesswork is used.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        f"ns.data.{arguments.registry} = ns.data.{arguments.registry} or {{}}",
        "local reused = {",
    ]
    for spell_id, english, italian in selected:
        lines.append(
            f"    [{spell_id}] = {{ en = {lua_string(english)}, description = {lua_string(italian)} }},"
        )
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        f"    if ns.data.{arguments.registry}[id] == nil then",
        f"        ns.data.{arguments.registry}[id] = record",
        "    end",
        "end",
    ]
    arguments.output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"reused={len(selected)} token_free={sum('$' not in en for _, en, _ in selected)} "
          f"ambiguous={skipped_ambiguous} token_mismatch={skipped_tokens} "
          f"output={arguments.output}")


if __name__ == "__main__":
    main()
