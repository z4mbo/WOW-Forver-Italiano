# WOW Forver - Italiano

An open-source, offline Italian translation addon for **World of Warcraft: Forever**. This repository targets the **Forever beta client (interface 16001)**. Translation packs are kept separate from the display code so they can be extended as the beta and new game content change.

## Current beta coverage

This first beta includes **98 quest, 49 item, 223 spell, and 411 interface entries**, including profession labels and selected quest dialogue and objective text. It translates matching text in the quest log, spellbook, tooltips, and selected panels. Unknown text remains in the game's original language. Use `/wfi status` in game to see the loaded entry counts.

An addon cannot replace every string in the client. This beta pack is **not a complete Italian localization**: combat UI, nameplates, map artwork, audio, cinematics, player chat, third-party addons, server messages, and unencountered content can still appear in English. New Forever content must be captured, translated, and tested as it becomes available. The addon does not translate arbitrary text automatically during play and does not contact an AI service.

![Italian quest log and tracker in the Forever beta](media/quest-log-italiano.jpg)

![Italian priest spellbook in the Forever beta](media/spellbook-italiano.jpg)

## Install on the Forever beta

1. Download [the beta ZIP](dist/WOWForverItaliano-0.1.0-beta.zip) or build it using `tools/build-release.ps1`.
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

Capture is **off by default**. Captured data stays in the client's local `WTF/Account/.../SavedVariables/WOWForverItaliano.lua` file and is never sent by the addon. Do not upload the full SavedVariables file publicly without reviewing it; the account path and other local data may be sensitive. You can copy only relevant quest, item, or spell entries into a contribution issue.

## Contribute translations

Quest entries are indexed by quest ID in [`Addon/Data/Quests.lua`](Addon/Data/Quests.lua); item entries by item ID in [`Addon/Data/Items.lua`](Addon/Data/Items.lua); and spell entries by spell ID in [`Addon/Data/SpellsCaster.lua`](Addon/Data/SpellsCaster.lua), [`Addon/Data/SpellsClasses.lua`](Addon/Data/SpellsClasses.lua), and [`Addon/Data/SpellsExtra.lua`](Addon/Data/SpellsExtra.lua). Interface and profession labels are in [`Addon/Data/UI.lua`](Addon/Data/UI.lua), [`Addon/Data/Professions.lua`](Addon/Data/Professions.lua), and other small data packs in that directory. See [CONTRIBUTING.md](CONTRIBUTING.md) for the format and review rules. This initial pack was translated with GPT Luna agents and requires in-game proofreading, particularly for gender, grammar, exact beta text, and new Forever content.

## License and attribution

Original addon code and project artwork are MIT licensed; see [LICENSE](LICENSE). WoW and World of Warcraft are Blizzard Entertainment trademarks. This community addon is not affiliated with or endorsed by Blizzard. Blizzard game text and other third-party material retain their respective owners' rights; the MIT grant covers only material the contributors can license.
