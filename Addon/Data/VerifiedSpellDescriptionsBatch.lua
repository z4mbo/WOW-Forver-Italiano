-- Spell descriptions checked against the local Forever beta Spell.db2 dump.
-- Source: enUS Description_lang; IDs and text also compared with itIT.
-- Dynamic spell tokens are kept verbatim for the guarded tooltip renderer.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

local verifiedSpellDescriptions = {
    -- Undead racial and core Rogue abilities.
    [7744] = {
        en = "Instantly removes all Charm, Fear and Sleep effects.",
        description = "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.",
    },
    [20577] = {
        en = "When activated, regenerates $20578s1% of total Health and $20578s2% of total Mana every $20578t1 sec for $20578d. Only works on Humanoid or Undead corpses within $a1 yds. Any movement, action, or damage taken while Cannibalizing will cancel the effect.",
        description = "Quando viene attivato, rigenera il $20578s1% della salute totale e il $20578s2% del mana totale ogni $20578t1 s per $20578d. Funziona solo sui cadaveri di umanoidi o non morti entro $a1 m. Qualsiasi movimento, azione o danno subito durante il Cannibalismo annulla l'effetto.",
    },
    [1752] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [1757] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [1758] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [1759] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [1760] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [1766] = {
        en = "A quick kick that injures a single foe for $s1 damage.  It also interrupts spellcasting and prevents any spell in that school from being cast for $d.",
        description = "Un rapido calcio che infligge $s1 danni a un nemico. Interrompe il lancio degli incantesimi e impedisce di lanciare incantesimi di quella scuola per $d.",
    },
    [1776] = {
        en = "Causes $s1 damage, stops your attack, and incapacitates the target for $d.  The target must be facing you.  Any damage taken will break the effect.  Awards $s2 combo $lpoint:points;.",
        description = "Infligge $s1 danni, interrompe il tuo attacco e incapacita il bersaglio per $d. Il bersaglio deve essere rivolto verso di te. Qualsiasi danno subito interrompe l'effetto. Genera $s2 $lpoint:punti; combo.",
    },
    [1784] = {
        en = "Allows the rogue to sneak around, but reduces your speed by $s3%.  Lasts until cancelled.",
        description = "Permette al ladro di muoversi furtivamente, ma riduce la tua velocità del $s3%. Dura finché non viene annullato.",
    },
    [1856] = {
        en = "Allows the rogue to vanish from sight, entering an improved stealth mode for $11327d. Also breaks movement impairing effects.",
        description = "Permette al ladro di svanire alla vista, entrando in uno stato di furtività migliorata per $11327d. Rimuove anche gli effetti che limitano il movimento.",
    },
    [1943] = {
        en = "Finishing move that causes damage over time, increased by your Attack Power.  Lasts longer per combo point:\n   1 point  : ${($m1+$b1)*4} damage over 8 secs\n   2 points: ${($m1+$b1*2)*5} damage over 10 secs\n   3 points: ${($m1+$b1*3)*6} damage over 12 secs\n   4 points: ${($m1+$b1*4)*7} damage over 14 secs\n   5 points: ${($m1+$b1*5)*8} damage over 16 secs",
        description = "Mossa finale che infligge danni periodici, aumentati dalla tua potenza d'attacco. La durata aumenta in base ai punti combo:\n   1 punto: ${($m1+$b1)*4} danni in 8 s\n   2 punti: ${($m1+$b1*2)*5} danni in 10 s\n   3 punti: ${($m1+$b1*3)*6} danni in 12 s\n   4 punti: ${($m1+$b1*4)*7} danni in 14 s\n   5 punti: ${($m1+$b1*5)*8} danni in 16 s",
    },
    [2098] = {
        en = "Finishing move that causes damage per combo point, increased by Attack Power:\n   1 point  : ${$m1+(1*$b1*$<mult>)}-${$M1+(1*$b1*$<mult>)} damage\n   2 points: ${$m1+(2*$b1*$<mult>)}-${$M1+(2*$b1*$<mult>)} damage\n   3 points: ${$m1+(3*$b1*$<mult>)}-${$M1+(3*$b1*$<mult>)} damage\n   4 points: ${$m1+(4*$b1*$<mult>)}-${$M1+(4*$b1*$<mult>)} damage\n   5 points: ${$m1+(5*$b1*$<mult>)}-${$M1+(5*$b1*$<mult>)} damage",
        description = "Mossa finale che infligge danni in base ai punti combo, aumentati dalla potenza d'attacco:\n   1 punto: ${$m1+(1*$b1*$<mult>)}-${$M1+(1*$b1*$<mult>)} danni\n   2 punti: ${$m1+(2*$b1*$<mult>)}-${$M1+(2*$b1*$<mult>)} danni\n   3 punti: ${$m1+(3*$b1*$<mult>)}-${$M1+(3*$b1*$<mult>)} danni\n   4 punti: ${$m1+(4*$b1*$<mult>)}-${$M1+(4*$b1*$<mult>)} danni\n   5 punti: ${$m1+(5*$b1*$<mult>)}-${$M1+(5*$b1*$<mult>)} danni",
    },
    [2589] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [2590] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [2591] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [2842] = {
        en = "You can create and mix poisons, with both found and storebought ingredients.",
        description = "Ti permette di creare e combinare veleni usando ingredienti trovati o acquistati.",
    },
    [5171] = {
        en = "Finishing move that increases melee attack speed by $s2%.  Lasts longer per combo point:\n   1 point  : ${9*$<mult>} seconds\n   2 points: ${12*$<mult>} seconds\n   3 points: ${15*$<mult>} seconds\n   4 points: ${18*$<mult>} seconds\n   5 points: ${21*$<mult>} seconds",
        description = "Mossa finale che aumenta del $s2% la velocità d'attacco in mischia. La durata aumenta in base ai punti combo:\n   1 punto: ${9*$<mult>} secondi\n   2 punti: ${12*$<mult>} secondi\n   3 punti: ${15*$<mult>} secondi\n   4 punti: ${18*$<mult>} secondi\n   5 punti: ${21*$<mult>} secondi",
    },
    [5277] = {
        en = "The rogue's dodge chance will increase by $s1% for $d.",
        description = "La probabilità di schivata del ladro aumenta del $s1% per $d.",
    },
    [5938] = {
        en = "Performs an instant off-hand weapon attack that automatically applies the poison from your off-hand weapon to the target.  Slower weapons require more Energy.  Neither Shiv nor the poison it applies can be a critical strike.  Awards 1 combo point.",
        description = "Esegue un attacco istantaneo con l'arma nella mano secondaria e applica automaticamente al bersaglio il veleno presente su quell'arma. Le armi più lente richiedono più energia. Né Shiv né il veleno applicato possono infliggere un colpo critico. Genera 1 punto combo.",
    },
    [6770] = {
        en = "Incapacitates the target for up to $d. Only works on Humanoids that are not in combat.  Any damage taken will break the effect. Only 1 target may be sapped at a time. Does not break Stealth.",
        description = "Inabilita il bersaglio per un massimo di $d. Funziona solo sugli umanoidi fuori dal combattimento. Qualsiasi danno subito interrompe l'effetto. Si può inabilitare un solo bersaglio alla volta. Non interrompe la Furtività.",
    },
    [8676] = {
        en = "Ambush the target, causing $s2% weapon damage plus 70 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Assalta il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più 70. Devi essere in Furtività, trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [8681] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $8679h% chance of poisoning the enemy which instantly inflicts $8680s1 Nature damage.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $8679h% di probabilità di avvelenare il nemico, infliggendogli istantaneamente $8680s1 danni naturali. $m3 cariche.",
    },
    [8721] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [8724] = {
        en = "Ambush the target, causing $s2% weapon damage plus 100 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Assalta il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più 100. Devi essere in Furtività, trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11267] = {
        en = "Ambush the target, causing $s2% weapon damage plus 185 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Assalta il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più 185. Devi essere in Furtività, trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11268] = {
        en = "Ambush the target, causing $s2% weapon damage plus 230 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Assalta il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più 230. Devi essere in Furtività, trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11269] = {
        en = "Ambush the target, causing $s2% weapon damage plus 290 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Assalta il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più 290. Devi essere in Furtività, trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11273] = {
        en = "Finishing move that causes damage over time, increased by your Attack Power.  Lasts longer per combo point:\n   1 point  : ${($m1+$b1)*4} damage over 8 secs\n   2 points: ${($m1+$b1*2)*5} damage over 10 secs\n   3 points: ${($m1+$b1*3)*6} damage over 12 secs\n   4 points: ${($m1+$b1*4)*7} damage over 14 secs\n   5 points: ${($m1+$b1*5)*8} damage over 16 secs",
        description = "Mossa finale che infligge danni periodici, aumentati dalla tua potenza d'attacco. La durata aumenta in base ai punti combo:\n   1 punto: ${($m1+$b1)*4} danni in 8 s\n   2 punti: ${($m1+$b1*2)*5} danni in 10 s\n   3 punti: ${($m1+$b1*3)*6} danni in 12 s\n   4 punti: ${($m1+$b1*4)*7} danni in 14 s\n   5 punti: ${($m1+$b1*5)*8} danni in 16 s",
    },
    [11274] = {
        en = "Finishing move that causes damage over time, increased by your Attack Power.  Lasts longer per combo point:\n   1 point  : ${($m1+$b1)*4} damage over 8 secs\n   2 points: ${($m1+$b1*2)*5} damage over 10 secs\n   3 points: ${($m1+$b1*3)*6} damage over 12 secs\n   4 points: ${($m1+$b1*4)*7} damage over 14 secs\n   5 points: ${($m1+$b1*5)*8} damage over 16 secs",
        description = "Mossa finale che infligge danni periodici, aumentati dalla tua potenza d'attacco. La durata aumenta in base ai punti combo:\n   1 punto: ${($m1+$b1)*4} danni in 8 s\n   2 punti: ${($m1+$b1*2)*5} danni in 10 s\n   3 punti: ${($m1+$b1*3)*6} danni in 12 s\n   4 punti: ${($m1+$b1*4)*7} danni in 14 s\n   5 punti: ${($m1+$b1*5)*8} danni in 16 s",
    },
    [11275] = {
        en = "Finishing move that causes damage over time, increased by your Attack Power.  Lasts longer per combo point:\n   1 point  : ${($m1+$b1)*4} damage over 8 secs\n   2 points: ${($m1+$b1*2)*5} damage over 10 secs\n   3 points: ${($m1+$b1*3)*6} damage over 12 secs\n   4 points: ${($m1+$b1*4)*7} damage over 14 secs\n   5 points: ${($m1+$b1*5)*8} damage over 16 secs",
        description = "Mossa finale che infligge danni periodici, aumentati dalla tua potenza d'attacco. La durata aumenta in base ai punti combo:\n   1 punto: ${($m1+$b1)*4} danni in 8 s\n   2 punti: ${($m1+$b1*2)*5} danni in 10 s\n   3 punti: ${($m1+$b1*3)*6} danni in 12 s\n   4 punti: ${($m1+$b1*4)*7} danni in 14 s\n   5 punti: ${($m1+$b1*5)*8} danni in 16 s",
    },
    [11279] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11280] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11281] = {
        en = "Backstab the target, causing $s2% weapon damage plus $s1 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards $s3 combo $lpoint:points;.",
        description = "Pugnala il bersaglio alle spalle, infliggendo danni pari al $s2% dei danni dell'arma più $s1. Devi trovarti alle spalle del bersaglio e impugnare un pugnale nella mano primaria. Genera $s3 $lpoint:punti; combo.",
    },
    [11285] = {
        en = "Causes $s1 damage, stops your attack, and incapacitates the target for $d.  The target must be facing you.  Any damage taken will break the effect.  Awards $s2 combo $lpoint:points;.",
        description = "Infligge $s1 danni, interrompe il tuo attacco e inabilita il bersaglio per $d. Il bersaglio deve essere rivolto verso di te. Qualsiasi danno subito interrompe l'effetto. Genera $s2 $lpoint:punti; combo.",
    },
    [11286] = {
        en = "Causes $s1 damage, stops your attack, and incapacitates the target for $d.  The target must be facing you.  Any damage taken will break the effect.  Awards $s2 combo $lpoint:points;.",
        description = "Infligge $s1 danni, interrompe il tuo attacco e inabilita il bersaglio per $d. Il bersaglio deve essere rivolto verso di te. Qualsiasi danno subito interrompe l'effetto. Genera $s2 $lpoint:punti; combo.",
    },
    [11289] = {
        en = "Garrote the enemy, causing $o1 damage over $d, increased by your Attack Power.  Must be stealthed and behind the target.  Awards $s2 combo $lpoint:points;.",
        description = "Strozza il nemico, infliggendo $o1 danni in $d, aumentati dalla tua potenza d'attacco. Devi essere in Furtività e trovarti alle spalle del bersaglio. Genera $s2 $lpoint:punti; combo.",
    },
    [11290] = {
        en = "Garrote the enemy, causing $o1 damage over $d, increased by your Attack Power.  Must be stealthed and behind the target.  Awards $s2 combo $lpoint:points;.",
        description = "Strozza il nemico, infliggendo $o1 danni in $d, aumentati dalla tua potenza d'attacco. Devi essere in Furtività e trovarti alle spalle del bersaglio. Genera $s2 $lpoint:punti; combo.",
    },
    [11293] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [11294] = {
        en = "An instant strike that causes $s1 damage in addition to your normal weapon damage.  Awards $s2 combo $lpoint:points;.",
        description = "Un colpo istantaneo che infligge $s1 danni aggiuntivi rispetto ai normali danni dell'arma. Genera $s2 $lpoint:punti; combo.",
    },
    [11297] = {
        en = "Incapacitates the target for up to $d. Only works on Humanoids that are not in combat.  Any damage taken will break the effect. Only 1 target may be sapped at a time. Does not break Stealth.",
        description = "Inabilita il bersaglio per un massimo di $d. Funziona solo sugli umanoidi fuori dal combattimento. Qualsiasi danno subito interrompe l'effetto. Si può inabilitare un solo bersaglio alla volta. Non interrompe la Furtività.",
    },
    [11300] = {
        en = "Finishing move that causes damage per combo point, increased by Attack Power:\n   1 point  : ${$m1+(1*$b1*$<mult>)}-${$M1+(1*$b1*$<mult>)} damage\n   2 points: ${$m1+(2*$b1*$<mult>)}-${$M1+(2*$b1*$<mult>)} damage\n   3 points: ${$m1+(3*$b1*$<mult>)}-${$M1+(3*$b1*$<mult>)} damage\n   4 points: ${$m1+(4*$b1*$<mult>)}-${$M1+(4*$b1*$<mult>)} damage\n   5 points: ${$m1+(5*$b1*$<mult>)}-${$M1+(5*$b1*$<mult>)} damage",
        description = "Mossa finale che infligge danni in base ai punti combo, aumentati dalla potenza d'attacco:\n   1 punto: ${$m1+(1*$b1*$<mult>)}-${$M1+(1*$b1*$<mult>)} danni\n   2 punti: ${$m1+(2*$b1*$<mult>)}-${$M1+(2*$b1*$<mult>)} danni\n   3 punti: ${$m1+(3*$b1*$<mult>)}-${$M1+(3*$b1*$<mult>)} danni\n   4 punti: ${$m1+(4*$b1*$<mult>)}-${$M1+(4*$b1*$<mult>)} danni\n   5 punti: ${$m1+(5*$b1*$<mult>)}-${$M1+(5*$b1*$<mult>)} danni",
    },
    [11303] = {
        en = "Performs a feint, causing no damage but lowering your threat by a large amount, making the enemy less likely to attack you.",
        description = "Esegue una finta senza infliggere danni, ma riduce notevolmente la tua minaccia e rende il nemico meno incline ad attaccarti.",
    },
    [11305] = {
        en = "Increases the rogue's movement speed by $s1% for $d.  Does not break stealth.",
        description = "Aumenta del $s1% la velocità di movimento del ladro per $d. Non interrompe la Furtività.",
    },
    [11341] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60}  minutes.\nEach strike has a $11338h% chance of poisoning the enemy which instantly inflicts $11335s1 Nature damage.  $m2 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11338h% di probabilità di avvelenare il nemico, infliggendogli istantaneamente $11335s1 danni naturali. $m2 cariche.",
    },
    [11342] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $11339h% chance of poisoning the enemy which instantly inflicts $11336s1 Nature damage.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11339h% di probabilità di avvelenare il nemico, infliggendogli istantaneamente $11336s1 danni naturali. $m3 cariche.",
    },
    [11343] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $11340h% chance of poisoning the enemy which instantly inflicts $11337s1 Nature damage.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11340h% di probabilità di avvelenare il nemico, infliggendogli istantaneamente $11337s1 danni naturali. $m3 cariche.",
    },
    [11357] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $11355h% chance of poisoning the enemy for $11353o1 Nature damage over $11353d.  Stacks up to $11353u times on a single target.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11355h% di probabilità di avvelenare il nemico, infliggendogli $11353o1 danni naturali in $11353d. Si accumula fino a $11353u volte sullo stesso bersaglio. $m3 cariche.",
    },
    [11358] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $11356h% chance of poisoning the enemy for $11354o1 Nature damage over $11354d.  Stacks up to $11354u times on a single target.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11356h% di probabilità di avvelenare il nemico, infliggendogli $11354o1 danni naturali in $11354d. Si accumula fino a $11354u volte sullo stesso bersaglio. $m3 cariche.",
    },
    [11400] = {
        en = "Coats a weapon with poison that lasts for ${$m2/60} minutes.\nEach strike has a $11399h% chance of poisoning the enemy, increasing their casting time by $11398s1% for $11398d.  $m3 charges.",
        description = "Ricopre un'arma di veleno per ${$m2/60} minuti.\nOgni colpo ha il $11399h% di probabilità di avvelenare il nemico, aumentando del $11398s1% il suo tempo di lancio per $11398d. $m3 cariche.",
    },
    [20572] = {
        en = "Increases Attack Power and Spell Power by $s1% for $d.",
        description = "Aumenta del $s1% la potenza d'attacco e la potenza magica per $d.",
    },
    [20574] = {
        en = "Increases your critical strike chance with all spells and abilities by $s1% while you have an axe or a two-handed axe equipped.",
        description = "Aumenta del $s1% la probabilità di colpo critico di tutti gli incantesimi e le abilità mentre impugni un'ascia o un'ascia a due mani.",
    },
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
