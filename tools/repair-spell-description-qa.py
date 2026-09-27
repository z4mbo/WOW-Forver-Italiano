"""Apply reviewed Italian grammar fixes to exact Luna spell-description drafts."""

import json
import os
import runpy
import tempfile
from pathlib import Path


root = Path(__file__).resolve().parents[1]
memory_path = (Path(os.environ.get("TEMP", tempfile.gettempdir())) /
               "wfi-luna-batch" / "spell-description" / "memory.json")
memory = json.loads(memory_path.read_text(encoding="utf-8"))
verify = runpy.run_path(str(root / "tools" / "translate-luna-batch.py"))["verify"]

combo_replacements = {
    "$lpunto combo:punti combo;": "$lpunto:punti combo;",
    "$l punto combo:punti combo;": "$lpunto:punti combo;",
    "$l punto:punti; combo": "$lpunto:punti combo;",
    "$lcombo point:punti combo;": "$lpunto:punti combo;",
    "$lpoint:punti; combo": "$lpunto:punti combo;",
    "$lpunto:punti; combo": "$lpunto:punti combo;",
}
changed = []
for source, record in memory.items():
    if "combo $lpoint:points;" not in source:
        continue
    original = record["it"]
    revised = original
    for old, new in combo_replacements.items():
        revised = revised.replace(old, new)
    if revised != original:
        problem = verify(source, revised, "spell-description")
        if problem:
            raise ValueError(f"Invalid revised spell description: {problem}: {source!r}")
        record["it"] = revised
        changed.append(source)

uppercase_count = 0
for source, record in memory.items():
    if "Combo $LPoint:Points;" not in source:
        continue
    original = record["it"]
    revised = original.replace("$LPoint:Punto:Punti Combo;", "$Lpunto:punti combo;")
    revised = revised.replace("punto $Lcombo:combo;", "$Lpunto:punti combo;")
    if revised != original:
        problem = verify(source, revised, "spell-description")
        if problem:
            raise ValueError(f"Invalid uppercase selector: {problem}: {source!r}")
        record["it"] = revised
        changed.append(source)
        uppercase_count += 1

specific = {
    "Reduces the cost of your Envenom and Eviscerate abilities": (
        "Avvelenamento e Scorticamento", "Avvelenamento ed Eviscerazione"),
    "Creates $s1 Explosive Sheep": (
        "il $lnemico più vicino:nemici più vicini; e $lesplodono:esplodono;",
        "$lil nemico più vicino:i nemici più vicini; e $lesplodono:esplode;"),
}
for prefix, (old, new) in specific.items():
    matches = [source for source in memory if source.startswith(prefix)]
    if len(matches) != 1:
        raise ValueError(f"Expected one source for {prefix!r}, got {len(matches)}")
    source = matches[0]
    original = memory[source]["it"]
    if original.count(old) != 1:
        raise ValueError(f"Expected one {old!r} in {source!r}")
    revised = original.replace(old, new)
    problem = verify(source, revised, "spell-description")
    if problem:
        raise ValueError(f"Invalid specific repair: {problem}: {source!r}")
    memory[source]["it"] = revised
    changed.append(source)

assert uppercase_count == 3, uppercase_count
assert len(changed) >= 15, len(changed)
memory_path.write_text(json.dumps(memory, ensure_ascii=False, indent=2) + "\n",
                       encoding="utf-8")
print(f"Repaired {len(changed)} reviewed source strings ({uppercase_count} uppercase selectors)")
