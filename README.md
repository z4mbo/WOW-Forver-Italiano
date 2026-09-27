# WOW Forver - Italiano

An open-source, offline Italian translation addon for **World of Warcraft: Forever**. This repository targets the **Forever beta client (interface 16001)**. Translation packs are kept separate from the display code so they can be extended as the beta and new game content change.

## Current beta coverage

Version **0.5.0-beta** adds exact-source translations for every blank or English-identical localized text field found in the 14 DB2 text tables extracted from the installed Forever beta build **1.60.1.70009**. The audited catalogue contains **53,845 field/ID gaps with zero unrepresented**, plus corrections for **1,765** high-confidence Italian fields that contain unrelated text. It retains 141 quest IDs and expands the NPC-name catalogue. Run `tools/catalog-stats.py` for current catalogue counts and `/wfi status` in game for loaded counts. Catalogue matches do not establish that every record can be displayed in Italian at runtime.

The exact local DB2 gap counts for this release are in [`docs/coverage-0.5.0.it.md`](docs/coverage-0.5.0.it.md).

The read-only audit identifies 11,292 spell-description, 4,616 aura-description, 3,984 item-description, 16,773 spell-name, and 7,351 item-name IDs whose Italian field is blank or identical to English. The coverage reporters count only addon records with the exact same ID and English source. They do not count server-only text or prove that the game displays each record. The beta also has some Italian fields containing unrelated text; a separate conservative audit covers 1,765 such entries.

Some missing text was reused from the locally installed Retail Italian data after exact source and ambiguity checks. UI reuse additionally requires matching `GlobalStrings.db2` ID and tag in the beta and Retail clients. The process is documented in [`tools/retail-db2-reuse.md`](tools/retail-db2-reuse.md). The generated Lua packs work offline and do not require Retail to be installed by players.

This beta pack is **not a complete Italian localization**. All 53 quest IDs in the currently installed beta's local quest cache have catalogue entries, but the cache includes only quests that this client has encountered; unencountered and new server content is still missing. The beta's itIT class-name fields are empty on the character-selection screen, which loads before addons. Some spell descriptions are empty even through the client API, so descriptions with unresolved numeric tokens cannot be displayed safely. Some combat UI, nameplates, map artwork, audio, cinematics, player chat, third-party addons, server messages, and unencountered content can still appear in English. Classic-sourced quest entries are applied only when their live title matches the recorded source, so a reused beta ID cannot show unrelated Italian dialogue. The addon does not translate arbitrary text automatically during play and does not contact an AI service.

### Verified client gaps

The installed Forever beta build **1.60.1.70009** has empty Italian class-name fields for all nine playable classes in `ChrClasses.db2`. This is why class names can disappear on character selection when the client starts in `itIT`. Addons load only after entering the game, so this addon cannot repair that login screen. In the raw local `Spell.db2` extraction, 7,502 English spell descriptions have an empty Italian field, and another 3,790 have identical English and Italian text. These file counts exclude runtime hotfixes and do not establish what each character will encounter. The reproducible read-only audit is described in [`tools/extract-db2-locales.md`](tools/extract-db2-locales.md).

Quest descriptions and NPC dialogue are often sent by the server. The installed client contains no complete export of that content. Completing those translations requires obtaining each exact text and ID from gameplay or a source provided by the Forever project. Report a missing line with its quest, spell, item, or NPC ID and the exact English text so contributors can translate it without guessing.

![Italian quest log and tracker in the Forever beta](media/quest-log-italiano.jpg)

![Italian priest spellbook in the Forever beta](media/spellbook-italiano.jpg)

## Install on the Forever beta

1. Download [the beta ZIP](dist/WOWForverItaliano-0.5.0-beta.zip) or build it using `tools/build-release.ps1`.
2. Extract its `WOWForverItaliano` folder into `World of Warcraft/_classic_beta_/Interface/AddOns/`.
3. Enable **WOW Forver - Italiano** in the game's AddOns screen, then type `/reload`.
4. Type `/wfi status` to check the loaded translation counts.

The folder must contain `WOWForverItaliano.toc` directly; avoid an extra nested folder. This package is for Forever beta 1.60.x, not Retail or old Classic clients.

## Commands

| Command | Action |
| --- | --- |
| `/wfi status` | Show version and translation counts |
| `/wfi on` | Enable translations |
| `/wfi off` | Disable translations; `/reload` restores already rendered English text |
| `/wfi capture on` | Save encountered quest, item, and spell source text locally |
| `/wfi capture off` | Stop recording source text |
| `/wfi audit globals` | Save this client's exact UI globals locally for source review |
| `/wfi audit visible` | Save visible text from selected Blizzard panels locally |

Capture and audits are **off by default**. Captured data stays in the client's local `WTF/Account/.../SavedVariables/WOWForverItaliano.lua` file and is never sent by the addon. Run `/reload` after an audit to write it to disk. Do not upload the full SavedVariables file publicly; copy only the relevant source strings into a contribution issue.

## Contribute translations

Quest entries are indexed by quest ID in [`Addon/Data/Quests.lua`](Addon/Data/Quests.lua) and the other quest packs. Item and spell entries live in [`Addon/Data/Items.lua`](Addon/Data/Items.lua) and the `Spells*.lua` packs. Interface translations are in the remaining `Addon/Data` files. [`CONTRIBUTING.md`](CONTRIBUTING.md) describes the source and review rules. [`tools/extract_questcache_text.py`](tools/extract_questcache_text.py) can inventory verbatim cache fragments by quest ID, but its output does not identify each fragment's role and must be reviewed manually. [`tools/check-client-ui-source.py`](tools/check-client-ui-source.py) checks UI keys against a local client global audit. Translation work used GPT Luna agents and still needs in-game proofreading as Forever changes.

## License and attribution

Original addon code and project artwork are MIT licensed; see [LICENSE](LICENSE). WoW and World of Warcraft are Blizzard Entertainment trademarks. This community addon is not affiliated with or endorsed by Blizzard. Blizzard game text and other third-party material retain their respective owners' rights; the MIT grant covers only material the contributors can license.
