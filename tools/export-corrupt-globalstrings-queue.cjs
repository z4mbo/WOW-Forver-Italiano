#!/usr/bin/env node
/* Exact beta GlobalStrings rows with demonstrably mismapped nonblank itIT. */
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
    if (Array.isArray(row) && row.length === 3)
      rows.set(id, { tag: row[0].string || '', value: row[1].string || '', flags: row[2].data });
  }
  return rows;
}
const collisions = JSON.parse(fs.readFileSync(path.join(audit, 'corrupt-itit-review.json'), 'utf8'));
const enRows = read('enUS'), itRows = read('itIT');
const grouped = new Map();
for (const collision of collisions) {
  if (collision.table !== 'GlobalStrings' || collision.field !== 'TagText_lang') continue;
  const enRow = enRows.get(collision.id), itRow = itRows.get(collision.id);
  if (!enRow || !itRow || enRow.tag !== itRow.tag ||
      enRow.value !== collision.en || itRow.value !== collision.it)
    throw new Error(`Audit mismatch GlobalStrings ID ${collision.id}`);
  if (!grouped.has(collision.en)) grouped.set(collision.en, { en: collision.en, rows: [] });
  grouped.get(collision.en).rows.push({ id: collision.id, tag: enRow.tag,
    flags: enRow.flags, badIt: collision.it });
}
const queue = [...grouped.values()];
const out = path.join(audit, 'corrupt-globalstrings-queue.json');
fs.writeFileSync(out, JSON.stringify(queue, null, 2), 'utf8');
console.log(JSON.stringify({ path: out, sources: queue.length,
  ids: queue.reduce((n, group) => n + group.rows.length, 0),
  flagged: queue.reduce((n, group) => n + group.rows.filter(row => row.flags & 1).length, 0) }));
