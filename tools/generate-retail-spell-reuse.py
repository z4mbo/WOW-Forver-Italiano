"""Generate optional Italian spell reuse packs from local Retail and beta DB2 dumps.

This script only reads extracted enUS/itIT JSON files. It never downloads data,
modifies the TOC, or includes the DB2 dumps in the repository. Exact packs require
matching ID and exact enUS text. Text-match packs require one distinct Retail
Italian value for the exact English string across all Retail donor IDs.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
DEFAULT_AUDIT = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit"
DEFAULT_BETA = DEFAULT_AUDIT / "locale-verified"
DEFAULT_RETAIL = DEFAULT_AUDIT / "retail-locale-verified"
DEFAULT_AUDIT_OUT = DEFAULT_AUDIT / "retail-reuse-generator-report.json"

sys.path.insert(0, str(ROOT / "tools"))
from generate_spell_reuse import tokens_compatible  # noqa: E402

# Manually reviewed Retail spell-name translations that are too dubious to
# propagate by English-only fallback. Exact ID matches remain eligible because
# they have independent source identity; this list affects the name text pack only.
SPELL_NAME_TEXT_FALLBACK_BLOCKLIST = {
    "Tactician",
    "Lunar Suffusion",
    "Book of the Dead",
    "Spirit Bomb Effect",
}

SPECS = (
    {
        "key": "spell_description", "table": "Spell", "field": "Description_lang",
        "registry": "spellDescriptionOverrides", "en_key": "en", "it_key": "description",
        "exact_file": "RetailSpellDescriptionMemory.lua",
        "text_file": "RetailSpellTextMatchMemory.lua", "tokenized": True,
    },
    {
        "key": "spell_aura", "table": "Spell", "field": "AuraDescription_lang",
        "registry": "spellAuraDescriptionOverrides", "en_key": "en", "it_key": "description",
        "exact_file": "RetailSpellAuraMemory.lua",
        "text_file": "RetailSpellAuraTextMatchMemory.lua", "tokenized": True,
    },
    {
        "key": "spell_name", "table": "SpellName", "field": "Name_lang",
        "registry": "spells", "en_key": "en", "it_key": "name",
        "exact_file": "RetailSpellNameMemory.lua",
        "text_file": "RetailSpellNameTextMatchMemory.lua", "tokenized": False,
    },
)


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value.get("entries"), list):
        raise ValueError(f"{path}: missing entries array")
    return value


def index_entries(path: Path, field: str) -> dict[int, dict[str, str]]:
    result: dict[int, dict[str, str]] = {}
    for row in load_json(path)["entries"]:
        record = row.get(field) or {}
        identifier = int(row["id"])
        if identifier in result:
            raise ValueError(f"{path}: duplicate ID {identifier}")
        result[identifier] = {
            "enUS": record.get("enUS") or "",
            "itIT": record.get("itIT") or "",
        }
    return result


def has_translation(en: str, it: str) -> bool:
    return bool(en and it and it != en and "\ufffd" not in en and "\ufffd" not in it)


def blank_or_english(it: str, en: str) -> bool:
    return not it or it == en


def encode_lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def load_addon_data(output_names: set[str]):
    try:
        from lupa import LuaRuntime
    except ImportError as error:
        raise RuntimeError("The bundled Python environment must provide lupa for addon conflict checks") from error
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute(
        "WFI_DB = {}; SlashCmdList = {}; "
        "CreateFrame = function() return { RegisterEvent=function() end, "
        "SetScript=function() end, UnregisterEvent=function() end } end"
    )
    namespace = lua.table()
    toc = (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig").splitlines()
    for raw in toc:
        name = raw.strip()
        if name == "Core.lua" or (name.startswith("Data\\") and name.lower().endswith(".lua")):
            if Path(name.replace("\\", "/")).name in output_names:
                continue
            file = ADDON / name.replace("\\", "/")
            if file.is_file():
                lua.execute(file.read_text(encoding="utf-8"), "WOWForverItaliano", namespace)
    return namespace.data


def record_value(lua_record, key: str):
    if lua_record is None:
        return None
    try:
        return lua_record[key]
    except (TypeError, KeyError):
        return None


def existing_override(registry, identifier: int):
    try:
        return registry[identifier]
    except (TypeError, KeyError):
        return None


def make_output(spec: dict[str, Any], records: list[tuple[int, str, str]], mode: str) -> str:
    is_name = spec["key"] == "spell_name"
    title = "exact ID and enUS text" if mode == "exact" else "unique enUS text; donor ID may differ"
    lines = [
        f"-- Generated from the installed Retail client and beta locale extracts ({title}).",
        "-- Optional pack: this file is intentionally not added to the TOC by the generator.",
    ]
    if mode == "text":
        lines.append("-- Text-match provenance: the Italian value is unique across all Retail donor IDs for the exact English string.")
    lines += [
        "local _, ns = ...",
        "ns.data = ns.data or {}",
    ]
    if is_name:
        lines += [
            "ns.data.spells = ns.data.spells or {}",
            "local reused = {",
        ]
    else:
        lines += [
            f"ns.data.{spec['registry']} = ns.data.{spec['registry']} or {{}}",
            "local reused = {",
        ]
    for identifier, en, it in sorted(records):
        lines.append(
            f"    [{identifier}] = {{ en = {encode_lua_string(en)}, "
            f"{spec['it_key']} = {encode_lua_string(it)} }},"
        )
    lines.append("}")
    if is_name:
        lines += [
            "for id, record in pairs(reused) do",
            "    local current = ns.data.spells[id]",
            "    if current == nil then",
            "        ns.data.spells[id] = record",
            "    elseif type(current) == \"table\" and current.name == nil and",
            "           (current.en == nil or current.en == record.en) then",
            "        current.en = current.en or record.en",
            "        current.name = record.name",
            "    end",
            "end",
        ]
    else:
        registry = spec["registry"]
        lines += [
            "for id, record in pairs(reused) do",
            f"    if ns.data.{registry}[id] == nil then",
            f"        ns.data.{registry}[id] = record",
            "    end",
            "end",
        ]
    return "\n".join(lines) + "\n"


def check_generated(path: Path, spec: dict[str, Any], records: list[tuple[int, str, str]]) -> None:
    """Compile with Lua and check every output pair against the selected source records."""
    from lupa import LuaRuntime

    lua = LuaRuntime(unpack_returned_tuples=True)
    namespace = lua.table()
    lua.execute("ns = {}; ns.data = {}")
    # Execute with a fresh addon namespace; a syntax error raises here.
    lua.execute(path.read_text(encoding="utf-8"), "WOWForverItaliano", namespace)
    registry = namespace.data[spec["registry"]]
    if spec["key"] == "spell_name":
        registry = namespace.data.spells
    if len(records) != sum(1 for _ in records):
        raise AssertionError(f"{path}: inconsistent record count")
    for identifier, en, it in records:
        value = registry[identifier]
        if value is None or value["en"] != en or value[spec["it_key"]] != it:
            raise AssertionError(f"{path}: Lua output mismatch at ID {identifier}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--beta-dir", type=Path, default=DEFAULT_BETA)
    parser.add_argument("--retail-dir", type=Path, default=DEFAULT_RETAIL)
    parser.add_argument("--output-dir", type=Path, default=ADDON / "Data")
    parser.add_argument("--report", type=Path, default=DEFAULT_AUDIT_OUT)
    arguments = parser.parse_args()

    output_names = {spec["exact_file"] for spec in SPECS} | {spec["text_file"] for spec in SPECS}
    addon_data = load_addon_data(output_names)
    report: dict[str, Any] = {
        "sources": {"beta": str(arguments.beta_dir), "retail": str(arguments.retail_dir)},
        "packs": {}, "ambiguity_samples": {},
        "manual_quality_blocklist": sorted(SPELL_NAME_TEXT_FALLBACK_BLOCKLIST),
    }

    for spec in SPECS:
        table = spec["table"]
        field = spec["field"]
        beta = index_entries(arguments.beta_dir / f"{table}.json", field)
        retail = index_entries(arguments.retail_dir / f"{table}.json", field)
        registry = addon_data[spec["registry"]]
        is_name = spec["key"] == "spell_name"
        exact: list[tuple[int, str, str]] = []
        exact_skips = Counter()
        for identifier, source in beta.items():
            en = source["enUS"]
            if not en:
                continue
            beta_it = source["itIT"]
            if not blank_or_english(beta_it, en):
                exact_skips["beta_already_has_italian"] += 1
                continue
            donor = retail.get(identifier)
            if donor is None or donor["enUS"] != en:
                exact_skips["same_id_missing_or_english_differs"] += 1
                continue
            it = donor["itIT"]
            if not has_translation(en, it):
                exact_skips["retail_italian_empty_or_same_as_english"] += 1
                continue
            if spec["tokenized"] and not tokens_compatible(en, it):
                exact_skips["token_incompatible"] += 1
                continue
            current = existing_override(registry, identifier)
            if is_name:
                current_name = record_value(current, "name")
                current_en = record_value(current, "en")
                if current_name:
                    exact_skips["addon_name_already_present"] += 1
                    continue
                if current_en and current_en != en:
                    exact_skips["addon_name_source_conflict"] += 1
                    continue
            elif current is not None:
                exact_skips["addon_override_already_present"] += 1
                continue
            exact.append((identifier, en, it))

        # For fallback, determine ambiguity from every translated Retail donor first.
        # Incompatible token shapes remain ambiguity evidence and are not silently discarded.
        translations_by_en: dict[str, set[str]] = defaultdict(set)
        donor_counts: Counter[str] = Counter()
        for donor in retail.values():
            en, it = donor["enUS"], donor["itIT"]
            if has_translation(en, it):
                translations_by_en[en].add(it)
                donor_counts[en] += 1
        ambiguous = {en: sorted(options) for en, options in translations_by_en.items() if len(options) > 1}
        text: list[tuple[int, str, str]] = []
        text_skips = Counter()
        ambiguity_targets: list[dict[str, Any]] = []
        exact_ids = {identifier for identifier, _, _ in exact}
        for identifier, source in beta.items():
            en, beta_it = source["enUS"], source["itIT"]
            if not en:
                continue
            if not blank_or_english(beta_it, en):
                text_skips["beta_already_has_italian"] += 1
                continue
            if identifier in exact_ids:
                text_skips["already_selected_by_exact_id_pack"] += 1
                continue
            if is_name and en in SPELL_NAME_TEXT_FALLBACK_BLOCKLIST:
                text_skips["manual_quality_blocklist"] += 1
                continue
            options = translations_by_en.get(en, set())
            if len(options) > 1:
                text_skips["ambiguous_retail_italian_for_english"] += 1
                if len(ambiguity_targets) < 12:
                    ambiguity_targets.append({"id": identifier, "enUS": en, "itIT_options": sorted(options)})
                continue
            if not options:
                text_skips["no_retail_italian_donor_for_english"] += 1
                continue
            it = next(iter(options))
            if spec["tokenized"] and not tokens_compatible(en, it):
                text_skips["unique_text_translation_token_incompatible"] += 1
                continue
            current = existing_override(registry, identifier)
            if is_name:
                current_name = record_value(current, "name")
                current_en = record_value(current, "en")
                if current_name:
                    text_skips["addon_name_already_present"] += 1
                    continue
                if current_en and current_en != en:
                    text_skips["addon_name_source_conflict"] += 1
                    continue
            elif current is not None:
                text_skips["addon_override_already_present"] += 1
                continue
            text.append((identifier, en, it))

        # Keep one bounded sample for an auditable ambiguity review.
        sample = sorted(
            ({"enUS": en, "itIT_options": variants, "retail_donor_count": donor_counts[en]}
             for en, variants in ambiguous.items()),
            key=lambda row: (-len(row["itIT_options"]), row["enUS"])
        )[:12]
        report["ambiguity_samples"][spec["key"]] = {"translation_conflict_groups": sample,
                                                            "beta_ambiguous_targets": ambiguity_targets}
        for mode, records, filename, skipped in (
            ("exact_id", exact, spec["exact_file"], exact_skips),
            ("unique_english_text", text, spec["text_file"], text_skips),
        ):
            path = arguments.output_dir / filename
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(make_output(spec, records, "exact" if mode == "exact_id" else "text"), encoding="utf-8")
            check_generated(path, spec, records)
            # Revalidate source pairing/placeholder contract after Lua compilation.
            for identifier, en, it in records:
                beta_source = beta[identifier]
                if beta_source["enUS"] != en or not blank_or_english(beta_source["itIT"], en):
                    raise AssertionError(f"{filename}: beta source changed at ID {identifier}")
                if mode == "exact_id":
                    retail_source = retail.get(identifier)
                    if retail_source is None or retail_source["enUS"] != en or retail_source["itIT"] != it:
                        raise AssertionError(f"{filename}: exact Retail source mismatch at ID {identifier}")
                else:
                    if len(translations_by_en.get(en, set())) != 1 or next(iter(translations_by_en[en])) != it:
                        raise AssertionError(f"{filename}: text provenance is ambiguous at ID {identifier}")
                if spec["tokenized"] and not tokens_compatible(en, it):
                    raise AssertionError(f"{filename}: token incompatibility at ID {identifier}")
            report["packs"][filename] = {
                "mode": mode, "registry": spec["registry"], "field": field,
                "count": len(records), "unique_english": len({en for _, en, _ in records}),
                "ids": [identifier for identifier, _, _ in records],
                "skipped": dict(skipped), "path": str(path),
            }

    arguments.report.parent.mkdir(parents=True, exist_ok=True)
    arguments.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    for filename, entry in report["packs"].items():
        print(f"{filename}: {entry['count']} records; {entry['unique_english']} unique enUS; {entry['path']}")
    print(f"Audit report: {arguments.report}")
    print("Lua syntax, source IDs/text, addon conflicts, and placeholder checks passed.")


if __name__ == "__main__":
    main()
