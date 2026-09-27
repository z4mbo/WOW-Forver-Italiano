# Reusing local Retail Italian text

The 0.4.0-beta addon includes translations from the locally installed Retail client **12.1.0.69933** only where a beta field has the same ID and English text, or where its exact English text has one unambiguous Retail Italian translation. The generators preserve the beta ID and English source and do not overwrite an existing addon translation. Dynamic spell placeholders must be compatible. The matching mode is documented in each generated Lua pack.

The Retail and Forever beta `Spell` and `SpellName` DB2 layout hashes match. `ItemSparse` has different layout hashes; each client was decoded using its own layout. The raw DB2 and JSON dumps stay outside this repository in `%TEMP%\wfi-casc-audit`.

The UI reuse pack follows a stricter rule. `tools/generate-globalstrings-reuse.cjs` reads `GlobalStrings.db2` from the beta and Retail in both `enUS` and `itIT`. It accepts a row only when its numeric ID, `BaseTag`, and English text match across the clients, the beta's Italian text still equals English, and Retail has one unambiguous Italian rendering for that English text. It restricts reuse to short literal FrameXML strings without format codes, excludes internal/test labels, and keeps an independently reviewed blocklist for misleading Retail translations. The output is `Addon/Data/RetailGlobalStringsMemory.lua`; the raw four DB2 files and provenance report stay in the temporary audit directory. The DB2 file data ID is `1394440` and the expected layout is `D40F6D96`, as described by [WoWDBDefs GlobalStrings](https://github.com/wowdev/WoWDBDefs/blob/master/definitions/GlobalStrings.dbd).

For an installation at `C:\Program Files (x86)\World of Warcraft`, the local `CASCConsole.exe` can extract the three DB2 files for product `wow` with a three-line `FID;path` listfile:

```text
1140089;dbfilesclient/spell.db2
1990283;dbfilesclient/spellname.db2
1572924;dbfilesclient/itemsparse.db2
```

Run Listfile mode separately with `--locale enUS` and `--locale itIT`, `--product wow`, and `--storage` pointing to the World of Warcraft installation root. The offline extraction used for this release logged `Online: False`. The local `extract-db2-locales.cjs` reader can decode the files with the corresponding WoWDBDefs layouts. `ChrClasses` can be omitted from the Retail extraction; the addon still targets the Forever beta.

Once both client JSON directories exist, run `tools/generate-retail-spell-reuse.py` and `tools/generate-retail-item-reuse.py` in the bundled Python runtime with `lupa`. These scripts read beta `locale-verified` and Retail `retail-locale-verified`, write Lua packs, and emit provenance/count reports under the temporary audit directory. Review the generated output and run the local source validators before adding any pack to the TOC. The committed Lua data is usable offline without the Retail client or these temporary inputs.

The beta-only generators `tools/generate-cross-field-reuse.py`, `tools/generate-spell-aliases.py`, and `tools/generate-item-aliases.py` reuse a verified translation only when the target field has the identical English source and one unambiguous Italian rendering. Run the cross-field generator for `description` and `aura`, then the spell alias generator normally and with `--aura`, then the item alias generator. They load the TOC in order and write separate guarded packs. Re-run `tools/validate-spell-bulk.py`, `tools/validate-item-bulk.py`, and `tools/check-spell-renderability.py` after regeneration.

An exact English text match across different IDs is evidence for translation reuse, not proof of identical gameplay behavior. The addon still requires the beta spell or item ID and displayed source text to match before replacing a tooltip. Server quest text and NPC dialogue are outside these DB2 files.
