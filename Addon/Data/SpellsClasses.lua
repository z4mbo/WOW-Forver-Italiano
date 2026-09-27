-- Spell names and IDs cross-checked against the WoW Forever beta spellbooks
-- (build 1.60.1.70009): https://www.60.tools/spellbook/warrior
-- https://www.60.tools/spellbook/rogue
-- https://www.60.tools/spellbook/warlock
-- https://www.60.tools/spellbook/hunter
-- https://www.60.tools/spellbook/druid
-- https://www.60.tools/spellbook/shaman
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

-- Warrior
ns.data.spells[6673] = { en = "Battle Shout", name = "Grido di Battaglia" }
ns.data.spells[78] = { en = "Heroic Strike", name = "Attacco Eroico" }
ns.data.spells[100] = { en = "Charge", name = "Carica" }
ns.data.spells[772] = { en = "Rend", name = "Lacerare" }
ns.data.spells[6343] = { en = "Thunder Clap", name = "Tuono" }
ns.data.spells[7384] = { en = "Overpower", name = "Sopraffazione" }
ns.data.spells[5308] = { en = "Execute", name = "Esecuzione" }
ns.data.spells[7386] = { en = "Sunder Armor", name = "Fendere Armatura" }
ns.data.spells[355] = { en = "Taunt", name = "Provocazione" }
ns.data.spells[71] = { en = "Defensive Stance", name = "Assetto Difensivo" }
ns.data.spells[2687] = { en = "Bloodrage", name = "Rabbia Sanguinaria" }
ns.data.spells[72] = { en = "Shield Bash", name = "Colpo di Scudo" }

-- Rogue
ns.data.spells[1752] = { en = "Sinister Strike", name = "Attacco Funesto" }
ns.data.spells[2098] = { en = "Eviscerate", name = "Sventramento" }
ns.data.spells[5171] = { en = "Slice and Dice", name = "Fendente Rapido" }
ns.data.spells[1784] = { en = "Stealth", name = "Furtività" }
ns.data.spells[1776] = { en = "Gouge", name = "Sfregio" }
ns.data.spells[1766] = { en = "Kick", name = "Calcio" }
ns.data.spells[53] = { en = "Backstab", name = "Pugnalata alle Spalle" }
ns.data.spells[2983] = { en = "Sprint", name = "Scatto" }
ns.data.spells[1856] = { en = "Vanish", name = "Svanire" }
ns.data.spells[8676] = { en = "Ambush", name = "Agguato" }
ns.data.spells[921] = { en = "Pick Pocket", name = "Borseggiare" }
ns.data.spells[6770] = { en = "Sap", name = "Sap" }

-- Warlock
ns.data.spells[172] = { en = "Corruption", name = "Corruzione" }
ns.data.spells[980] = { en = "Curse of Agony", name = "Maledizione dell'Agonia" }
ns.data.spells[348] = { en = "Immolate", name = "Immolazione" }
ns.data.spells[686] = { en = "Shadow Bolt", name = "Dardo d'Ombra" }
ns.data.spells[5782] = { en = "Fear", name = "Paura" }
ns.data.spells[1454] = { en = "Life Tap", name = "Trasfusione di Vita" }
ns.data.spells[1120] = { en = "Drain Soul", name = "Risucchio dell'Anima" }
ns.data.spells[1949] = { en = "Hellfire", name = "Fuoco Infernale" }
ns.data.spells[6201] = { en = "Create Healthstone", name = "Crea Pietra della Salute" }
ns.data.spells[688] = { en = "Summon Imp", name = "Evoca Imp" }
ns.data.spells[706] = { en = "Demon Armor", name = "Armatura Demoniaca" }
ns.data.spells[710] = { en = "Banish", name = "Esilio" }

-- Hunter
ns.data.spells[3044] = { en = "Arcane Shot", name = "Tiro Arcano" }
ns.data.spells[1978] = { en = "Serpent Sting", name = "Morso del Serpente" }
ns.data.spells[5116] = { en = "Concussive Shot", name = "Tiro Concusso" }
ns.data.spells[1130] = { en = "Hunter's Mark", name = "Marchio del Cacciatore" }
ns.data.spells[2973] = { en = "Raptor Strike", name = "Colpo del Raptor" }
ns.data.spells[13165] = { en = "Aspect of the Hawk", name = "Aspetto del Falco" }
ns.data.spells[1515] = { en = "Tame Beast", name = "Addomesticamento Bestia" }
ns.data.spells[5384] = { en = "Feign Death", name = "Finta Morte" }
ns.data.spells[136] = { en = "Mend Pet", name = "Cura Famiglio" }
ns.data.spells[2643] = { en = "Multi-Shot", name = "Tiro Multiplo" }
ns.data.spells[19434] = { en = "Aimed Shot", name = "Tiro Mirato" }
ns.data.spells[2974] = { en = "Wing Clip", name = "Mozzare Ali" }

-- Druid
ns.data.spells[5176] = { en = "Wrath", name = "Ira" }
ns.data.spells[8921] = { en = "Moonfire", name = "Fuoco Lunare" }
ns.data.spells[774] = { en = "Rejuvenation", name = "Rinvigorimento" }
ns.data.spells[8936] = { en = "Regrowth", name = "Ricrescita" }
ns.data.spells[5185] = { en = "Healing Touch", name = "Tocco Curativo" }
ns.data.spells[1126] = { en = "Mark of the Wild", name = "Marchio della Natura" }
ns.data.spells[467] = { en = "Thorns", name = "Spine" }
ns.data.spells[339] = { en = "Entangling Roots", name = "Radici Avvolgenti" }
ns.data.spells[768] = { en = "Cat Form", name = "Forma Felina" }
ns.data.spells[5487] = { en = "Bear Form", name = "Forma d'Orso" }
ns.data.spells[29166] = { en = "Innervate", name = "Innervazione" }
ns.data.spells[18960] = { en = "Teleport: Moonglade", name = "Teletrasporto: Radaluna" }

-- Shaman
ns.data.spells[403] = { en = "Lightning Bolt", name = "Dardo Fulminante" }
ns.data.spells[8042] = { en = "Earth Shock", name = "Folgorazione della Terra" }
ns.data.spells[8050] = { en = "Flame Shock", name = "Folgorazione di Fiamma" }
ns.data.spells[331] = { en = "Healing Wave", name = "Onda Curativa" }
ns.data.spells[8004] = { en = "Lesser Healing Wave", name = "Onda Curativa Inferiore" }
ns.data.spells[324] = { en = "Lightning Shield", name = "Scudo di Fulmini" }
ns.data.spells[8017] = { en = "Rockbiter Weapon", name = "Arma Rocciamorso" }
ns.data.spells[2484] = { en = "Earthbind Totem", name = "Totem del Vincolo Terrestre" }
ns.data.spells[8075] = { en = "Strength of Earth Totem", name = "Totem della Forza della Terra" }
ns.data.spells[5394] = { en = "Healing Stream Totem", name = "Totem del Flusso Curativo" }
ns.data.spells[2645] = { en = "Ghost Wolf", name = "Lupo Spettrale" }
ns.data.spells[556] = { en = "Astral Recall", name = "Richiamo Astrale" }

-- Racial ability names cross-checked against enUS and itIT SpellName.db2.
ns.data.spells[7744] = { en = "Will of the Forsaken", name = "Volontà dei Reietti" }
ns.data.spells[20577] = { en = "Cannibalize", name = "Cannibalismo" }
ns.data.spells[20549] = { en = "War Stomp", name = "Zoccolo di Guerra" }
-- Original authored Italian retained; itIT SpellName.db2 has no Name_lang for 20554.
ns.data.spells[20554] = { en = "Berserking", name = "Berserker" }
ns.data.spells[20572] = { en = "Blood Fury", name = "Furia Sanguinaria" }
ns.data.spells[20573] = { en = "Hardiness", name = "Audacia" }
-- Original authored Italian retained; itIT SpellName.db2 has no Name_lang for 20580.
ns.data.spells[20580] = { en = "Shadowmeld", name = "Fondersi nelle Ombre" }
ns.data.spells[20582] = { en = "Quickness", name = "Rapidità" }
ns.data.spells[20585] = { en = "Wisp Spirit", name = "Spirito di Fuoco Fatuo" }
ns.data.spells[20591] = { en = "Expansive Mind", name = "Apertura Mentale" }
ns.data.spells[20593] = { en = "Engineering Specialization", name = "Specializzazione: Ingegneria" }
ns.data.spells[20594] = { en = "Stoneform", name = "Forma di Pietra" }
ns.data.spells[20598] = { en = "The Human Spirit", name = "Spirito Umano" }
-- Original authored Italian retained; itIT SpellName.db2 has no Name_lang for 20600.
ns.data.spells[20600] = { en = "Perception", name = "Percezione" }
ns.data.spells[20589] = { en = "Escape Artist", name = "Artista della Fuga" }
ns.data.spells[20574] = { en = "Axe Specialization", name = "Specializzazione: Asce" }
