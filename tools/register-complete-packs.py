"""Insert generated complete data packs into the addon TOC, once each."""

from pathlib import Path


root = Path(__file__).resolve().parents[1] / "Addon"
toc = root / "WOWForverItaliano.toc"
prefixes = (
    "CompleteSpellName", "CompleteSpellNameOverride", "CompleteSpellSubtext", "CompleteSpellDescription",
    "CompleteSpellDescriptionAliases",
    "CompleteAuraDescription", "CompleteItemName", "CompleteItemDescription",
    "CompleteCorruptSpellName", "CompleteCorruptItemName",
    "CompleteCorruptItemDescription",
    "CompleteGlobalStrings",
    "CompleteCorruptGlobalStrings",
    "CompleteExtraClientUI",
    "CompleteChrClasses",
    "CompleteCorruptExtraClientUI",
    "CompleteQuestSkillUI",
)
existing = toc.read_text(encoding="utf-8-sig").splitlines()
listed = set(existing)
added = []
for prefix in prefixes:
    for path in sorted((root / "Data").glob(prefix + "[0-9][0-9][0-9].lua")):
        row = "Data\\" + path.name
        if row not in listed:
            listed.add(row)
            added.append(row)
if added:
    index = next(i for i, line in enumerate(existing) if line.startswith("Modules\\"))
    existing[index:index] = added
    toc.write_text("\n".join(existing) + "\n", encoding="utf-8")
print(f"added={len(added)}")
for row in added:
    print(row)
