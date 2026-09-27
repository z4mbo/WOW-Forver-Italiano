-- Italian selector corrections from grammar-selector-review.jsonl.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
ns.data.spellAuraDescriptionOverrides = ns.data.spellAuraDescriptionOverrides or {}

local spellFixes = {
    [370] = { en = "Purges the enemy target, removing $m1 magic $leffect:effects;.", description = "Dissolve sul bersaglio nemico $m1 $leffetto:effetti; di magia." },
    [587] = { en = "Conjures $s1 $lmuffin:muffins;, providing the mage and $ghis:her; allies with something to eat.\r\n\r\nConjured items disappear if logged out for more than 15 minutes.", description = "Crea $s1 $ldolcetto:dolcetti;, così il mago ha qualcosa da mangiare e può condividere il cibo $gcon i suoi alleati:con le sue alleate;.\r\n\r\nGli oggetti evocati scompaiono se resti disconnesso per più di 15 minuti." },
    [703] = { en = "Garrote the enemy, causing $o1 damage over $d, increased by your Attack Power.  Must be stealthed and behind the target.  Awards $s2 combo $lpoint:points;.", description = "Garrota il nemico, infliggendo $o1 danni nell’arco di $d, aumentati dalla tua potenza d’attacco.  Devi essere in Furtività alle spalle del bersaglio.  Assegna $s2 $lpunto:punti; combo." },
    [1082] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Assegna $s3 $lpunto:punti; combo." },
    [1725] = { en = "Throws a distraction, attracting the attention of all nearby enemies and reducing their Stealth detection as if they were ${$m2/-5} $Llevel:levels; lower for $s1 seconds. Does not break stealth.", description = "Crea un diversivo che attira l’attenzione dei nemici vicini e ne riduce la capacità di rilevare la Furtività come se fossero di ${$m2/-5} $Llivello:livelli; inferiori per $s1 secondi. Non interrompe la Furtività." },
    [1822] = { en = "Rake the target for $s1 damage and an additional $o2 damage over $d.  Awards $s3 combo $lpoint:points;.", description = "Graffia il bersaglio, infliggendo $s1 danni e altri $o2 danni nell’arco di $d.  Assegna $s3 $lpunto:punti; combo." },
    [1823] = { en = "Rake the target for $s1 damage and an additional $o2 damage over $d.  Awards $s3 combo $lpoint:points;.", description = "Graffia il bersaglio, infliggendo $s1 danni e altri $o2 danni nell’arco di $d.  Assegna $s3 $lpunto:punti; combo." },
    [1824] = { en = "Rake the target for $s1 damage and an additional $o2 damage over $d.  Awards $s3 combo $lpoint:points;.", description = "Graffia il bersaglio, infliggendo $s1 danni e altri $o2 danni nell’arco di $d.  Assegna $s3 $lpunto:punti; combo." },
    [3029] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Assegna $s3 $lpunto:punti; combo." },
    [5201] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Assegna $s3 $lpunto:punti; combo." },
    [9827] = { en = "Pounce, stunning the target for $d and causing $9826o1 damage over $9826d.  Must be prowling and behind the target.  Awards $s3 combo $lpoint:points;.", description = "Balza sul bersaglio, stordendolo per $d e infliggendo $9826o1 danni nell’arco di $9826d.  Devi essere in agguato alle spalle del bersaglio.  Assegna $s3 $lpunto:punti; combo." },
    [9849] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Assegna $s3 $lpunto:punti; combo." },
    [9850] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Assegna $s3 $lpunto:punti; combo." },
    [9904] = { en = "Rake the target for $s1 damage and an additional $o2 damage over $d.  Awards $s3 combo $lpoint:points;.", description = "Graffia il bersaglio, infliggendo $s1 danni e altri $o2 danni nell’arco di $d.  Assegna $s3 $lpunto:punti; combo." },
    [19736] = { en = "Purges $s1 harmful magic $leffect:effects; from a friend or $s1 beneficial magic $leffect:effects; from an enemy.  If an effect is devoured, the Felhunter will be healed for $19735s1.", description = "Rimuove da un alleato $s1 $leffetto:effetti; magici dannosi oppure da un nemico $s1 $leffetto:effetti; magici benefici. Se divora un effetto, il Vilsegugio recupera $19735s1 salute." },
    [462868] = { en = "Purges $s1 harmful magic $leffect:effects; from a friend or $s1 beneficial magic $leffect:effects; from an enemy.  If an effect is devoured, the Felhunter will be healed for $19735s1.", description = "Rimuove da un alleato $s1 $leffetto:effetti; magici dannosi oppure da un nemico $s1 $leffetto:effetti; magici benefici. Se divora un effetto, il Vilsegugio recupera $19735s1 salute." },
    [1229228] = { en = "Pounce, stunning the target for $d and causing $9826o1 damage over $9826d.  Must be prowling and behind the target.  Awards $s3 combo $lpoint:points;.", description = "Balza sul bersaglio, stordendolo per $d e infliggendo $9826o1 danni nell’arco di $9826d.  Devi essere in agguato alle spalle del bersaglio.  Assegna $s3 $lpunto:punti; combo." },
    [1232054] = { en = "Combine $s4 Illusion Dust and $s5 Righteous $LOrb:Orbs; at a Mote of Possibility in pursuit of a new discovery.", description = "Combina $s4 Illusion Dust e $s5 $LSfera:sfere; Righteous presso un Mote of Possibility per tentare una nuova scoperta." },
    [1232077] = { en = "Combine $s4 Illusion Dust and $s5 Righteous $LOrb:Orbs; at a Mote of Possibility in pursuit of a new discovery.", description = "Combina $s4 Illusion Dust e $s5 $LSfera:sfere; Righteous presso un Mote of Possibility per tentare una nuova scoperta." },
    [1232079] = { en = "Combine $s4 Illusion Dust and $s5 Righteous $LOrb:Orbs; at a Mote of Possibility in pursuit of a new discovery.", description = "Combina $s4 Illusion Dust e $s5 $LSfera:sfere; Righteous presso un Mote of Possibility per tentare una nuova scoperta." },
    [1232176] = { en = "Combine $s4 Illusion Dust and $s5 Righteous $LOrb:Orbs; at a Mote of Possibility in pursuit of a new discovery.", description = "Combina $s4 Illusion Dust e $s5 $LSfera:sfere; Righteous presso un Mote of Possibility per tentare una nuova scoperta." },
    [1258520] = { en = "Pounce, stunning the target for $d and causing $9826o1 damage over $9826d.  Must be prowling and behind the target.  Awards $s3 combo $lpoint:points;.", description = "Balza sul bersaglio, stordendolo per $d e infliggendo $9826o1 danni nell’arco di $9826d.  Devi essere in agguato alle spalle del bersaglio.  Assegna $s3 $lpunto:punti; combo." },
    [1302511] = { en = "Purges $s1 harmful magic $leffect:effects; from a friend or $s1 beneficial magic $leffect:effects; from an enemy.  If an effect is devoured, the Felhunter will be healed for $19735s1.", description = "Rimuove da un alleato $s1 $leffetto:effetti; magici dannosi oppure da un nemico $s1 $leffetto:effetti; magici benefici. Se divora un effetto, il Vilsegugio recupera $19735s1 salute." },
}
for spellID, entry in pairs(spellFixes) do
    ns.data.spellDescriptionOverrides[spellID] = entry
end

local auraFixes = {
    [368218] = { en = "$s1 damage every $t1 $lsecond:seconds;.", description = "$s1 danni ogni $t1 $lsecondo:secondi;." },
    [368235] = { en = "$s1 damage every $t1 $lsecond:seconds;.", description = "$s1 danni ogni $t1 $lsecondo:secondi;." },
    [417157] = { en = "Your next $n Starfire $Lcast deals:casts deal; $s2% increased damage.", description = "Ogni $n $Lincantesimo di Fuoco Stellare infligge:incantesimi di Fuoco Stellare infliggono; il $s2% di danni aggiuntivi." },
    [1231098] = { en = "$s1 damage every $t1 $lsecond:seconds;.", description = "$s1 danni ogni $t1 $lsecondo:secondi;." },
    [1232755] = { en = "$s1 damage every $t1 $lsecond:seconds;.", description = "$s1 danni ogni $t1 $lsecondo:secondi;." },
    [1233069] = { en = "$s1 damage every $t1 $lsecond:seconds;.", description = "$s1 danni ogni $t1 $lsecondo:secondi;." },
    [1293696] = { en = "The caster's pet deals an additional ${$<minDam>*$<mult>} to ${$<maxDam>*$<mult>} damage with its next $m2 $Lattack:attacks;.", description = "Il famiglio dell’incantatore infligge danni aggiuntivi da ${$<minDam>*$<mult>} a ${$<maxDam>*$<mult>} con il prossimo $m2 $Lattacco:attacchi;." },
}
for spellID, entry in pairs(auraFixes) do
    ns.data.spellAuraDescriptionOverrides[spellID] = entry
end
