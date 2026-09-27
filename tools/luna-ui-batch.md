# Luna UI translation batch (draft)

Exact observed beta client strings that are absent from existing mappings. Translation proposals are deliberately short for tight UI areas.

| Source string | Suggested Italian | Source/client path | UI context |
|---|---|---|---|
| Armor Proficiency | Armature | `Addon/Data/SpellbookUI.lua:14` contains the existing too-long translation; source key is the exact spellbook label. | Spellbook, character's general spell list. Shortens “Competenza nelle armature” to a natural section label consistent with the adjacent category-style labels (e.g. “Abilità”, “Passiva”). |
| Press F6 to submit an issue for this Spell | Premi F6 per segnalare un problema con questo incantesimo | Live tooltip observation (Sventramento); checked extracted client Lua under `%TEMP%\wfi-casc-audit\extract` and `extract-itIT` for same-family text. | Blue built-in Issue Reporter prompt in a spell tooltip. Italian keeps the shortcut first and uses the concise, familiar UI verb “segnalare”. |

## Integration point

The source key already exists in `Addon/Data/SpellbookUI.lua` and is installed into `ns.data.ui`; only the translation value needs changing when this draft is accepted. No source key is added here. Other candidate labels already have mappings in `Addon/Data/VerifiedUIGaps.lua` and are intentionally excluded as duplicates.

## Evidence boundary

The first item is an exact checked-in extracted beta UI label. The second is exact live client text reported for Sventramento; it was not found as a literal in the available extracted Lua/localization trees, and no other `Press F6...` variants were found in those trees. No further source strings are guessed or added.
