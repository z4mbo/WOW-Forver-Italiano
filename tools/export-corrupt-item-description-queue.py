"""Group demonstrably mismapped item descriptions with exact item-name guards."""

import json
import os
import tempfile
from collections import OrderedDict
from pathlib import Path


audit = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-casc-audit"
collisions = json.loads((audit / "corrupt-itit-review.json").read_text(encoding="utf-8"))
items = json.loads((audit / "locale-verified" / "ItemSparse.json").read_text(encoding="utf-8"))["entries"]
by_id = {item["id"]: item for item in items}
groups = OrderedDict()
for collision in collisions:
    if collision["table"] != "ItemSparse" or collision["field"] != "Description_lang":
        continue
    item = by_id[collision["id"]]
    source = item["Description_lang"]["enUS"]
    bad_italian = item["Description_lang"]["itIT"]
    if source != collision["en"] or bad_italian != collision["it"]:
        raise ValueError(f"Audit source mismatch for ItemSparse ID {collision['id']}")
    english_name = item["Display_lang"]["enUS"]
    italian_name = item["Display_lang"].get("itIT")
    if not english_name:
        raise ValueError(f"Missing exact English item name for {collision['id']}")
    groups.setdefault(source, {"en": source, "rows": []})["rows"].append({
        "id": collision["id"], "enName": english_name, "itName": italian_name,
        "badIt": bad_italian,
    })
queue = list(groups.values())
out = audit / "corrupt-item-description-queue.json"
out.write_text(json.dumps(queue, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"{out}: sources={len(queue)} ids={sum(len(group['rows']) for group in queue)}")
