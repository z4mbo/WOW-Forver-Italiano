#!/usr/bin/env node
/* Extract exact-ID beta GlobalStrings where itIT is blank or English. */
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const audit = path.join(os.tmpdir(), 'wfi-casc-audit');
const { WDCReader } = require(path.join(audit, 'wow-casc-dbc', 'package', 'dist', 'index.cjs'));
function read(locale) {
  const reader = new WDCReader(fs.readFileSync(path.join(audit, `beta-globalstrings-${locale}`,
    'dbfilesclient', 'globalstrings.db2')));
  if (reader.layoutHash !== 0xD40F6D96) throw new Error(`Unexpected ${locale} layout`);
  const rows = new Map();
  for (const id of reader.getAllIDs()) {
    const row = reader.getRowData(id);
    if (!Array.isArray(row) || row.length !== 3) continue;
    rows.set(id, { tag: row[0].string || '', value: row[1].string || '', flags: row[2].data });
  }
  return rows;
}
const english = read('enUS'), italian = read('itIT');
const gap = [];
for (const [id, row] of english) {
  const other = italian.get(id);
  if (!row.value || !other || row.tag !== other.tag) continue;
  if (!other.value || other.value === row.value) {
    gap.push({ id, tag: row.tag, en: row.value, flags: row.flags });
  }
}
gap.sort((a, b) => a.id - b.id);
const groups = new Map();
for (const row of gap) {
  if (!groups.has(row.en)) groups.set(row.en, { en: row.en, ids: [], tags: [], flags: [] });
  const group = groups.get(row.en);
  group.ids.push(row.id);
  group.tags.push(row.tag);
  group.flags.push(row.flags);
}
const out = path.join(audit, 'globalstrings-complete-queue.json');
fs.writeFileSync(out, JSON.stringify([...groups.values()], null, 2), 'utf8');
console.log(`rows=${english.size} missing_ids=${gap.length} flagged_ids=${gap.filter(row => row.flags & 1).length} unique_sources=${groups.size} output=${out}`);
