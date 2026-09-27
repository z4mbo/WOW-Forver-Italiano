-- Additional Classic and WoW Forever class spell names.
-- IDs and English names are taken from the WoW Forever spellbook references
-- (60.tools, client build 1.60.1.70009) and the linked Classic spell IDs.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

local spells = {
    -- Warrior: opening toolkit and core abilities.
    [2457] = { en = "Battle Stance", name = "Assetto da Battaglia" },
    [1715] = { en = "Hamstring (Rank 1)", name = "Azzoppamento (Grado 1)" },
    [7372] = { en = "Hamstring (Rank 2)", name = "Azzoppamento (Grado 2)" },
    [7373] = { en = "Hamstring (Rank 3)", name = "Azzoppamento (Grado 3)" },
    [694] = { en = "Mocking Blow (Rank 1)", name = "Colpo Provocatorio (Grado 1)" },
    [7400] = { en = "Mocking Blow (Rank 2)", name = "Colpo Provocatorio (Grado 2)" },
    [7402] = { en = "Mocking Blow (Rank 3)", name = "Colpo Provocatorio (Grado 3)" },
    [1160] = { en = "Demoralizing Shout (Rank 1)", name = "Grido Demoralizzante (Grado 1)" },
    [6190] = { en = "Demoralizing Shout (Rank 2)", name = "Grido Demoralizzante (Grado 2)" },
    [1154] = { en = "Rend (Rank 2)", name = "Lacerare (Grado 2)" },
    [6546] = { en = "Rend (Rank 3)", name = "Lacerare (Grado 3)" },
    [6547] = { en = "Rend (Rank 4)", name = "Lacerare (Grado 4)" },
    [6552] = { en = "Pummel (Rank 1)", name = "Pugno (Grado 1)" },
    [1680] = { en = "Whirlwind", name = "Turbine" },
    [12294] = { en = "Mortal Strike (Rank 1)", name = "Colpo Mortale (Grado 1)" },

    -- Rogue: stealth tools, combo builders, and finishers.
    [1804] = { en = "Pick Lock", name = "Forzatura" },
    [1725] = { en = "Distract", name = "Distrazione" },
    [8647] = { en = "Expose Armor (Rank 1)", name = "Scopri Armatura (Grado 1)" },
    [8681] = { en = "Instant Poison (Rank 1)", name = "Veleno Istantaneo (Grado 1)" },
    [1785] = { en = "Stealth (Rank 2)", name = "Furtività (Grado 2)" },
    [1786] = { en = "Stealth (Rank 3)", name = "Furtività (Grado 3)" },
    [1787] = { en = "Stealth (Rank 4)", name = "Furtività (Grado 4)" },
    [1758] = { en = "Sinister Strike (Rank 2)", name = "Attacco Funesto (Grado 2)" },
    [1759] = { en = "Sinister Strike (Rank 3)", name = "Attacco Funesto (Grado 3)" },
    [1760] = { en = "Sinister Strike (Rank 4)", name = "Attacco Funesto (Grado 4)" },

    -- Mage: utility, armor, and signature control spells.
    [1953] = { en = "Blink", name = "Traslazione" },
    [12051] = { en = "Evocation", name = "Evocazione" },
    [2136] = { en = "Fire Blast (Rank 1)", name = "Esplosione di Fuoco (Grado 1)" },
    [2137] = { en = "Fire Blast (Rank 2)", name = "Esplosione di Fuoco (Grado 2)" },
    [2138] = { en = "Fire Blast (Rank 3)", name = "Esplosione di Fuoco (Grado 3)" },
    [118] = { en = "Polymorph (Rank 1)", name = "Metamorfosi (Grado 1)" },
    [12824] = { en = "Polymorph (Rank 2)", name = "Metamorfosi (Grado 2)" },
    [7302] = { en = "Ice Armor (Rank 1)", name = "Armatura di Ghiaccio (Grado 1)" },
    [6117] = { en = "Mage Armor (Rank 1)", name = "Armatura Magica (Grado 1)" },
    [1449] = { en = "Arcane Explosion (Rank 1)", name = "Esplosione Arcana (Grado 1)" },
    [1463] = { en = "Mana Shield (Rank 1)", name = "Scudo di Mana (Grado 1)" },

    -- Priest: early utility, crowd control, and shadow magic.
    [586] = { en = "Fade (Rank 1)", name = "Dissolvenza (Grado 1)" },
    [8122] = { en = "Psychic Scream (Rank 1)", name = "Grido Psichico (Grado 1)" },
    [8092] = { en = "Mind Blast (Rank 1)", name = "Esplosione Mentale (Grado 1)" },
    [2006] = { en = "Resurrection (Rank 1)", name = "Resurrezione (Grado 1)" },
    [13908] = { en = "Desperate Prayer (Rank 1)", name = "Preghiera Disperata (Grado 1)" },

    -- Paladin: blessings, healing, and holy damage.
    [19740] = { en = "Blessing of Might (Rank 1)", name = "Benedizione del Vigore (Grado 1)" },
    [19742] = { en = "Blessing of Wisdom (Rank 1)", name = "Benedizione della Saggezza (Grado 1)" },
    [7328] = { en = "Redemption (Rank 1)", name = "Redenzione (Grado 1)" },
    [879] = { en = "Exorcism (Rank 1)", name = "Esorcismo (Grado 1)" },
    [498] = { en = "Divine Protection", name = "Protezione Divina" },

    -- Hunter: ranged attacks, pet care, and fieldcraft.
    [75] = { en = "Auto Shot", name = "Tiro Automatico" },
    [1543] = { en = "Flare", name = "Razzo Luminoso" },
    [1494] = { en = "Track Beasts", name = "Individuazione delle Bestie" },
    [1513] = { en = "Scare Beast (Rank 1)", name = "Spaventa Bestia (Grado 1)" },
    [883] = { en = "Call Pet", name = "Richiama Famiglio" },
    [982] = { en = "Revive Pet", name = "Rianima Famiglio" },

    -- Warlock: curses, drains, demons, and soul magic.
    [689] = { en = "Drain Life (Rank 1)", name = "Risucchio Vitale (Grado 1)" },
    [702] = { en = "Curse of Weakness (Rank 1)", name = "Maledizione della Debolezza (Grado 1)" },
    [697] = { en = "Summon Voidwalker", name = "Evocazione: Ombra del Vuoto" },
    [712] = { en = "Summon Succubus", name = "Evoca Succube" },
    [6202] = { en = "Create Healthstone (Minor)", name = "Crea Pietra della Salute (Minore)" },
    [5784] = { en = "Summon Felsteed", name = "Evoca Destriero Vil" },
    [6229] = { en = "Shadow Ward (Rank 1)", name = "Protezione dall'Ombra (Grado 1)" },

    -- Druid: shapeshifting, roots, and nature magic.
    [770] = { en = "Faerie Fire (Rank 1)", name = "Fuoco Fatato (Grado 1)" },
    [783] = { en = "Travel Form", name = "Forma da Viaggio" },
    [5211] = { en = "Bash (Rank 1)", name = "Colpo Poderoso (Grado 1)" },
    [6807] = { en = "Maul (Rank 1)", name = "Sventramento (Grado 1)" },
    [5229] = { en = "Enrage", name = "Infuriarsi" },
    [2912] = { en = "Starfire (Rank 1)", name = "Fuoco Stellare (Grado 1)" },
    [2782] = { en = "Remove Curse", name = "Rimuovi Maledizione" },

    -- Shaman: elemental shocks, totems, and weapon enchantments.
    [8071] = { en = "Stoneskin Totem (Rank 1)", name = "Totem della Pelle di Pietra (Grado 1)" },
    [3599] = { en = "Searing Totem (Rank 1)", name = "Totem Fiamma Ardente (Grado 1)" },
    [1535] = { en = "Fire Nova Totem (Rank 1)", name = "Totem Nova di Fuoco (Grado 1)" },
    [8177] = { en = "Grounding Totem", name = "Totem di Radicamento" },
    [8033] = { en = "Frostbrand Weapon (Rank 1)", name = "Arma Lingua di Gelo (Grado 1)" },
}

for id, entry in pairs(spells) do
    ns.data.spells[id] = entry
end
