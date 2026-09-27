"""Check bulk item tooltip descriptions against the installed beta DB2 extract."""

import json
import os
from pathlib import Path

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified" / "ItemSparse.json"
PACKS = ("BulkItemDescriptions.lua", "BulkItemDescriptionsHigh.lua",
         "BulkItemFrequent.lua", "BulkItemFrequentMore.lua",
         "BulkItemFrequentNext.lua", "BulkItemFrequentFinal.lua",
         "BulkItemFrequentNext2.lua", "BulkItemFrequentNext3.lua",
         "BulkItemFrequentNext4.lua",
         "RetailItemDescriptionMemory.lua",
         "RetailItemDescriptionTextMatchMemory.lua",
         "ItemTranslationAliases.lua")


def main() -> None:
    source = {item["id"]: item for item in
              json.loads(SOURCE.read_text(encoding="utf-8"))["entries"]}
    errors = []
    total = set()
    for pack_name in PACKS:
        lua = LuaRuntime(unpack_returned_tuples=True)
        namespace = lua.table()
        pack = ROOT / "Addon" / "Data" / pack_name
        if not pack.exists():
            continue
        lua.execute(pack.read_text(encoding="utf-8"), "WOWForverItaliano", namespace)
        records = namespace.data.itemDescriptionOverrides
        for item_id, record in records.items():
            item = source.get(int(item_id))
            if not item:
                errors.append(f"{pack_name}: {item_id}: no local item source")
                continue
            display, description = item["Display_lang"], item.get("Description_lang") or {}
            if record.enName != display.get("enUS"):
                errors.append(f"{pack_name}: {item_id}: English item name mismatch")
            if record.itName != (display.get("itIT") or None):
                errors.append(f"{pack_name}: {item_id}: Italian item name mismatch")
            if record.enDescription != description.get("enUS"):
                errors.append(f"{pack_name}: {item_id}: English description mismatch")
            if description.get("itIT") not in ("", record.enDescription):
                errors.append(f"{pack_name}: {item_id}: already localized in client")
            if not record.description or record.description == record.enDescription:
                errors.append(f"{pack_name}: {item_id}: untranslated description")
            if item_id in total:
                errors.append(f"{pack_name}: {item_id}: duplicate override")
            total.add(item_id)
        print(f"{pack_name}: {sum(1 for _ in records.items())} entries")
    print(f"item_description_overrides={len(total)}")
    if errors:
        raise SystemExit("\n".join(errors[:30]))
    print("All item source checks passed.")


if __name__ == "__main__":
    main()
