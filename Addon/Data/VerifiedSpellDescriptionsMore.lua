-- Verified player-facing spell descriptions from the local Forever beta client DB2 locale audit.
-- Exact enUS Description_lang records copied by spell ID; itIT was blank or English-identical.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

local verifiedSpellDescriptions = {
    -- Exact enUS provenance: Spell.db2 ID 53, Description_lang.
    [53] = { en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.", description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell’arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo." },
    -- Exact enUS provenance: Spell.db2 ID 139, Description_lang.
    [139] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 143, Description_lang.
    [143] = { en = "Hurls a fiery ball that causes $s1 Fire damage and an additional $o2 Fire damage over $d.", description = "Scaglia una palla di fuoco che infligge $s1 danni da fuoco e altri $o2 danni da fuoco in $d." },
    -- Exact enUS provenance: Spell.db2 ID 145, Description_lang.
    [145] = { en = "Hurls a fiery ball that causes $s1 Fire damage and an additional $o2 Fire damage over $d.", description = "Scaglia una palla di fuoco che infligge $s1 danni da fuoco e altri $o2 danni da fuoco in $d." },
    -- Exact enUS provenance: Spell.db2 ID 585, Description_lang.
    [585] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
    -- Exact enUS provenance: Spell.db2 ID 586, Description_lang.
    [586] = { en = "Fade out, discouraging enemies from attacking you for $d.", description = "Svanisci, scoraggiando i nemici dall’attaccarti per $d." },
    -- Exact enUS provenance: Spell.db2 ID 598, Description_lang.
    [598] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
    -- Exact enUS provenance: Spell.db2 ID 712, Description_lang.
    [712] = { en = "Summons a Succubus under the command of the Warlock.", description = "Evoca una Succube al servizio dello Stregone." },
    -- Exact enUS provenance: Spell.db2 ID 970, Description_lang.
    [970] = { en = "A word of darkness that causes $o1 Shadow damage over $d.", description = "Una parola oscura infligge $o1 danni da ombra nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 980, Description_lang.
    [980] = { en = "Afflicts the target with agony, causing $o1 Shadow damage over $d. This damage is dealt slowly at first, and builds up as the Bane reaches its full duration. Only one Bane per Warlock can be active on any one target.", description = "Affligge il bersaglio con agonia, infliggendo $o1 danni da ombra nell’arco di $d. I danni aumentano gradualmente fino alla fine dell’effetto. Ogni Stregone può avere una sola Agonia attiva per bersaglio." },
    -- Exact enUS provenance: Spell.db2 ID 984, Description_lang.
    [984] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
    -- Exact enUS provenance: Spell.db2 ID 992, Description_lang.
    [992] = { en = "A word of darkness that causes $o1 Shadow damage over $d.", description = "Una parola oscura infligge $o1 danni da ombra nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 1244, Description_lang.
    [1244] = { en = "Power infuses the target, increasing their Stamina by $s1 for $d.", description = "Il potere pervade il bersaglio, aumentandone la Tempra di $s1 per $d." },
    -- Exact enUS provenance: Spell.db2 ID 1245, Description_lang.
    [1245] = { en = "Power infuses the target, increasing their Stamina by $s1 for $d.", description = "Il potere pervade il bersaglio, aumentandone la Tempra di $s1 per $d." },
    -- Exact enUS provenance: Spell.db2 ID 1460, Description_lang.
    [1460] = { en = "Increases the target's Intellect by $s1 for $d.", description = "Aumenta l’Intelletto del bersaglio di $s1 per $d." },
    -- Exact enUS provenance: Spell.db2 ID 1461, Description_lang.
    [1461] = { en = "Increases the target's Intellect by $s1 for $d.", description = "Aumenta l’Intelletto del bersaglio di $s1 per $d." },
    -- Exact enUS provenance: Spell.db2 ID 1785, Description_lang.
    [1785] = { en = "Allows the rogue to sneak around, but reduces your speed by $s3%.  Lasts until cancelled.", description = "Permette al ladro di muoversi furtivamente, ma riduce la velocità del $s3%. Dura finché non viene annullata." },
    -- Exact enUS provenance: Spell.db2 ID 1786, Description_lang.
    [1786] = { en = "Allows the rogue to sneak around, but reduces your speed by $s3%.  Lasts until cancelled.", description = "Permette al ladro di muoversi furtivamente, ma riduce la velocità del $s3%. Dura finché non viene annullata." },
    -- Exact enUS provenance: Spell.db2 ID 1787, Description_lang.
    [1787] = { en = "Allows the rogue to sneak around, but reduces your speed by $s3%.  Lasts until cancelled.", description = "Permette al ladro di muoversi furtivamente, ma riduce la velocità del $s3%. Dura finché non viene annullata." },
    -- Exact enUS provenance: Spell.db2 ID 1804, Description_lang.
    [1804] = { en = "Allows opening of locked chests and doors.", description = "Permette di scassinare forzieri e porte chiusi a chiave." },
    -- Exact enUS provenance: Spell.db2 ID 2006, Description_lang.
    [2006] = { en = "Brings a dead player back to life with $s1 health and $q1 mana.  Cannot be cast when in combat.", description = "Riporta in vita un giocatore morto con $s1 salute e $q1 mana. Non si può lanciare in combattimento." },
    -- Exact enUS provenance: Spell.db2 ID 2052, Description_lang.
    [2052] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 2053, Description_lang.
    [2053] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 2054, Description_lang.
    [2054] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 2055, Description_lang.
    [2055] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 2137, Description_lang.
    [2137] = { en = "Blasts the enemy for $s1 Fire damage.", description = "Colpisce il nemico con un’esplosione che infligge $s1 danni da fuoco." },
    -- Exact enUS provenance: Spell.db2 ID 2138, Description_lang.
    [2138] = { en = "Blasts the enemy for $s1 Fire damage.", description = "Colpisce il nemico con un’esplosione che infligge $s1 danni da fuoco." },
    -- Exact enUS provenance: Spell.db2 ID 2645, Description_lang.
    [2645] = { en = "Turns the Shaman into a Ghost Wolf, increasing speed by $s2%.  Only useable outdoors.", description = "Trasforma lo Sciamano in un Lupo Spettrale, aumentando la velocità del $s2%. Utilizzabile solo all’aperto." },
    -- Exact enUS provenance: Spell.db2 ID 2782, Description_lang.
    [2782] = { en = "Dispels $s1 Curse or Bane from a friendly target.", description = "Rimuove $s1 Maledizione o Anatema da un bersaglio amico." },
    -- Exact enUS provenance: Spell.db2 ID 2912, Description_lang.
    [2912] = { en = "Causes $s1 Arcane damage to the target.", description = "Infligge $s1 danni arcani al bersaglio." },
    -- Exact enUS provenance: Spell.db2 ID 2983, Description_lang.
    [2983] = { en = "Increases the rogue's movement speed by $s1% for $d.  Does not break stealth.", description = "Aumenta del $s1% la velocità di movimento del ladro per $d. Non interrompe la Furtività." },
    -- Exact enUS provenance: Spell.db2 ID 5176, Description_lang.
    [5176] = { en = "Causes $s1 Nature damage to the target.", description = "Infligge $s1 danni da natura al bersaglio." },
    -- Exact enUS provenance: Spell.db2 ID 5185, Description_lang.
    [5185] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 5308, Description_lang.
    [5308] = { en = "Attempt to finish off a wounded foe, causing $s1 damage and converting each extra point of rage into $*10;F1 additional damage.  Only usable on enemies that have 20% or less health.", description = "Tenta di finire un nemico ferito, infliggendo $s1 danni e convertendo ogni punto Rabbia in eccesso in $*10;F1 danni aggiuntivi. Utilizzabile solo contro nemici con il 20% o meno della salute." },
    -- Exact enUS provenance: Spell.db2 ID 5782, Description_lang.
    [5782] = { en = "Strikes fear in the enemy, causing it to run in fear for up to $d.  Damage caused may interrupt the effect.  Only 1 target can be feared at a time.", description = "Incute paura nel nemico, costringendolo a fuggire terrorizzato per un massimo di $d. I danni inflitti possono interrompere l’effetto. Si può impaurire un solo bersaglio alla volta." },
    -- Exact enUS provenance: Spell.db2 ID 5784, Description_lang.
    [5784] = { en = "Summons a Felsteed, which serves as a mount for the caster.", description = "Evoca un destriero infernale che funge da cavalcatura per l’incantatore." },
    -- Exact enUS provenance: Spell.db2 ID 6060, Description_lang.
    [6060] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
    -- Exact enUS provenance: Spell.db2 ID 6063, Description_lang.
    [6063] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 6064, Description_lang.
    [6064] = { en = "Heal your target for $s1.", description = "Cura il bersaglio di $s1 punti salute." },
    -- Exact enUS provenance: Spell.db2 ID 6074, Description_lang.
    [6074] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 6075, Description_lang.
    [6075] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 6076, Description_lang.
    [6076] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 6077, Description_lang.
    [6077] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 6078, Description_lang.
    [6078] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 6229, Description_lang.
    [6229] = { en = "Absorbs $s1 shadow damage.  Lasts $d.", description = "Assorbe $s1 danni da ombra. Dura $d." },
    -- Exact enUS provenance: Spell.db2 ID 6807, Description_lang.
    [6807] = { en = "Increases the druid's next attack by $s1 damage.", description = "Aumenta di $s1 i danni del prossimo attacco del druido." },
    -- Exact enUS provenance: Spell.db2 ID 8092, Description_lang.
    [8092] = { en = "Blasts the target for $s1 Shadow damage, but causes a high amount of threat.", description = "Colpisce il bersaglio con $s1 danni da ombra, ma genera molta minaccia." },
    -- Exact enUS provenance: Spell.db2 ID 8122, Description_lang.
    [8122] = { en = "The caster lets out a psychic scream, causing $i enemies within $a1 yards to flee for $d.  Damage caused may interrupt the effect.", description = "L’incantatore emette un urlo psichico che costringe $i nemici entro $a1 m a fuggire per $d. I danni inflitti possono interrompere l’effetto." },
    -- Exact enUS provenance: Spell.db2 ID 8921, Description_lang.
    [8921] = { en = "Burns the enemy for $s2 Arcane damage and then an additional $o1 Arcane damage over $d.", description = "Brucia il nemico, infliggendo $s2 danni arcani e altri $o1 danni arcani nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 8936, Description_lang.
    [8936] = { en = "Heals a friendly target for $s1 and another $o2 over $d.", description = "Cura un bersaglio amico di $s1 punti salute e di altri $o2 nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 10156, Description_lang.
    [10156] = { en = "Increases the target's Intellect by $s1 for $d.", description = "Aumenta l’Intelletto del bersaglio di $s1 per $d." },
    -- Exact enUS provenance: Spell.db2 ID 10892, Description_lang.
    [10892] = { en = "A word of darkness that causes $o1 Shadow damage over $d.", description = "Una parola oscura infligge $o1 danni da ombra nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 10893, Description_lang.
    [10893] = { en = "A word of darkness that causes $o1 Shadow damage over $d.", description = "Una parola oscura infligge $o1 danni da ombra nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 10927, Description_lang.
    [10927] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 10928, Description_lang.
    [10928] = { en = "Heals the target of $o1 damage over $d.", description = "Cura il bersaglio di $o1 danni nell’arco di $d." },
    -- Exact enUS provenance: Spell.db2 ID 10933, Description_lang.
    [10933] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
    -- Exact enUS provenance: Spell.db2 ID 10934, Description_lang.
    [10934] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con una Punizione che infligge $s1 danni sacri." },
}

ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
for id, description in pairs(verifiedSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
    local entry = ns.data.spells[id]
    if type(entry) == "table" then
        entry.enDescription = description.en
        entry.description = description.description
    end
end
