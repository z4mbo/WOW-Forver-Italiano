# Beta DB2 localized text inventory

This inventory defines the broader local DB2 search boundary for the Forever beta audit. It joins DB2 paths in `%TEMP%\wfi-casc-audit\console\listfile.csv` to WoWDBDefs tables with `locstring` fields. The listfile is a path catalogue; it does not prove every listed file is present in a particular install. The six additional tables listed first were each extracted successfully from the local beta client in both `enUS` and `itIT`, using CASCConsole and the target list in `%TEMP%\wfi-casc-audit\extra-db2-targets.csv`. The other tables were already in the existing locale audit set; `GlobalStrings` has its own extraction and coverage path.

The priority ranks estimate likely player visibility and addon addressability. They are triage guidance, not proof that every field is currently hooked by the addon. Some WoWDBDefs field names below are unions across historical layouts; only fields in the active layout apply to this beta build.

| Rank | Table | WoWDBDefs localized fields | Likely surface |
| --- | --- | --- | --- |
| 1 | Achievement | `Title_lang`, `Description_lang`, `Reward_lang` | Achievement lists, criteria, and reward text |
| 1 | AreaTable | `AreaName_lang` | Zone and subzone names in maps, tooltips, and location UI |
| 1 | Creature | `Name_lang`, `NameAlt_lang`, `Title_lang`, `TitleAlt_lang` | NPC names and titles in unit frames and nameplates |
| 1 | Faction | `Name_lang`, `Description_lang` | Reputation UI and faction references |
| 1 | ItemSparse | `Description_lang`, `Display_lang`, `Display1_lang`, `Display2_lang`, `Display3_lang` | Item names and tooltip text |
| 1 | QuestInfo | `InfoName_lang` | Quest type labels |
| 1 | QuestLine | `Name_lang`, `Description_lang` | Quest-line tracking and journal text |
| 1 | SkillLine | `DisplayName_lang`, `Description_lang`, `AlternateVerb_lang`, `HordeDisplayName_lang` | Profession and skill labels and descriptions |
| 1 | Spell | `Name_lang`, `NameSubtext_lang`, `Description_lang`, `AuraDescription_lang` | Spell names and tooltip text |
| 1 | SpellName | `Name_lang` | Spell name lookup and tooltip text |
| 2 | ChrRaces | `Name_lang`, `Name_male_lang`, `Name_female_lang`, `Name_lowercase_lang`, `Name_female_lowercase_lang`, `Lore_name_lang`, `Lore_name_female_lang`, `Lore_name_lower_lang`, `Lore_name_lower_female_lang`, `LoreDescription_lang`, `Short_name_lang`, `Short_name_female_lang`, `Short_name_lower_lang`, `Short_name_lower_female_lang` | Race names and character creation lore |
| 2 | GlobalStrings | `TagText_lang` | Shared interface labels |
| 2 | Map | `MapName_lang`, `MapDescription0_lang`, `MapDescription1_lang`, `PvpShortDescription_lang`, `PvpLongDescription_lang`, plus historical layout fields | Map, loading, and battleground descriptions |
| 3 | ChrClasses | `Name_lang`, `Name_female_lang`, `Name_male_lang`, `Description_lang`, `RoleInfoString_lang`, `DisabledString_lang`, `Hyphenated_name_male_lang`, `Hyphenated_name_female_lang` | Class names and descriptions in character creation and class UI |

`ChrClasses` has a pre-login limit: the class selection/creation screen is shown before ordinary addon code is reliably loaded. Translating this table in addon data can still help after entering the world when the same labels are exposed through runtime APIs, but it cannot by itself translate the pre-login character creation screen.

The six-table audit outputs and queue are kept outside the repository at `%TEMP%\wfi-casc-audit\extra-locale-verified\`. `all-fields-translation-queue.json` groups exact English strings and records their table-field sources and DB2 IDs. Blank Italian values and values identical to English are both candidates; equality alone does not prove that a proper noun or shared label needs translation.
