"""Restore three WoW plural selectors lost in Luna spell-description drafts."""

import json
import os
import tempfile
from pathlib import Path


memory_path = Path(os.environ.get("TEMP", tempfile.gettempdir())) / "wfi-luna-batch" / "spell-description" / "memory.json"
memory = json.loads(memory_path.read_text(encoding="utf-8"))
repairs = (
    (
        "Roots the target in place and causes $o2 Nature damage",
        "${$17245m1+1} bersagli radicati",
        "${$17245m1+1} $lbersaglio radicato:bersagli radicati;",
    ),
    (
        "Causes $s1 damage, stops your attack, and incapacitates",
        "Assegna $s2 punti combo.",
        "Assegna $s2 $lpunto combo:punti combo;.",
    ),
    (
        "Whenever you dodge or parry an attack you gain an Unfair Advantage",
        "ottenendo $432274s3 punti combo.",
        "ottenendo $432274s3 $lpunto combo:punti combo;.",
    ),
)
for prefix, old, new in repairs:
    matches = [source for source in memory if source.startswith(prefix)]
    if len(matches) != 1:
        raise ValueError(f"Expected one exact beta source beginning {prefix!r}")
    source = matches[0]
    draft = memory[source]["it"]
    if draft.count(old) != 1:
        raise ValueError(f"Expected one selector repair point in {source!r}")
    memory[source]["it"] = draft.replace(old, new, 1)
    memory[source]["status"] = "verified"
    memory[source]["reason"] = ""
memory_path.write_text(json.dumps(memory, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"Restored {len(repairs)} exact WoW plural selectors")
