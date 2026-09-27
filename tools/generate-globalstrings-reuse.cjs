#!/usr/bin/env node
/* Reuse source-matched Retail Italian UI strings from locally extracted DB2s. */
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');

const root = path.resolve(__dirname, '..');
const audit = process.argv[2] || path.join(os.tmpdir(), 'wfi-casc-audit');
const output = path.join(root, 'Addon', 'Data', 'RetailGlobalStringsMemory.lua');
const report = path.join(audit, 'retail-globalstrings-reuse.json');
const { WDCReader } = require(path.join(audit, 'wow-casc-dbc', 'package', 'dist', 'index.cjs'));

function read(directory) {
  const file = path.join(audit, directory, 'dbfilesclient', 'globalstrings.db2');
  const reader = new WDCReader(fs.readFileSync(file));
  if (reader.layoutHash !== 0xD40F6D96) throw new Error(`${directory}: unexpected GlobalStrings layout`);
  const rows = new Map();
  for (const id of reader.getAllIDs()) {
    const row = reader.getRowData(id);
    if (!Array.isArray(row) || row.length !== 3) {
      throw new Error(`${directory}: invalid row ${id}`);
    }
    if (!row[0].string) continue;
    rows.set(id, { tag: row[0].string, value: row[1].string || '', flags: row[2].data });
  }
  return rows;
}

const betaEn = read('beta-globalstrings-enUS');
const betaIt = read('beta-globalstrings-itIT');
const retailEn = read('retail-globalstrings-enUS');
const retailIt = read('retail-globalstrings-itIT');
// Independent Italian-language review found these Retail values unsuitable for
// global source-text reuse. A separately reviewed manual pack may repair them.
const blockedRetailIDs = new Set([57956, 58170, 58706, 59417, 59435]);
const officialByEnglish = new Map();
function addOfficial(en, it) {
  if (!en || !it || en === it) return;
  if (!officialByEnglish.has(en)) officialByEnglish.set(en, new Set());
  officialByEnglish.get(en).add(it);
}
for (const [id, en] of betaEn) {
  const it = betaIt.get(id);
  if (it && en.tag === it.tag) addOfficial(en.value, it.value);
}
for (const [id, en] of retailEn) {
  const it = retailIt.get(id);
  if (it && en.tag === it.tag) addOfficial(en.value, it.value);
}

function eligibleText(en, it, tag, flags) {
  if (!(flags & 1) || !en || !it || en === it || en.length > 180 || it.length > 240) return false;
  if (/[|%$<>\r\n\ufffd]/.test(en) || /[|%$<>\r\n\ufffd]/.test(it)) return false;
  if (/^(?:TEST|UNUSED|DEBUG|SLASH_|KIOSK|BLIZZARD_STORE|PHOTO_SHARING)/i.test(tag) ||
      /(?:_TEST_|_UNUSED_|_DEBUG_)/i.test(tag)) return false;
  if (/^(?:\*TEMP TEXT\*|\[PH\]|Test$|do not translate$|Unused\b)/i.test(en)) return false;
  return true;
}

const selected = [];
for (const [id, beta] of betaEn) {
  if (blockedRetailIDs.has(id)) continue;
  const betaItalian = betaIt.get(id);
  const retailEnglish = retailEn.get(id);
  const retailItalian = retailIt.get(id);
  if (!betaItalian || !retailEnglish || !retailItalian ||
      beta.tag !== betaItalian.tag || beta.tag !== retailEnglish.tag ||
      beta.tag !== retailItalian.tag || betaItalian.value !== beta.value ||
      retailEnglish.value !== beta.value ||
      !eligibleText(beta.value, retailItalian.value, beta.tag, beta.flags) ||
      officialByEnglish.get(beta.value)?.size !== 1) continue;
  selected.push({ id, tag: beta.tag, en: beta.value, it: retailItalian.value });
}
selected.sort((a, b) => a.id - b.id);
const unique = new Map();
for (const row of selected) unique.set(row.en, row);
const escaped = value => JSON.stringify(value);
const lines = [
  '-- Generated from exact GlobalStrings.db2 ID, BaseTag and enUS matches in the installed beta and Retail clients.',
  '-- Only unambiguous literal strings from FrameXML are used; existing addon UI translations take precedence.',
  'local _, ns = ...',
  'ns.data = ns.data or {}',
  'ns.data.ui = ns.data.ui or {}',
  'local reused = {',
];
for (const row of [...unique.values()].sort((a, b) => a.en.localeCompare(b.en))) {
  lines.push(`    [${escaped(row.en)}] = ${escaped(row.it)}, -- ${row.id} ${row.tag}`);
}
lines.push('}', 'for source, translated in pairs(reused) do',
  '    if ns.data.ui[source] == nil then ns.data.ui[source] = translated end',
  'end');
fs.writeFileSync(output, lines.join('\n') + '\n', 'utf8');
fs.writeFileSync(report, JSON.stringify({ selected, unique: [...unique.values()] }, null, 2), 'utf8');
console.log(`matched_rows=${selected.length} unique_source=${unique.size} output=${output}`);
