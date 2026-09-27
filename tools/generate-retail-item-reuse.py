"""Generate item name/description fallbacks from the installed Retail DB2.

Retail is used only where its ItemSparse record has the same ID and exact
enUS text as the Forever beta record. Italian strings are accepted only when
they are nonempty, differ from the English text, and are unambiguous for that
English source. Existing add-on entries are left in place.
"""

from __future__ import annotations

import json
import os
import re
from collections import defaultdict
from pathlib import Path
from typing import Any

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Addon"
TEMP = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit"
BETA_FILE = TEMP / "locale-verified" / "ItemSparse.json"
RETAIL_FILE = TEMP / "retail-locale-verified" / "ItemSparse.json"
OUTPUT_DIR = TEMP / "retail-item-spell-b"
DESCRIPTION_OUTPUT = ADDON / "Data" / "RetailItemDescriptionMemory.lua"
NAME_OUTPUT = ADDON / "Data" / "RetailItemNameMemory.lua"
TEXT_DESCRIPTION_OUTPUT = ADDON / "Data" / "RetailItemDescriptionTextMatchMemory.lua"
TEXT_NAME_OUTPUT = ADDON / "Data" / "RetailItemNameTextMatchMemory.lua"
REPORT_OUTPUT = OUTPUT_DIR / "generation-report.json"

# Preserve placeholder and WoW markup order. The contents of $g alternatives
# can be localized, so compare the structural token rather than its wording.
TOKEN_RE = re.compile(
    r"\$g[^;\r\n]*;"
    r"|\$[A-Za-z][A-Za-z0-9]*"
    r"|\$[0-9]+"
    r"|\|c[0-9A-Fa-f]{8}"
    r"|\|r"
    r"|\|T[^|]*\|t"
    r"|\|A[^|]*\|a"
    r"|\|H[^|]*\|h"
    r"|\|h"
    r"|\|n"
    r"|%%"
    r"|%(?:[0-9]+\$)?[-+#0 ]*[0-9]*(?:\.[0-9]+)?[sdf]"
    r"|\{[0-9]+\}"
)
UNSUPPORTED_MARKUP_RE = re.compile(r"<\s*/?\s*[A-Za-z][^>]*>")
UNRELIABLE_ITEM_NAME_RE = re.compile(
    r"\b(?:DNT|DEP|DEBUG|TEST|DEPRECATED|PLACEHOLDER|UNUSED|OLD)\b|"
    r"\[\s*PH\s*\]|\(\s*old\d*\s*\)",
    re.IGNORECASE,
)


def read_json(path: Path) -> list[dict[str, Any]]:
    return json.loads(path.read_text(encoding="utf-8-sig"))["entries"]


def safe_text(value: Any, *, max_length: int = 1600) -> bool:
    return (
        isinstance(value, str)
        and bool(value)
        and len(value) <= max_length
        and not any(char in value for char in ("\r", "\n", "\x00", "\ufffd"))
        and not UNSUPPORTED_MARKUP_RE.search(value)
    )


def token_signature(value: str) -> tuple[str, ...]:
    return tuple(TOKEN_RE.findall(value))


def tokens_compatible(english: str, italian: str) -> bool:
    return token_signature(english) == token_signature(italian)


def reliable_item_name(english: Any, italian_source: Any = None) -> bool:
    return (
        safe_text(english, max_length=300)
        and not UNRELIABLE_ITEM_NAME_RE.search(english)
        and not (isinstance(italian_source, str) and UNRELIABLE_ITEM_NAME_RE.search(italian_source))
    )


def lua_string(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def load_current_addon(toc_text: str | None = None) -> tuple[LuaRuntime, Any]:
    """Load current data files to exclude IDs already covered by the add-on."""
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.execute(
        "WFI_DB = {}; SlashCmdList = {}; "
        "CreateFrame = function() return { "
        "RegisterEvent=function() end, UnregisterEvent=function() end, "
        "SetScript=function() end } end"
    )
    namespace = lua.table()
    toc = ADDON / "WOWForverItaliano.toc"
    toc_source = toc_text if toc_text is not None else toc.read_text(encoding="utf-8-sig")
    for line in toc_source.splitlines():
        name = line.strip().replace("\\", "/")
        if name == "Core.lua" or (name.startswith("Data/") and name.endswith(".lua")):
            if name in {
                "Data/RetailItemDescriptionMemory.lua",
                "Data/RetailItemNameMemory.lua",
                "Data/RetailItemDescriptionTextMatchMemory.lua",
                "Data/RetailItemNameTextMatchMemory.lua",
            }:
                continue
            lua.execute((ADDON / name).read_text(encoding="utf-8"), "WOWForverItaliano", namespace)
    return lua, namespace


def field(entry: dict[str, Any], name: str) -> dict[str, Any]:
    value = entry.get(name)
    return value if isinstance(value, dict) else {}


def entry_id(entry: dict[str, Any]) -> int:
    return int(entry.get("id", entry.get("ID")))


def collect_candidates(
    beta_entries: list[dict[str, Any]], retail_entries: list[dict[str, Any]], namespace: Any
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    retail_by_id = {entry_id(entry): entry for entry in retail_entries}
    beta_ids_in_retail = 0
    exact_name_pairs: list[dict[str, Any]] = []
    exact_description_pairs: list[dict[str, Any]] = []
    for beta in beta_entries:
        identifier = entry_id(beta)
        retail = retail_by_id.get(identifier)
        if retail is None:
            continue
        beta_ids_in_retail += 1
        beta_display, retail_display = field(beta, "Display_lang"), field(retail, "Display_lang")
        beta_description = field(beta, "Description_lang")
        retail_description = field(retail, "Description_lang")

        beta_name_en = beta_display.get("enUS")
        beta_name_it = beta_display.get("itIT")
        retail_name_en = retail_display.get("enUS")
        retail_name_it = retail_display.get("itIT")
        reliable_name = reliable_item_name(beta_name_en, beta_name_it)
        if (safe_text(beta_name_en, max_length=300) and beta_name_en == retail_name_en
                and reliable_name
                and safe_text(retail_name_it, max_length=300)
                and retail_name_it != retail_name_en
                and (not beta_name_it or beta_name_it == beta_name_en)):
            exact_name_pairs.append({
                "id": identifier,
                "en": beta_name_en,
                "it": retail_name_it,
                "beta_it": beta_name_it,
            })

        beta_desc_en = beta_description.get("enUS")
        beta_desc_it = beta_description.get("itIT")
        retail_desc_en = retail_description.get("enUS")
        retail_desc_it = retail_description.get("itIT")
        if (reliable_name and safe_text(beta_desc_en) and beta_desc_en == retail_desc_en
                and safe_text(retail_desc_it)
                and retail_desc_it != retail_desc_en
                and (not beta_desc_it or beta_desc_it == beta_desc_en)
                and tokens_compatible(beta_desc_en, retail_desc_it)):
            exact_description_pairs.append({
                "id": identifier,
                "en": beta_desc_en,
                "it": retail_desc_it,
                "beta_it": beta_desc_it,
                "en_name": beta_name_en,
                "it_name": beta_name_it,
            })

    data = namespace["data"]
    existing_names = data["items"]
    existing_descriptions = data["itemDescriptionOverrides"]

    def unambiguous(pairs: list[dict[str, Any]]) -> tuple[set[str], int]:
        translations: dict[str, set[str]] = defaultdict(set)
        for pair in pairs:
            translations[pair["en"]].add(pair["it"])
        conflicts = {english for english, options in translations.items() if len(options) != 1}
        return conflicts, len(translations)

    name_conflicts, unique_name_sources = unambiguous(exact_name_pairs)
    description_conflicts, unique_description_sources = unambiguous(exact_description_pairs)
    names: list[dict[str, Any]] = []
    descriptions: list[dict[str, Any]] = []
    skipped_existing_names = 0
    skipped_existing_descriptions = 0
    skipped_name_conflicts = 0
    skipped_description_conflicts = 0
    for pair in exact_name_pairs:
        identifier = pair["id"]
        current = existing_names[identifier]
        if pair["en"] in name_conflicts:
            skipped_name_conflicts += 1
            continue
        if current is not None:
            if not (isinstance(current, type(data)) and current["name"] is None
                    and (current["en"] is None or current["en"] == pair["en"])):
                skipped_existing_names += 1
                continue
        record: dict[str, Any] = {"id": identifier, "en": pair["en"], "name": pair["it"]}
        beta_it = pair["beta_it"]
        if beta_it and beta_it != pair["en"] and beta_it != pair["it"]:
            record["itSource"] = beta_it
        names.append(record)

    for pair in exact_description_pairs:
        identifier = pair["id"]
        if pair["en"] in description_conflicts:
            skipped_description_conflicts += 1
            continue
        if existing_descriptions[identifier] is not None:
            skipped_existing_descriptions += 1
            continue
        record = {
            "id": identifier,
            "enName": pair["en_name"],
            "enDescription": pair["en"],
            "description": pair["it"],
        }
        if pair["it_name"]:
            record["itName"] = pair["it_name"]
        descriptions.append(record)

    stats = {
        "betaIdsPresentInRetail": beta_ids_in_retail,
        "exactEnglishNameCandidates": len(exact_name_pairs),
        "exactEnglishDescriptionCandidatesAfterTokenCheck": len(exact_description_pairs),
        "uniqueEnglishNameCandidateStrings": unique_name_sources,
        "uniqueEnglishDescriptionCandidateStrings": unique_description_sources,
        "nameStringsWithConflictingRetailItalian": len(name_conflicts),
        "descriptionStringsWithConflictingRetailItalian": len(description_conflicts),
        "skippedNamesAlreadyCoveredOrConflictingEn": skipped_existing_names,
        "skippedDescriptionsAlreadyCovered": skipped_existing_descriptions,
        "skippedNameTranslationConflicts": skipped_name_conflicts,
        "skippedDescriptionTranslationConflicts": skipped_description_conflicts,
        "generatedNameRows": len(names),
        "generatedDescriptionRows": len(descriptions),
        "generatedNamesWithItSource": sum("itSource" in row for row in names),
        "generatedDescriptionsWithItName": sum("itName" in row for row in descriptions),
    }
    return names, descriptions, stats


def collect_text_match_candidates(
    beta_entries: list[dict[str, Any]],
    retail_entries: list[dict[str, Any]],
    namespace: Any,
    exact_name_ids: set[int],
    exact_description_ids: set[int],
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], dict[str, Any]]:
    """Reuse a single Italian value for an exact English source across Retail IDs."""
    name_donors: dict[str, set[str]] = defaultdict(set)
    description_donors: dict[str, set[str]] = defaultdict(set)
    for donor in retail_entries:
        display = field(donor, "Display_lang")
        donor_name_en, donor_name_it = display.get("enUS"), display.get("itIT")
        if (reliable_item_name(donor_name_en, donor_name_it)
                and safe_text(donor_name_it, max_length=300)
                and donor_name_it != donor_name_en):
            name_donors[donor_name_en].add(donor_name_it)

        description = field(donor, "Description_lang")
        donor_desc_en, donor_desc_it = description.get("enUS"), description.get("itIT")
        if (reliable_item_name(donor_name_en, donor_name_it)
                and safe_text(donor_desc_en) and safe_text(donor_desc_it)
                and donor_desc_it != donor_desc_en
                and tokens_compatible(donor_desc_en, donor_desc_it)):
            description_donors[donor_desc_en].add(donor_desc_it)

    ambiguous_names = {english for english, options in name_donors.items() if len(options) != 1}
    ambiguous_descriptions = {
        english for english, options in description_donors.items() if len(options) != 1
    }
    data = namespace["data"]
    existing_names = data["items"]
    existing_descriptions = data["itemDescriptionOverrides"]
    names: list[dict[str, Any]] = []
    descriptions: list[dict[str, Any]] = []
    skipped_existing_names = 0
    skipped_existing_descriptions = 0
    skipped_exact_name_ids = 0
    skipped_exact_description_ids = 0
    skipped_ambiguous_names = 0
    skipped_ambiguous_descriptions = 0
    skipped_incompatible_descriptions = 0

    for beta in beta_entries:
        identifier = entry_id(beta)
        display = field(beta, "Display_lang")
        name_en, name_it = display.get("enUS"), display.get("itIT")
        reliable_name = reliable_item_name(name_en, name_it)
        if reliable_name and (not name_it or name_it == name_en):
            options = name_donors.get(name_en, set())
            if len(options) > 1:
                skipped_ambiguous_names += 1
            elif len(options) == 1:
                if identifier in exact_name_ids:
                    skipped_exact_name_ids += 1
                else:
                    current = existing_names[identifier]
                    if current is not None and not (
                        isinstance(current, type(data))
                        and current["name"] is None
                        and (current["en"] is None or current["en"] == name_en)
                    ):
                        skipped_existing_names += 1
                    else:
                        record: dict[str, Any] = {
                            "id": identifier,
                            "en": name_en,
                            "name": next(iter(options)),
                        }
                        if name_it and name_it != name_en and name_it != record["name"]:
                            record["itSource"] = name_it
                        names.append(record)

        description = field(beta, "Description_lang")
        description_en, description_it = description.get("enUS"), description.get("itIT")
        if not reliable_name or not safe_text(description_en) or (
            description_it and description_it != description_en
        ):
            continue
        options = description_donors.get(description_en, set())
        if len(options) > 1:
            skipped_ambiguous_descriptions += 1
            continue
        if len(options) != 1:
            continue
        translation = next(iter(options))
        if not tokens_compatible(description_en, translation):
            skipped_incompatible_descriptions += 1
            continue
        if identifier in exact_description_ids:
            skipped_exact_description_ids += 1
            continue
        if existing_descriptions[identifier] is not None:
            skipped_existing_descriptions += 1
            continue
        record = {
            "id": identifier,
            "enName": name_en,
            "enDescription": description_en,
            "description": translation,
        }
        if name_it:
            record["itName"] = name_it
        descriptions.append(record)

    stats = {
        "retailNameDonorStrings": len(name_donors),
        "retailDescriptionDonorStrings": len(description_donors),
        "ambiguousRetailNameDonorStrings": len(ambiguous_names),
        "ambiguousRetailDescriptionDonorStrings": len(ambiguous_descriptions),
        "textMatchNameRowsSkippedForExactPack": skipped_exact_name_ids,
        "textMatchDescriptionRowsSkippedForExactPack": skipped_exact_description_ids,
        "textMatchNameRowsSkippedForExistingAddon": skipped_existing_names,
        "textMatchDescriptionRowsSkippedForExistingAddon": skipped_existing_descriptions,
        "textMatchNameRowsSkippedForAmbiguousSource": skipped_ambiguous_names,
        "textMatchDescriptionRowsSkippedForAmbiguousSource": skipped_ambiguous_descriptions,
        "textMatchDescriptionRowsSkippedForTokenMismatch": skipped_incompatible_descriptions,
        "generatedTextMatchNameRows": len(names),
        "generatedTextMatchDescriptionRows": len(descriptions),
        "generatedTextMatchNamesWithItSource": sum("itSource" in row for row in names),
        "generatedTextMatchDescriptionsWithItName": sum("itName" in row for row in descriptions),
    }
    return names, descriptions, stats


def lua_pack_names(rows: list[dict[str, Any]]) -> str:
    lines = [
        "-- Generated from exact ItemSparse Retail enUS/itIT matches for Forever beta IDs.",
        "-- The source ID and exact beta enUS name gate every fallback; existing names are preserved.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        "ns.data.items = ns.data.items or {}",
        "local reused = {",
    ]
    for row in rows:
        fields = [f"en = {lua_string(row['en'])}", f"name = {lua_string(row['name'])}"]
        if "itSource" in row:
            fields.append(f"itSource = {lua_string(row['itSource'])}")
        lines.append(f"    [{row['id']}] = {{ {', '.join(fields)} }},")
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        "    local current = ns.data.items[id]",
        "    if current == nil then",
        "        current = {}",
        "        ns.data.items[id] = current",
        "    end",
        "    if type(current) == \"table\" and current.name == nil and",
        "       (current.en == nil or current.en == record.en) then",
        "        current.en = current.en or record.en",
        "        current.name = record.name",
        "        if current.itSource == nil and record.itSource ~= nil then",
        "            current.itSource = record.itSource",
        "        end",
        "    end",
        "end",
        "",
    ]
    return "\n".join(lines)


def lua_pack_descriptions(rows: list[dict[str, Any]]) -> str:
    lines = [
        "-- Generated from exact ItemSparse Retail enUS/itIT matches for Forever beta IDs.",
        "-- Beta enName/itName source fields are retained for the tooltip ID/name gate.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        "ns.data.itemDescriptionOverrides = ns.data.itemDescriptionOverrides or {}",
        "local reused = {",
    ]
    for row in rows:
        fields = [f"enName = {lua_string(row['enName'])}"]
        if "itName" in row:
            fields.append(f"itName = {lua_string(row['itName'])}")
        fields += [
            f"enDescription = {lua_string(row['enDescription'])}",
            f"description = {lua_string(row['description'])}",
        ]
        lines.append(f"    [{row['id']}] = {{ {', '.join(fields)} }},")
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        "    if ns.data.itemDescriptionOverrides[id] == nil then",
        "        ns.data.itemDescriptionOverrides[id] = record",
        "    end",
        "end",
        "",
    ]
    return "\n".join(lines)


def lua_pack_text_names(rows: list[dict[str, Any]]) -> str:
    lines = [
        "-- Generated from unambiguous ItemSparse Retail translations keyed by exact enUS text.",
        "-- Used only for beta IDs not covered by exact-ID Retail or existing name entries.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        "ns.data.items = ns.data.items or {}",
        "local reused = {",
    ]
    for row in rows:
        fields = [f"en = {lua_string(row['en'])}", f"name = {lua_string(row['name'])}"]
        if "itSource" in row:
            fields.append(f"itSource = {lua_string(row['itSource'])}")
        lines.append(f"    [{row['id']}] = {{ {', '.join(fields)} }},")
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        "    local current = ns.data.items[id]",
        "    if current == nil then",
        "        current = {}",
        "        ns.data.items[id] = current",
        "    end",
        "    if type(current) == \"table\" and current.name == nil and",
        "       (current.en == nil or current.en == record.en) then",
        "        current.en = current.en or record.en",
        "        current.name = record.name",
        "        if current.itSource == nil and record.itSource ~= nil then",
        "            current.itSource = record.itSource",
        "        end",
        "    end",
        "end",
        "",
    ]
    return "\n".join(lines)


def lua_pack_text_descriptions(rows: list[dict[str, Any]]) -> str:
    lines = [
        "-- Generated from unambiguous ItemSparse Retail translations keyed by exact enUS text.",
        "-- Exact-ID Retail and existing item description overrides take precedence.",
        "local _, ns = ...",
        "ns.data = ns.data or {}",
        "ns.data.itemDescriptionOverrides = ns.data.itemDescriptionOverrides or {}",
        "local reused = {",
    ]
    for row in rows:
        fields = [f"enName = {lua_string(row['enName'])}"]
        if "itName" in row:
            fields.append(f"itName = {lua_string(row['itName'])}")
        fields += [
            f"enDescription = {lua_string(row['enDescription'])}",
            f"description = {lua_string(row['description'])}",
        ]
        lines.append(f"    [{row['id']}] = {{ {', '.join(fields)} }},")
    lines += [
        "}",
        "for id, record in pairs(reused) do",
        "    if ns.data.itemDescriptionOverrides[id] == nil then",
        "        ns.data.itemDescriptionOverrides[id] = record",
        "    end",
        "end",
        "",
    ]
    return "\n".join(lines)


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    beta_entries = read_json(BETA_FILE)
    retail_entries = read_json(RETAIL_FILE)
    lua, namespace = load_current_addon()
    names, descriptions, stats = collect_candidates(beta_entries, retail_entries, namespace)
    text_names, text_descriptions, text_stats = collect_text_match_candidates(
        beta_entries,
        retail_entries,
        namespace,
        {row["id"] for row in names},
        {row["id"] for row in descriptions},
    )

    # Simulate adding all four generated packs to the TOC. The loader must
    # exclude them so reruns retain the same set of existing add-on overrides.
    toc_text = (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig")
    simulated_toc = toc_text + "\n" + "\n".join(
        (
            "Data/RetailItemNameMemory.lua",
            "Data/RetailItemDescriptionMemory.lua",
            "Data/RetailItemNameTextMatchMemory.lua",
            "Data/RetailItemDescriptionTextMatchMemory.lua",
        )
    )
    _, simulated_namespace = load_current_addon(simulated_toc)
    current_data, simulated_data = namespace["data"], simulated_namespace["data"]
    if (len(list(current_data["items"].items())) != len(list(simulated_data["items"].items()))
            or len(list(current_data["itemDescriptionOverrides"].items()))
            != len(list(simulated_data["itemDescriptionOverrides"].items()))):
        raise RuntimeError("Generated Retail packs changed current add-on coverage when simulated in TOC")
    NAME_OUTPUT.write_text(lua_pack_names(names), encoding="utf-8")
    DESCRIPTION_OUTPUT.write_text(lua_pack_descriptions(descriptions), encoding="utf-8")
    TEXT_NAME_OUTPUT.write_text(lua_pack_text_names(text_names), encoding="utf-8")
    TEXT_DESCRIPTION_OUTPUT.write_text(
        lua_pack_text_descriptions(text_descriptions), encoding="utf-8"
    )

    report = {
        "retailBuild": "12.1.0.69933",
        "betaSource": str(BETA_FILE),
        "retailSource": str(RETAIL_FILE),
        "betaRows": len(beta_entries),
        "retailRows": len(retail_entries),
        "nameOutput": str(NAME_OUTPUT),
        "descriptionOutput": str(DESCRIPTION_OUTPUT),
        "textMatchNameOutput": str(TEXT_NAME_OUTPUT),
        "textMatchDescriptionOutput": str(TEXT_DESCRIPTION_OUTPUT),
        **stats,
        **text_stats,
        "simulatedTocExcludesAllFourOutputs": True,
    }
    REPORT_OUTPUT.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    # Parse generated Lua packs before returning success.
    for source in (
        lua_pack_names(names),
        lua_pack_descriptions(descriptions),
        lua_pack_text_names(text_names),
        lua_pack_text_descriptions(text_descriptions),
    ):
        lua.execute("assert(load(...))", source)
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
