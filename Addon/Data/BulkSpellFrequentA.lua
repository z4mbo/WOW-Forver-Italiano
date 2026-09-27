-- High-frequency spell description overrides from spell-priority.jsonl ranks 121-180.
-- One representative ID per exact English description; source strings and tokens are preserved.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
local frequentSpellDescriptions = {
    -- Priority rank 128; representative spell ID 415068.
    [415068] = { en = "Causes $s1 Holy damage to an enemy target and has $s2% chance to crit against Demons and Undead.", description = "Infligge $s1 danni sacri a un bersaglio nemico e ha il $s2% di probabilità di infliggere un colpo critico contro Demoni e Non morti." },
    -- Priority rank 129; representative spell ID 442893.
    [442893] = { en = "Chance to hit with spells increased by $s1%. Not cumulative with other ring runes.", description = "Aumenta di $s1% la probabilità di colpire con gli incantesimi. Non si cumula con altre rune dell’anello." },
    -- Priority rank 130; representative spell ID 1230948.
    [1230948] = { en = "The Global Cooldown of your offensive spells is reduced by ${$m1/-1000}.1 seconds.", description = "Riduce di ${$m1/-1000}.1 secondi il tempo di recupero globale dei tuoi incantesimi offensivi." },
    -- Priority rank 131; representative spell ID 1231578.
    [1231578] = { en = "Restores $s1 health instantly, however you also suffer $s2% of that amount over time.\r\n\r\nThe symptoms of this effect can manifest as either a $1231579d poison or a $1231580d disease.", description = "Ripristina subito $s1 salute, ma poi subisci nel tempo danni pari al $s2% di quella quantità.\r\n\r\nI sintomi di questo effetto possono manifestarsi come veleno di durata $1231579d o come malattia di durata $1231580d." },
    -- Priority rank 133; representative spell ID 1279983.
    [1279983] = { en = "$s1 Fire damage dealt to all enemies in target area.", description = "Infligge $s1 danni da fuoco a tutti i nemici nell’area bersaglio." },
    -- Priority rank 134; representative spell ID 1309501.
    [1309501] = { en = "Right Click to summon and dismiss your pet ent.", description = "Clic destro per evocare o congedare il tuo ent." },
    -- Priority rank 135; representative spell ID 99.
    [99] = { en = "The druid roars, decreasing nearby enemies' melee attack power by $s1.  Lasts $d.", description = "Il druido ruggisce, riducendo di $s1 la potenza d’attacco in mischia dei nemici vicini. Dura $d." },
    -- Priority rank 136; representative spell ID 596.
    [596] = { en = "A powerful prayer that heals the target and their party for $s1. Party members must be within $a1 yards of target.", description = "Una preghiera potente cura il bersaglio e i membri del suo gruppo di $s1. I membri del gruppo devono trovarsi entro $a1 metri dal bersaglio." },
    -- Priority rank 137; representative spell ID 1082.
    [1082] = { en = "Claw the enemy for $s2% normal damage plus $s1. Awards $s3 combo $lpoint:points;.", description = "Graffia il nemico, infliggendo danni pari al $s2% dei danni normali più $s1. Genera $s3 combo $lpoint:points;." },
    -- Priority rank 138; representative spell ID 1098.
    [1098] = { en = "Subjugates the target demon, up to level $m1, forcing it to do your bidding.  While subjugated, the time between the demon's attacks is increased by $s2% and its casting speed is slowed by $s3%.  Lasts up to $d.  If you repeatedly subjugate the same demon, it will become more difficult to control with each attempt.", description = "Soggioga il demone bersaglio fino al livello $m1 e lo costringe a eseguire i tuoi ordini. Mentre è soggiogato, il tempo tra i suoi attacchi aumenta del $s2% e la sua velocità di lancio degli incantesimi si riduce del $s3%. Dura fino a $d. Se soggioghi ripetutamente lo stesso demone, ogni tentativo rende più difficile controllarlo." },
    -- Priority rank 139; representative spell ID 1130.
    [1130] = { en = "Places the Hunter's Mark on the target, increasing the Ranged Attack Power of all attackers against that target by $s2.  In addition, the target of this ability can always be seen by the hunter whether it stealths or turns invisible.  The target also appears on the mini-map.  Lasts for $d.", description = "Applica Hunter’s Mark al bersaglio, aumentando di $s2 la potenza d’attacco a distanza di tutti gli attaccanti contro di esso. Inoltre, il Cacciatore può sempre vedere il bersaglio, anche se entra in modalità furtiva o diventa invisibile. Il bersaglio appare anche sulla minimappa. Dura $d." },
    -- Priority rank 140; representative spell ID 1515.
    [1515] = { en = "Begins taming a beast to be your companion.  Your armor is reduced by $s3% while you focus on taming the beast for $d.  If you lose the beast's attention for any reason, the taming process will fail.  Once tamed, the beast will be very unhappy and disloyal.  Try feeding the pet immediately to make it happy.", description = "Inizia ad addomesticare una bestia per farne la tua compagna. Mentre ti concentri per addomesticarla, la tua armatura si riduce del $s3% per $d. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce. Una volta addomesticata, la bestia sarà molto infelice e sleale. Prova subito a darle da mangiare per renderla felice." },
    -- Priority rank 141; representative spell ID 2008.
    [2008] = { en = "Returns the spirit to the body, restoring a dead target to life with $s1 health and $q1 mana.  Cannot be cast when in combat.", description = "Richiama lo spirito nel corpo e riporta in vita un bersaglio morto con $s1 salute e $q1 mana. Non si può lanciare in combattimento." },
    -- Priority rank 142; representative spell ID 2537.
    [2537] = { en = "A strike that causes $s1 damage and increases the holy damage taken by the target by up to $s2 per Crusader Strike.  Can be applied up to 5 times.  Lasts $d.", description = "Colpisce il bersaglio, infliggendo $s1 danni e aumentando fino a $s2 i danni sacri che subisce per ogni Crusader Strike. L’effetto può accumularsi fino a 5 volte. Dura $d." },
    -- Priority rank 144; representative spell ID 5349.
    [5349] = { en = "Increases your damage with Two-Handed Maces by $s1 and gives a 2% chance of stunning the target for 5 seconds.", description = "Aumenta i tuoi danni con le mazze a due mani di $s1 e conferisce il 2% di probabilità di stordire il bersaglio per 5 secondi." },
    -- Priority rank 146; representative spell ID 5857.
    [5857] = { en = "Deals $s1 Fire damage.", description = "Infligge $s1 danni da fuoco." },
    -- Priority rank 149; representative spell ID 7294.
    [7294] = { en = "Causes $s1 Holy damage to any creature that strikes a party member within $a1 yards. Players may only have one Aura on them per Paladin at any one time.", description = "Infligge $s1 danni sacri a ogni creatura che colpisce un membro del gruppo entro $a1 metri. Ogni paladino può applicare una sola Aura a ciascun giocatore." },
    -- Priority rank 152; representative spell ID 8129.
    [8129] = { en = "Drains $s1 mana from a target. For each mana drained in this way, the target takes 0.5 Shadow damage.", description = "Sottrae $s1 mana al bersaglio. Per ogni punto mana sottratto in questo modo, il bersaglio subisce 0,5 danni da ombra." },
    -- Priority rank 153; representative spell ID 8398.
    [8398] = { en = "Inflicts $s2 Frost damage to nearby enemies, reducing their movement speed by $s1% for $d.", description = "Infligge $s2 danni da gelo ai nemici vicini e ne riduce la velocità di movimento del $s1% per $d." },
    -- Priority rank 155; representative spell ID 10373.
    [10373] = { en = "Delivers a fatal wound for $s1 Physical damage. Deals $s2% increased damage to targets below $s3% health.", description = "Infligge una ferita mortale che causa $s1 danni fisici. Infligge il $s2% di danni aggiuntivi ai bersagli con meno del $s3% di salute." },
    -- Priority rank 156; representative spell ID 11113.
    [11113] = { en = "A wave of flame radiates outward from the caster, damaging all enemies caught within the blast for $s1 Fire damage, and Dazing them for $s2% reduced movement speed for $d.", description = "Un’ondata di fiamme si propaga dall’incantatore, infliggendo $s1 danni da fuoco a tutti i nemici investiti dall’esplosione e rallentandoli del $s2% per $d." },
    -- Priority rank 157; representative spell ID 12318.
    [12318] = { en = "Increases the melee attack power bonus of your Battle Shout by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco in mischia fornito da Battle Shout." },
    -- Priority rank 158; representative spell ID 12324.
    [12324] = { en = "Increases the melee attack power reduction of your Demoralizing Shout by $s1%.", description = "Aumenta del $s1% la riduzione della potenza d’attacco in mischia applicata da Demoralizing Shout." },
    -- Priority rank 161; representative spell ID 16858.
    [16858] = { en = "Increases the Attack Power reduction of your Demoralizing Roar by $s1% and the damage caused by your Ferocious Bite by $s2%.", description = "Aumenta del $s1% la riduzione della potenza d’attacco fornita da Demoralizing Roar e del $s2% i danni inflitti da Ferocious Bite." },
    -- Priority rank 162; representative spell ID 17050.
    [17050] = { en = "Increases the effects of your Mark of the Wild and Gift of the Wild spells by $s1%.", description = "Aumenta del $s1% gli effetti degli incantesimi Mark of the Wild e Gift of the Wild." },
    -- Priority rank 163; representative spell ID 17746.
    [17746] = { en = "Increases your effective stealth level by ${$s1/5}.", description = "Aumenta di ${$s1/5} il tuo livello effettivo di furtività." },
    -- Priority rank 164; representative spell ID 17815.
    [17815] = { en = "Increases the initial damage of your Immolate spell by $s1%.", description = "Aumenta del $s1% i danni iniziali dell’incantesimo Immolate." },
    -- Priority rank 167; representative spell ID 19281.
    [19281] = { en = "Weakens the target enemy, reducing melee attack power by $s1 and reducing the effectiveness of any healing by $s2%. Lasts $d", description = "Indebolisce il nemico bersaglio, riducendone di $s1 la potenza d’attacco in mischia e del $s2% l’efficacia delle cure ricevute. Dura $d." },
    -- Priority rank 168; representative spell ID 19506.
    [19506] = { en = "Increases the Ranged Attack Power of party members within $a1 yards by $s1. Lasts $d.", description = "Aumenta la potenza d’attacco a distanza dei membri del gruppo entro $a1 metri di $s1. Dura $d." },
    -- Priority rank 169; representative spell ID 20042.
    [20042] = { en = "Increases the melee attack power bonus of your Blessing of Might by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco in mischia fornito da Blessing of Might." },
    -- Priority rank 170; representative spell ID 20484.
    [20484] = { en = "Returns the spirit to the body, restoring a dead target to life with $s1 health and $q mana.", description = "Richiama lo spirito nel corpo e riporta in vita un bersaglio morto con $s1 salute e $q mana." },
    -- Priority rank 172; representative spell ID 22836.
    [22836] = { en = "+$s1 Attack Power against Elementals.", description = "+$s1 alla potenza d’attacco contro gli elementali." },
    -- Priority rank 173; representative spell ID 24351.
    [24351] = { en = "Reduces the hit chance of Fear effects against you by $s1%.", description = "Riduce del $s1% la probabilità che gli effetti di Fear vadano a segno su di te." },
    -- Priority rank 174; representative spell ID 24362.
    [24362] = { en = "Increased Fist Weapons +$s1.", description = "Aumenta di $s1 l’abilità con le armi a pugno." },
    -- Priority rank 176; representative spell ID 29082.
    [29082] = { en = "Increases the damage you deal with all weapons by $s1%.", description = "Aumenta del $s1% i danni che infliggi con tutte le armi." },
    -- Priority rank 177; representative spell ID 400574.
    [400574] = { en = "Blasts the target with energy, dealing $s1 Arcane damage. Each time you cast Arcane Blast, the damage of all your other spells is increased by $400573s1% and the mana cost of Arcane Blast is increased by $400573s2%. Effect stacks up to $400573u times and lasts $400573d or until any other damage spell is cast.", description = "Colpisce il bersaglio con un’esplosione d’energia, infliggendo $s1 danni arcani. Ogni volta che lanci Arcane Blast, i danni di tutti gli altri tuoi incantesimi aumentano del $400573s1% e il costo in mana di Arcane Blast aumenta del $400573s2%. L’effetto si accumula fino a $400573u volte e dura $400573d o finché non lanci un altro incantesimo che infligge danni." },
    -- Priority rank 180; representative spell ID 1213288.
    [1213288] = { en = "Reduces the chance for your attacks to be dodged or parried by $s1%.", description = "Riduce del $s1% la probabilità che i tuoi attacchi vengano schivati o parati." },
}
for id, description in pairs(frequentSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
end
