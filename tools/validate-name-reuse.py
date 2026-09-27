"""Verify generated spell and item name memories against local client DB2."""

from __future__ import annotations

import json
import os
from collections import defaultdict
from pathlib import Path

from lupa import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified"
TRUSTED_DONOR_MAX_ID = 100_000
KINDS = (
    ("SpellName.json", "Name_lang", "SpellNameTranslationMemory.lua", "spells"),
    ("ItemSparse.json", "Display_lang", "ItemNameTranslationMemory.lua", "items"),
)


def main() -> None:
    errors = []
    official_item_ids = set()
    for db2_file, field_name, lua_file, registry in KINDS:
        entries = json.loads((SOURCE / db2_file).read_text(encoding="utf-8"))["entries"]
        by_id = {entry["id"]: entry.get(field_name) or {} for entry in entries}
        known: dict[str, set[str]] = defaultdict(set)
        for identifier, field in by_id.items():
            if identifier >= TRUSTED_DONOR_MAX_ID:
                continue
            english, italian = field.get("enUS"), field.get("itIT")
            if english and italian and english != italian:
                known[english].add(italian)

        lua = LuaRuntime(unpack_returned_tuples=True)
        namespace = lua.table()
        lua.execute((ROOT / "Addon" / "Data" / lua_file).read_text(encoding="utf-8"),
                    "WOWForverItaliano", namespace)
        records = namespace.data[registry]
        count = 0
        for identifier, record in records.items():
            count += 1
            if lua_file == "ItemNameTranslationMemory.lua":
                official_item_ids.add(int(identifier))
            field = by_id.get(int(identifier))
            if not field or field.get("enUS") != record.en:
                errors.append(f"{lua_file}: {identifier}: source name differs")
                continue
            if field.get("itIT") not in ("", record.en):
                errors.append(f"{lua_file}: {identifier}: already localized")
            options = known.get(record.en, ())
            if len(options) != 1 or record.name not in options:
                errors.append(f"{lua_file}: {identifier}: no unique official name")
        print(f"{lua_file}: {count} verified names")
    item_source = {
        entry["id"]: entry.get("Display_lang") or {}
        for entry in json.loads((SOURCE / "ItemSparse.json").read_text(
            encoding="utf-8"))["entries"]
    }
    manual_file = "BulkItemNamesA.lua"
    lua = LuaRuntime(unpack_returned_tuples=True)
    namespace = lua.table()
    lua.execute((ROOT / "Addon" / "Data" / manual_file).read_text(encoding="utf-8"),
                "WOWForverItaliano", namespace)
    records = namespace.data["items"]
    earlier_lua = LuaRuntime(unpack_returned_tuples=True)
    earlier_lua.execute("WFI_DB = {}; SlashCmdList = {}; CreateFrame = function() return { RegisterEvent=function() end, SetScript=function() end } end")
    earlier = earlier_lua.table()
    for raw in (ROOT / "Addon" / "WOWForverItaliano.toc").read_text(
            encoding="utf-8-sig").splitlines():
        toc_name = raw.strip()
        if toc_name == "Data\\BulkItemNamesA.lua":
            break
        if toc_name == "Core.lua" or (toc_name.startswith("Data\\") and
                                     toc_name.endswith(".lua")):
            earlier_lua.execute((ROOT / "Addon" / toc_name.replace("\\", "/")).read_text(
                encoding="utf-8"), "WOWForverItaliano", earlier)
    earlier_items = earlier.data["items"]
    for identifier, record in records.items():
        identifier = int(identifier)
        field = item_source.get(identifier) or {}
        if field.get("enUS") != record.en:
            errors.append(f"{manual_file}: {identifier}: source name differs")
        if not record.name or record.name == record.en:
            errors.append(f"{manual_file}: {identifier}: untranslated name")
        if field.get("itIT") not in ("", record.en, record.name, record.itSource):
            errors.append(f"{manual_file}: {identifier}: unrecorded itIT source")
        if record.itSource and field.get("itIT") != record.itSource:
            errors.append(f"{manual_file}: {identifier}: itSource differs")
        if identifier in official_item_ids:
            errors.append(f"{manual_file}: {identifier}: official pack already supplies name")
        if earlier_items[identifier] is not None:
            errors.append(f"{manual_file}: {identifier}: would overwrite earlier item data")
    print(f"{manual_file}: {sum(1 for _ in records.items())} manually reviewed names")

    spell_source = {
        entry["id"]: entry.get("Name_lang") or {}
        for entry in json.loads((SOURCE / "SpellName.json").read_text(
            encoding="utf-8"))["entries"]
    }
    spell_file = "BulkSpellNamesB.lua"
    spell_lua = LuaRuntime(unpack_returned_tuples=True)
    spell_namespace = spell_lua.table()
    spell_lua.execute((ROOT / "Addon" / "Data" / spell_file).read_text(
        encoding="utf-8"), "WOWForverItaliano", spell_namespace)
    spell_records = spell_namespace.data["spells"]
    official_item_names: dict[str, set[str]] = defaultdict(set)
    for identifier, field in item_source.items():
        if identifier >= TRUSTED_DONOR_MAX_ID:
            continue
        english, italian = field.get("enUS"), field.get("itIT")
        if english and italian and italian != english:
            official_item_names[english].add(italian)
    for identifier, record in spell_records.items():
        field = spell_source.get(int(identifier)) or {}
        if field.get("enUS") != record.en:
            errors.append(f"{spell_file}: {identifier}: source name differs")
        if not record.name or record.name == record.en:
            errors.append(f"{spell_file}: {identifier}: untranslated name")
        if field.get("itIT") not in ("", record.en):
            errors.append(f"{spell_file}: {identifier}: already localized")
        official = official_item_names.get(record.en, ())
        if len(official) == 1 and record.name not in official:
            errors.append(f"{spell_file}: {identifier}: differs from official item name")
    print(f"{spell_file}: {sum(1 for _ in spell_records.items())} manually reviewed names")

    corrupted_file = "VerifiedCorruptedItemNames.lua"
    corrupted_lua = LuaRuntime(unpack_returned_tuples=True)
    corrupted_namespace = corrupted_lua.table()
    corrupted_lua.execute((ROOT / "Addon" / "Data" / corrupted_file).read_text(
        encoding="utf-8"), "WOWForverItaliano", corrupted_namespace)
    corrupted_records = corrupted_namespace.data["items"]
    for identifier, record in corrupted_records.items():
        field = item_source.get(int(identifier)) or {}
        if field.get("enUS") != record.en:
            errors.append(f"{corrupted_file}: {identifier}: source name differs")
        if field.get("itIT") != record.itSource:
            errors.append(f"{corrupted_file}: {identifier}: corrupted Italian source differs")
        if not record.name or record.name == record.en or record.name == record.itSource:
            errors.append(f"{corrupted_file}: {identifier}: no usable Italian name")
    print(f"{corrupted_file}: {sum(1 for _ in corrupted_records.items())} source-checked corrections")
    if errors:
        raise SystemExit("\n".join(errors[:30]))
    print("All source and name checks passed.")


if __name__ == "__main__":
    main()
