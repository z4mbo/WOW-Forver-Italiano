-- High-frequency spell descriptions from the local spell-priority export.
-- Each English description is an exact source string; duplicate IDs sharing it are propagated by the caller.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}

local verifiedSpellDescriptions = {
    -- Rank 1, shared by 56 spell IDs.
    [7675] = { en = "Increases healing done by spells and effects by up to $s1.", description = "Aumenta fino a $s1 le cure fornite dagli incantesimi e dagli effetti." },
    -- Rank 2, shared by 56 spell IDs.
    [7704] = { en = "Increases damage done by Shadow spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti d’ombra." },
    -- Rank 3, shared by 55 spell IDs.
    [7697] = { en = "Increases damage done by Frost spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti di gelo." },
    -- Rank 4, shared by 54 spell IDs.
    [7683] = { en = "Increases damage done by Fire spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti di fuoco." },
    -- Rank 5, shared by 51 spell IDs.
    [13590] = { en = "Increases damage done by Arcane spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti arcani." },
    -- Rank 6, shared by 44 spell IDs.
    [7690] = { en = "Increases damage done by Nature spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti di natura." },
    -- Rank 7, shared by 41 spell IDs.
    [7511] = { en = "Increased Defense +$s1.", description = "Difesa aumentata: +$s1." },
    -- Rank 8, shared by 39 spell IDs.
    [13674] = { en = "Increases your chance to block attacks with a shield by $s1%.", description = "Aumenta del $s1% la probabilità di bloccare gli attacchi con uno scudo." },
    -- Rank 9, shared by 39 spell IDs.
    [21499] = { en = "Increases damage done by Holy spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti sacri." },
    -- Rank 10, shared by 38 spell IDs.
    [21013] = { en = "+$s1 ranged Attack Power.", description = "+$s1 potenza d’attacco a distanza." },
    -- Rank 11, shared by 30 spell IDs.
    [1272224] = { en = "Collecting herbs.", description = "Raccolta di erbe." },
    -- Rank 12, shared by 29 spell IDs.
    [24694] = { en = "+$s1 Attack Power in Cat, Bear, and Dire Bear forms only.", description = "+$s1 potenza d’attacco solo in Forma Felina, Orso o Orso Ferino." },
    -- Rank 13, shared by 23 spell IDs.
    [7520] = { en = "Increased Swords +$s1.", description = "Abilità con le spade aumentata di +$s1." },
    -- Rank 14, shared by 22 spell IDs.
    [7534] = { en = "Increased Daggers +$s1.", description = "Abilità con i pugnali aumentata di +$s1." },
    -- Rank 15, shared by 22 spell IDs.
    [7538] = { en = "Increased Axes +$s1.", description = "Abilità con le asce aumentata di +$s1." },
    -- Rank 16, shared by 21 spell IDs.
    [13492] = { en = "+$s1 Attack Power against Beasts.", description = "+$s1 potenza d’attacco contro le Bestie." },
    -- Rank 17, shared by 21 spell IDs.
    [13549] = { en = "Stings the target, causing $o1 Nature damage over $d.  Only one Sting per Hunter can be active on any one target.", description = "Punge il bersaglio, infliggendo $o1 danni da natura in $d. Un cacciatore può mantenere attiva una sola Puntura su ciascun bersaglio." },
    -- Rank 18, shared by 19 spell IDs.
    [12981] = { en = "+$s1 Attack Power against Undead.", description = "+$s1 potenza d’attacco contro i Non Morti." },
    -- Rank 19, shared by 18 spell IDs.
    [7529] = { en = "Increased Two-handed Swords +$s1.", description = "Abilità con le spade a due mani aumentata di +$s1." },
    -- Rank 20, shared by 18 spell IDs.
    [7532] = { en = "Increased Maces +$s1.", description = "Abilità con le mazze aumentata di +$s1." },
    -- Rank 21, shared by 18 spell IDs.
    [7533] = { en = "Increased Two-handed Maces +$s1.", description = "Abilità con le mazze a due mani aumentata di +$s1." },
    -- Rank 22, shared by 18 spell IDs.
    [7549] = { en = "Increased Two-handed Axes +$s1.", description = "Abilità con le asce a due mani aumentata di +$s1." },
    -- Rank 23, shared by 18 spell IDs.
    [15464] = { en = "Improves your chance to hit by ${$s1}.1%.", description = "Aumenta la probabilità di colpire di ${$s1}.1%." },
    -- Rank 24, shared by 16 spell IDs.
    [409691] = { en = "A strong attack that increases melee damage by $s1.", description = "Un attacco potente che aumenta di $s1 i danni in mischia." },
    -- Rank 25, shared by 15 spell IDs.
    [4171] = { en = "Your Agility is increased by $s1.", description = "La tua Agilità aumenta di $s1." },
    -- Rank 26, shared by 15 spell IDs.
    [4204] = { en = "Your Intellect is increased by $s1.", description = "Il tuo Intelletto aumenta di $s1." },
    -- Rank 27, shared by 15 spell IDs.
    [4222] = { en = "Your Spirit is increased by $s1.", description = "Il tuo Spirito aumenta di $s1." },
    -- Rank 28, shared by 15 spell IDs.
    [5720] = { en = "Instantly restores $s1 life.", description = "Ripristina istantaneamente $s1 salute." },
    -- Rank 29, shared by 14 spell IDs.
    [1464] = { en = "Slams the opponent, causing weapon damage plus $s1.", description = "Colpisce violentemente l’avversario, infliggendo i danni dell’arma più $s1." },
    -- Rank 30, shared by 14 spell IDs.
    [408681] = { en = "Instantly shocks the target with concussive force, causing $s1 Nature damage.  It also interrupts spellcasting and prevents any spell in that school from being cast for $d.  Causes a high amount of threat and taunts the target.", description = "Colpisce istantaneamente il bersaglio con una forza concussiva, infliggendo $s1 danni da natura. Interrompe il lancio degli incantesimi e impedisce di lanciare incantesimi di quella scuola per $d. Genera molta minaccia e provoca il bersaglio." },
    -- Rank 31, shared by 13 spell IDs.
    [2692] = { en = "Strength increased by $s1.", description = "Forza aumentata di $s1." },
    -- Rank 32, shared by 13 spell IDs.
    [14824] = { en = "Increases ranged attack speed by $s1%.", description = "Aumenta del $s1% la velocità d’attacco a distanza." },
    -- Rank 33, shared by 12 spell IDs.
    [4778] = { en = "Increases your defense by $s1.", description = "Aumenta la tua difesa di $s1." },
    -- Rank 34, shared by 11 spell IDs.
    [12822] = { en = "+$s1 Attack Power against Demons.", description = "+$s1 potenza d’attacco contro i Demoni." },
    -- Rank 35, shared by 11 spell IDs.
    [364820] = { en = "Deals $s1 Fire damage every $t1 sec.", description = "Infligge $s1 danni da fuoco ogni $t1 sec." },
    -- Rank 36, shared by 11 spell IDs.
    [1271688] = { en = "Mining.\r\n\r\n", description = "Estrazione mineraria.\r\n\r\n" },
    -- Rank 37, shared by 10 spell IDs.
    [430] = { en = "Restores $o1 mana over $d.  Must remain seated while drinking.", description = "Ripristina $o1 mana in $d. Devi restare seduto mentre bevi." },
    -- Rank 38, shared by 10 spell IDs.
    [4187] = { en = "Stamina increased by $s1.", description = "Tempra aumentata di $s1." },
    -- Rank 39, shared by 10 spell IDs.
    [4832] = { en = "Increases Fire spell damage by $s1.", description = "Aumenta di $s1 i danni degli incantesimi di fuoco." },
    -- Rank 40, shared by 10 spell IDs.
    [4848] = { en = "Increases Nature spell damage by $s1.", description = "Aumenta di $s1 i danni degli incantesimi di natura." },
    -- Rank 41, shared by 10 spell IDs.
    [4880] = { en = "Increases Shadow spell damage by $s1.", description = "Aumenta di $s1 i danni degli incantesimi d’ombra." },
    -- Rank 42, shared by 10 spell IDs.
    [14521] = { en = "Allows $s1% of your Mana regeneration to continue while casting.", description = "Permette di mantenere durante il lancio il $s1% della rigenerazione del mana." },
    -- Rank 43, shared by 10 spell IDs.
    [24545] = { en = "Armor increased by $s1.", description = "Armatura aumentata di $s1." },
    -- Rank 44, shared by 10 spell IDs.
    [445575] = { en = "Acid rain falls from above, inflicting $s1 Nature damage to players struck.", description = "Piove acido dall’alto, infliggendo $s1 danni da natura ai giocatori colpiti." },
    -- Rank 45, shared by 10 spell IDs.
    [1219539] = { en = "Unlocks your potential while inside Naxxramas.  Increasing your damage by ${$m1/100}.2% and your health by ${$m2/100}.2% for each Sanctified item equipped.  (Equipping more than $1223336s2 Sanctified items provides no additional benefit)", description = "Sblocca il tuo potenziale all’interno di Naxxramas. Aumenta i danni del ${$m1/100}.2% e la salute del ${$m2/100}.2% per ogni oggetto Sanctified equipaggiato. (Equipaggiare più di $1223336s2 oggetti Sanctified non fornisce ulteriori benefici)" },
    -- Rank 46, shared by 10 spell IDs.
    [1219548] = { en = "Unlocks your potential while inside Naxxramas.  Increasing your healing by ${$m1/100}.2% and your health by ${$m2/100}.2% for each Sanctified item equipped.  (Equipping more than $1223336s2 Sanctified items provides no additional benefit)", description = "Sblocca il tuo potenziale all’interno di Naxxramas. Aumenta le cure del ${$m1/100}.2% e la salute del ${$m2/100}.2% per ogni oggetto Sanctified equipaggiato. (Equipaggiare più di $1223336s2 oggetti Sanctified non fornisce ulteriori benefici)" },
    -- Rank 47, shared by 10 spell IDs.
    [1220514] = { en = "Unlocks your potential while inside Naxxramas.  Increasing your threat caused by ${$m1/100}.2%, your damage by ${$m2/100}.2%, and your health by ${$m3/100}.2% for each Sanctified item equipped.  (Equipping more than $1223336s2 Sanctified items provides no additional benefit)", description = "Sblocca il tuo potenziale all’interno di Naxxramas. Aumenta la minaccia generata del ${$m1/100}.2%, i danni del ${$m2/100}.2% e la salute del ${$m3/100}.2% per ogni oggetto Sanctified equipaggiato. (Equipaggiare più di $1223336s2 oggetti Sanctified non fornisce ulteriori benefici)" },
    -- Rank 48, shared by 9 spell IDs.
    [4077] = { en = "Absorbs $s1 frost damage.  Lasts $d.", description = "Assorbe $s1 danni da gelo. Dura $d." },
    -- Rank 49, shared by 9 spell IDs.
    [4334] = { en = "Increases your damage with One-Handed Axes by $s1.", description = "Aumenta di $s1 i danni inflitti con le asce a una mano." },
    -- Rank 50, shared by 9 spell IDs.
    [4366] = { en = "Increases your damage with One-Handed Maces by $s1.", description = "Aumenta di $s1 i danni inflitti con le mazze a una mano." },
    -- Rank 51, shared by 9 spell IDs.
    [4472] = { en = "Increases your damage with Two-Handed Maces by $s1.", description = "Aumenta di $s1 i danni inflitti con le mazze a due mani." },
    -- Rank 52, shared by 9 spell IDs.
    [5626] = { en = "Increases your damage with Guns by $s1.", description = "Aumenta di $s1 i danni inflitti con le armi da fuoco." },
    -- Rank 53, shared by 9 spell IDs.
    [5742] = { en = "Increases your damage with Bows by $s1.", description = "Aumenta di $s1 i danni inflitti con gli archi." },
    -- Rank 54, shared by 9 spell IDs.
    [6151] = { en = "Increases your stealth by $s1.", description = "Aumenta la tua furtività di $s1." },
    -- Rank 55, shared by 9 spell IDs.
    [7535] = { en = "Increased Bows +$s1.", description = "Abilità con gli archi aumentata di +$s1." },
    -- Rank 56, shared by 9 spell IDs.
    [7823] = { en = "Increased Fishing +$s1.", description = "Abilità di pesca aumentata di +$s1." },
    -- Rank 57, shared by 9 spell IDs.
    [18787] = { en = "Increases Attack Power by $s1 for $d.", description = "Aumenta la potenza d’attacco di $s1 per $d." },
    -- Rank 58, shared by 9 spell IDs.
    [21010] = { en = "Increases damage done to Undead by magical spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti ai Non Morti dagli incantesimi e dagli effetti magici." },
    -- Rank 59, shared by 9 spell IDs.
    [25975] = { en = "Decreases the magical resistances of your spell targets by $s1.", description = "Riduce di $s1 le resistenze magiche dei bersagli dei tuoi incantesimi." },
}

for id, description in pairs(verifiedSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
end
