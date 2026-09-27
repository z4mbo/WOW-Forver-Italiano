-- High-frequency spell descriptions from priority ranks 181-400.
-- Exact English source strings; one representative per distinct description.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}

local verifiedSpellDescriptions = {
    -- Rank 181, shared by 5 spell IDs.
    [1220654] = { en = "Increases your casting speed by $s1%.", description = "Aumenta la velocità di lancio dei tuoi incantesimi del $s1%." },
    -- Rank 182, shared by 5 spell IDs.
    [1264478] = { en = "Emits a piercing shriek, inflicting $s1 Nature amage and Increases the casting time of all spells by $s2% for$d.", description = "Emette un acuto stridio che infligge $s1 danni da natura e aumenta del $s2% il tempo di lancio di tutti gli incantesimi per $d." },
    -- Rank 183, shared by 5 spell IDs.
    [1264735] = { en = "Pinches an enemy's legs for $s1 damage and reduces movement speed by $s2% for $d.", description = "Pizzica le gambe del nemico, infliggendo $s1 danni e riducendo la velocità di movimento del $s2% per $d." },
    -- Rank 184, shared by 5 spell IDs.
    [1264758] = { en = "Viciously bites enemy appendages for $s1 damage and reduces the effectiveness of any healing by $s2% for $d.", description = "Morde ferocemente le membra del nemico, infliggendo $s1 danni e riducendo del $s2% l’efficacia delle cure per $d." },
    -- Rank 185, shared by 5 spell IDs.
    [1265038] = { en = "Tears at an enemy's legs for $o1 damage over $d and reduces movement speed by $s2% for $d.", description = "Lacera le gambe del nemico, infliggendo $o1 danni in $d e riducendo la velocità di movimento del $s2% per $d." },
    -- Rank 186, shared by 5 spell IDs.
    [1265054] = { en = "Grabs an enemy's weapon with its talons, causing $s1 damage and disarming them for $d.", description = "Afferra l’arma del nemico con gli artigli, infliggendo $s1 danni e disarmandolo per $d." },
    -- Rank 187, shared by 5 spell IDs.
    [1265065] = { en = "Slash an enemy with razor talons, causing the target to Bleed for $o1 damage over $d.", description = "Lacera un nemico con artigli affilati, facendo sanguinare il bersaglio per $o1 danni in $d." },
    -- Rank 188, shared by 5 spell IDs.
    [1265843] = { en = "Entangles an enemy in a corrosive web, immobilizing them and dealing $o1 Nature damage over $d.", description = "Intrappola un nemico in una ragnatela corrosiva, immobilizzandolo e infliggendo $o1 danni da natura in $d." },
    -- Rank 189, shared by 5 spell IDs.
    [1265899] = { en = "Your tallstrider kicks up an abrasive cloud of dust, reducing the target's Armor by $s1 for $d.", description = "Il tuo tallstrider solleva una nuvola di polvere abrasiva, riducendo l’armatura del bersaglio di $s1 per $d." },
    -- Rank 190, shared by 5 spell IDs.
    [1277324] = { en = "Cannibalize $o1 of your own Health over $d to gain ${$o2+$SPI} Mana.", description = "Consuma $o1 della tua salute in $d per ottenere ${$o2+$SPI} mana." },
    -- Rank 191, shared by 5 spell IDs.
    [1277331] = { en = "Chastise the target, causing $s1 Holy damage and Immobilizing them for up to $d. Only works against Humanoids.  This spell causes very low threat", description = "Castiga il bersaglio, infliggendo $s1 danni sacri e immobilizzandolo fino a $d. Funziona solo contro gli Umanoidi. Genera pochissima minaccia." },
    -- Rank 192, shared by 5 spell IDs.
    [1289402] = { en = "Collect the appearances of this armor set.", description = "Colleziona gli aspetti di questo set d’armatura." },
    -- Rank 193, shared by 5 spell IDs.
    [1291987] = { en = "Increases the chance your Pick Pocket and Distract abilities are successful by $s1%", description = "Aumenta del $s1% la probabilità che le abilità Borseggio e Distrazione abbiano successo." },
    -- Rank 194, shared by 5 spell IDs.
    [1295622] = { en = "Honor gains increased by $s1%.\r\n", description = "I punti onore ottenuti aumentano del $s1%.\r\n" },
    -- Rank 195, shared by 5 spell IDs.
    [1296017] = { en = "Decipher an untranslated scroll.", description = "Decifra una pergamena non tradotta." },
    -- Rank 196, shared by 5 spell IDs.
    [1300934] = { en = "Increases your attack speed and casting speed by $s1%.", description = "Aumenta del $s1% la velocità d’attacco e di lancio degli incantesimi." },
    -- Rank 197, shared by 5 spell IDs.
    [1309346] = { en = "Summons and dismisses a rideable devilsaur.", description = "Evoca o congeda un devilsaur cavalcabile." },
    -- Rank 198, shared by 5 spell IDs.
    [1309436] = { en = "Right Click to summon and dismiss your pet furbolg.", description = "Clic destro per evocare o congedare il tuo famiglio furbolg." },
    -- Rank 199, shared by 4 spell IDs.
    [65] = { en = "Increases your attack speed by $s1% for $d.", description = "Aumenta la velocità d’attacco del $s1% per $d." },
    -- Rank 200, shared by 4 spell IDs.
    [118] = { en = "Transforms the enemy into a sheep, forcing it to wander around for up to $d.  While wandering, the sheep cannot attack or cast spells but will regenerate very quickly.  Any damage will transform the target back into its normal form.  Only one target can be polymorphed at a time.  Only works on Beasts, Humanoids and Critters.", description = "Trasforma il nemico in una pecora, costringendola a vagare per $d. Mentre vaga, non può attaccare né lanciare incantesimi, ma rigenera salute molto rapidamente. Qualsiasi danno riporta il bersaglio alla sua forma normale. Puoi trasformare un solo bersaglio alla volta. Funziona solo su Bestie, Umanoidi e piccole creature." },
    -- Rank 201, shared by 4 spell IDs.
    [1008] = { en = "Amplifies magic used against the targeted party member, increasing damage taken from spells by up to $s1 and healing spells by up to $s2.  Lasts $d.", description = "Amplifica la magia usata contro il membro del gruppo selezionato, aumentando fino a $s1 i danni subiti dagli incantesimi e fino a $s2 le cure ricevute. Dura $d." },
    -- Rank 202, shared by 4 spell IDs.
    [1120] = { en = "Drains the soul of the target, causing $o2 Shadow damage over $d. Non-trivial targets damaged by Drain Soul have a chance to grant you a Soul Shard. Non-trivial targets killed by Drain Soul will always grant you a Soul shard. Soul Shards are required for other spells.", description = "Risucchia l’anima del bersaglio, infliggendo $o2 danni da ombra in $d. I bersagli impegnativi danneggiati da Risucchio dell’Anima possono fornirti un Frammento d’Anima. I bersagli impegnativi uccisi da Risucchio dell’Anima ne forniscono sempre uno. I Frammenti d’Anima servono per altri incantesimi." },
    -- Rank 203, shared by 4 spell IDs.
    [1495] = { en = "Counterattack the enemy for melee weapon damage plus $s1. Can only be performed after you dodge.", description = "Contrattacca infliggendo i danni dell’arma da mischia più $s1. Puoi usare questo attacco solo dopo aver schivato." },
    -- Rank 204, shared by 4 spell IDs.
    [1822] = { en = "Rake the target for $s1 damage and an additional $o2 damage over $d.  Awards $s3 combo $lpoint:points;.", description = "Graffia il bersaglio, infliggendo $s1 danni e altri $o2 danni in $d. Assegna $s3 $lpoint:points; combo." },
    -- Rank 205, shared by 4 spell IDs.
    [2947] = { en = "Surrounds the target in a shield of fire.  Every strike against the target causes $s1 Fire damage to the attacker.  Lasts $d.  Your pet cannot cast Fire Shield on itself.", description = "Avvolge il bersaglio in uno scudo di fuoco. Ogni attacco contro il bersaglio infligge $s1 danni da fuoco all’attaccante. Dura $d. Il tuo famiglio non può lanciare Scudo di Fuoco su se stesso." },
    -- Rank 206, shared by 4 spell IDs.
    [3131] = { en = "Inflicts $s1 Frost damage to an enemy.", description = "Infligge $s1 danni da gelo a un nemico." },
    -- Rank 208, shared by 4 spell IDs.
    [3741] = { en = "Increase Holy resistance by $s1.", description = "Aumenta la resistenza sacra di $s1." },
    -- Rank 209, shared by 4 spell IDs.
    [4064] = { en = "Inflicts $s1 Fire damage and stuns targets in a 3 yard radius for $d. Any damage will break the effect.", description = "Infligge $s1 danni da fuoco e stordisce i bersagli entro un raggio di 3 m per $d. Qualsiasi danno subito interrompe l’effetto." },
    -- Rank 210, shared by 4 spell IDs.
    [4065] = { en = "Inflicts $s1 Fire damage and stuns targets in a 5 yard radius for $d. Any damage will break the effect.", description = "Infligge $s1 danni da fuoco e stordisce i bersagli entro un raggio di 5 m per $d. Qualsiasi danno subito interrompe l’effetto." },
    -- Rank 211, shared by 4 spell IDs.
    [4382] = { en = "Increases your damage with Daggers by $s1.", description = "Aumenta di $s1 i danni inflitti con i pugnali." },
    -- Rank 212, shared by 4 spell IDs.
    [4488] = { en = "Increases your damage with Staves by $s1.", description = "Aumenta di $s1 i danni inflitti con i bastoni." },
    -- Rank 213, shared by 4 spell IDs.
    [4542] = { en = "Increase Holy resistance by $s1 and gives a $s2% chance of reflecting hostile Holy spells back at the caster.", description = "Aumenta la resistenza sacra di $s1 e conferisce una probabilità del $s2% di riflettere gli incantesimi sacri ostili contro chi li lancia." },
    -- Rank 214, shared by 4 spell IDs.
    [4547] = { en = "Increase Fire resistance by $s1.", description = "Aumenta la resistenza al fuoco di $s1." },
    -- Rank 215, shared by 4 spell IDs.
    [4549] = { en = "Increase Frost resistance by $s1.", description = "Aumenta la resistenza al gelo di $s1." },
    -- Rank 216, shared by 4 spell IDs.
    [4550] = { en = "Increase Shadow resistance by $s1.", description = "Aumenta la resistenza all’ombra di $s1." },
    -- Rank 217, shared by 4 spell IDs.
    [4553] = { en = "Increase Fire resistance by $s1 and gives a $s2% chance of reflecting hostile Fire spells back at the caster.", description = "Aumenta la resistenza al fuoco di $s1 e conferisce una probabilità del $s2% di riflettere gli incantesimi del fuoco ostili contro chi li lancia." },
    -- Rank 218, shared by 4 spell IDs.
    [4560] = { en = "Increase Nature resistance by $s1 and gives a $s2% chance of reflecting hostile Nature spells back at the caster.", description = "Aumenta la resistenza alla natura di $s1 e conferisce una probabilità del $s2% di riflettere gli incantesimi della natura ostili contro chi li lancia." },
    -- Rank 219, shared by 4 spell IDs.
    [4567] = { en = "Increase Frost resistance by $s1 and gives a $s2% chance of reflecting hostile Frost spells back at the caster.", description = "Aumenta la resistenza al gelo di $s1 e conferisce una probabilità del $s2% di riflettere gli incantesimi del gelo ostili contro chi li lancia." },
    -- Rank 220, shared by 4 spell IDs.
    [4574] = { en = "Increase Shadow resistance by $s1 and gives a $s2% chance of reflecting hostile Shadow spells back at the caster.", description = "Aumenta la resistenza all’ombra di $s1 e conferisce una probabilità del $s2% di riflettere gli incantesimi d’ombra ostili contro chi li lancia." },
    -- Rank 221, shared by 4 spell IDs.
    [4788] = { en = "Increases your Fire Magic skill by $s1 and reduces your Frost Resistance by $s2.", description = "Aumenta di $s1 l’abilità di magia del fuoco e riduce di $s2 la resistenza al gelo." },
    -- Rank 222, shared by 4 spell IDs.
    [4792] = { en = "Increases your Nature Magic skill by $s1, but decreases your Shadow and Fire resistance by $s2.", description = "Aumenta di $s1 l’abilità di magia della natura, ma riduce di $s2 le resistenze all’ombra e al fuoco." },
    -- Rank 223, shared by 4 spell IDs.
    [4796] = { en = "Increases your Frost Magic skill by $s1 and decreases your Fire Resistance by $s2.", description = "Aumenta di $s1 l’abilità di magia del gelo e riduce di $s2 la resistenza al fuoco." },
    -- Rank 224, shared by 4 spell IDs.
    [5138] = { en = "Transfers $s1 Mana every $t1 sec from the target to the caster. Lasts $d.", description = "Trasferisce $s1 mana dal bersaglio all’incantatore ogni $t1 sec. Dura $d." },
    -- Rank 225, shared by 4 spell IDs.
    [5341] = { en = "Increases your damage with Two-Handed Axes by $s1 and gives a 2% chance of reducing enemy armor by 100 for 15 seconds.", description = "Aumenta di $s1 i danni inflitti con le asce a due mani e conferisce una probabilità del 2% di ridurre di 100 l’armatura del nemico per 15 secondi." },
    -- Rank 226, shared by 4 spell IDs.
    [5356] = { en = "Increases your damage with Two-Handed Swords by $s1 and your chance to parry with one by 3%.", description = "Aumenta di $s1 i danni inflitti con le spade a due mani e del 3% la probabilità di parare con una spada a due mani." },
    -- Rank 227, shared by 4 spell IDs.
    [5429] = { en = "Increases your damage with One-Handed Axes by $s1 and gives a 1% chance of reducing enemy armor by 100 for 15 seconds.", description = "Aumenta di $s1 i danni inflitti con le asce a una mano e conferisce una probabilità dell’1% di ridurre di 100 l’armatura del nemico per 15 secondi." },
    -- Rank 228, shared by 4 spell IDs.
    [5449] = { en = "Increases your damage with One-Handed Swords by $s1 and your chance to parry by 3%.", description = "Aumenta di $s1 i danni inflitti con le spade a una mano e del 3% la probabilità di parare." },
    -- Rank 229, shared by 4 spell IDs.
    [5549] = { en = "Increases your damage with One-Handed Maces by $s1 and has a 1% chance of stunning the target for 5 seconds.", description = "Aumenta di $s1 i danni inflitti con le mazze a una mano e conferisce una probabilità dell’1% di stordire il bersaglio per 5 secondi." },
    -- Rank 230, shared by 4 spell IDs.
    [5638] = { en = "Increases your damage with Guns by $s1 and have a 2% chance of stunning the target for 3 seconds.", description = "Aumenta di $s1 i danni inflitti con le armi da fuoco e conferisce una probabilità del 2% di stordire il bersaglio per 3 secondi." },
    -- Rank 231, shared by 4 spell IDs.
    [5751] = { en = "Increases your damage with Bows and by $s1 and has a 2% chance of bleeding the target for 90 damage over 10 seconds.", description = "Aumenta di $s1 i danni inflitti con gli archi e conferisce una probabilità del 2% di far sanguinare il bersaglio, infliggendo 90 danni in 10 secondi." },
    -- Rank 232, shared by 4 spell IDs.
    [5812] = { en = "Increases your chance to Critical Hit with Nature Magic by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con la magia della natura." },
    -- Rank 233, shared by 4 spell IDs.
    [5835] = { en = "Increases your chance to Critical Hit with Fire Magic by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con la magia del fuoco." },
    -- Rank 234, shared by 4 spell IDs.
    [5866] = { en = "Increases your chance to Critical Hit with Frost Magic by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con la magia del gelo." },
    -- Rank 235, shared by 4 spell IDs.
    [5884] = { en = "Reduces an enemy's chance to hit with attacks by $s1% for $d.", description = "Riduce del $s1% la probabilità che un nemico ti colpisca con i suoi attacchi per $d." },
    -- Rank 236, shared by 4 spell IDs.
    [5896] = { en = "Increases your chance to Critical Hit with Shadow Magic by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con la magia dell’ombra." },
    -- Rank 237, shared by 4 spell IDs.
    [5969] = { en = "Increases your damage with Crossbows by $s1.", description = "Aumenta di $s1 i danni inflitti con le balestre." },
    -- Rank 238, shared by 4 spell IDs.
    [7159] = { en = "Inflicts normal damage plus $s1 to an enemy, but only if attacking from behind. ", description = "Infligge a un nemico i danni normali più $s1, ma solo se attacchi alle sue spalle." },
    -- Rank 239, shared by 4 spell IDs.
    [7272] = { en = "Reduces nearby enemies' chance to hit with attacks by $s1% for $d.", description = "Riduce del $s1% la probabilità che i nemici vicini ti colpiscano con i loro attacchi per $d." },
    -- Rank 240, shared by 4 spell IDs.
    [7302] = { en = "Increases Armor by $s1 and frost resistance by $s3.   If an enemy strikes the caster, they may have their movement slowed by $7321s1% and the time between their attacks increased by $7321s2% for $7321d.  Only one type of Armor spell can be active on the Mage at any time.  Lasts $d.", description = "Aumenta l’armatura di $s1 e la resistenza al gelo di $s3. Se un nemico colpisce l’incantatore, il suo movimento può essere rallentato del $7321s1% e il tempo tra i suoi attacchi aumentato del $7321s2% per $7321d. Sul mago può essere attivo un solo incantesimo di armatura alla volta. Dura $d." },
    -- Rank 241, shared by 4 spell IDs.
    [7405] = { en = "Sunders the target's armor, reducing it by $s1 per Sunder Armor and causes a high amount of threat.  Can be applied up to 5 times.  Lasts $d.", description = "Frantuma l’armatura del bersaglio, riducendola di $s1 per ogni applicazione di Sunder Armor e generando molta minaccia. Può accumularsi fino a 5 volte. Dura $d." },
    -- Rank 242, shared by 4 spell IDs.
    [8056] = { en = "Instantly shocks the target with frost, causing $s2 Frost damage and slowing movement speed by $s1%.  Lasts $d.", description = "Colpisce istantaneamente il bersaglio con il gelo, infliggendo $s2 danni da gelo e riducendone la velocità di movimento del $s1%. Dura $d." },
    -- Rank 243, shared by 4 spell IDs.
    [8099] = { en = "Increases the target's Stamina by $s1 for $d.", description = "Aumenta la Tempra del bersaglio di $s1 per $d." },
    -- Rank 244, shared by 4 spell IDs.
    [8115] = { en = "Increases the target's Agility by $s1 for $d.", description = "Aumenta l’Agilità del bersaglio di $s1 per $d." },
    -- Rank 245, shared by 4 spell IDs.
    [8204] = { en = "Blasts nearby enemies with thunder, increasing the time between their attacks by $s2% for $d and doing $s1 damage to them. Will affect up to $i targets.", description = "Colpisce i nemici vicini con un tuono, aumentando del $s2% il tempo tra i loro attacchi per $d e infliggendo loro $s1 danni. Può colpire fino a $i bersagli." },
    -- Rank 246, shared by 4 spell IDs.
    [8492] = { en = "Targets in a cone in front of the caster take ${$m2*$<frostdamage>} to ${$M2*$<frostdamage>}  Frost damage and are slowed by $s1% for $d.", description = "I bersagli nel cono davanti all’incantatore subiscono da ${$m2*$<frostdamage>} a ${$M2*$<frostdamage>} danni da gelo e vengono rallentati del $s1% per $d." },
    -- Rank 247, shared by 4 spell IDs.
    [10651] = { en = "Curses a target by lowering damage done by $m1 for $d", description = "Maledice un bersaglio, riducendo di $m1 i danni inflitti per $d." },
    -- Rank 248, shared by 4 spell IDs.
    [10909] = { en = "Allows the caster to see through the target's eyes for $d.  Will not work if the target is in another instance or on another continent.", description = "Permette all’incantatore di vedere attraverso gli occhi del bersaglio per $d. Non funziona se il bersaglio si trova in un’altra istanza o su un altro continente." },
    -- Rank 249, shared by 4 spell IDs.
    [11390] = { en = "Increases spell damage by up to $s1 for $d.", description = "Aumenta fino a $s1 i danni degli incantesimi per $d." },
    -- Rank 250, shared by 4 spell IDs.
    [13161] = { en = "The hunter takes on the aspects of a beast, becoming untrackable and increasing Melee Attack Power by $s2. Only one Aspect can be active at a time.", description = "Il cacciatore assume gli aspetti di una bestia, diventando impossibile da tracciare e aumentando la potenza d’attacco in mischia di $s2. Puoi avere un solo Aspetto attivo alla volta." },
    -- Rank 251, shared by 4 spell IDs.
    [13665] = { en = "Increases your chance to parry an attack by $s1%.", description = "Aumenta del $s1% la probabilità di parare un attacco." },
    -- Rank 252, shared by 4 spell IDs.
    [14752] = { en = "Holy power infuses the target, increasing their Spirit by $s1 for $d.", description = "La potenza sacra pervade il bersaglio, aumentando il suo Spirito di $s1 per $d." },
    -- Rank 253, shared by 4 spell IDs.
    [15268] = { en = "Gives your Shadow damage spells a $h% chance to stun the target for $15269d.", description = "I tuoi incantesimi che infliggono danni da ombra hanno una probabilità del $h% di stordire il bersaglio per $15269d." },
    -- Rank 254, shared by 4 spell IDs.
    [15496] = { en = "Inflicts weapon damage plus $s1 to an enemy and its nearest ally.", description = "Infligge a un nemico e al suo alleato più vicino i danni dell’arma più $s1." },
    -- Rank 255, shared by 4 spell IDs.
    [18265] = { en = "Transfers $s1 health from the target to the caster every $t1 sec.  Lasts $d.", description = "Trasferisce $s1 salute dal bersaglio all’incantatore ogni $t1 sec. Dura $d." },
    -- Rank 256, shared by 4 spell IDs.
    [18310] = { en = "Increases the speed reduction of your Curse of Exhaustion by $s1%.", description = "Aumenta del $s1% l’effetto rallentante di Curse of Exhaustion." },
    -- Rank 257, shared by 4 spell IDs.
    [18544] = { en = "Increases your spell damage by $s2% and the critical strike chance of your offensive spells by $s1%.", description = "Aumenta del $s2% i danni dei tuoi incantesimi e del $s1% la probabilità di colpo critico degli incantesimi offensivi." },
    -- Rank 258, shared by 4 spell IDs.
    [18985] = { en = "Reduces the hit chance of Silence effects against you by $s1%.", description = "Riduce del $s1% la probabilità che gli effetti di Silenzio ti colpiscano." },
    -- Rank 259, shared by 4 spell IDs.
    [19134] = { en = "Shouts at an enemy, paralyzing it with terror for $d. and causing all other nearby enemies to flee in fear.", description = "Urla contro un nemico, paralizzandolo dal terrore per $d e facendo fuggire impauriti tutti gli altri nemici vicini." },
    -- Rank 260, shared by 4 spell IDs.
    [19306] = { en = "A strike that becomes active after parrying an opponent's attack. This attack deals $s2% weapon damage plus $m1 and immobilizes the target for $d. Counterattack cannot be blocked, dodged, or parried.", description = "Un contrattacco che si attiva dopo aver parato un attacco avversario. Infligge danni pari al $s2% dei danni dell’arma più $m1 e immobilizza il bersaglio per $d. Non può essere bloccato, schivato o parato." },
    -- Rank 261, shared by 4 spell IDs.
    [22780] = { en = "Improves your chance to hit with ranged weapons by ${$s1}.1%.", description = "Aumenta di ${$s1}.1% la probabilità di colpire con le armi a distanza." },
    -- Rank 262, shared by 4 spell IDs.
    [23440] = { en = "Improves your chance to get a critical strike with spells by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con gli incantesimi." },
    -- Rank 263, shared by 4 spell IDs.
    [23480] = { en = "Increases your critical strike chance with spells by $m2% and increases damage done by your Fire spells by up to $s1.", description = "Aumenta del $m2% la probabilità di colpo critico degli incantesimi e fino a $s1 i danni inflitti dagli incantesimi di fuoco." },
    -- Rank 264, shared by 4 spell IDs.
    [23727] = { en = "Improves your chance to hit with spells by ${$s1}.1%.", description = "Aumenta di ${$s1}.1% la probabilità di colpire con gli incantesimi." },
    -- Rank 265, shared by 4 spell IDs.
    [23881] = { en = "Instantly attack the target causing damage equal to $s2% of your Attack Power plus $s1 and increasing your movement speed by $s3% for $d.", description = "Attacca istantaneamente il bersaglio, infliggendo danni pari al $s2% della tua potenza d’attacco più $s1 e aumentando la velocità di movimento del $s3% per $d." },
    -- Rank 266, shared by 4 spell IDs.
    [23922] = { en = "Slam the target with your shield, causing $s2 damage, increased by your Block Value, and has a 50% chance of dispelling $s1 magic effect on the target. Causes a very high amount of threat.", description = "Colpisce il bersaglio con lo scudo, infliggendo $s2 danni aumentati dal tuo valore di blocco. Ha una probabilità del 50% di dissolvere un effetto magico $s1 sul bersaglio. Genera una quantità elevatissima di minaccia." },
    -- Rank 267, shared by 4 spell IDs.
    [23992] = { en = "Increases Fire resistance by $s1.", description = "Aumenta la resistenza al fuoco di $s1." },
    -- Rank 268, shared by 4 spell IDs.
    [24446] = { en = "Increases Frost resistance by $s1.", description = "Aumenta la resistenza al gelo di $s1." },
    -- Rank 269, shared by 4 spell IDs.
    [24488] = { en = "Increases Shadow resistance by $s1.", description = "Aumenta la resistenza all’ombra di $s1." },
    -- Rank 270, shared by 4 spell IDs.
    [24492] = { en = "Increases Nature resistance by $s1.", description = "Aumenta la resistenza alla natura di $s1." },
    -- Rank 271, shared by 4 spell IDs.
    [24493] = { en = "Increases Arcane resistance by $s1.", description = "Aumenta la resistenza arcana di $s1." },
    -- Rank 272, shared by 4 spell IDs.
    [24583] = { en = "Inflicts $o2 Nature damage over $d. Effect can stack up to 5 times on a single target.", description = "Infligge $o2 danni da natura in $d. L’effetto può accumularsi fino a 5 volte sullo stesso bersaglio." },
    -- Rank 273, shared by 4 spell IDs.
    [24597] = { en = "The wolf howls, increasing the melee attack power of all party members within $a1 yards by $s1.  Lasts $d.", description = "Il lupo ulula, aumentando la potenza offensiva in mischia di tutti i membri del gruppo entro $a1 m di $s1. Dura $d." },
    -- Rank 274, shared by 4 spell IDs.
    [25190] = { en = "Charges an enemy, inflicting normal damage plus $s2 ", description = "Carica un nemico, infliggendo danni normali più $s2." },
    -- Rank 275, shared by 4 spell IDs.
    [26090] = { en = "Shakes the ground with thundering force, doing $s1 Nature damage to all enemies within $a1 yards.", description = "Scuote il terreno con una forza tonante, infliggendo $s1 danni da natura a tutti i nemici entro $a1 m." },
    -- Rank 276, shared by 4 spell IDs.
    [28793] = { en = "Increases the friendly target's spell damage and healing by up to $s1 for $d.", description = "Aumenta fino a $s1 i danni e le cure inflitti dagli incantesimi del bersaglio amico per $d." },
    -- Rank 277, shared by 4 spell IDs.
    [366994] = { en = "Deals $s1 Shadow damage every $t1 sec.", description = "Infligge $s1 danni da ombra ogni $t1 sec." },
    -- Rank 278, shared by 4 spell IDs.
    [402261] = { en = "Deals Holy damage every $t2 sec.", description = "Infligge danni sacri ogni $t2 sec." },
    -- Rank 279, shared by 4 spell IDs.
    [402277] = { en = "Healing every $t2 sec for $d.", description = "Cura ogni $t2 sec. per $d." },
    -- Rank 280, shared by 4 spell IDs.
    [407995] = { en = "Bite the target for $s2% normal damage plus $s1.", description = "Morde il bersaglio, infliggendo danni pari al $s2% dei danni normali più $s1." },
    -- Rank 281, shared by 4 spell IDs.
    [460692] = { en = "Calls down a fiery rain to burn enemies in the area of effect for $o1 Fire damage over $d.", description = "Fa piovere fuoco sui nemici nell’area, infliggendo $o1 danni da fuoco in $d." },
    -- Rank 282, shared by 4 spell IDs.
    [1223731] = { en = "Unlocks your potential while inside Naxxramas.  Increasing your damage by ${$m1/100}.2% and your health by ${$m2/100}.2% for each piece of Sanctified armor equipped.", description = "Sblocca il tuo potenziale all’interno di Naxxramas. Aumenta i danni del ${$m1/100}.2% e la salute del ${$m2/100}.2% per ogni pezzo d’armatura Sanctified equipaggiato." },
    -- Rank 283, shared by 4 spell IDs.
    [1232054] = { en = "Combine $s4 Illusion Dust and $s5 Righteous $LOrb:Orbs; at a Mote of Possibility in pursuit of a new discovery.", description = "Combina $s4 Illusion Dust e $s5 Righteous $LOrb:Orbs; presso un Mote of Possibility per tentare una nuova scoperta." },
    -- Rank 284, shared by 4 spell IDs.
    [1250922] = { en = "Drink to increase healing done by spells and effects by up to $s1. Lasts $d.", description = "Bevi per aumentare fino a $s1 le cure fornite dagli incantesimi e dagli effetti. Dura $d." },
    -- Rank 285, shared by 4 spell IDs.
    [1250974] = { en = "Drink to increase your Spirit by $s1. Lasts for $d.", description = "Bevi per aumentare il tuo Spirito di $s1. Dura $d." },
    -- Rank 286, shared by 4 spell IDs.
    [1282398] = { en = "Plant the seed in a Greenhouse to grow it over time.", description = "Pianta il seme in una Greenhouse per farlo crescere nel tempo." },
    -- Rank 287, shared by 4 spell IDs.
    [1286011] = { en = "Summons and dismisses a rideable crane. This is a very fast mount.", description = "Evoca o congeda una gru cavalcabile. È una cavalcatura molto veloce." },
    -- Rank 288, shared by 4 spell IDs.
    [1292683] = { en = "Increases all threat generated by $s1%.", description = "Aumenta del $s1% tutta la minaccia generata." },
    -- Rank 289, shared by 4 spell IDs.
    [1293241] = { en = "Command a hawk to dive-bomb your targeted enemy, dealing ${$s1+($rap*($s4/100))} Physical damage and continuing its assault for $1293248d. Only $s3 hawks can be active at once. Summon Hawk shares its cooldown with Arcane Shot.", description = "Ordina a un falco di piombare sul nemico selezionato, infliggendo ${$s1+($rap*($s4/100))} danni fisici e continuando l’attacco per $1293248d. Puoi avere al massimo $s3 falchi attivi contemporaneamente. Evoca Falco condivide il tempo di recupero con Tiro Arcano." },
    -- Rank 290, shared by 4 spell IDs.
    [1294877] = { en = "Increases your level to $s1 and grants you gear and supplies appropriate to that level for your class and tradeskills.", description = "Ti porta al livello $s1 e ti fornisce equipaggiamento e scorte adeguati a quel livello, alla tua classe e alle tue professioni." },
    -- Rank 291, shared by 4 spell IDs.
    [1298501] = { en = "Decreases all threat generated by $s1%.", description = "Riduce del $s1% tutta la minaccia generata." },
    -- Rank 292, shared by 4 spell IDs.
    [1300943] = { en = "Increased Spirit +$s1", description = "Spirito aumentato: +$s1" },
    -- Rank 293, shared by 4 spell IDs.
    [1309268] = { en = "Summons and dismisses a rideable warden saber.", description = "Evoca o congeda una warden saber cavalcabile." },
    -- Rank 294, shared by 4 spell IDs.
    [1309377] = { en = "Summons and dismisses a rideable moose.", description = "Evoca o congeda un alce cavalcabile." },
    -- Rank 295, shared by 4 spell IDs.
    [1309595] = { en = "A word of dark binding that inflicts $s1 Shadow damage to the target. If your target is not killed by Shadow Word: Death, you take backlash damage equal to $s3% of your maximum health.", description = "Una parola di oscuro vincolo infligge $s1 danni da ombra al bersaglio. Se Shadow Word: Death non uccide il bersaglio, subisci danni di contraccolpo pari al $s3% della tua salute massima." },
    -- Rank 296, shared by 4 spell IDs.
    [1310015] = { en = "Movement speed increased by $s1% in Stranglethorn Vale and Riverglades.", description = "La velocità di movimento aumenta del $s1% in Stranglethorn Vale e Riverglades." },
    -- Rank 297, shared by 4 spell IDs.
    [1318031] = { en = "Thrown attacks blow up on impact, causing $1318031s1 Fire damage to nearby enemies.", description = "Gli attacchi lanciati esplodono all’impatto, infliggendo $1318031s1 danni da fuoco ai nemici vicini." },
    -- Rank 298, shared by 3 spell IDs.
    [128] = { en = "Removes all magic effects from the caster and will absorb $s2 magic damage for $d.", description = "Rimuove tutti gli effetti magici dall’incantatore e assorbe $s2 danni magici per $d." },
    -- Rank 299, shared by 3 spell IDs.
    [130] = { en = "Slows falling speed for $d.", description = "Rallenta la velocità di caduta per $d." },
    -- Rank 300, shared by 3 spell IDs.
    [453] = { en = "Soothes the target, reducing the range at which it will attack you by $s1 yards.  Only affects Humanoid targets level $v or lower.  Lasts $d.", description = "Placa il bersaglio, riducendo di $s1 iarde la distanza alla quale può attaccarti. Funziona solo sugli Umanoidi di livello $v o inferiore. Dura $d." },
    -- Rank 301, shared by 3 spell IDs.
    [474] = { en = "Decreases the target's agility by $s1.", description = "Riduce l’Agilità del bersaglio di $s1." },
    -- Rank 302, shared by 3 spell IDs.
    [700] = { en = "Puts the enemy target to sleep for up to $d.  Any damage caused will awaken the target.  Only one target can be asleep at a time.", description = "Addormenta il bersaglio nemico fino a $d. Qualsiasi danno subito lo risveglia. Puoi addormentare un solo bersaglio alla volta." },
    -- Rank 303, shared by 3 spell IDs.
    [1114] = { en = "Increases your chance to dodge by $s1%.", description = "Aumenta del $s1% la probabilità di schivare." },
    -- Rank 304, shared by 3 spell IDs.
    [2833] = { en = "Permanently increase the Stamina value by $ec2 and armor value by $ec1 of an item worn on the chest, legs, hands or feet. Only usable on items level $ecim and above.", description = "Aumenta permanentemente di $ec2 la Tempra e di $ec1 l’armatura di un oggetto indossato su torso, gambe, mani o piedi. Utilizzabile solo su oggetti di livello $ecim o superiore." },
    -- Rank 305, shared by 3 spell IDs.
    [2878] = { en = "The targeted undead enemy will be compelled to flee for up to $d.  Damage caused may interrupt the effect.  Only one target can be turned at a time.", description = "Costringe il nemico non morto selezionato a fuggire per un massimo di $d. I danni subiti possono interrompere l’effetto. Puoi soggiogare un solo bersaglio alla volta." },
    -- Rank 306, shared by 3 spell IDs.
    [2916] = { en = "Increases your chance to get a critical with a spell by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere un colpo critico con un incantesimo." },
    -- Rank 307, shared by 3 spell IDs.
    [3011] = { en = "Fires a flaming shot at the enemy, doing an additional $s1 and making the damage fire based.", description = "Scaglia un colpo infuocato contro il nemico, infliggendo $s1 danni aggiuntivi e convertendo il danno in danno da fuoco." },
    -- Rank 308, shared by 3 spell IDs.
    [3034] = { en = "Stings the target, draining $o1 mana over $d.  Only one Sting per Hunter can be active on any one target.", description = "Punge il bersaglio, prosciugando $o1 mana in $d. Un cacciatore può mantenere attiva una sola Puntura su ciascun bersaglio." },
    -- Rank 309, shared by 3 spell IDs.
    [3106] = { en = "Inflicts $s1 Nature damage to nearby enemies.", description = "Infligge $s1 danni da natura ai nemici vicini." },
    -- Rank 310, shared by 3 spell IDs.
    [4167] = { en = "Encases the target in sticky webs rendering them unable to move for $d.", description = "Avvolge il bersaglio in ragnatele appiccicose, immobilizzandolo per $d." },
    -- Rank 311, shared by 3 spell IDs.
    [4433] = { en = "Increases your chance to critical with all melee weapons by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere colpi critici con tutte le armi da mischia." },
    -- Rank 312, shared by 3 spell IDs.
    [4915] = { en = "Increases your chance to critical with Bows by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere colpi critici con gli archi." },
    -- Rank 313, shared by 3 spell IDs.
    [5466] = { en = "Increases your chance to get a critical with Two-Handed Axes by $s1%.", description = "Aumenta di $s1 la probabilità di infliggere un colpo critico con le asce a due mani." },
    -- Rank 314, shared by 3 spell IDs.
    [5527] = { en = "Increases your chance to get a critical hit with Two-Handed Maces by $s1%.", description = "Aumenta di $s1 la probabilità di infliggere un colpo critico con le mazze a due mani." },
    -- Rank 315, shared by 3 spell IDs.
    [5545] = { en = "Increases your chance to get a critical hit with One-Handed Maces by $s1%.", description = "Aumenta di $s1 la probabilità di infliggere un colpo critico con le mazze a una mano." },
    -- Rank 316, shared by 3 spell IDs.
    [5715] = { en = "Increases your chance to get a critical with Staves by $s1%.", description = "Aumenta di $s1 la probabilità di infliggere un colpo critico con i bastoni." },
    -- Rank 317, shared by 3 spell IDs.
    [5816] = { en = "Decreases your mana cost to cast Nature spells by $s1.", description = "Riduce di $s1 il costo in mana degli incantesimi della natura." },
    -- Rank 318, shared by 3 spell IDs.
    [5834] = { en = "Decreases your mana cost to cast Fire spells by $s1.", description = "Riduce di $s1 il costo in mana degli incantesimi del fuoco." },
    -- Rank 319, shared by 3 spell IDs.
    [5927] = { en = "Decreases your mana cost to cast Holy spells by $s1.", description = "Riduce di $s1 il costo in mana degli incantesimi sacri." },
    -- Rank 320, shared by 3 spell IDs.
    [5970] = { en = "Increases your chance to critical with Crossbows by $s1%.", description = "Aumenta del $s1% la probabilità di infliggere colpi critici con le balestre." },
    -- Rank 321, shared by 3 spell IDs.
    [6094] = { en = "Increases your chance to get a critical with Wands by $s1%.", description = "Aumenta di $s1 la probabilità di infliggere un colpo critico con le bacchette." },
    -- Rank 322, shared by 3 spell IDs.
    [6117] = { en = "Increases your resistance to all magic by $s1 and allows $s2% of your mana regeneration to continue while casting.  Only one type of Armor spell can be active on the Mage at any time.  Lasts $d.", description = "Aumenta di $s1 la resistenza a tutte le magie e permette al $s2% della rigenerazione del mana di continuare durante il lancio degli incantesimi. Sul mago può essere attivo un solo incantesimo di armatura alla volta. Dura $d." },
    -- Rank 323, shared by 3 spell IDs.
    [7887] = { en = "Instantly overpower the enemy, causing weapon damage plus $s1.  Only useable after the target dodges.  The Overpower cannot be blocked, dodged or parried.", description = "Sopraffà istantaneamente il nemico, infliggendo i danni dell’arma più $s1. Usabile solo dopo che il bersaglio ha schivato. Sopraffazione non può essere bloccata, schivata o parata." },
    -- Rank 324, shared by 3 spell IDs.
    [8258] = { en = "Gives $s1 additional armor to nearby party members for $d. Players may only have one aura on them per paladin at any one time.", description = "Fornisce $s1 armatura aggiuntiva ai membri del gruppo vicini per $d. Ogni paladino può avere una sola aura attiva su ciascun giocatore." },
    -- Rank 325, shared by 3 spell IDs.
    [8516] = { en = "Attack Power increased by $s1. Granted $s2 Extra Attack.", description = "Potenza d’attacco aumentata di $s1. Conferisce $s2 attacco aggiuntivo." },
    -- Rank 326, shared by 3 spell IDs.
    [9827] = { en = "Pounce, stunning the target for $d and causing $9826o1 damage over $9826d.  Must be prowling and behind the target.  Awards $s3 combo $lpoint:points;.", description = "Si avventa sul bersaglio, stordendolo per $d e infliggendo $9826o1 danni in $9826d. Devi essere in agguato e alle spalle del bersaglio. Assegna $s3 $lpoint:points; combo." },
    -- Rank 327, shared by 3 spell IDs.
    [11554] = { en = "Reduces the melee attack power of all enemies within $a1 yards by $s1 for $d.", description = "Riduce la potenza offensiva in mischia di tutti i nemici entro $a1 m di $s1 per $d." },
    -- Rank 328, shared by 3 spell IDs.
    [11974] = { en = "Wraps an ally in a shield that lasts up to $d., absorbing a maximum of $s1 Physical or magical damage. While the shield holds, spells will not be interrupted by Physical attacks.", description = "Avvolge un alleato in uno scudo che dura fino a $d e assorbe un massimo di $s1 danni fisici o magici. Finché lo scudo regge, gli attacchi fisici non interrompono gli incantesimi." },
    -- Rank 329, shared by 3 spell IDs.
    [12021] = { en = "Causes an enemy to fixate upon the caster and increases the caster's attack speed by $s2% for $d. While the target is fixated upon the caster, the target is very reluctant to attack anything else.", description = "Costringe un nemico a concentrarsi sull’incantatore e ne aumenta la velocità d’attacco del $s2% per $d. Finché è concentrato sull’incantatore, il bersaglio è molto riluttante ad attaccare chiunque altro." },
    -- Rank 330, shared by 3 spell IDs.
    [12418] = { en = "Increases your effective stealth detection level by ${$s1/5}.", description = "Aumenta il tuo livello effettivo di individuazione delle unità furtive di ${$s1/5}." },
    -- Rank 331, shared by 3 spell IDs.
    [13486] = { en = "Wounds the target for $s1 Physical damage.", description = "Ferisce il bersaglio, infliggendo $s1 danni fisici." },
    -- Rank 332, shared by 3 spell IDs.
    [13898] = { en = "Permanently enchant a melee weapon to often strike for $13897s1 additional fire damage.", description = "Incanta permanentemente un’arma da mischia affinché colpisca spesso infliggendo $13897s1 danni da fuoco aggiuntivi." },
    -- Rank 333, shared by 3 spell IDs.
    [14076] = { en = "Gives you a $s1% chance to return to stealth mode after using your Sap ability.", description = "Conferisce una probabilità del $s1% di tornare furtivo dopo aver usato Sap." },
    -- Rank 334, shared by 3 spell IDs.
    [16833] = { en = "Reduces the mana cost of all shapeshifting by $s1%.", description = "Riduce del $s1% il costo in mana di tutte le trasformazioni." },
    -- Rank 335, shared by 3 spell IDs.
    [16836] = { en = "Increases damage caused by your Thorns spell by $s1%.", description = "Aumenta del $s1% i danni inflitti dall’incantesimo Spine." },
    -- Rank 336, shared by 3 spell IDs.
    [18179] = { en = "Increases the effect of your Curse of Weakness by $s1%.", description = "Aumenta del $s1% l’effetto di Curse of Weakness." },
    -- Rank 337, shared by 3 spell IDs.
    [18229] = { en = "Restores $o1 health over $d.   Must remain seated while eating.   Also increases your Stamina by $18191s for $18191d.", description = "Ripristina $o1 salute in $d. Devi restare seduto mentre mangi. Aumenta inoltre la tua Tempra di $18191s per $18191d." },
    -- Rank 338, shared by 3 spell IDs.
    [18501] = { en = "Increases the Physical damage dealt by the caster by $s1 and speeds its attacks by $s2% for $d.", description = "Aumenta di $s1 i danni fisici inflitti dall’incantatore e del $s2% la sua velocità d’attacco per $d." },
    -- Rank 339, shared by 3 spell IDs.
    [19151] = { en = "Increases all damage caused against Humanoid targets by $s1% and increases critical damage caused against Humanoid targets by an additional $s2%.", description = "Aumenta del $s1% tutti i danni inflitti agli Umanoidi e di un ulteriore $s2% i danni critici contro gli Umanoidi." },
    -- Rank 340, shared by 3 spell IDs.
    [19736] = { en = "Purges $s1 harmful magic $leffect:effects; from a friend or $s1 beneficial magic $leffect:effects; from an enemy.  If an effect is devoured, the Felhunter will be healed for $19735s1.", description = "Rimuove da un alleato $s1 effetti magici dannosi $leffect:effects; oppure da un nemico $s1 effetti magici benefici $leffect:effects;. Se divora un effetto, il Vilsegugio viene curato di $19735s1." },
    -- Rank 341, shared by 3 spell IDs.
    [19876] = { en = "Gives $s1 additional Shadow resistance to all party and raid members within $a1 yards. Players may only have one Aura on them per Paladin at any one time.", description = "Fornisce $s1 resistenza all’ombra aggiuntiva a tutti i membri del gruppo e dell’incursione entro $a1 m. Ogni paladino può avere una sola Aura attiva su ciascun giocatore." },
    -- Rank 342, shared by 3 spell IDs.
    [19888] = { en = "Gives $s1 additional Frost resistance to all party and raid members within $a1 yards. Players may only have one Aura on them per Paladin at any one time.", description = "Fornisce $s1 resistenza al gelo aggiuntiva a tutti i membri del gruppo e dell’incursione entro $a1 m. Ogni paladino può avere una sola Aura attiva su ciascun giocatore." },
    -- Rank 343, shared by 3 spell IDs.
    [19891] = { en = "Gives $s1 additional Fire resistance to all party and raid members within $a1 yards. Players may only have one Aura on them per Paladin at any one time.", description = "Fornisce $s1 resistenza al fuoco aggiuntiva a tutti i membri del gruppo e dell’incursione entro $a1 m. Ogni paladino può avere una sola Aura attiva su ciascun giocatore." },
    -- Rank 344, shared by 3 spell IDs.
    [19977] = { en = "Places a Blessing on the friendly target, increasing the effects of Holy Light spells used on the target by up to $s1 and the effect Flash of Light spells used on the target by up to $s2.  Lasts $d.  Players may only have one Blessing on them per Paladin at any one time.", description = "Applica una Benedizione al bersaglio amico, aumentando fino a $s1 gli effetti degli incantesimi Holy Light lanciati sul bersaglio e fino a $s2 quelli degli incantesimi Flash of Light. Dura $d. Ogni paladino può avere una sola Benedizione attiva su ciascun giocatore." },
    -- Rank 345, shared by 3 spell IDs.
    [20249] = { en = "Increases the critical effect chance of your Flash of Light spell by $s1%.", description = "Aumenta del $s1% la probabilità di colpo critico dell’incantesimo Flash of Light." },
    -- Rank 346, shared by 3 spell IDs.
    [20335] = { en = "Increases the melee attack power bonus of your Seal of the Crusader and the Holy damage increase of your Judgement of the Crusader by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco di Seal of the Crusader e l’aumento dei danni sacri di Judgement of the Crusader." },
    -- Rank 347, shared by 3 spell IDs.
    [22188] = { en = "Increased Crossbows +$s1.", description = "Abilità con le balestre aumentata di +$s1." },
    -- Rank 348, shared by 3 spell IDs.
    [23162] = { en = "Decreases Defense by $s1 for $d.  This decrease increases the chance attacks will Hit and Critical the target and reduces the chance the target will Block, Dodge, or Parry the attack.", description = "Riduce di $s1 la Difesa per $d. Questo riduce la probabilità che gli attacchi colpiscano o infliggano colpi critici al bersaglio e la probabilità che il bersaglio blocchi, schivi o pari gli attacchi." },
    -- Rank 349, shared by 3 spell IDs.
    [23796] = { en = "Increases healing done by spells and effects by up to $s1 and damage done by up to $s2.", description = "Aumenta fino a $s1 le cure e fino a $s2 i danni inflitti dagli incantesimi e dagli effetti." },
    -- Rank 350, shared by 3 spell IDs.
    [24423] = { en = "Blasts a single enemy for $s1 damage and lowers the melee attack power of all enemies in melee range by $s2 for $d.", description = "Colpisce un singolo nemico infliggendo $s1 danni e riduce di $s2 per $d la potenza d’attacco in mischia di tutti i nemici a portata." },
    -- Rank 351, shared by 3 spell IDs.
    [24433] = { en = "Increases the critical hit chance of Wrath and Starfire by $s1%.", description = "Aumenta del $s1% la probabilità di colpo critico di Wrath e Starfire." },
    -- Rank 352, shared by 3 spell IDs.
    [25113] = { en = "Increases damage and healing done by magical spells and effects by up to $s1.   Also increases chance to get a critical hit with spells by $s3%.", description = "Aumenta fino a $s1 i danni e le cure inflitti dagli incantesimi e dagli effetti magici. Aumenta inoltre del $s3% la probabilità di colpo critico degli incantesimi." },
    -- Rank 353, shared by 3 spell IDs.
    [25717] = { en = "Decreases the fire resistance of your spell targets by $s1.", description = "Riduce di $s1 la resistenza al fuoco dei bersagli dei tuoi incantesimi." },
    -- Rank 354, shared by 3 spell IDs.
    [26400] = { en = "Reduces the threat you generate by $s1% for $d.", description = "Riduce del $s1% la minaccia che generi per $d." },
    -- Rank 355, shared by 3 spell IDs.
    [27723] = { en = "Improves your chance to hit with attacks by $s1% for $d.", description = "Aumenta del $s1% la probabilità di colpire con gli attacchi per $d." },
    -- Rank 356, shared by 3 spell IDs.
    [28531] = { en = "Deals $s1 frost damage a second.", description = "Infligge $s1 danni da gelo al secondo." },
    -- Rank 357, shared by 3 spell IDs.
    [368218] = { en = "Consecrates the land beneath Paladin, doing $o1 Holy damage over $d to enemies who enter the area.", description = "Consacra il terreno sotto il paladino, infliggendo $o1 danni sacri in $d ai nemici che entrano nell’area." },
    -- Rank 358, shared by 3 spell IDs.
    [370538] = { en = "Teleport player to Ahn'Qiraj.", description = "Teletrasporta il giocatore ad Ahn’Qiraj." },
    -- Rank 359, shared by 3 spell IDs.
    [401502] = { en = "Launches a bolt of frostfire at the enemy, causing $s2 Frostfire damage, slowing movement speed by $s1% and causing an additional $o3 Frostfire damage over $d. This spell will be checked against the lower of the target's Frost and Fire resists and counts as both Frost and Fire damage.", description = "Scaglia un dardo di fuocogelo contro il nemico, infliggendo $s2 danni da fuocogelo, riducendone la velocità di movimento del $s1% e infliggendo altri $o3 danni da fuocogelo in $d. L’incantesimo usa la resistenza più bassa tra gelo e fuoco del bersaglio e conta sia come danno da gelo sia come danno da fuoco." },
    -- Rank 360, shared by 3 spell IDs.
    [401859] = { en = "Places a spell on the target that heals them for ${($m1+($bh*$bc))*$<mult>} the next time they take damage or receive non-periodic healing. When the heal occurs, Prayer of Mending jumps to a party or raid member within $401880a1 yards. Jumps up to $s2 times and lasts $401877d after each jump. This spell can only be placed on one target at a time per caster.", description = "Applica un incantesimo al bersaglio che lo cura di ${($m1+($bh*$bc))*$<mult>} la prossima volta che subisce danni o riceve una cura non periodica. Quando avviene la cura, Prayer of Mending salta a un membro del gruppo o dell’incursione entro $401880a1 m. Può saltare fino a $s2 volte e dura $401877d dopo ogni salto. Ogni incantatore può applicare questo incantesimo a un solo bersaglio alla volta." },
    -- Rank 361, shared by 3 spell IDs.
    [401863] = { en = "Places a spell on the target that heals them the next time they take damage.  When the heal occurs, Prayer of Mending jumps to a party or raid member within $41635a1 yards. Jumps up to $48113n times and lasts $48111d after each jump. This spell can only be placed on one target at a time.\r\n", description = "Applica un incantesimo al bersaglio che lo cura la prossima volta che subisce danni. Quando avviene la cura, Prayer of Mending salta a un membro del gruppo o dell’incursione entro $41635a1 m. Può saltare fino a $48113n volte e dura $48111d dopo ogni salto. Può essere applicato a un solo bersaglio alla volta." },
    -- Rank 362, shared by 3 spell IDs.
    [401877] = { en = "Places a spell on the target that heals them the next time they take damage or receive healing.  When the heal occurs, Prayer of Mending jumps to a party or raid member within $a1 yards.  Jumps up to $n times and lasts $d after each jump.  This spell can only be placed on one target at a time.", description = "Applica un incantesimo al bersaglio che lo cura la prossima volta che subisce danni o riceve una cura. Quando avviene la cura, Prayer of Mending salta a un membro del gruppo o dell’incursione entro $a1 m. Può saltare fino a $n volte e dura $d dopo ogni salto. Può essere applicato a un solo bersaglio alla volta." },
    -- Rank 363, shared by 3 spell IDs.
    [403501] = { en = "Send a ghostly soul to assault your current target, dealing $s1 damage, and increasing all Shadow damage over time you deal to that target by $s2% for $d. When Haunt expires for any reason you will be healed for $s3% of the damage it dealt to your target.", description = "Invia un’anima spettrale ad assalire il bersaglio attuale, infliggendo $s1 danni e aumentando del $s2% per $d tutti i danni da ombra periodici che gli infliggi. Quando Haunt termina per qualsiasi motivo, recuperi salute pari al $s3% dei danni inflitti al bersaglio." },
    -- Rank 364, shared by 3 spell IDs.
    [408120] = { en = "Heals the target and their party for $o1 over $d. Party members must be within $a1 yards of target. The amount healed is applied quickly at first, and slows down as Wild Growth reaches its full duration.", description = "Cura il bersaglio e i membri del suo gruppo di $o1 in $d. I membri del gruppo devono trovarsi entro $a1 m dal bersaglio. Le cure vengono applicate rapidamente all’inizio e rallentano man mano che Wild Growth raggiunge la durata massima." },
    -- Rank 365, shared by 3 spell IDs.
    [408490] = { en = "You hurl molten lava at the target, dealing $s1 Fire damage. If your Flame Shock is on the target, Lava Burst deals $s2% increased damage.", description = "Scagli lava fusa contro il bersaglio, infliggendo $s1 danni da fuoco. Se il bersaglio è affetto da Flame Shock, Lava Burst infligge il $s2% di danni aggiuntivi." },
    -- Rank 366, shared by 3 spell IDs.
    [408491] = { en = "You hurl molten lava at the target, dealing $s1 Fire damage. If your Flame Shock is on the target, Lava Burst deals $408490s2% increased damage.", description = "Scagli lava fusa contro il bersaglio, infliggendo $s1 danni da fuoco. Se il bersaglio è affetto da Flame Shock, Lava Burst infligge il $408490s2% di danni aggiuntivi." },
    -- Rank 367, shared by 3 spell IDs.
    [408521] = { en = "Heals a friendly target for $s1, an additional $o2 over $d, and increases the effectiveness of your Chain Heal casts directly on that target by $s3%.", description = "Cura un bersaglio amico di $s1 e di altri $o2 in $d. Inoltre, aumenta del $s3% l’efficacia dei lanci di Chain Heal diretti a quel bersaglio." },
    -- Rank 368, shared by 3 spell IDs.
    [412758] = { en = "Deals $s1 Fire damage to your target and an additional $m2% damage if the target is afflicted by Immolate.", description = "Infligge $s1 danni da fuoco al bersaglio e il $m2% di danni aggiuntivi se è affetto da Immolate." },
    -- Rank 369, shared by 3 spell IDs.
    [414644] = { en = "Lacerates the enemy target, making them bleed for $o1 damage over $d plus $s2% weapon damage per existing application of Lacerate on the target. Causes a high amount of threat. This effect stacks up to $u times on the same target.", description = "Lacera il bersaglio nemico, facendolo sanguinare per $o1 danni in $d, più danni pari al $s2% dei danni dell’arma per ogni applicazione di Lacerate già presente sul bersaglio. Genera molta minaccia. L’effetto si accumula fino a $u volte sullo stesso bersaglio." },
    -- Rank 370, shared by 3 spell IDs.
    [427717] = { en = "Shadow energy slowly destroys the target, causing $o1 damage over $d. In addition, if the Unstable Affliction is dispelled it will cause ${$m1*$m3/100} damage to the dispeller and silence them for $427719d. Only one Unstable Affliction or Immolate per Warlock can be active on any one target.", description = "L’energia d’ombra distrugge lentamente il bersaglio, infliggendo $o1 danni in $d. Se Unstable Affliction viene dissolta, infligge ${$m1*$m3/100} danni a chi l’ha dissolta e lo silenzia per $427719d. Ogni stregone può mantenere attivo un solo effetto tra Unstable Affliction e Immolate su ciascun bersaglio." },
    -- Rank 371, shared by 3 spell IDs.
    [437809] = { en = "Consumes the target in holy flames that cause $s1 Holy damage and an additional $s2 Holy damage every $t2 sec for $d.", description = "Avvolge il bersaglio in fiamme sacre, infliggendo $s1 danni sacri e altri $s2 danni sacri ogni $t2 sec. per $d." },
    -- Rank 372, shared by 3 spell IDs.
    [449970] = { en = "Gives you a $h% chance to get an extra attack on the same target after dealing damage with your weapon.", description = "Dopo aver inflitto danni con un’arma, hai una probabilità del $h% di sferrare un attacco aggiuntivo contro lo stesso bersaglio." },
    -- Rank 373, shared by 3 spell IDs.
    [458436] = { en = "A vicious strike that deals $s2% weapon damage and causes the target to Bleed for ${$m3/100*8*$AP} Physical damage over $d.", description = "Un colpo feroce che infligge danni pari al $s2% dei danni dell’arma e fa sanguinare il bersaglio, infliggendo ${$m3/100*8*$AP} danni fisici in $d." },
    -- Rank 374, shared by 3 spell IDs.
    [467280] = { en = "Creates a cloud of lightning that lasts $d., blasting all enemies in a selected area for $s1  Nature damage and inflicting $s2 additional damage every $t2 sec.", description = "Crea una nube di fulmini che dura $d. Colpisce tutti i nemici nell’area selezionata, infliggendo $s1 danni da natura e altri $s2 danni ogni $t2 sec." },
    -- Rank 375, shared by 3 spell IDs.
    [474126] = { en = "Increases damage done by spells and effects by up to $s1.", description = "Aumenta fino a $s1 i danni inflitti dagli incantesimi e dagli effetti." },
    -- Rank 376, shared by 3 spell IDs.
    [1214451] = { en = "Reduces damage inflicted to all nearby Spirits by $s1%.", description = "Riduce del $s1% i danni inflitti a tutti gli Spiriti vicini." },
    -- Rank 377, shared by 3 spell IDs.
    [1217206] = { en = "Attaches a permanent scope to a bow or gun that increases its damage by 10.", description = "Applica permanentemente un mirino a un arco o a un fucile, aumentandone i danni di 10." },
    -- Rank 378, shared by 3 spell IDs.
    [1231556] = { en = "Duplicity and Deception's extra attacks now trigger $s1 extra attacks.", description = "Gli attacchi aggiuntivi di Duplicity and Deception ora attivano $s1 attacchi aggiuntivi." },
    -- Rank 379, shared by 3 spell IDs.
    [1231618] = { en = "Inflicts $s1% weapon damage and sets the target ablaze, dealing Radiant damage over $d.", description = "Infligge danni pari al $s1% dei danni dell’arma e incendia il bersaglio, infliggendo danni radianti in $d." },
    -- Rank 380, shared by 3 spell IDs.
    [1231657] = { en = "Mind Flay's, Fire Blast's, and Drain Life's ranges are increased by $s1 yards, but Mind Flay no longer slows enemies.", description = "Aumenta di $s1 m la portata di Mind Flay, Fire Blast e Drain Life, ma Mind Flay non rallenta più i nemici." },
    -- Rank 381, shared by 3 spell IDs.
    [1233815] = { en = "Load yourself into a cannon. Seems safe enough.", description = "Caricati in un cannone. Sembra abbastanza sicuro." },
    -- Rank 382, shared by 3 spell IDs.
    [1237162] = { en = "Increases your spell haste by $m2% and increases damage done by your Shadow spells by up to $s1.", description = "Aumenta del $m2% la celerità degli incantesimi e fino a $s1 i danni inflitti dagli incantesimi d’ombra." },
    -- Rank 383, shared by 3 spell IDs.
    [1250942] = { en = "Drink to regenerate $s1 mana every 5 seconds. Lasts for $d.", description = "Bevi per rigenerare $s1 mana ogni 5 secondi. Dura $d." },
    -- Rank 384, shared by 3 spell IDs.
    [1254748] = { en = "Permanently increase the Attack Power value by $ec2 and armor value by $ec1 of an item worn on the chest, legs, hands or feet. Only usable on items level $ecim and above.", description = "Aumenta permanentemente il valore di Potenza d’attacco di $ec2 e l’armatura di $ec1 di un oggetto indossato su torso, gambe, mani o piedi. Utilizzabile solo su oggetti di livello $ecim o superiore." },
    -- Rank 385, shared by 3 spell IDs.
    [1254750] = { en = "Permanently increase the Spell Power value by $ec2 and armor value by $ec1 of an item worn on the chest, legs, hands or feet. Only usable on items level $ecim and above.", description = "Aumenta permanentemente il valore di Potenza magica di $ec2 e l’armatura di $ec1 di un oggetto indossato su torso, gambe, mani o piedi. Utilizzabile solo su oggetti di livello $ecim o superiore." },
    -- Rank 386, shared by 3 spell IDs.
    [1259416] = { en = "Glide downward through the air for $d while controlling your direction of travel.", description = "Planando, scendi lentamente nell’aria per $d e controlli la direzione di movimento." },
    -- Rank 387, shared by 3 spell IDs.
    [1269555] = { en = "Attempts to sunder the soul of a nearby enemy. When the Phantasm is dispelled it will cause damage to the dispeller and summon a Phantasm at the targets location that travels toward the caster.", description = "Tenta di lacerare l’anima di un nemico vicino. Quando il Fantasma viene dissolto, infligge danni a chi lo dissolve ed evoca un Fantasma nella posizione del bersaglio, che si dirige verso l’incantatore." },
    -- Rank 388, shared by 3 spell IDs.
    [1279523] = { en = "Cure a sickly animal afflicted by fel taint.", description = "Cura un animale malato, contaminato dall’energia vile." },
    -- Rank 389, shared by 3 spell IDs.
    [1292546] = { en = "Reduces the duration of all movement impairing effects on you by $m2%.", description = "Riduce del $m2% la durata di tutti gli effetti che limitano il movimento." },
    -- Rank 390, shared by 3 spell IDs.
    [1293248] = { en = "Summons a hawk.", description = "Evoca un falco." },
    -- Rank 391, shared by 3 spell IDs.
    [1294786] = { en = "Reduces the hit chance of Charm effects against you by $s1%.", description = "Riduce del $s1% la probabilità che gli effetti di Ammaliamento ti colpiscano." },
    -- Rank 392, shared by 3 spell IDs.
    [1298856] = { en = "Sling the Explosive Runeshard at a target location, signalling Maerion to attack.", description = "Scaglia la Scheggia Runica Esplosiva verso un punto, segnalando a Maerion di attaccare." },
    -- Rank 394, shared by 3 spell IDs.
    [1301076] = { en = "Reduces the chance for your melee attacks to be Dodged or Parried by ${$m1/10}.1%.", description = "Riduce di ${$m1/10}.1% la probabilità che i tuoi attacchi in mischia vengano schivati o parati." },
    -- Rank 395, shared by 3 spell IDs.
    [1306650] = { en = "Reduces the Mana cost of spells by $s1%.", description = "Riduce del $s1% il costo in mana degli incantesimi." },
    -- Rank 396, shared by 3 spell IDs.
    [1310687] = { en = "A steady snipe that increases ranged damage by $s1.", description = "Un colpo di precisione che aumenta di $s1 i danni a distanza." },
    -- Rank 397, shared by 3 spell IDs.
    [1310912] = { en = "Activated by Holy Shock. Heals the target and their party for $s1. Party members must be within $a1 yards of target.", description = "Si attiva con Shock Sacro. Cura il bersaglio e i membri del suo gruppo di $s1. Devono trovarsi entro $a1 m dal bersaglio." },
    -- Rank 398, shared by 3 spell IDs.
    [1315972] = { en = "Stuns target and yourself for $d. Ogres are Stunned for $1317450d and refund $1317450s2% of the cooldown.", description = "Stordisce il bersaglio e te per $d. Gli Ogre restano storditi per $1317450d e recuperano il $1317450s2% del tempo di recupero." },
    -- Rank 399, shared by 2 spell IDs.
    [87] = { en = "Attack speed increased by $s1%\r\nMovement speed increased by $s2%", description = "Velocità d’attacco aumentata del $s1%\r\nVelocità di movimento aumentata del $s2%" },
    -- Rank 400, shared by 2 spell IDs.
    [1038] = { en = "Places a Blessing on the party member, reducing the amount of all threat generated by $s1% for $d.  Players may only have one Blessing on them per Paladin at any one time.", description = "Applica una Benedizione al membro del gruppo, riducendo del $s1% per $d tutta la minaccia generata. Ogni paladino può avere una sola Benedizione attiva su ciascun giocatore." },
}

for id, description in pairs(verifiedSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
end
