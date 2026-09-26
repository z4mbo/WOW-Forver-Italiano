# Contributing

This project is intended to grow with WoW: Forever. Please include the **client build**, the relevant **quest, item, or spell ID** when applicable, the **exact English source from that beta build**, your proposed Italian translation, and a screenshot or source link when reporting a missing translation. A Classic database entry alone does not prove that Forever uses the same text. Do not paste a full SavedVariables file into a public issue.

## Translation rules

- Use official Italian WoW terms where available: *missione*, *Registro missioni*, *ricompensa*, *Pietra del Ritorno*, *cavalcatura*.
- Keep proper names in English unless an official localized form is verified.
- Preserve `%s`, `%d`, color escapes (`|c...|r`), hyperlinks, line breaks, and other game formatting exactly.
- Do not invent IDs or silently map two different English names to one ID. Confirm every quest, item, or spell ID against the beta. Label Classic references as provisional until the live beta title is checked.
- Translate quest bodies only after locating the actual English text in the beta client, cache, or live quest panel. Keep an audit trail with the build, ID, and source.
- Prefer short natural Italian for buttons; quest dialogue should retain its original tone.
- Add only source text you have rights to contribute. Avoid copying another translation pack without license review and attribution.

## Data format

```lua
-- Addon/Data/Quests.lua
[123] = {
    enTitle = "English quest title",
    title = "Titolo italiano",
    description = "Descrizione italiana", -- optional if exact source is verified
},

-- Addon/Data/Items.lua
[456] = { en = "English item name", name = "Nome italiano" },

-- Addon/Data/SpellsCaster.lua or SpellsClasses.lua
[789] = { en = "English spell (Rank 1)", name = "Incantesimo italiano (Grado 1)" },
```

The `en`/`enTitle` field is used to avoid showing an outdated translation if a beta name changes, and to translate matching visual labels. For item body text, record the exact English description as `enDescription` and the Italian as `description`. For quests, include the beta build and source in a nearby comment or contribution notes. Partial entries are welcome. An absent translation leaves the original game text visible.

`/wfi audit globals` saves client UI globals and `/wfi audit visible` saves text from selected open Blizzard panels locally. `/wfi capture on` records encountered quest, item, and spell text. After `/reload`, review the local SavedVariables file and extract only the relevant lines. `tools/extract_questcache_text.py` lists verbatim quest cache fragments, but it does not determine whether a fragment is a title, objective, description, or another field. Never translate a fragment whose boundaries or role are unclear.

Build a release with `pwsh -File tools/build-release.ps1`. Test the resulting ZIP in `_classic_beta_` and include a genuine in-game screenshot showing the relevant panel.
