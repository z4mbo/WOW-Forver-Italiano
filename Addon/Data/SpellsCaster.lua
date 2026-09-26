local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

-- Base spell names and IDs cross-checked against the WoW Classic spell database
-- (Wowhead Classic, linked by ID below). Rank is kept explicit because each
-- rank has a separate spell ID even when the base title is identical.
-- The Forever beta uses client build 1.60.1.70009; its custom spell additions
-- can be checked in the 60.tools database: https://www.60.tools/spells

local spells = {
    -- Priest: early damage, healing, and buffs.
    -- Sources: https://www.wowhead.com/classic/spell=585/smite ;
    -- https://www.wowhead.com/classic/spell=589/shadow-word-pain ;
    -- https://www.wowhead.com/classic/spell=139/renew
    [585] = { en = "Smite (Rank 1)", name = "Punizione (Grado 1)", enDescription = "Smite an enemy for 14 to 19 Holy damage.", description = "Colpisce un nemico infliggendo 14-19 danni sacri." },
    [591] = { en = "Smite (Rank 2)", name = "Punizione (Grado 2)" },
    [598] = { en = "Smite (Rank 3)", name = "Punizione (Grado 3)" },
    [984] = { en = "Smite (Rank 4)", name = "Punizione (Grado 4)" },
    [1004] = { en = "Smite (Rank 5)", name = "Punizione (Grado 5)" },
    [6060] = { en = "Smite (Rank 6)", name = "Punizione (Grado 6)" },
    [10933] = { en = "Smite (Rank 7)", name = "Punizione (Grado 7)" },
    [10934] = { en = "Smite (Rank 8)", name = "Punizione (Grado 8)" },
    [589] = { en = "Shadow Word: Pain (Rank 1)", name = "Parola d'ombra: dolore (Grado 1)", enDescription = "A word of darkness that causes 30 Shadow damage over 18 sec.", description = "Una parola di oscurità che infligge 30 danni da ombra in 18 s." },
    [594] = { en = "Shadow Word: Pain (Rank 2)", name = "Parola d'ombra: dolore (Grado 2)" },
    [970] = { en = "Shadow Word: Pain (Rank 3)", name = "Parola d'ombra: dolore (Grado 3)" },
    [992] = { en = "Shadow Word: Pain (Rank 4)", name = "Parola d'ombra: dolore (Grado 4)" },
    [2767] = { en = "Shadow Word: Pain (Rank 5)", name = "Parola d'ombra: dolore (Grado 5)" },
    [10892] = { en = "Shadow Word: Pain (Rank 6)", name = "Parola d'ombra: dolore (Grado 6)" },
    [10893] = { en = "Shadow Word: Pain (Rank 7)", name = "Parola d'ombra: dolore (Grado 7)" },
    [139] = { en = "Renew (Rank 1)", name = "Rinnovamento (Grado 1)", enDescription = "Heals the target for 45 over 15 sec.", description = "Cura il bersaglio di 45 punti salute in 15 s." },
    [6074] = { en = "Renew (Rank 2)", name = "Rinnovamento (Grado 2)" },
    [6075] = { en = "Renew (Rank 3)", name = "Rinnovamento (Grado 3)" },
    [6076] = { en = "Renew (Rank 4)", name = "Rinnovamento (Grado 4)" },
    [6077] = { en = "Renew (Rank 5)", name = "Rinnovamento (Grado 5)" },
    [6078] = { en = "Renew (Rank 6)", name = "Rinnovamento (Grado 6)" },
    [10927] = { en = "Renew (Rank 7)", name = "Rinnovamento (Grado 7)" },
    [10928] = { en = "Renew (Rank 8)", name = "Rinnovamento (Grado 8)" },
    -- Sources: https://www.wowhead.com/classic/spell=2050/lesser-heal ;
    -- https://www.wowhead.com/classic/spell=2054/heal ;
    -- https://www.wowhead.com/classic/spell=17/power-word-shield
    [2050] = { en = "Lesser Heal (Rank 1)", name = "Cura minore (Grado 1)", enDescription = "Heals a friendly target for 46 to 56.", description = "Cura un bersaglio amico di 46-56 punti salute." },
    [2052] = { en = "Lesser Heal (Rank 2)", name = "Cura minore (Grado 2)" },
    [2053] = { en = "Lesser Heal (Rank 3)", name = "Cura minore (Grado 3)" },
    [2054] = { en = "Heal (Rank 1)", name = "Cura (Grado 1)", enDescription = "Heals a friendly target for 295 to 341.", description = "Cura un bersaglio amico di 295-341 punti salute." },
    [2055] = { en = "Heal (Rank 2)", name = "Cura (Grado 2)" },
    [6063] = { en = "Heal (Rank 3)", name = "Cura (Grado 3)" },
    [6064] = { en = "Heal (Rank 4)", name = "Cura (Grado 4)" },
    [17] = { en = "Power Word: Shield (Rank 1)", name = "Parola del Potere: Scudo (Grado 1)", enDescription = "Absorbs 44 damage. Lasts 30 sec.", description = "Assorbe 44 danni. Dura 30 s." },
    [592] = { en = "Power Word: Shield (Rank 2)", name = "Parola del Potere: Scudo (Grado 2)" },
    [600] = { en = "Power Word: Shield (Rank 3)", name = "Parola del Potere: Scudo (Grado 3)" },
    [3747] = { en = "Power Word: Shield (Rank 4)", name = "Parola del Potere: Scudo (Grado 4)" },
    [6065] = { en = "Power Word: Shield (Rank 5)", name = "Parola del Potere: Scudo (Grado 5)" },
    [6066] = { en = "Power Word: Shield (Rank 6)", name = "Parola del Potere: Scudo (Grado 6)" },
    [10898] = { en = "Power Word: Shield (Rank 7)", name = "Parola del Potere: Scudo (Grado 7)" },
    [10899] = { en = "Power Word: Shield (Rank 8)", name = "Parola del Potere: Scudo (Grado 8)" },
    [10900] = { en = "Power Word: Shield (Rank 9)", name = "Parola del Potere: Scudo (Grado 9)" },
    [1243] = { en = "Power Word: Fortitude (Rank 1)", name = "Parola del Potere: Fermezza (Grado 1)" },
    [1244] = { en = "Power Word: Fortitude (Rank 2)", name = "Parola del Potere: Fermezza (Grado 2)" },
    [1245] = { en = "Power Word: Fortitude (Rank 3)", name = "Parola del Potere: Fermezza (Grado 3)" },
    [2791] = { en = "Power Word: Fortitude (Rank 4)", name = "Parola del Potere: Fermezza (Grado 4)" },

    -- Mage: starter attacks, defenses, utility, and conjured water.
    -- Sources: https://www.wowhead.com/classic/spell=133/fireball ;
    -- https://www.wowhead.com/classic/spell=116/frostbolt ;
    -- https://www.wowhead.com/classic/spell=1459/arcane-intellect
    [133] = { en = "Fireball (Rank 1)", name = "Palla di Fuoco (Grado 1)" },
    [143] = { en = "Fireball (Rank 2)", name = "Palla di Fuoco (Grado 2)" },
    [145] = { en = "Fireball (Rank 3)", name = "Palla di Fuoco (Grado 3)" },
    [3140] = { en = "Fireball (Rank 4)", name = "Palla di Fuoco (Grado 4)" },
    [8400] = { en = "Fireball (Rank 5)", name = "Palla di Fuoco (Grado 5)" },
    [8401] = { en = "Fireball (Rank 6)", name = "Palla di Fuoco (Grado 6)" },
    [8402] = { en = "Fireball (Rank 7)", name = "Palla di Fuoco (Grado 7)" },
    [10148] = { en = "Fireball (Rank 8)", name = "Palla di Fuoco (Grado 8)" },
    [116] = { en = "Frostbolt (Rank 1)", name = "Dardo di Gelo (Grado 1)" },
    [205] = { en = "Frostbolt (Rank 2)", name = "Dardo di Gelo (Grado 2)" },
    [837] = { en = "Frostbolt (Rank 3)", name = "Dardo di Gelo (Grado 3)" },
    [7322] = { en = "Frostbolt (Rank 4)", name = "Dardo di Gelo (Grado 4)" },
    [8406] = { en = "Frostbolt (Rank 5)", name = "Dardo di Gelo (Grado 5)" },
    [8407] = { en = "Frostbolt (Rank 6)", name = "Dardo di Gelo (Grado 6)" },
    [8408] = { en = "Frostbolt (Rank 7)", name = "Dardo di Gelo (Grado 7)" },
    [1459] = { en = "Arcane Intellect (Rank 1)", name = "Intelletto Arcano (Grado 1)" },
    [1460] = { en = "Arcane Intellect (Rank 2)", name = "Intelletto Arcano (Grado 2)" },
    [1461] = { en = "Arcane Intellect (Rank 3)", name = "Intelletto Arcano (Grado 3)" },
    [10156] = { en = "Arcane Intellect (Rank 4)", name = "Intelletto Arcano (Grado 4)" },
    [10] = { en = "Blizzard (Rank 1)", name = "Tormenta di Ghiaccio (Grado 1)" },
    [6141] = { en = "Blizzard (Rank 2)", name = "Tormenta di Ghiaccio (Grado 2)" },

    -- Paladin: core early blessings, seals, and defenses.
    -- Sources: https://www.wowhead.com/classic/spell=20154/seal-of-righteousness ;
    -- https://www.wowhead.com/classic/spell=853/hammer-of-justice ;
    -- https://www.wowhead.com/classic/spell=633/lay-on-hands
    [20154] = { en = "Seal of Righteousness (Rank 1)", name = "Sigillo della Rettitudine (Grado 1)" },
    [20164] = { en = "Seal of Justice (Rank 1)", name = "Sigillo della Giustizia (Grado 1)" },
    [20287] = { en = "Seal of Righteousness (Rank 2)", name = "Sigillo della Rettitudine (Grado 2)" },
    [20288] = { en = "Seal of Righteousness (Rank 3)", name = "Sigillo della Rettitudine (Grado 3)" },
    [20289] = { en = "Seal of Righteousness (Rank 4)", name = "Sigillo della Rettitudine (Grado 4)" },
    [20290] = { en = "Seal of Righteousness (Rank 5)", name = "Sigillo della Rettitudine (Grado 5)" },
    [20291] = { en = "Seal of Righteousness (Rank 6)", name = "Sigillo della Rettitudine (Grado 6)" },
    [20292] = { en = "Seal of Righteousness (Rank 7)", name = "Sigillo della Rettitudine (Grado 7)" },
    [853] = { en = "Hammer of Justice (Rank 1)", name = "Martello della Giustizia (Grado 1)" },
    [5588] = { en = "Hammer of Justice (Rank 2)", name = "Martello della Giustizia (Grado 2)" },
    [5589] = { en = "Hammer of Justice (Rank 3)", name = "Martello della Giustizia (Grado 3)" },
    [10308] = { en = "Hammer of Justice (Rank 4)", name = "Martello della Giustizia (Grado 4)" },
    [633] = { en = "Lay on Hands (Rank 1)", name = "Imposizione delle Mani (Grado 1)" },
    [2800] = { en = "Lay on Hands (Rank 2)", name = "Imposizione delle Mani (Grado 2)" },
    [10310] = { en = "Lay on Hands (Rank 3)", name = "Imposizione delle Mani (Grado 3)" },
    [1022] = { en = "Blessing of Protection (Rank 1)", name = "Benedizione della Protezione (Grado 1)" },
}

for id, entry in pairs(spells) do
    ns.data.spells[id] = entry
end
