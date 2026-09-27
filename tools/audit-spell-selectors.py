"""List WoW plural/gender selector words in Luna spell-description drafts."""

import json
import os
import re
import tempfile
from collections import Counter
from pathlib import Path


memory = json.loads((Path(os.environ.get("TEMP", tempfile.gettempdir())) /
                     "wfi-luna-batch" / "spell-description" /
                     "memory.json").read_text(encoding="utf-8"))
selector = re.compile(r"\$[lLgG]([^:;]+):([^;]+);")
forms = Counter()
examples = {}
for source, record in memory.items():
    for singular, plural in selector.findall(record["it"]):
        key = (singular, plural)
        forms[key] += 1
        examples.setdefault(key, source)
for (singular, plural), count in forms.most_common():
    print(json.dumps({"count": count, "it": f"{singular}:{plural}",
                      "source": examples[(singular, plural)][:120]}, ensure_ascii=False))
