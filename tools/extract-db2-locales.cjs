#!/usr/bin/env node
/* Extract locale text from already dumped DB2 files. No client data is written to the repo. */
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');

const audit = process.argv[2] || path.join(os.tmpdir(), 'wfi-casc-audit');
const output = process.argv[3] || path.join(audit, 'locale-verified');
const { WDCReader } = require(path.join(audit, 'wow-casc-dbc/package/dist/index.cjs'));
const definitions = path.join(audit, 'wowdbdefs-definitions');
const tables = {
  Spell: ['NameSubtext_lang', 'Description_lang', 'AuraDescription_lang'],
  SpellName: ['Name_lang'],
  ChrClasses: ['Name_lang', 'Name_female_lang', 'Name_male_lang'],
  ItemSparse: ['Description_lang', 'Display3_lang', 'Display2_lang', 'Display1_lang', 'Display_lang'],
};

function schema(name, layoutHash) {
  const source = fs.readFileSync(path.join(definitions, `${name}.dbd`), 'utf8');
  const lines = source.split(/\r?\n/);
  const types = new Map();
  for (const line of lines.slice(1)) {
    if (!line.trim()) break;
    const m = /^(int|float|locstring|string)(?:<[^>]+>)?\s+([^\s?]+)/.exec(line);
    if (m) types.set(m[2], m[1]);
  }
  const wanted = layoutHash.toString(16).padStart(8, '0').toUpperCase();
  const start = lines.findIndex(line => line.startsWith('LAYOUT ') &&
    line.slice(7).split(',').map(s => s.trim().toUpperCase()).includes(wanted));
  if (start < 0) throw new Error(`${name}: no schema for layout ${wanted}`);
  const columns = [];
  for (let i = start + 1; i < lines.length && lines[i].trim(); i++) {
    const line = lines[i].trim();
    if (/^(BUILD|COMMENT|LAYOUT)\b/.test(line)) continue;
    const m = /^(?:\$([^$]+)\$)?([^<\[]+?)(?:<(u?)(\d+)>)?(?:\[(\d+)\])?$/.exec(line);
    if (!m) throw new Error(`${name}: unknown schema field ${line}`);
    const [, annotation = '', field, , bits, count] = m;
    const type = types.get(field);
    if (!type) throw new Error(`${name}: unknown schema type ${field}`);
    columns.push({ field, type, inline: !annotation.split(',').includes('noninline'),
      id: annotation.split(',').includes('id'), bits: bits ? Number(bits) : 32,
      count: count ? Number(count) : 1 });
  }
  return columns;
}

function sparseStrings(row, columns, wanted) {
  const data = row.data;
  const result = {};
  if (data.length === 0) return result;
  let offset = 0;
  for (const column of columns) {
    if (!column.inline) continue;
    if (column.type === 'string' || column.type === 'locstring') {
      const values = [];
      for (let n = 0; n < column.count; n++) {
        const end = data.indexOf(0, offset);
        if (end < 0) throw new Error(`unterminated ${column.field}`);
        values.push(data.toString('utf8', offset, end));
        offset = end + 1;
      }
      if (wanted.includes(column.field)) result[column.field] = values.length === 1 ? values[0] : values;
    } else {
      offset += Math.ceil(column.bits / 8) * column.count;
    }
    if (offset > data.length) throw new Error(`row ends before ${column.field}`);
    if (wanted.every(field => Object.hasOwn(result, field))) break;
  }
  return result;
}

function normalStrings(row, columns, wanted) {
  const result = {};
  let index = 0;
  for (const column of columns) {
    if (!column.inline) continue;
    if (index >= row.length) throw new Error(`row ends before ${column.field}`);
    if (wanted.includes(column.field)) result[column.field] = row[index].string || '';
    index++;
    if (wanted.every(field => Object.hasOwn(result, field))) break;
  }
  return result;
}

function read(name, locale) {
  const dir = locale === 'enUS' ? 'extract' : 'extract-itIT';
  const file = path.join(audit, dir, 'dbfilesclient', `${name.toLowerCase()}.db2`);
  const reader = new WDCReader(fs.readFileSync(file));
  const columns = schema(name, reader.layoutHash);
  for (const field of tables[name]) {
    if (!columns.some(column => column.field === field)) throw new Error(`${name}: missing field ${field}`);
  }
  const records = new Map();
  for (const id of reader.getAllIDs()) {
    const row = reader.getRowData(id);
    if (!row) continue;
    let values;
    try {
      values = Array.isArray(row)
        ? normalStrings(row, columns, tables[name])
        : sparseStrings(row, columns, tables[name]);
    } catch (error) {
      throw new Error(`${name}/${locale} ID ${id}: ${error.message}`);
    }
    records.set(id, values);
  }
  return { records, layoutHash: reader.layoutHash.toString(16).padStart(8, '0').toUpperCase() };
}

fs.mkdirSync(output, { recursive: true });
const report = {};
for (const name of Object.keys(tables)) {
  const en = read(name, 'enUS');
  const it = read(name, 'itIT');
  if (en.layoutHash !== it.layoutHash) throw new Error(`${name}: locale layouts differ`);
  const fields = {};
  for (const field of tables[name]) fields[field] = {
    enNonempty: 0, itNonempty: 0, missingItalian: 0, sameAsEnglish: 0, different: 0,
  };
  const entries = [];
  for (const id of [...new Set([...en.records.keys(), ...it.records.keys()])].sort((a, b) => a - b)) {
    const source = en.records.get(id) || {};
    const target = it.records.get(id) || {};
    const values = {};
    let include = false;
    for (const field of tables[name]) {
      const enUS = source[field] || '';
      const itIT = target[field] || '';
      const stat = fields[field];
      if (enUS) stat.enNonempty++;
      if (itIT) stat.itNonempty++;
      if (enUS && !itIT) stat.missingItalian++;
      if (enUS && itIT && enUS === itIT) stat.sameAsEnglish++;
      if (enUS && itIT && enUS !== itIT) stat.different++;
      if (enUS || itIT) { values[field] = { enUS, itIT }; include = true; }
    }
    if (include) entries.push({ id, ...values });
  }
  report[name] = { layoutHash: en.layoutHash, enRows: en.records.size, itRows: it.records.size,
    enOnlyIds: [...en.records.keys()].filter(id => !it.records.has(id)).length,
    itOnlyIds: [...it.records.keys()].filter(id => !en.records.has(id)).length,
    fields, output: `${name}.json` };
  fs.writeFileSync(path.join(output, `${name}.json`), JSON.stringify({ source: name, entries }, null, 2));
}
fs.writeFileSync(path.join(output, 'coverage-report.json'), JSON.stringify(report, null, 2));
console.log(JSON.stringify(report, null, 2));
