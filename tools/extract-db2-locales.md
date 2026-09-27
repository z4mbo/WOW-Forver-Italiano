# Local DB2 text audit

`extract-db2-locales.cjs` reads the already extracted enUS and itIT DB2 files from a
local WoW client audit. It uses `WDCReader` from `@rhyster/wow-casc-dbc` for record
IDs and storage decoding, then the exact layout in WoWDBDefs for field positions.
It makes no network requests and does not edit the addon.

```powershell
node tools/extract-db2-locales.cjs $env:TEMP\wfi-casc-audit
```

The first argument is the audit directory, defaulting to
`$env:TEMP\wfi-casc-audit`. The optional second argument is the output directory,
defaulting to `locale-verified` inside the audit directory. The audit directory
must contain `extract/dbfilesclient`, `extract-itIT/dbfilesclient`,
`wowdbdefs-definitions/{Spell,SpellName,ChrClasses,ItemSparse}.dbd`, and
`wow-casc-dbc/package/dist/index.cjs`.

Outputs are JSON by table and `coverage-report.json`. They contain client text,
so keep them outside the repository. `missingItalian` means an English field is
populated but its Italian DB2 field is empty. `sameAsEnglish` means both fields
contain identical text; that can include names or intentional unchanged text and
does not, by itself, prove a missing translation. Dynamic `${...}` placeholders
in spell descriptions are preserved literally; this script does not render them.

The reader rejects missing schema layouts, missing expected columns, truncated
string fields, and differing locale layout hashes. The audit reflects only the
DB2 dumps supplied. It does not apply `DBCache.bin` hotfixes or establish whether
the game has additional text in runtime tables or server responses.
