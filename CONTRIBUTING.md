# Contributing

This project is intended to grow with WoW: Forever. Please include the **client build**, the relevant **quest, item, or spell ID** when applicable, the **exact English source**, your proposed Italian translation, and a screenshot or source link when reporting a missing translation. Do not paste a full SavedVariables file into a public issue.

## Translation rules

- Use official Italian WoW terms where available: *missione*, *Registro missioni*, *ricompensa*, *Pietra del Ritorno*, *cavalcatura*.
- Keep proper names in English unless an official localized form is verified.
- Preserve `%s`, `%d`, color escapes (`|c...|r`), hyperlinks, line breaks, and other game formatting exactly.
- Do not invent IDs or silently map two different English names to one ID. Confirm every quest, item, or spell ID against the beta or a reliable game database.
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

The `en`/`enTitle` field is used to avoid showing an outdated translation if a beta name changes, and to translate matching visual labels. For body text, record the exact English description as `enDescription` and the Italian as `description`. Partial entries are welcome. An absent translation leaves the original game text visible.

Build a release with `pwsh -File tools/build-release.ps1`. Test the resulting ZIP in `_classic_beta_` and include a genuine in-game screenshot showing the relevant panel.
