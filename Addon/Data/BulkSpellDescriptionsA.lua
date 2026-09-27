-- Source: installed Forever beta Spell.db2 extraction, Spell.json Description_lang (enUS present; itIT blank).
-- IDs are limited to 1-30000 and checked against existing Addon/Data ID tables.
-- This batch contains token-free descriptions; English source spacing and wording are preserved exactly.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
local verifiedSpellDescriptions = {
    -- Spell.db2 ID 379, Description_lang.
    [379] = { en = "Protects the target with an earthen shield, giving a chance of ignoring spell interruption when damaged and causing attacks to heal the shielded target.  This effect can only occur once every few seconds.  Limited charges. Earth Shield can only be placed on one target at a time and only one Elemental Shield can be active on a target at a time.", description = "Protegge il bersaglio con uno scudo terrestre, dando la possibilità di evitare l’interruzione degli incantesimi quando subisce danni e facendo sì che gli attacchi curino il bersaglio protetto. Questo effetto può attivarsi solo una volta ogni pochi secondi. Cariche limitate. Scudo di Terra può essere applicato a un solo bersaglio alla volta e su un bersaglio può essere attivo un solo Scudo Elementale." },
    -- Spell.db2 ID 455, Description_lang.
    [455] = { en = "Restore target's mana.", description = "Ripristina il mana del bersaglio." },
    -- Spell.db2 ID 468, Description_lang.
    [468] = { en = "Summons and dismisses a rideable white stallion.", description = "Evoca e congeda la cavalcatura Stallone Bianco." },
    -- Spell.db2 ID 470, Description_lang.
    [470] = { en = "Summons and dismisses a rideable black stallion.", description = "Evoca e congeda la cavalcatura Stallone Nero." },
    -- Spell.db2 ID 471, Description_lang.
    [471] = { en = "Summons and dismisses a rideable palomino.", description = "Evoca e congeda la cavalcatura palomino." },
    -- Spell.db2 ID 472, Description_lang.
    [472] = { en = "Summons and dismisses a rideable pinto.", description = "Evoca e congeda la cavalcatura pinto." },
    -- Spell.db2 ID 595, Description_lang.
    [595] = { en = "Increase party's armor until duration expires or the priest stops praying.", description = "Aumenta l’armatura del gruppo finché l’effetto non termina o il sacerdote non smette di pregare." },
    -- Spell.db2 ID 713, Description_lang.
    [713] = { en = "Summons an Incubus under the command of the Warlock.", description = "Evoca un Incubus al servizio dello Stregone." },
    -- Spell.db2 ID 820, Description_lang.
    [820] = { en = "Restores 6 health per minute.", description = "Ripristina 6 punti salute al minuto." },
    -- Spell.db2 ID 821, Description_lang.
    [821] = { en = "Restores 6 mana per minute.", description = "Ripristina 6 punti mana al minuto." },
    -- Spell.db2 ID 850, Description_lang.
    [850] = { en = "Pummel (Learn).", description = "Apprendi l’abilità Pummel." },
    -- Spell.db2 ID 994, Description_lang.
    [994] = { en = "Increase party's armor until duration expires or the priest stops praying.", description = "Aumenta l’armatura del gruppo finché l’effetto non termina o il sacerdote non smette di pregare." },
    -- Spell.db2 ID 1009, Description_lang.
    [1009] = { en = "Pummels an enemy.", description = "Colpisce un nemico con un pugno." },
    -- Spell.db2 ID 1012, Description_lang.
    [1012] = { en = "Increases your attack rating with Swords by 3.", description = "Aumenta di 3 la valutazione di attacco con le spade." },
    -- Spell.db2 ID 1054, Description_lang.
    [1054] = { en = "Enchants a weapon with fire.", description = "Incanta un’arma con il fuoco." },
    -- Spell.db2 ID 1183, Description_lang.
    [1183] = { en = "Restores 36 health per minute.", description = "Ripristina 36 punti salute al minuto." },
    -- Spell.db2 ID 1299, Description_lang.
    [1299] = { en = "Increase Frost resistance by 4.", description = "Aumenta di 4 la resistenza al gelo." },
    -- Spell.db2 ID 1462, Description_lang.
    [1462] = { en = "Gather information about the target beast.  The tooltip will display damage, health, armor, any special resistances, and diet.", description = "Raccoglie informazioni sulla bestia bersaglio. La descrizione mostra i danni, la salute, l’armatura, le eventuali resistenze speciali e la dieta." },
    -- Spell.db2 ID 1599, Description_lang.
    [1599] = { en = "Increase Fire resistance by 4.", description = "Aumenta di 4 la resistenza al fuoco." },
    -- Spell.db2 ID 1742, Description_lang.
    [1742] = { en = "Cower, causing no damage but lowering your threat, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 1753, Description_lang.
    [1753] = { en = "Cower, causing no damage but lowering your threat, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 1754, Description_lang.
    [1754] = { en = "Cower, causing no damage but lowering your threat, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 1755, Description_lang.
    [1755] = { en = "Cower, causing no damage but lowering your threat, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 1756, Description_lang.
    [1756] = { en = "Cower, causing no damage but lowering your threat, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 1842, Description_lang.
    [1842] = { en = "Sneak up on the trap in order to disarm it.  Don't get too close or the trap will go off.", description = "Ti avvicini furtivamente alla trappola per disarmarla. Non avvicinarti troppo o scatterà." },
    -- Spell.db2 ID 1966, Description_lang.
    [1966] = { en = "Performs a feint, causing no damage but lowering your threat by a small amount, making the enemy less likely to attack you.", description = "Fingi un attacco senza infliggere danni e riduci leggermente la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 2117, Description_lang.
    [2117] = { en = "Increases your chance to parry by 3%.", description = "Aumenta del 3% la probabilità di parare." },
    -- Spell.db2 ID 2259, Description_lang.
    [2259] = { en = "Allows an alchemist to brew basic potions up to a maximum potential skill of 75.  Requires Herbs found with the Herbalism skill.", description = "Permette a un alchimista di preparare pozioni semplici, fino a un livello massimo di abilità pari a 75. Richiede erbe raccolte con Erbalismo." },
    -- Spell.db2 ID 2383, Description_lang.
    [2383] = { en = "Nearby herb bushes appear on the minimap.   Only one type of thing can be tracked at a time.", description = "Mostra sulla minimappa i cespugli di erbe nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 2580, Description_lang.
    [2580] = { en = "Nearby mineral veins appear on the minimap.   Only one type of thing can be tracked at a time.", description = "Mostra sulla minimappa i filoni di minerali nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 2649, Description_lang.
    [2649] = { en = "Taunt the target, increasing the likelihood the creature will focus attacks on you.", description = "Provoca il bersaglio, aumentando la probabilità che la creatura concentri i suoi attacchi su di te." },
    -- Spell.db2 ID 2828, Description_lang.
    [2828] = { en = "Increase sharp weapon damage by 2 for 30 minutes.", description = "Aumenta di 2 i danni delle armi da taglio per 30 minuti." },
    -- Spell.db2 ID 2829, Description_lang.
    [2829] = { en = "Increase sharp weapon damage by 3 for 30 minutes.", description = "Aumenta di 3 i danni delle armi da taglio per 30 minuti." },
    -- Spell.db2 ID 2830, Description_lang.
    [2830] = { en = "Increase sharp weapon damage by 4 for 30 minutes.", description = "Aumenta di 4 i danni delle armi da taglio per 30 minuti." },
    -- Spell.db2 ID 3101, Description_lang.
    [3101] = { en = "Allows an alchemist to brew standard potions up to a maximum potential skill of 150.", description = "Permette a un alchimista di preparare pozioni standard, fino a un livello massimo di abilità pari a 150." },
    -- Spell.db2 ID 3124, Description_lang.
    [3124] = { en = "Gives a chance to parry enemy melee attacks.", description = "Conferisce una probabilità di parare gli attacchi in mischia nemici." },
    -- Spell.db2 ID 3338, Description_lang.
    [3338] = { en = "Adds a chance to deal damage in an area around the caster when successfully hit.", description = "Aggiunge una probabilità di infliggere danni ad area attorno all’incantatore quando si viene colpiti." },
    -- Spell.db2 ID 3464, Description_lang.
    [3464] = { en = "Allows an alchemist to brew amazing potions up to a maximum potential skill of 225.", description = "Permette a un alchimista di preparare pozioni eccezionali, fino a un livello massimo di abilità pari a 225." },
    -- Spell.db2 ID 3569, Description_lang.
    [3569] = { en = "Allows the miner to smelt a chunk of iron ore and a lump of coal together into a steel bar.  Smelting steel requires a forge.", description = "Permette al minatore di fondere insieme un pezzo di minerale di ferro e un pezzo di carbone per ottenere un lingotto d’acciaio. Per fondere l’acciaio serve una fucina." },
    -- Spell.db2 ID 3592, Description_lang.
    [3592] = { en = "Cures diseases and neutralizes poisons up to level 35.", description = "Cura le malattie e neutralizza i veleni fino al livello 35." },
    -- Spell.db2 ID 3607, Description_lang.
    [3607] = { en = "Will release Yenniku from his imprisonment", description = "Libera Yenniku dalla sua prigionia." },
    -- Spell.db2 ID 3976, Description_lang.
    [3976] = { en = "Attaches a permanent scope to a bow or gun that increases its damage by 3.", description = "Applica un mirino permanente a un arco o a un’arma da fuoco, aumentandone i danni di 3." },
    -- Spell.db2 ID 4056, Description_lang.
    [4056] = { en = "Blasts open simple locked doors.", description = "Fa saltare le serrature semplici." },
    -- Spell.db2 ID 4075, Description_lang.
    [4075] = { en = "Blasts open difficult locked doors.", description = "Fa saltare le serrature difficili." },
    -- Spell.db2 ID 4161, Description_lang.
    [4161] = { en = "Adds chance to counter attack when hit.", description = "Aggiunge una probabilità di contrattaccare quando si viene colpiti." },
    -- Spell.db2 ID 4231, Description_lang.
    [4231] = { en = "Increase your Spirit by 1.", description = "Aumenta di 1 lo spirito." },
    -- Spell.db2 ID 4233, Description_lang.
    [4233] = { en = "Increase your Spirit by 1.", description = "Aumenta di 1 lo spirito." },
    -- Spell.db2 ID 4234, Description_lang.
    [4234] = { en = "Increase your Spirit by 1.", description = "Aumenta di 1 lo spirito." },
    -- Spell.db2 ID 4236, Description_lang.
    [4236] = { en = "Increase your Spirit by 1.", description = "Aumenta di 1 lo spirito." },
    -- Spell.db2 ID 4302, Description_lang.
    [4302] = { en = "Increases your chance to Parry with One-Handed Swords by 4%.", description = "Aumenta del 4% la probabilità di parare con spade a una mano." },
    -- Spell.db2 ID 4303, Description_lang.
    [4303] = { en = "Increases your chance to Parry with One-Handed Swords by 5%.", description = "Aumenta del 5% la probabilità di parare con spade a una mano." },
    -- Spell.db2 ID 4304, Description_lang.
    [4304] = { en = "Increases your chances to parry with a One-Handed Sword by 2%.", description = "Aumenta del 2% la probabilità di parare con una spada a una mano." },
    -- Spell.db2 ID 4305, Description_lang.
    [4305] = { en = "Increases your chances to parry with a One-Handed Sword by 2%.", description = "Aumenta del 2% la probabilità di parare con una spada a una mano." },
    -- Spell.db2 ID 4307, Description_lang.
    [4307] = { en = "Increases your chance to parry with One-Handed Axes by 2%.", description = "Aumenta del 2% la probabilità di parare con asce a una mano." },
    -- Spell.db2 ID 4308, Description_lang.
    [4308] = { en = "Increases your chance to parry with One-Handed Axes by 4%.", description = "Aumenta del 4% la probabilità di parare con asce a una mano." },
    -- Spell.db2 ID 4309, Description_lang.
    [4309] = { en = "Increases your chance to parry with One-Handed Axes by 5%.", description = "Aumenta del 5% la probabilità di parare con asce a una mano." },
    -- Spell.db2 ID 4328, Description_lang.
    [4328] = { en = "Increases your chance to parry with One-Handed Maces by 2%.", description = "Aumenta del 2% la probabilità di parare con mazze a una mano." },
    -- Spell.db2 ID 4329, Description_lang.
    [4329] = { en = "Increases your chance to parry with One-Handed Maces by 4%.", description = "Aumenta del 4% la probabilità di parare con mazze a una mano." },
    -- Spell.db2 ID 4330, Description_lang.
    [4330] = { en = "Increases your chance to parry with One-Handed Maces by 5%.", description = "Aumenta del 5% la probabilità di parare con mazze a una mano." },
    -- Spell.db2 ID 4337, Description_lang.
    [4337] = { en = "Increases your damage with One-Handed Axes by 1.", description = "Aumenta di 1 i danni con le asce a una mano." },
    -- Spell.db2 ID 4359, Description_lang.
    [4359] = { en = "Increases your damage with One-Handed Swords by 1.", description = "Aumenta di 1 i danni con le spade a una mano." },
    -- Spell.db2 ID 4364, Description_lang.
    [4364] = { en = "Increases your damage with One-Handed Swords by 2.", description = "Aumenta di 2 i danni con le spade a una mano." },
    -- Spell.db2 ID 4375, Description_lang.
    [4375] = { en = "Increases your damage with One-Handed Maces by 1.", description = "Aumenta di 1 i danni con le mazze a una mano." },
    -- Spell.db2 ID 4414, Description_lang.
    [4414] = { en = "Increases your chance to parry with Two-Handed Axes by 2%.", description = "Aumenta del 2% la probabilità di parare con asce a due mani." },
    -- Spell.db2 ID 4416, Description_lang.
    [4416] = { en = "Increases your chance to parry with Two-Handed Axes by 4%.", description = "Aumenta del 4% la probabilità di parare con asce a due mani." },
    -- Spell.db2 ID 4417, Description_lang.
    [4417] = { en = "Increases your chance to parry with Two-Handed Axes by 5%.", description = "Aumenta del 5% la probabilità di parare con asce a due mani." },
    -- Spell.db2 ID 4426, Description_lang.
    [4426] = { en = "Increases your chance to parry with Two-Handed Maces by 2%.", description = "Aumenta del 2% la probabilità di parare con mazze a due mani." },
    -- Spell.db2 ID 4428, Description_lang.
    [4428] = { en = "Increases your chance to parry with Two-Handed Maces by 4%.", description = "Aumenta del 4% la probabilità di parare con mazze a due mani." },
    -- Spell.db2 ID 4429, Description_lang.
    [4429] = { en = "Increases your chance to parry with Two-Handed Maces by 5%.", description = "Aumenta del 5% la probabilità di parare con mazze a due mani." },
    -- Spell.db2 ID 4517, Description_lang.
    [4517] = { en = "Restores 12 mana per minute.", description = "Ripristina 12 punti mana al minuto." },
    -- Spell.db2 ID 4518, Description_lang.
    [4518] = { en = "Restores 24 mana per minute.", description = "Ripristina 24 punti mana al minuto." },
    -- Spell.db2 ID 4519, Description_lang.
    [4519] = { en = "Restores 36 mana per minute.", description = "Ripristina 36 punti mana al minuto." },
    -- Spell.db2 ID 4625, Description_lang.
    [4625] = { en = "Increase Shadow resistance by 4.", description = "Aumenta di 4 la resistenza all’ombra." },
    -- Spell.db2 ID 4710, Description_lang.
    [4710] = { en = "Increases damage done to Giants with either spells or physical attacks by 5.", description = "Aumenta di 5 i danni inflitti ai Giganti con incantesimi o attacchi fisici." },
    -- Spell.db2 ID 4758, Description_lang.
    [4758] = { en = "Increases your chance to parry by 3%.", description = "Aumenta del 3% la probabilità di parare." },
    -- Spell.db2 ID 4759, Description_lang.
    [4759] = { en = "Increases your chance to parry by 3%.", description = "Aumenta del 3% la probabilità di parare." },
    -- Spell.db2 ID 4760, Description_lang.
    [4760] = { en = "Increases your chance to block with a Shield (not a Buckler) by 2%.", description = "Aumenta del 2% la probabilità di bloccare con uno scudo (esclusi i brocchieri)." },
    -- Spell.db2 ID 4920, Description_lang.
    [4920] = { en = "Increases your chance to critical with all Bows by 1%.", description = "Aumenta dell’1% la probabilità di infliggere colpi critici con tutti gli archi." },
    -- Spell.db2 ID 4922, Description_lang.
    [4922] = { en = "Increases your chance to critical with Guns by 2%.", description = "Aumenta del 2% la probabilità di infliggere colpi critici con le armi da fuoco." },
    -- Spell.db2 ID 5170, Description_lang.
    [5170] = { en = "This skill allows the Rogue to apply disguises.", description = "Questa abilità permette al Ladro di applicare travestimenti." },
    -- Spell.db2 ID 476, Description_lang.
    [476] = { en = "Teaches Frost Shield (Rank 1).", description = "Insegna Frost Shield (grado 1)." },
    -- Spell.db2 ID 481, Description_lang.
    [481] = { en = "Teaches Water Elemental (Rank 2).", description = "Insegna Water Elemental (grado 2)." },
    -- Spell.db2 ID 490, Description_lang.
    [490] = { en = "Teaches Frost Shield (Rank 2).", description = "Insegna Frost Shield (grado 2)." },
    -- Spell.db2 ID 493, Description_lang.
    [493] = { en = "Teaches Khadgar's Unlocking (Rank 1).", description = "Insegna Khadgar's Unlocking (grado 1)." },
    -- Spell.db2 ID 506, Description_lang.
    [506] = { en = "Teaches Ice Armor (Rank 1).", description = "Insegna Ice Armor (grado 1)." },
    -- Spell.db2 ID 519, Description_lang.
    [519] = { en = "Teaches Ghost Wolf (Rank 2).", description = "Insegna Ghost Wolf (grado 2)." },
    -- Spell.db2 ID 520, Description_lang.
    [520] = { en = "Teaches Chains of Ice (Rank 2).", description = "Insegna Chains of Ice (grado 2)." },
    -- Spell.db2 ID 531, Description_lang.
    [531] = { en = "Teaches Lightning Bolt (Rank 2).", description = "Insegna Lightning Bolt (grado 2)." },
    -- Spell.db2 ID 533, Description_lang.
    [533] = { en = "Teaches Unyielding Will (Rank 1).", description = "Insegna Unyielding Will (grado 1)." },
    -- Spell.db2 ID 534, Description_lang.
    [534] = { en = "Teaches Molten Blast (Rank 1).", description = "Insegna Molten Blast (grado 1)." },
    -- Spell.db2 ID 537, Description_lang.
    [537] = { en = "Teaches Undying Strength (Rank 1).", description = "Insegna Undying Strength (grado 1)." },
    -- Spell.db2 ID 538, Description_lang.
    [538] = { en = "Teaches Healing Wave (Rank 2).", description = "Insegna Healing Wave (grado 2)." },
    -- Spell.db2 ID 540, Description_lang.
    [540] = { en = "Teaches Nullify Disease (Rank 1).", description = "Insegna Nullify Disease (grado 1)." },
    -- Spell.db2 ID 541, Description_lang.
    [541] = { en = "Teaches Fire Resistance.", description = "Insegna Fire Resistance." },
    -- Spell.db2 ID 560, Description_lang.
    [560] = { en = "Teaches Spirit Armor (Rank 2).", description = "Insegna Spirit Armor (grado 2)." },
    -- Spell.db2 ID 561, Description_lang.
    [561] = { en = "Teaches Molten Blast (Rank 2).", description = "Insegna Molten Blast (grado 2)." },
    -- Spell.db2 ID 567, Description_lang.
    [567] = { en = "Teaches Undying Strength (Rank 2).", description = "Insegna Undying Strength (grado 2)." },
    -- Spell.db2 ID 574, Description_lang.
    [574] = { en = "Teaches Redemption.", description = "Insegna Redemption." },
    -- Spell.db2 ID 575, Description_lang.
    [575] = { en = "Teaches Unyielding Will (Rank 2).", description = "Insegna Unyielding Will (grado 2)." },
    -- Spell.db2 ID 612, Description_lang.
    [612] = { en = "Teaches Holy Smite (Rank 2).", description = "Insegna Holy Smite (grado 2)." },
    -- Spell.db2 ID 613, Description_lang.
    [613] = { en = "Teaches Lesser Heal (Rank 2).", description = "Insegna Lesser Heal (grado 2)." },
    -- Spell.db2 ID 614, Description_lang.
    [614] = { en = "Teaches Shadow Word: Fumble (Rank 1).", description = "Insegna Shadow Word: Fumble (grado 1)." },
    -- Spell.db2 ID 615, Description_lang.
    [615] = { en = "Teaches Dispel Magic (Rank 1).", description = "Insegna Dispel Magic (grado 1)." },
    -- Spell.db2 ID 616, Description_lang.
    [616] = { en = "Teaches Shadow Word: Pain (Rank 2).", description = "Insegna Shadow Word: Pain (grado 2)." },
    -- Spell.db2 ID 618, Description_lang.
    [618] = { en = "Teaches Prayer of Healing (Rank 1).", description = "Insegna Prayer of Healing (grado 1)." },
    -- Spell.db2 ID 624, Description_lang.
    [624] = { en = "Teaches Inner Fire (Rank 2).", description = "Insegna Inner Fire (grado 2)." },
    -- Spell.db2 ID 625, Description_lang.
    [625] = { en = "Teaches Curse of Archimonde.", description = "Insegna Curse of Archimonde." },
    -- Spell.db2 ID 626, Description_lang.
    [626] = { en = "Teaches Seal of Might (Rank 3).", description = "Insegna Seal of Might (grado 3)." },
    -- Spell.db2 ID 627, Description_lang.
    [627] = { en = "Teaches Mind Control.", description = "Insegna Mind Control." },
    -- Spell.db2 ID 650, Description_lang.
    [650] = { en = "Teaches Blood Boil (Rank 1).", description = "Insegna Blood Boil (grado 1)." },
    -- Spell.db2 ID 653, Description_lang.
    [653] = { en = "Teaches Seal of Might (Rank 1).", description = "Insegna Seal of Might (grado 1)." },
    -- Spell.db2 ID 655, Description_lang.
    [655] = { en = "Teaches Blood Boil (Rank 2).", description = "Insegna Blood Boil (grado 2)." },
    -- Spell.db2 ID 657, Description_lang.
    [657] = { en = "Teaches Create Greater Healthstone.", description = "Insegna Create Greater Healthstone." },
    -- Spell.db2 ID 659, Description_lang.
    [659] = { en = "Teaches Divine Shield (Rank 1).", description = "Insegna Divine Shield (grado 1)." },
    -- Spell.db2 ID 661, Description_lang.
    [661] = { en = "Teaches Blood Boil (Rank 3).", description = "Insegna Blood Boil (grado 3)." },
    -- Spell.db2 ID 662, Description_lang.
    [662] = { en = "Teaches Seal of Might (Rank 2).", description = "Insegna Seal of Might (grado 2)." },
    -- Spell.db2 ID 663, Description_lang.
    [663] = { en = "Teaches Fear (Rank 3).", description = "Insegna Fear (grado 3)." },
    -- Spell.db2 ID 664, Description_lang.
    [664] = { en = "Teaches Holy Light (Rank 3).", description = "Insegna Holy Light (grado 3)." },
    -- Spell.db2 ID 721, Description_lang.
    [721] = { en = "Teaches Shadow Bolt (Rank 2).", description = "Insegna Shadow Bolt (grado 2)." },
    -- Spell.db2 ID 736, Description_lang.
    [736] = { en = "Teaches Drain Life (Rank 3).", description = "Insegna Drain Life (grado 3)." },
    -- Spell.db2 ID 766, Description_lang.
    [766] = { en = "Teaches Water Elemental (Rank 1).", description = "Insegna Water Elemental (grado 1)." },
    -- Spell.db2 ID 789, Description_lang.
    [789] = { en = "Teaches Divine Escape (Rank 1).", description = "Insegna Divine Escape (grado 1)." },
    -- Spell.db2 ID 842, Description_lang.
    [842] = { en = "Teaches Ethereal Form (Rank 2).", description = "Insegna Ethereal Form (grado 2)." },
    -- Spell.db2 ID 864, Description_lang.
    [864] = { en = "Teaches Seal of Righteousness (Rank 1).", description = "Insegna Seal of Righteousness (grado 1)." },
    -- Spell.db2 ID 874, Description_lang.
    [874] = { en = "Teaches Fire Ward.", description = "Insegna Fire Ward." },
    -- Spell.db2 ID 890, Description_lang.
    [890] = { en = "Teaches Renew (Rank 5).", description = "Insegna Renew (grado 5)." },
    -- Spell.db2 ID 900, Description_lang.
    [900] = { en = "Teaches Molten Blast (Rank 3).", description = "Insegna Molten Blast (grado 3)." },
    -- Spell.db2 ID 902, Description_lang.
    [902] = { en = "Teaches Spirit Armor (Rank 3).", description = "Insegna Spirit Armor (grado 3)." },
    -- Spell.db2 ID 910, Description_lang.
    [910] = { en = "Teaches Unyielding Will (Rank 3).", description = "Insegna Unyielding Will (grado 3)." },
    -- Spell.db2 ID 924, Description_lang.
    [924] = { en = "Teaches Molten Blast (Rank 4).", description = "Insegna Molten Blast (grado 4)." },
    -- Spell.db2 ID 926, Description_lang.
    [926] = { en = "Teaches Thunderclap (Rank 2).", description = "Insegna Thunderclap (grado 2)." },
    -- Spell.db2 ID 931, Description_lang.
    [931] = { en = "Teaches Exorcism (Rank 2).", description = "Insegna Exorcism (grado 2)." },
    -- Spell.db2 ID 936, Description_lang.
    [936] = { en = "Teaches Holy Ward.", description = "Insegna Holy Ward." },
    -- Spell.db2 ID 950, Description_lang.
    [950] = { en = "Teaches Mind Bomb.", description = "Insegna Mind Bomb." },
    -- Spell.db2 ID 952, Description_lang.
    [952] = { en = "Teaches Molten Blast (Rank 5).", description = "Insegna Molten Blast (grado 5)." },
    -- Spell.db2 ID 967, Description_lang.
    [967] = { en = "Teaches Group Astral Recall.", description = "Insegna Group Astral Recall." },
    -- Spell.db2 ID 973, Description_lang.
    [973] = { en = "Teaches Holy Protection.", description = "Insegna Holy Protection." },
    -- Spell.db2 ID 977, Description_lang.
    [977] = { en = "Teaches Shadow Protection.", description = "Insegna Shadow Protection." },
    -- Spell.db2 ID 999, Description_lang.
    [999] = { en = "Teaches Shadow Word: Fumble (Rank 2).", description = "Insegna Shadow Word: Fumble (grado 2)." },
    -- Spell.db2 ID 1003, Description_lang.
    [1003] = { en = "Teaches Shadow Word: Befuddle (Rank 2).", description = "Insegna Shadow Word: Befuddle (grado 2)." },
    -- Spell.db2 ID 1023, Description_lang.
    [1023] = { en = "Teaches Seal of Protection (Rank 1).", description = "Insegna Seal of Protection (grado 1)." },
    -- Spell.db2 ID 1027, Description_lang.
    [1027] = { en = "Teaches Holy Light (Rank 4).", description = "Insegna Holy Light (grado 4)." },
    -- Spell.db2 ID 1029, Description_lang.
    [1029] = { en = "Teaches Bane of Agony (Rank 3).", description = "Insegna Bane of Agony (grado 3)." },
    -- Spell.db2 ID 1037, Description_lang.
    [1037] = { en = "Teaches Seal of Fury (Rank 1).", description = "Insegna Seal of Fury (grado 1)." },
    -- Spell.db2 ID 1070, Description_lang.
    [1070] = { en = "Teaches Faerie Fire (Rank 3).", description = "Insegna Faerie Fire (grado 3)." },
    -- Spell.db2 ID 1089, Description_lang.
    [1089] = { en = "Teaches Shadow Bolt (Rank 4).", description = "Insegna Shadow Bolt (grado 4)." },
    -- Spell.db2 ID 1101, Description_lang.
    [1101] = { en = "Teaches Mana Funnel.", description = "Insegna Mana Funnel." },
    -- Spell.db2 ID 1105, Description_lang.
    [1105] = { en = "Teaches Seal of Wisdom (Rank 3).", description = "Insegna Seal of Wisdom (grado 3)." },
    -- Spell.db2 ID 1107, Description_lang.
    [1107] = { en = "Teaches Corruption (Rank 1).", description = "Insegna Corruption (grado 1)." },
    -- Spell.db2 ID 1109, Description_lang.
    [1109] = { en = "Teaches Curse of Weakness (Rank 2).", description = "Insegna Curse of Weakness (grado 2)." },
    -- Spell.db2 ID 1366, Description_lang.
    [1366] = { en = "Learn Summon Imp.", description = "Insegna Summon Imp." },
    -- Spell.db2 ID 1385, Description_lang.
    [1385] = { en = "Learn Summon Voidwalker.", description = "Insegna Summon Voidwalker." },
    -- Spell.db2 ID 1403, Description_lang.
    [1403] = { en = "Learn Summon Succubus.", description = "Insegna Summon Succubus." },
    -- Spell.db2 ID 2363, Description_lang.
    [2363] = { en = "Teaches you how to make an Elixir of Minor Fortitude.", description = "Insegna a preparare Elixir of Minor Fortitude." },
    -- Spell.db2 ID 3068, Description_lang.
    [3068] = { en = "Teaches Blizzard (Rank 2).", description = "Insegna Blizzard (grado 2)." },
    -- Spell.db2 ID 3069, Description_lang.
    [3069] = { en = "Teaches Sleep (Rank 3).", description = "Insegna Sleep (grado 3)." },
    -- Spell.db2 ID 3084, Description_lang.
    [3084] = { en = "Teaches Holy Word: Shield (Rank 3).", description = "Insegna Holy Word: Shield (grado 3)." },
    -- Spell.db2 ID 3086, Description_lang.
    [3086] = { en = "Teaches Shadow Word: Befuddle (Rank 1).", description = "Insegna Shadow Word: Befuddle (grado 1)." },
    -- Spell.db2 ID 3087, Description_lang.
    [3087] = { en = "Teaches Lightning Storm (Rank 1).", description = "Insegna Lightning Storm (grado 1)." },
    -- Spell.db2 ID 3088, Description_lang.
    [3088] = { en = "Teaches Lightning Storm (Rank 2).", description = "Insegna Lightning Storm (grado 2)." },
    -- Spell.db2 ID 3094, Description_lang.
    [3094] = { en = "Teaches Seal of Righteousness (Rank 3).", description = "Insegna Seal of Righteousness (grado 3)." },
    -- Spell.db2 ID 3112, Description_lang.
    [3112] = { en = "Increase the damage of a blunt weapon by 2 for 30 minutes.", description = "Aumenta di 2 i danni delle armi contundenti per 30 minuti." },
    -- Spell.db2 ID 3113, Description_lang.
    [3113] = { en = "Increase the damage of a blunt weapon by 3 for 30 minutes.", description = "Aumenta di 3 i danni delle armi contundenti per 30 minuti." },
    -- Spell.db2 ID 3114, Description_lang.
    [3114] = { en = "Increase the damage of a blunt weapon by 4 for 30 minutes.", description = "Aumenta di 4 i danni delle armi contundenti per 30 minuti." },
    -- Spell.db2 ID 3183, Description_lang.
    [3183] = { en = "Teaches you how to make a Limited Invulnerability Potion.", description = "Insegna a preparare Limited Invulnerability Potion." },
    -- Spell.db2 ID 3214, Description_lang.
    [3214] = { en = "Teaches Lightning Storm (Rank 3).", description = "Insegna Lightning Storm (grado 3)." },
    -- Spell.db2 ID 3218, Description_lang.
    [3218] = { en = "Teaches Call Spirit (Rank 2).", description = "Insegna Call Spirit (grado 2)." },
    -- Spell.db2 ID 3456, Description_lang.
    [3456] = { en = "Teaches you how to make a Mighty Troll's Blood Elixir.", description = "Insegna a preparare Mighty Troll's Blood Elixir." },
    -- Spell.db2 ID 3559, Description_lang.
    [3559] = { en = "Teaches Ethereal Form (Rank 1).", description = "Insegna Ethereal Form (grado 1)." },
    -- Spell.db2 ID 3594, Description_lang.
    [3594] = { en = "When applied to a melee weapon it gives a 15% chance of casting Shadowbolt III at the opponent when it hits.  Lasts 30 minutes.", description = "Quando viene applicato a un’arma da mischia, conferisce il 15% di probabilità di lanciare Shadowbolt III sull’avversario a ogni colpo. Dura 30 minuti." },
    -- Spell.db2 ID 3595, Description_lang.
    [3595] = { en = "When applied to a melee weapon it gives a 10% chance of casting Frostbolt at the opponent when it hits.  Lasts 30 minutes.", description = "Quando viene applicato a un’arma da mischia, conferisce il 10% di probabilità di lanciare Frostbolt sull’avversario a ogni colpo. Dura 30 minuti." },
    -- Spell.db2 ID 3693, Description_lang.
    [3693] = { en = "Teaches Burning Spirit (Rank 4).", description = "Insegna Burning Spirit (grado 4)." },
    -- Spell.db2 ID 3694, Description_lang.
    [3694] = { en = "Teaches Seal of Reckoning (Rank 1).", description = "Insegna Seal of Reckoning (grado 1)." },
    -- Spell.db2 ID 3695, Description_lang.
    [3695] = { en = "Teaches Seal of Reckoning (Rank 2).", description = "Insegna Seal of Reckoning (grado 2)." },
    -- Spell.db2 ID 3713, Description_lang.
    [3713] = { en = "Teaches Seal of Wisdom (Rank 2).", description = "Insegna Seal of Wisdom (grado 2)." },
    -- Spell.db2 ID 3716, Description_lang.
    [3716] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.", description = "Provoca la creatura, aumentando la probabilità che attacchi il Camminatore del Vuoto." },
    -- Spell.db2 ID 3733, Description_lang.
    [3733] = { en = "Teaches Demon Breath.", description = "Insegna Demon Breath." },
    -- Spell.db2 ID 3750, Description_lang.
    [3750] = { en = "Teaches Remove Curse (Rank 2).", description = "Insegna Remove Curse (grado 2)." },
    -- Spell.db2 ID 3900, Description_lang.
    [3900] = { en = "Teaches you how to sew a Shadow Hood.", description = "Insegna a cucire Shadow Hood." },
    -- Spell.db2 ID 3903, Description_lang.
    [3903] = { en = "Teaches you how to sew a Spider Belt.", description = "Insegna a cucire Spider Belt." },
    -- Spell.db2 ID 4377, Description_lang.
    [4377] = { en = "Increases your damage with One-Handed Maces by 1.", description = "Aumenta di 1 i danni con le mazze a una mano." },
    -- Spell.db2 ID 4617, Description_lang.
    [4617] = { en = "Increase Frost resistance by 4 and gives a 3% chance of reflecting hostile Frost spells back at the caster.", description = "Aumenta di 4 la resistenza al gelo e conferisce il 3% di probabilità di riflettere gli incantesimi ostili di gelo sull’incantatore." },
    -- Spell.db2 ID 4618, Description_lang.
    [4618] = { en = "Increase Frost resistance by 4.", description = "Aumenta di 4 la resistenza al gelo." },
    -- Spell.db2 ID 4619, Description_lang.
    [4619] = { en = "Increase Frost resistance by 4 and gives a 5% chance of reflecting hostile Frost spells back at the caster.", description = "Aumenta di 4 la resistenza al gelo e conferisce il 5% di probabilità di riflettere gli incantesimi ostili di gelo sull’incantatore." },
    -- Spell.db2 ID 4620, Description_lang.
    [4620] = { en = "Increase Frost resistance by 4.", description = "Aumenta di 4 la resistenza al gelo." },
    -- Spell.db2 ID 5286, Description_lang.
    [5286] = { en = "Teaches Mark of the Wild (Rank 2).", description = "Insegna Mark of the Wild (grado 2)." },
    -- Spell.db2 ID 5454, Description_lang.
    [5454] = { en = "Increases your chance to parry while wielding a Two-Handed Sword by 2%.", description = "Aumenta del 2% la probabilità di parare mentre si impugna una spada a due mani." },
    -- Spell.db2 ID 5455, Description_lang.
    [5455] = { en = "Increases your chance to parry while wielding a Two-Handed Sword by 4%.", description = "Aumenta del 4% la probabilità di parare mentre si impugna una spada a due mani." },
    -- Spell.db2 ID 5456, Description_lang.
    [5456] = { en = "Increases your chance to parry while wielding a Two-Handed Sword by 5%.", description = "Aumenta del 5% la probabilità di parare mentre si impugna una spada a due mani." },
    -- Spell.db2 ID 5500, Description_lang.
    [5500] = { en = "Shows the location of all nearby demons on the minimap until cancelled.  Only one type of tracking can be used at a time.", description = "Mostra sulla minimappa i demoni nelle vicinanze finché l’effetto non viene annullato. È possibile usare un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 5502, Description_lang.
    [5502] = { en = "Shows the location of all nearby undead on the minimap until cancelled.   Only one type of tracking can be used at a time.", description = "Mostra sulla minimappa i non morti nelle vicinanze finché l’effetto non viene annullato. È possibile usare un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 5521, Description_lang.
    [5521] = { en = "Increases your damage with One-Handed Axes by 3 and gives a 1% chance of decreasing enemy armor by 200 for 15 seconds.", description = "Aumenta di 3 i danni con le asce a una mano e conferisce l’1% di probabilità di ridurre di 200 l’armatura del nemico per 15 secondi." },
    -- Spell.db2 ID 5555, Description_lang.
    [5555] = { en = "Increase the chance of getting a critical hit with a One-Handed Mace by 2%.", description = "Aumenta del 2% la probabilità di infliggere un colpo critico con una mazza a una mano." },
    -- Spell.db2 ID 5668, Description_lang.
    [5668] = { en = "Disguise yourself as a Human Peasant.", description = "Ti traveste da contadino umano." },
    -- Spell.db2 ID 5669, Description_lang.
    [5669] = { en = "Disguise yourself as an Orcish Peon.", description = "Ti traveste da peone orchesco." },
    -- Spell.db2 ID 5670, Description_lang.
    [5670] = { en = "Allows you to disguise yourself as a Human Peasant, and allows other Disguises as you find them in the world.", description = "Ti permette di travestirti da contadino umano e di usare altri travestimenti man mano che li trovi nel mondo." },
    -- Spell.db2 ID 5671, Description_lang.
    [5671] = { en = "Allows you to disguise yourself as an Orcish Peon, and allows other Disguises as you find them in the world.", description = "Ti permette di travestirti da peone orchesco e di usare altri travestimenti man mano che li trovi nel mondo." },
    -- Spell.db2 ID 5807, Description_lang.
    [5807] = { en = "Increases your armor while wearing a Shield or Buckler by 55.", description = "Aumenta di 55 l’armatura mentre si indossa uno scudo o un brocchiere." },
    -- Spell.db2 ID 5823, Description_lang.
    [5823] = { en = "Increases Nature spell damage by 3.", description = "Aumenta di 3 i danni degli incantesimi di natura." },
    -- Spell.db2 ID 5824, Description_lang.
    [5824] = { en = "Increases Nature spell damage by 3.", description = "Aumenta di 3 i danni degli incantesimi di natura." },
    -- Spell.db2 ID 5826, Description_lang.
    [5826] = { en = "Increases your Nature Magic skill by 4, but decreases your Shadow and Fire resistance by 1.", description = "Aumenta di 4 l’abilità Magia della Natura, ma riduce di 1 la resistenza all’ombra e al fuoco." },
    -- Spell.db2 ID 6102, Description_lang.
    [6102] = { en = "Increases your damage with Wands by 1.", description = "Aumenta di 1 i danni con le bacchette." },
    -- Spell.db2 ID 6103, Description_lang.
    [6103] = { en = "Increases your damage with Wands by 1.", description = "Aumenta di 1 i danni con le bacchette." },
    -- Spell.db2 ID 6104, Description_lang.
    [6104] = { en = "Increases your damage with Wands by 1.", description = "Aumenta di 1 i danni con le bacchette." },
    -- Spell.db2 ID 6105, Description_lang.
    [6105] = { en = "Increases your damage with Wands by 1.", description = "Aumenta di 1 i danni con le bacchette." },
    -- Spell.db2 ID 6113, Description_lang.
    [6113] = { en = "Increases your damage with Wands by 2.", description = "Aumenta di 2 i danni con le bacchette." },
    -- Spell.db2 ID 6360, Description_lang.
    [6360] = { en = "Soothes the target, increasing the chance that it will attack something else.", description = "Calma il bersaglio, aumentando la probabilità che attacchi qualcos’altro." },
    -- Spell.db2 ID 6461, Description_lang.
    [6461] = { en = "Allows opening of locked chests and doors.  Gives a potential of 150 in your lockpicking skill.", description = "Permette di scassinare forzieri e porte chiusi. Porta l’abilità Scassinamento fino a un massimo di 150." },
    -- Spell.db2 ID 6463, Description_lang.
    [6463] = { en = "Allows opening of locked chests and doors.  Gives a potential of 225 in your lockpicking skill.", description = "Permette di scassinare forzieri e porte chiusi. Porta l’abilità Scassinamento fino a un massimo di 225." },
    -- Spell.db2 ID 6481, Description_lang.
    [6481] = { en = "Allows opening of locked chests and doors.  Gives a potential of 150 in your lockpicking skill.", description = "Permette di scassinare forzieri e porte chiusi. Porta l’abilità Scassinamento fino a un massimo di 150." },
    -- Spell.db2 ID 5395, Description_lang.
    [5395] = { en = "Creates a Death Capsule, which is used to Feign Death.", description = "Crea una Death Capsule, usata per l’abilità Feign Death." },
    -- Spell.db2 ID 6470, Description_lang.
    [6470] = { en = "Creates a Tiny Bronze Key that is a reagent for mage unlocking spells.", description = "Crea una Tiny Bronze Key, reagente per gli incantesimi di apertura dei maghi." },
    -- Spell.db2 ID 6471, Description_lang.
    [6471] = { en = "Creates a Tiny Iron Key that is a reagent for mage unlocking spells.", description = "Crea una Tiny Iron Key, reagente per gli incantesimi di apertura dei maghi." },
    -- Spell.db2 ID 6482, Description_lang.
    [6482] = { en = "Allows opening of locked chests and doors.  Gives a potential of 225 in your lockpicking skill.", description = "Permette di scassinare forzieri e porte chiusi. Porta l’abilità Scassinamento fino a un massimo di 225." },
    -- Spell.db2 ID 6510, Description_lang.
    [6510] = { en = "Create the reagent for the Blind ability.", description = "Crea il reagente per l’abilità Accecamento." },
    -- Spell.db2 ID 6612, Description_lang.
    [6612] = { en = "Increases Rage by 20 to 40.", description = "Aumenta la Rabbia da 20 a 40." },
    -- Spell.db2 ID 6613, Description_lang.
    [6613] = { en = "Increases Rage by 30 to 60.", description = "Aumenta la Rabbia da 30 a 60." },
    -- Spell.db2 ID 6681, Description_lang.
    [6681] = { en = "Makes the Paladin immune to Disease.", description = "Rende il paladino immune alle malattie." },
    -- Spell.db2 ID 7198, Description_lang.
    [7198] = { en = "Restores 48 mana per minute.", description = "Ripristina 48 punti mana al minuto." },
    -- Spell.db2 ID 7200, Description_lang.
    [7200] = { en = "Restores 48 health per minute.", description = "Ripristina 48 punti salute al minuto." },
    -- Spell.db2 ID 8089, Description_lang.
    [8089] = { en = "When applied to your fishing pole, increases Fishing by 100 for 5 minutes.", description = "Quando viene applicato alla canna da pesca, aumenta di 100 l’abilità Pesca per 5 minuti." },
    -- Spell.db2 ID 8296, Description_lang.
    [8296] = { en = "Allows the miner to smelt 10 chunks of copper ore into 10 copper bars.  Smelting copper requires a forge.", description = "Permette al minatore di fondere 10 pezzi di minerale di rame per ottenere 10 lingotti di rame. Per fondere il rame serve una fucina." },
    -- Spell.db2 ID 9174, Description_lang.
    [9174] = { en = "Increase Rage by 30.", description = "Aumenta la Rabbia di 30." },
    -- Spell.db2 ID 9787, Description_lang.
    [9787] = { en = "Allows a blacksmith to make special weapons that are unavailable to the typical artisan blacksmith.", description = "Permette al fabbro di creare armi speciali non disponibili ai normali fabbri." },
    -- Spell.db2 ID 9788, Description_lang.
    [9788] = { en = "Allows a blacksmith to make special armors that are unavailable to the typical artisan blacksmith.", description = "Permette al fabbro di creare armature speciali non disponibili ai normali fabbri." },
    -- Spell.db2 ID 9900, Description_lang.
    [9900] = { en = "Increase sharp weapon damage by 6 for 30 minutes.", description = "Aumenta di 6 i danni delle armi da taglio per 30 minuti." },
    -- Spell.db2 ID 9903, Description_lang.
    [9903] = { en = "Increase the damage of a blunt weapon by 6 for 30 minutes.", description = "Aumenta di 6 i danni delle armi contundenti per 30 minuti." },
    -- Spell.db2 ID 10660, Description_lang.
    [10660] = { en = "Allows a leatherworker to make special tribal armors that are unavailable to a normal leatherworker.  ", description = "Permette a un conciatore di creare armature tribali speciali non disponibili ai normali conciatori." },
    -- Spell.db2 ID 11359, Description_lang.
    [11359] = { en = "Removes 1 magic, curse, poison or disease effect on you every 5 seconds for 30 seconds.", description = "Rimuove da te un effetto magico, una maledizione, un veleno o una malattia ogni 5 secondi per 30 secondi." },
    -- Spell.db2 ID 11611, Description_lang.
    [11611] = { en = "Allows an alchemist to brew astounding potions up to a maximum potential skill of 300.", description = "Permette a un alchimista di preparare pozioni straordinarie, fino a un livello massimo di abilità pari a 300." },
    -- Spell.db2 ID 12566, Description_lang.
    [12566] = { en = "Increases your running speed.   The longer you run the faster you go up to a maximum speed.  You cannot use plainsrunning in combat, underwater, or Indoors.", description = "Aumenta la velocità di corsa. Più a lungo corri, più vai veloce, fino a raggiungere la velocità massima. Non puoi usare la corsa nelle pianure in combattimento, sott’acqua o al chiuso." },
    -- Spell.db2 ID 12680, Description_lang.
    [12680] = { en = "Allows discovery of additional gems in Tin and Copper nodes.", description = "Permette di trovare gemme aggiuntive nei filoni di stagno e rame." },
    -- Spell.db2 ID 12687, Description_lang.
    [12687] = { en = "Allows discovery of additional gems in Iron, Tin and Copper nodes.", description = "Permette di trovare gemme aggiuntive nei filoni di ferro, stagno e rame." },
    -- Spell.db2 ID 12691, Description_lang.
    [12691] = { en = "Allows discovery of additional gems in Mithril, Iron, Tin and Copper nodes.", description = "Permette di trovare gemme aggiuntive nei filoni di mithril, ferro, stagno e rame." },
    -- Spell.db2 ID 16138, Description_lang.
    [16138] = { en = "Increase sharp weapon damage by 8 for 30 minutes.", description = "Aumenta di 8 i danni delle armi da taglio per 30 minuti." },
    -- Spell.db2 ID 16269, Description_lang.
    [16269] = { en = "Allows you to use Two-Handed Axes and Two-Handed Maces.", description = "Permette di usare asce e mazze a due mani." },
    -- Spell.db2 ID 16622, Description_lang.
    [16622] = { en = "Increase the damage of a blunt weapon by 8 for 30 minutes.", description = "Aumenta di 8 i danni delle armi contundenti per 30 minuti." },
    -- Spell.db2 ID 19566, Description_lang.
    [19566] = { en = "Allows an experienced leatherworker to turn Deeprock Salt into Refined Deeprock Salt.  Use of the device exposes the user to sub-core micro radiation and should not be used more than once every few days.", description = "Permette a un conciatore esperto di trasformare il Sale di Roccia Profonda in Sale di Roccia Profonda Raffinato. L’uso del dispositivo espone l’utilizzatore a radiazioni subnucleari e non dovrebbe essere ripetuto più di una volta ogni pochi giorni." },
    -- Spell.db2 ID 19646, Description_lang.
    [19646] = { en = "Allows opening of simple locks.  The skeleton key is consumed in the process.", description = "Permette di aprire serrature semplici. La chiave passepartout viene consumata durante l’uso." },
    -- Spell.db2 ID 19649, Description_lang.
    [19649] = { en = "Allows opening of standard locks.  The skeleton key is consumed in the process.", description = "Permette di aprire serrature standard. La chiave passepartout viene consumata durante l’uso." },
    -- Spell.db2 ID 19651, Description_lang.
    [19651] = { en = "Allows opening of difficult locks.  The skeleton key is consumed in the process.", description = "Permette di aprire serrature difficili. La chiave passepartout viene consumata durante l’uso." },
    -- Spell.db2 ID 19878, Description_lang.
    [19878] = { en = "Shows the location of all nearby demons on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa i demoni nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19879, Description_lang.
    [19879] = { en = "Shows the location of all nearby dragonkin on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa i draconidi nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19880, Description_lang.
    [19880] = { en = "Shows the location of all nearby elementals on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa gli elementali nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19882, Description_lang.
    [19882] = { en = "Shows the location of all nearby giants on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa i giganti nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19883, Description_lang.
    [19883] = { en = "Shows the location of all nearby humanoids on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa gli umanoidi nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19884, Description_lang.
    [19884] = { en = "Shows the location of all nearby undead on the minimap.  Only one form of tracking can be active at a time.", description = "Mostra sulla minimappa i non morti nelle vicinanze. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 19885, Description_lang.
    [19885] = { en = "Increases stealth detection and shows hidden units within detection range on the minimap.  Only one form of tracking can be active at a time.", description = "Aumenta la capacità di individuare i bersagli furtivi e mostra sulla minimappa le unità nascoste nel raggio di rilevamento. È possibile tenere attivo un solo tipo di tracciamento alla volta." },
    -- Spell.db2 ID 20709, Description_lang.
    [20709] = { en = "Allows opening of hard locks.  The skeleton key is consumed in the process.", description = "Permette di aprire serrature robuste. La chiave passepartout viene consumata durante l’uso." },
    -- Spell.db2 ID 22756, Description_lang.
    [22756] = { en = "Increase critical chance on a melee weapon by 2% for 30 minutes.", description = "Aumenta del 2% la probabilità di infliggere un colpo critico con un’arma da mischia per 30 minuti." },
    -- Spell.db2 ID 23047, Description_lang.
    [23047] = { en = "Reduces the casting time of your Immolate spell by 0.2  sec.", description = "Riduce di 0,2 secondi il tempo di lancio dell’incantesimo Immolate." },
    -- Spell.db2 ID 24425, Description_lang.
    [24425] = { en = "Increases movement speed by 10% and all stats by 15% for 2 hours.", description = "Aumenta del 10% la velocità di movimento e del 15% tutte le caratteristiche per 2 ore." },
    -- Spell.db2 ID 25163, Description_lang.
    [25163] = { en = "Reduces master's resistance and defense by 20.", description = "Riduce del 20% la resistenza e la difesa del padrone." },
    -- Spell.db2 ID 27786, Description_lang.
    [27786] = { en = "Restores 200 mana.", description = "Ripristina 200 punti mana." },
    -- Spell.db2 ID 27846, Description_lang.
    [27846] = { en = "Reduces the casting time of your Healing Touch spell by 0.15 sec.", description = "Riduce di 0,15 secondi il tempo di lancio del tuo incantesimo Healing Touch." },
    -- Spell.db2 ID 27986, Description_lang.
    [27986] = { en = "Allows the caster to levitate, floating a few feet above the ground.  While levitating, you will fall at a reduced speed and travel over water-like surfaces.  ", description = "Permette all’incantatore di levitare a pochi centimetri dal suolo. Durante la levitazione, cadi più lentamente e puoi spostarti sulle superfici simili all’acqua." },
    -- Spell.db2 ID 4425, Description_lang.
    [4425] = { en = "Teaches your tamed spider the Spider Poison ability. Spider Poison deals damage over time to an enemy.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo ragno addomesticato l’abilità Spider Poison. Spider Poison infligge danni periodici a un nemico.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4715, Description_lang.
    [4715] = { en = "Teaches your tamed bear the Growl of Fortitude ability. Growl of Fortitude increases the maximum health of the bear.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo orso addomesticato l’abilità Growl of Fortitude. Growl of Fortitude aumenta la salute massima dell’orso.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4731, Description_lang.
    [4731] = { en = "Teaches your tamed bear the Enraging Bite ability. Enraging Bite reduces an enemy's resistance to physical attacks as well as drawing its attention.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo orso addomesticato l’abilità Enraging Bite. Enraging Bite riduce la resistenza del nemico agli attacchi fisici e attira la sua attenzione.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4732, Description_lang.
    [4732] = { en = "Teaches your tamed bear the Roar of Fortitude ability. Roar of Fortitude increases the maximum health of everyone in your party.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo orso addomesticato l’abilità Roar of Fortitude. Roar of Fortitude aumenta la salute massima di tutti i membri del gruppo.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4733, Description_lang.
    [4733] = { en = "Teaches your tamed boar the Gore ability. Gore deals physical damage over time to an enemy.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo cinghiale addomesticato l’abilità Gore. Gore infligge danni fisici periodici a un nemico.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4734, Description_lang.
    [4734] = { en = "Teaches your tamed boar the Toughen Hide ability. Toughen Hide increases resistance to physical attacks.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo cinghiale addomesticato l’abilità Toughen Hide. Toughen Hide aumenta la resistenza agli attacchi fisici.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4735, Description_lang.
    [4735] = { en = "Teaches your tamed boar the Vital Wound ability. Vital Wound slows the attack speed of an enemy.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo cinghiale addomesticato l’abilità Vital Wound. Vital Wound riduce la velocità d’attacco del nemico.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4736, Description_lang.
    [4736] = { en = "Teaches your tamed bird the Flight of the Peregrine ability. Flight of the Peregrine increase the movement speed of the bird.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo uccello addomesticato l’abilità Flight of the Peregrine. Flight of the Peregrine aumenta la velocità di movimento dell’uccello.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4737, Description_lang.
    [4737] = { en = "Teaches your tamed bird the Eye Peck ability. Eye Peck causes an enemy to miss more often in combat.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo uccello addomesticato l’abilità Eye Peck. Eye Peck aumenta la probabilità che il nemico manchi i colpi in combattimento.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4740, Description_lang.
    [4740] = { en = "Teaches your tamed cat the Ferocity ability. Ferocity increases attack speed of the cat at the cost of receiving more damage when hit by phsical attacks.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo felino addomesticato l’abilità Ferocity. Ferocity aumenta la velocità d’attacco del felino, che subisce però più danni dagli attacchi fisici.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4742, Description_lang.
    [4742] = { en = "Teaches your tamed crab the Tough Shell ability. Tough Shell gives your crab a chance to increase it's armor value when hit.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo granchio addomesticato l’abilità Tough Shell. Tough Shell può aumentare l’armatura del granchio quando viene colpito.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4743, Description_lang.
    [4743] = { en = "Teaches your tamed crab the Tough Shell ability. Tough Shell gives your crab a chance to increase it's armor value when hit.\r\nRequires: \r\nPet Level 21+", description = "Insegna al tuo granchio addomesticato l’abilità Tough Shell. Tough Shell può aumentare l’armatura del granchio quando viene colpito.\r\nRichiede: \r\nLivello 21+ della mascotte" },
    -- Spell.db2 ID 4744, Description_lang.
    [4744] = { en = "Teaches your tamed crab the Tough Shell ability. Tough Shell gives your crab a chance to increase it's armor value when hit.\r\nRequires: \r\nPet Level 28+", description = "Insegna al tuo granchio addomesticato l’abilità Tough Shell. Tough Shell può aumentare l’armatura del granchio quando viene colpito.\r\nRichiede: \r\nLivello 28+ della mascotte" },
    -- Spell.db2 ID 4745, Description_lang.
    [4745] = { en = "Teaches your tamed crab the Tough Shell ability. Tough Shell gives your crab a chance to increase it's armor value when hit.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo granchio addomesticato l’abilità Tough Shell. Tough Shell può aumentare l’armatura del granchio quando viene colpito.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4746, Description_lang.
    [4746] = { en = "Teaches your tamed crab the Tight Pinch ability. Tight Pinch deals additional damage on the crab's next hit as well as stunning the enemy.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo granchio addomesticato l’abilità Tight Pinch. Tight Pinch infligge danni aggiuntivi al prossimo colpo del granchio e stordisce il nemico.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4747, Description_lang.
    [4747] = { en = "Teaches your tamed crab the Clenched Pinchers ability. Clenched Pinchers holds an enemy in place while dealing physical damage over time to it. While holding the enemy, the crab will be unable to attack or perform any other actions.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo granchio addomesticato l’abilità Clenched Pinchers. Clenched Pinchers immobilizza il nemico e gli infligge danni fisici periodici. Mentre lo trattiene, il granchio non può attaccare né compiere altre azioni.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4748, Description_lang.
    [4748] = { en = "Teaches your tamed crocilisk the Quick Snap ability. Quick Snap gives your crocilisk a chance to counterattack when hit.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo crocilisco addomesticato l’abilità Quick Snap. Quick Snap dà al crocilisco la possibilità di contrattaccare quando viene colpito.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4750, Description_lang.
    [4750] = { en = "Teaches your tamed crocilisk the Consume Flesh ability. Consume Flesh gives your crocilisk a chance to steal health from an enemy when attacking.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo crocilisco addomesticato l’abilità Consume Flesh. Consume Flesh dà al crocilisco la possibilità di sottrarre salute al nemico quando attacca.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4766, Description_lang.
    [4766] = { en = "Teaches your tamed horse the Rapid Gallop ability. Rapid Gallop increases the movement speed of your horse.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo cavallo addomesticato l’abilità Rapid Gallop. Rapid Gallop aumenta la velocità di movimento del cavallo.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4767, Description_lang.
    [4767] = { en = "Teaches your tamed horse the Stomp ability. Stomp deals additional damage as well as slowing the movement speed of the enemy.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo cavallo addomesticato l’abilità Stomp. Stomp infligge danni aggiuntivi e riduce la velocità di movimento del nemico.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4768, Description_lang.
    [4768] = { en = "Teaches your tamed raptor the Feast of Prey ability. Feast of Prey allows your raptor to recover health every time it kills an enemy.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo raptor addomesticato l’abilità Feast of Prey. Feast of Prey permette al raptor di recuperare salute ogni volta che uccide un nemico.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4769, Description_lang.
    [4769] = { en = "Teaches your tamed raptor the Vulnerable ability. Vulnerable increases all physical damage done to an enemy for a short time.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo raptor addomesticato l’abilità Vulnerable. Vulnerable aumenta per breve tempo tutti i danni fisici inflitti a un nemico.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4770, Description_lang.
    [4770] = { en = "Teaches your tamed raptor the Tendon Slice ability. Tendon Slice deals damage over time as well as slowing the enemies movement speed.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo raptor addomesticato l’abilità Tendon Slice. Tendon Slice infligge danni periodici e riduce la velocità di movimento dei nemici.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4771, Description_lang.
    [4771] = { en = "Teaches your tamed gorilla the Bruise ability. Bruise gives your gorilla a chance to reduce the armor value of an enemy when attacking.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo gorilla addomesticato l’abilità Bruise. Bruise dà al gorilla la possibilità di ridurre l’armatura del nemico quando attacca.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4772, Description_lang.
    [4772] = { en = "Teaches your tamed gorilla the Bruise ability. Bruise gives your gorilla a chance to reduce the armor value of an enemy when attacking.\r\nRequires: \r\nPet Level 21+", description = "Insegna al tuo gorilla addomesticato l’abilità Bruise. Bruise dà al gorilla la possibilità di ridurre l’armatura del nemico quando attacca.\r\nRichiede: \r\nLivello 21+ della mascotte" },
    -- Spell.db2 ID 4773, Description_lang.
    [4773] = { en = "Teaches your tamed gorilla the Bruise ability. Bruise gives your gorilla a chance to reduce the armor value of an enemy when attacking.\r\nRequires: \r\nPet Level 28+", description = "Insegna al tuo gorilla addomesticato l’abilità Bruise. Bruise dà al gorilla la possibilità di ridurre l’armatura del nemico quando attacca.\r\nRichiede: \r\nLivello 28+ della mascotte" },
    -- Spell.db2 ID 4774, Description_lang.
    [4774] = { en = "Teaches your tamed gorilla the Bruise ability. Bruise gives your gorilla a chance to reduce the armor value of an enemy when attacking.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo gorilla addomesticato l’abilità Bruise. Bruise dà al gorilla la possibilità di ridurre l’armatura del nemico quando attacca.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4775, Description_lang.
    [4775] = { en = "Teaches your tamed gorilla the Throw Rock ability. Throw Rock is a ranged attack.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo gorilla addomesticato l’abilità Throw Rock. Throw Rock è un attacco a distanza.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4777, Description_lang.
    [4777] = { en = "Teaches your tamed gorilla the Quickness ability. Quickness is an attack that can hit multiple enemies.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo gorilla addomesticato l’abilità Quickness. Quickness è un attacco che può colpire più nemici.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4782, Description_lang.
    [4782] = { en = "Teaches your tamed spider the Web ability. Web renders an enemy unable to move.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo ragno addomesticato l’abilità Web. Web immobilizza un nemico.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4804, Description_lang.
    [4804] = { en = "Teaches your tamed spider the Poisonous Spit ability. Poisonous Spit ranged attack that deals damage over time to an enemy.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo ragno addomesticato l’abilità Poisonous Spit. Poisonous Spit è un attacco a distanza che infligge danni periodici a un nemico.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4807, Description_lang.
    [4807] = { en = "Teaches your tamed tall strider the Healing Tongue ability. Healing Tongue heals friendly targets from a short range.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo strider alto addomesticato l’abilità Healing Tongue. Healing Tongue cura i bersagli alleati a breve distanza.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 4808, Description_lang.
    [4808] = { en = "Teaches your tamed tall strider the Healing Tongue ability. Healing Tongue heals friendly targets from a short range.\r\nRequires: \r\nPet Level 28+", description = "Insegna al tuo strider alto addomesticato l’abilità Healing Tongue. Healing Tongue cura i bersagli alleati a breve distanza.\r\nRichiede: \r\nLivello 28+ della mascotte" },
    -- Spell.db2 ID 4814, Description_lang.
    [4814] = { en = "Teaches your tamed tall strider the Strider Presence ability. Strider Presence helps regenerate health and mana.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo strider alto addomesticato l’abilità Strider Presence. Strider Presence aiuta a rigenerare salute e mana.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 4815, Description_lang.
    [4815] = { en = "Teaches your tamed wolf the Enraged Howl ability. Enraged Howl increases your party's strength and agility.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo lupo addomesticato l’abilità Enraged Howl. Enraged Howl aumenta la forza e l’agilità del gruppo.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 4816, Description_lang.
    [4816] = { en = "Teaches your tamed wolf the Rabid Maw ability. Rabid Maw decreases an enemy's strength and agility.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo lupo addomesticato l’abilità Rabid Maw. Rabid Maw riduce la forza e l’agilità di un nemico.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 5287, Description_lang.
    [5287] = { en = "Teaches Mark of the Wild (Rank 3).", description = "Insegna Mark of the Wild (grado 3)." },
    -- Spell.db2 ID 5316, Description_lang.
    [5316] = { en = "Place at a scytheclaw nest.", description = "Posiziona presso un nido di Scytheclaw." },
    -- Spell.db2 ID 5378, Description_lang.
    [5378] = { en = "Teaches your tamed turtle the Thick Skin ability. Thick Skin gives your turtle a chance to increase it's armor value when hit.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo tartaruga addomesticato l’abilità Thick Skin. Thick Skin può aumentare l’armatura della tartaruga quando viene colpita.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 5383, Description_lang.
    [5383] = { en = "Teaches your tamed turtle the Hand Snap ability. Hand Snap disarms an enemy as well as causing damage over time.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo tartaruga addomesticato l’abilità Hand Snap. Hand Snap disarma il nemico e gli infligge danni periodici.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 5398, Description_lang.
    [5398] = { en = "Teaches your tamed scorpion the Claw Cover ability. Claw Cover increases your scorpion's chance to parry.\r\nRequires: \r\nPet Level 36+", description = "Insegna al tuo scorpione addomesticato l’abilità Claw Cover. Claw Cover aumenta la probabilità di parata dello scorpione.\r\nRichiede: \r\nLivello 36+ della mascotte" },
    -- Spell.db2 ID 5399, Description_lang.
    [5399] = { en = "Teaches your tamed scorpion the Minor Scorpion Venom ability. Minor Scorpion Venom deals damage over time to an enemy.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo scorpione addomesticato l’abilità Minor Scorpion Venom. Minor Scorpion Venom infligge danni periodici a un nemico.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 6284, Description_lang.
    [6284] = { en = "Teaches your tamed pet to be tougher. This increases the base health of your pet by 50.", description = "Insegna alla tua mascotte addomesticata a diventare più resistente. Aumenta di 50 la sua salute base." },
    -- Spell.db2 ID 6287, Description_lang.
    [6287] = { en = "Teaches your tamed pet to be tougher. This increases the base health of your pet by 100.", description = "Insegna alla tua mascotte addomesticata a diventare più resistente. Aumenta di 100 la sua salute base." },
    -- Spell.db2 ID 6288, Description_lang.
    [6288] = { en = "Teaches your tamed pet to be tougher. This increases the base health of your pet by 150.", description = "Insegna alla tua mascotte addomesticata a diventare più resistente. Aumenta di 150 la sua salute base." },
    -- Spell.db2 ID 6289, Description_lang.
    [6289] = { en = "Teaches your tamed pet to be tougher. This increases the base health of your pet by 200.", description = "Insegna alla tua mascotte addomesticata a diventare più resistente. Aumenta di 200 la sua salute base." },
    -- Spell.db2 ID 6290, Description_lang.
    [6290] = { en = "Teaches your tamed pet to be tougher. This increases the base health of your pet by 250.", description = "Insegna alla tua mascotte addomesticata a diventare più resistente. Aumenta di 250 la sua salute base." },
    -- Spell.db2 ID 6312, Description_lang.
    [6312] = { en = "Teaches your tamed pet to be more aggressive. This increases the base damage done by your pet by 3.", description = "Insegna alla tua mascotte addomesticata a essere più aggressiva. Aumenta di 3 i danni base che infligge." },
    -- Spell.db2 ID 6318, Description_lang.
    [6318] = { en = "Teaches your tamed pet to be more aggressive. This increases the base damage done by your pet by 6.", description = "Insegna alla tua mascotte addomesticata a essere più aggressiva. Aumenta di 6 i danni base che infligge." },
    -- Spell.db2 ID 6319, Description_lang.
    [6319] = { en = "Teaches your tamed pet to be more aggressive. This increases the base damage done by your pet by 9.", description = "Insegna alla tua mascotte addomesticata a essere più aggressiva. Aumenta di 9 i danni base che infligge." },
    -- Spell.db2 ID 6320, Description_lang.
    [6320] = { en = "Teaches your tamed pet to be more aggressive. This increases the base damage done by your pet by 12.", description = "Insegna alla tua mascotte addomesticata a essere più aggressiva. Aumenta di 12 i danni base che infligge." },
    -- Spell.db2 ID 6321, Description_lang.
    [6321] = { en = "Teaches your tamed pet to be more aggressive. This increases the base damage done by your pet by 15.", description = "Insegna alla tua mascotte addomesticata a essere più aggressiva. Aumenta di 15 i danni base che infligge." },
    -- Spell.db2 ID 6329, Description_lang.
    [6329] = { en = "Teaches your tamed pet to recover from wounds faster.  This increases the pet's base Spirit by 5.", description = "Insegna alla tua mascotte addomesticata a riprendersi più rapidamente dalle ferite. Aumenta di 5 il suo Spirito base." },
    -- Spell.db2 ID 6335, Description_lang.
    [6335] = { en = "Teaches your tamed pet to recover from wounds faster.  This increases the pet's base Spirit by 10.", description = "Insegna alla tua mascotte addomesticata a riprendersi più rapidamente dalle ferite. Aumenta di 10 il suo Spirito base." },
    -- Spell.db2 ID 6336, Description_lang.
    [6336] = { en = "Teaches your tamed pet to recover from wounds faster.  This increases the pet's base Spirit by 15.", description = "Insegna alla tua mascotte addomesticata a riprendersi più rapidamente dalle ferite. Aumenta di 15 il suo Spirito base." },
    -- Spell.db2 ID 6337, Description_lang.
    [6337] = { en = "Teaches your tamed pet to recover from wounds faster.  This increases the pet's base Spirit by 20.", description = "Insegna alla tua mascotte addomesticata a riprendersi più rapidamente dalle ferite. Aumenta di 20 il suo Spirito base." },
    -- Spell.db2 ID 6338, Description_lang.
    [6338] = { en = "Teaches your tamed pet to recover from wounds faster.  This increases the pet's base Spirit by 25.", description = "Insegna alla tua mascotte addomesticata a riprendersi più rapidamente dalle ferite. Aumenta di 25 il suo Spirito base." },
    -- Spell.db2 ID 6448, Description_lang.
    [6448] = { en = "Teaches your tamed pet to be more resistant to magic.  This increases the pet's resistance to all magic schools to 3.", description = "Insegna alla tua mascotte addomesticata a essere più resistente alla magia. Porta a 3 la sua resistenza a tutte le scuole di magia." },
    -- Spell.db2 ID 6452, Description_lang.
    [6452] = { en = "Teaches your tamed pet to be more resistant to magic.  This increases the pet's resistance to all magic schools to 12.", description = "Insegna alla tua mascotte addomesticata a essere più resistente alla magia. Porta a 12 la sua resistenza a tutte le scuole di magia." },
    -- Spell.db2 ID 6453, Description_lang.
    [6453] = { en = "Teaches your tamed pet to be more resistant to magic.  This increases the pet's resistance to all magic schools to 12.", description = "Insegna alla tua mascotte addomesticata a essere più resistente alla magia. Porta a 12 la sua resistenza a tutte le scuole di magia." },
    -- Spell.db2 ID 6577, Description_lang.
    [6577] = { en = "Teaches your tamed wolf the Intimidating Growl ability. Intimidating Growl causes an enemy to run away in fear at an increased movement speed.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo lupo addomesticato l’abilità Intimidating Growl. Intimidating Growl fa fuggire il nemico impaurito a velocità di movimento aumentata.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 6582, Description_lang.
    [6582] = { en = "Teaches your tamed crocilisk the Pierce Ankle ability. Pierce Ankle knocks down an enemy and reduces it's movement speed.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo crocilisco addomesticato l’abilità Pierce Ankle. Pierce Ankle atterra il nemico e ne riduce la velocità di movimento.\r\nRichiede: \r\nLivello 13+ della mascotte" },
    -- Spell.db2 ID 6642, Description_lang.
    [6642] = { en = "Teaches Frost Shield (Rank 3).", description = "Insegna Frost Shield (grado 3)." },
    -- Spell.db2 ID 6666, Description_lang.
    [6666] = { en = "Teaches your tamed cat the Survival Instinct ability. Survival Instinct stuns an enemy and attempts to run away causing the enemy to lose interest in attacking the cat.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo felino addomesticato l’abilità Survival Instinct. Survival Instinct stordisce un nemico e tenta la fuga, facendo sì che il nemico perda interesse nell’attaccare il felino.\r\nRichiede: \r\nLivello 22+ della mascotte" },
    -- Spell.db2 ID 6768, Description_lang.
    [6768] = { en = "Performs a feint, causing no damage but lowering your threat by a medium amount, making the enemy less likely to attack you.", description = "Esegui una finta senza infliggere danni e riduci moderatamente la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 6777, Description_lang.
    [6777] = { en = "Summons and dismisses a rideable gray ram.", description = "Evoca e congeda la cavalcatura Montone Grigio." },
    -- Spell.db2 ID 6896, Description_lang.
    [6896] = { en = "Summons and dismisses a rideable black ram.", description = "Evoca e congeda la cavalcatura Montone Nero." },
    -- Spell.db2 ID 6898, Description_lang.
    [6898] = { en = "Summons and dismisses a rideable white ram.", description = "Evoca e congeda la cavalcatura Montone Bianco." },
    -- Spell.db2 ID 6899, Description_lang.
    [6899] = { en = "Summons and dismisses a rideable brown ram.", description = "Evoca e congeda la cavalcatura Montone Bruno." },
    -- Spell.db2 ID 7218, Description_lang.
    [7218] = { en = "Attaches a counterweight to a two-handed sword, mace, axe or polearm making it 3% faster.", description = "Applica un contrappeso a una spada, mazza, ascia o arma ad asta a due mani, aumentandone la velocità del 3%." },
    -- Spell.db2 ID 7220, Description_lang.
    [7220] = { en = "Attaches a chain to your weapon, making it impossible to disarm.", description = "Applica una catena all’arma, impedendo che venga disarmata." },
    -- Spell.db2 ID 7327, Description_lang.
    [7327] = { en = "Teaches Seal of Wisdom (Rank 1).", description = "Insegna Seal of Wisdom (grado 1)." },
    -- Spell.db2 ID 7974, Description_lang.
    [7974] = { en = "Gives Flight to Lord Azrethoc.", description = "Conferisce Flight a Lord Azrethoc." },
    -- Spell.db2 ID 8342, Description_lang.
    [8342] = { en = "Jumper Cables will sometimes be able to shock a dead player back to life.  Cannot be used when in combat.", description = "Jumper Cables possono a volte rianimare un giocatore morto con una scarica elettrica. Non si possono usare in combattimento." },
    -- Spell.db2 ID 8553, Description_lang.
    [8553] = { en = "Heats the blood and dulls the nerves.", description = "Riscalda il sangue e intorpidisce i nervi." },
    -- Spell.db2 ID 8605, Description_lang.
    [8605] = { en = "Teaches you how to cook a Herb Baked Egg.", description = "Insegna a cucinare Herb Baked Egg." },
    -- Spell.db2 ID 8717, Description_lang.
    [8717] = { en = "Learn Summon Felhunter.", description = "Insegna l’incantesimo Evocazione di Felhunter." },
    -- Spell.db2 ID 8838, Description_lang.
    [8838] = { en = "Teaches you how to sew Azure Silk Gloves.", description = "Insegna a cucire Azure Silk Gloves." },
    -- Spell.db2 ID 9783, Description_lang.
    [9783] = { en = "Attaches spurs to your boots that increase your mounted movement speed slightly.", description = "Applica degli speroni agli stivali, aumentando leggermente la velocità di movimento in sella." },
    -- Spell.db2 ID 10000, Description_lang.
    [10000] = { en = "Teaches you how to make a Wicked Mithril Blade.", description = "Insegna a preparare Wicked Mithril Blade." },
    -- Spell.db2 ID 10561, Description_lang.
    [10561] = { en = "Teaches you how to craft Big Voodoo Pants.", description = "Insegna a creare Big Voodoo Pants." },
    -- Spell.db2 ID 10571, Description_lang.
    [10571] = { en = "Teaches you how to craft Tough Scorpid Helm.", description = "Insegna a creare Tough Scorpid Helm." },
    -- Spell.db2 ID 10844, Description_lang.
    [10844] = { en = "Teaches you how to make Powerful Smelling Salts.", description = "Insegna a preparare Powerful Smelling Salts." },
    -- Spell.db2 ID 11886, Description_lang.
    [11886] = { en = "Shrink and Capture a Fallen Wildkin.", description = "Rimpicciolisci e cattura un Fallen Wildkin." },
    -- Spell.db2 ID 12143, Description_lang.
    [12143] = { en = "Teaches you how to sew Red Mageweave Gloves.", description = "Insegna a cucire Red Mageweave Gloves." },
    -- Spell.db2 ID 12472, Description_lang.
    [12472] = { en = "Finishes the remaining cooldown on all your other Frost spells.", description = "Azzera il tempo di recupero rimanente di tutti gli altri tuoi incantesimi di gelo." },
    -- Spell.db2 ID 13465, Description_lang.
    [13465] = { en = "Teaches you how to permanently enchant a shield with +30 armor.", description = "Insegna a incantare permanentemente shield conferendogli +30 armor." },
    -- Spell.db2 ID 13699, Description_lang.
    [13699] = { en = "Teaches you how to permanently enchant gloves to give +5 skinning skill.", description = "Insegna a incantare permanentemente gloves per conferire +5 skinning skill." },
    -- Spell.db2 ID 14814, Description_lang.
    [14814] = { en = "Throw near a patron of the Grim Guzzler", description = "Lancia vicino a un avventore del Grim Guzzler." },
    -- Spell.db2 ID 15299, Description_lang.
    [15299] = { en = "Teaches you how to make Dark Iron Plate.", description = "Insegna a preparare Dark Iron Plate." },
    -- Spell.db2 ID 15340, Description_lang.
    [15340] = { en = "Permanently adds 150 mana to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 150 punti mana a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15389, Description_lang.
    [15389] = { en = "Permanently adds 100 hit points to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 100 punti salute a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15391, Description_lang.
    [15391] = { en = "Permanently adds 125 armor to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 125 armatura a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15394, Description_lang.
    [15394] = { en = "Permanently adds 20 fire resistance to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 20 resistenza al fuoco a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15397, Description_lang.
    [15397] = { en = "Permanently adds 8 strength to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 8 forza a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15400, Description_lang.
    [15400] = { en = "Permanently adds 8 stamina to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 8 tempra a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15402, Description_lang.
    [15402] = { en = "Permanently adds 8 agility to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 8 agilità a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15404, Description_lang.
    [15404] = { en = "Permanently adds 8 intellect to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 8 intelletto a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15406, Description_lang.
    [15406] = { en = "Permanently adds 8 spirit to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 8 spirito a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 15779, Description_lang.
    [15779] = { en = "Summons and dismisses a rideable mechanical tallstrider.   This is a very fast mount.", description = "Evoca e congeda la cavalcatura mechanical tallstrider. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 15936, Description_lang.
    [15936] = { en = "Teaches you how to cook up a Crispy Bat Wing.", description = "Insegna a cucinare Crispy Bat Wing." },
    -- Spell.db2 ID 15975, Description_lang.
    [15975] = { en = "Teaches you how to make a Searing Golden Blade.", description = "Ti insegna a creare una Searing Golden Blade." },
    -- Spell.db2 ID 16055, Description_lang.
    [16055] = { en = "Summons and dismisses a rideable Nightsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Nightsaber. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16056, Description_lang.
    [16056] = { en = "Summons and dismisses a rideable Frostsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Frostsaber. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16058, Description_lang.
    [16058] = { en = "Summons and dismisses a rideable Leopard.", description = "Evoca e congeda la cavalcatura Leopardo Primordiale." },
    -- Spell.db2 ID 16059, Description_lang.
    [16059] = { en = "Summons and dismisses a rideable Tawny Saber Cat.", description = "Evoca e congeda la cavalcatura Fiera Fulva." },
    -- Spell.db2 ID 16080, Description_lang.
    [16080] = { en = "Summons and dismisses a rideable red wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Lupo Rosso. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16081, Description_lang.
    [16081] = { en = "Summons and dismisses a rideable arctic wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura arctic wolf. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16082, Description_lang.
    [16082] = { en = "Summons and dismisses a rideable Palomino.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Palomino. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16083, Description_lang.
    [16083] = { en = "Summons and dismisses a rideable white stallion.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Stallone Bianco. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16084, Description_lang.
    [16084] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor Rosso Chiazzato. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 16450, Description_lang.
    [16450] = { en = "Right Click to summon and dismiss your Smolderweb hatchling.", description = "Clic destro per evocare o congedare il tuo Smolderweb hatchling." },
    -- Spell.db2 ID 17161, Description_lang.
    [17161] = { en = "This container should be filled with water from the corrupt moon well in Jaedenar.", description = "Questo contenitore va riempito con l’acqua del pozzo lunare corrotto di Jaedenar." },
    -- Spell.db2 ID 17229, Description_lang.
    [17229] = { en = "Summons and dismisses a rideable Winterspring Frostsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Fiera Glaciale di Fontefredda. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17450, Description_lang.
    [17450] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor d'Avorio. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17459, Description_lang.
    [17459] = { en = "Summons and dismisses a rideable mechanical tallstrider.   This is a very fast mount.", description = "Evoca e congeda uno strider meccanico cavalcabile. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17460, Description_lang.
    [17460] = { en = "Summons and dismisses a rideable frost ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone del Gelo. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17461, Description_lang.
    [17461] = { en = "Summons and dismisses a rideable black ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17465, Description_lang.
    [17465] = { en = "Summons and dismisses a rideable skeletal warhorse.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Cavallo da Guerra Scheletrico Verde. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 17586, Description_lang.
    [17586] = { en = "Teaches you how to make a Major Healing Potion.", description = "Insegna a preparare Major Healing Potion." },
    -- Spell.db2 ID 17708, Description_lang.
    [17708] = { en = "Right Click to summon and dismiss Diablo.", description = "Clic destro per evocare o congedare Diablo." },
    -- Spell.db2 ID 17809, Description_lang.
    [17809] = { en = "Fire damage proc.", description = "Effetto di danni da fuoco all’attivazione." },
    -- Spell.db2 ID 17933, Description_lang.
    [17933] = { en = "Fire damage proc.", description = "Effetto di danni da fuoco all’attivazione." },
    -- Spell.db2 ID 17934, Description_lang.
    [17934] = { en = "Fire damage proc.", description = "Effetto di danni da fuoco all’attivazione." },
    -- Spell.db2 ID 17935, Description_lang.
    [17935] = { en = "Fire damage proc.", description = "Effetto di danni da fuoco all’attivazione." },
    -- Spell.db2 ID 18153, Description_lang.
    [18153] = { en = "Kodo Kombobulator on any Ancient, Aged, or Dying Kodo to lure the Kodo to follow (one at a time).", description = "Usa il Kodo Kombobulator su un Ancient, Aged o Dying Kodo per attirarlo e farlo seguire (uno alla volta)." },
    -- Spell.db2 ID 18520, Description_lang.
    [18520] = { en = "Charisma tooltip.", description = "Descrizione di Carisma." },
    -- Spell.db2 ID 18989, Description_lang.
    [18989] = { en = "Summons and dismisses a rideable gray kodo.", description = "Evoca e congeda la cavalcatura Kodo Grigio." },
    -- Spell.db2 ID 18990, Description_lang.
    [18990] = { en = "Summons and dismisses a rideable brown kodo.", description = "Evoca e congeda la cavalcatura Kodo Bruno." },
    -- Spell.db2 ID 18991, Description_lang.
    [18991] = { en = "Summons and dismisses a rideable green kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo Verde. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 18992, Description_lang.
    [18992] = { en = "Summons and dismisses a rideable teal kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo Verdeacqua. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 19169, Description_lang.
    [19169] = { en = "Teaches you how to craft Volcanic Leggings.", description = "Insegna a creare Volcanic Leggings." },
    -- Spell.db2 ID 19204, Description_lang.
    [19204] = { en = "Teaches you how to craft Devilsaur Gauntlets.", description = "Insegna a creare Devilsaur Gauntlets." },
    -- Spell.db2 ID 19470, Description_lang.
    [19470] = { en = "Places gem in Naga statue", description = "Posiziona la gemma nella statua naga." },
    -- Spell.db2 ID 19548, Description_lang.
    [19548] = { en = "Begins taming an Ice Claw Bear to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare an Ice Claw Bear come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19595, Description_lang.
    [19595] = { en = "Reflect shadow and frost spells back at their caster", description = "Riflette gli incantesimi d’ombra e di gelo sull’incantatore." },
    -- Spell.db2 ID 19674, Description_lang.
    [19674] = { en = "Begins taming a Large Crag Boar to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Large Crag Boar come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19687, Description_lang.
    [19687] = { en = "Begins taming a Snow Leopard to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Snow Leopard come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19688, Description_lang.
    [19688] = { en = "Begins taming an Adult Plainstrider to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare an Adult Plainstrider come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19689, Description_lang.
    [19689] = { en = "Begins taming a Prairie Stalker to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Prairie Stalker come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19692, Description_lang.
    [19692] = { en = "Begins taming a Swoop to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Swoop come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19693, Description_lang.
    [19693] = { en = "Begins taming a Webwood Lurker to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Webwood Lurker come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19694, Description_lang.
    [19694] = { en = "Begins taming a Dire Mottled Boar to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Dire Mottled Boar come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19696, Description_lang.
    [19696] = { en = "Begins taming a Surf Crawler to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Surf Crawler come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19697, Description_lang.
    [19697] = { en = "Begins taming an Armored Scorpid to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare an Armored Scorpid come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19699, Description_lang.
    [19699] = { en = "Begins taming a Nightsaber Stalker to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Nightsaber Stalker come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 19700, Description_lang.
    [19700] = { en = "Begins taming a Strigid Screecher to be your companion for 10 minutes.  If you lose the beast's attention for any reason, the taming process will fail.", description = "Inizia ad addomesticare a Strigid Screecher come tuo compagno per 10 minuti. Se per qualsiasi motivo perdi l’attenzione della bestia, l’addomesticamento fallisce." },
    -- Spell.db2 ID 20318, Description_lang.
    [20318] = { en = "Teaches Imp Blood Pact (Rank 2).", description = "Insegna Imp Blood Pact (grado 2)." },
    -- Spell.db2 ID 20319, Description_lang.
    [20319] = { en = "Teaches Imp Blood Pact (Rank 3).", description = "Insegna Imp Blood Pact (grado 3)." },
    -- Spell.db2 ID 20320, Description_lang.
    [20320] = { en = "Teaches Imp Blood Pact (Rank 4).", description = "Insegna Imp Blood Pact (grado 4)." },
    -- Spell.db2 ID 20321, Description_lang.
    [20321] = { en = "Teaches Imp Blood Pact (Rank 5).", description = "Insegna Imp Blood Pact (grado 5)." },
    -- Spell.db2 ID 20397, Description_lang.
    [20397] = { en = "Teaches Imp Blood Pact (Rank 1).", description = "Insegna Imp Blood Pact (grado 1)." },
    -- Spell.db2 ID 22717, Description_lang.
    [22717] = { en = "Summons and dismisses a rideable Black War Steed.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Destriero da Guerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22718, Description_lang.
    [22718] = { en = "Summons and dismisses a rideable Black War Kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo da Guerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22719, Description_lang.
    [22719] = { en = "Summons and dismisses a rideable black battlestrider.   This is a very fast mount.", description = "Evoca e congeda la cavalcatura Calcaguerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22720, Description_lang.
    [22720] = { en = "Summons and dismisses a rideable black war ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone da Guerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22721, Description_lang.
    [22721] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor da Guerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22722, Description_lang.
    [22722] = { en = "Summons and dismisses a rideable red skeletal warhorse.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Cavallo da Guerra Scheletrico Rosso. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22723, Description_lang.
    [22723] = { en = "Summons and dismisses a rideable Black War Tiger.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Tigre da Guerra Nera. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22724, Description_lang.
    [22724] = { en = "Summons and dismisses a rideable black war wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Lupo da Guerra Nero. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 22999, Description_lang.
    [22999] = { en = "Jumper Cables will sometimes be able to shock a dead player back to life.  Cannot be used when in combat.", description = "Jumper Cables possono a volte rianimare un giocatore morto con una scarica elettrica. Non si possono usare in combattimento." },
    -- Spell.db2 ID 23219, Description_lang.
    [23219] = { en = "Summons and dismisses a rideable Swift Mistsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Fiera della Nebbia Rapida. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23220, Description_lang.
    [23220] = { en = "Summons and dismisses a rideable Swift Dawnsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Fiera dell'Alba Rapida. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23221, Description_lang.
    [23221] = { en = "Summons and dismisses a rideable Swift Frostsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Fiera Glaciale Rapida. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23227, Description_lang.
    [23227] = { en = "Summons and dismisses a rideable Swift Palomino.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Palomino Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23228, Description_lang.
    [23228] = { en = "Summons and dismisses a rideable Swift White Steed.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Destriero Bianco Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23229, Description_lang.
    [23229] = { en = "Summons and dismisses a rideable Swift Brown Steed.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Destriero Bruno Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23238, Description_lang.
    [23238] = { en = "Summons and dismisses a rideable swift brown ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone Bruno Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23239, Description_lang.
    [23239] = { en = "Summons and dismisses a rideable swift gray ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone Grigio Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23240, Description_lang.
    [23240] = { en = "Summons and dismisses a rideable swift white ram.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Montone Bianco Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23241, Description_lang.
    [23241] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor Blu Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23242, Description_lang.
    [23242] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor Oliva Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23243, Description_lang.
    [23243] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor Arancio Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23246, Description_lang.
    [23246] = { en = "Summons and dismisses a rideable skeletal warhorse.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Cavallo da Guerra Scheletrico Viola. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23247, Description_lang.
    [23247] = { en = "Summons and dismisses a rideable kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo Bianco Grande. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23248, Description_lang.
    [23248] = { en = "Summons and dismisses a rideable kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo Grigio Grande. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23249, Description_lang.
    [23249] = { en = "Summons and dismisses a rideable kodo.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Kodo Bruno Grande. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23250, Description_lang.
    [23250] = { en = "Summons and dismisses a rideable wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Lupo Bruno Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23251, Description_lang.
    [23251] = { en = "Summons and dismisses a rideable wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Lupo della Foresta Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23252, Description_lang.
    [23252] = { en = "Summons and dismisses a rideable wolf.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Lupo Grigio Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23338, Description_lang.
    [23338] = { en = "Summons and dismisses a rideable Swift Stormsaber.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Fiera della Tempesta Rapida. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23357, Description_lang.
    [23357] = { en = "Teaches Beast Training, Feed Pet and Revive Pet.", description = "Insegna Beast Training, Feed Pet and Revive Pet." },
    -- Spell.db2 ID 23509, Description_lang.
    [23509] = { en = "Summons and dismisses a rideable Frostwolf Howler.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Belva dei Lupi Bianchi. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23510, Description_lang.
    [23510] = { en = "Summons and dismisses a rideable Stormpike Battle Charger.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Gran Destriero da Guerra dei Piccatonante. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 24242, Description_lang.
    [24242] = { en = "Summons and dismisses a rideable Raptor.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Raptor Razzashi Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 24252, Description_lang.
    [24252] = { en = "Summons and dismisses a rideable Tiger.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Tigre Zuliana Rapida. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 24576, Description_lang.
    [24576] = { en = "Summons and dismisses a rideable Chromatic Drake.  This is a very fast mount. You wish!", description = "Evoca e congeda la cavalcatura Draco Cromatico. È una cavalcatura molto veloce. Magari!" },
    -- Spell.db2 ID 25666, Description_lang.
    [25666] = { en = "Teaches you how to cook a delicious Giant Clam Scorcho.", description = "Insegna a cucinare delicious Giant Clam Scorcho." },
    -- Spell.db2 ID 25972, Description_lang.
    [25972] = { en = "Teaches Rejuvenation (Rank 11).", description = "Insegna Rejuvenation (grado 11)." },
    -- Spell.db2 ID 25973, Description_lang.
    [25973] = { en = "Teaches Backstab (Rank 9).", description = "Insegna Backstab (grado 9)." },
    -- Spell.db2 ID 25974, Description_lang.
    [25974] = { en = "Teaches Deadly Poison (Rank 5).", description = "Insegna Deadly Poison (grado 5)." },
    -- Spell.db2 ID 25976, Description_lang.
    [25976] = { en = "Teaches Feint (Rank 5).", description = "Insegna Feint (grado 5)." },
    -- Spell.db2 ID 25979, Description_lang.
    [25979] = { en = "Teaches Arcane Missiles (Rank 8).", description = "Insegna Arcane Missiles (grado 8)." },
    -- Spell.db2 ID 25983, Description_lang.
    [25983] = { en = "Teaches Greater Heal (Rank 5).", description = "Insegna Greater Heal (grado 5)." },
    -- Spell.db2 ID 26091, Description_lang.
    [26091] = { en = "Teaches you how to sew a Core Felcloth Bag.", description = "Insegna a cucire Core Felcloth Bag." },
    -- Spell.db2 ID 27727, Description_lang.
    [27727] = { en = "Teaches you how to sew an Enchanted Runecloth Bag.", description = "Insegna a cucire Enchanted Runecloth Bag." },
    -- Spell.db2 ID 27785, Description_lang.
    [27785] = { en = "Your normal ranged attacks have a 4% chance of restoring 200 mana.", description = "I normali attacchi a distanza hanno il 4% di probabilità di ripristinare 200 punti mana." },
    -- Spell.db2 ID 27834, Description_lang.
    [27834] = { en = "Teaches you how to make a Sageblade.", description = "Insegna a preparare Sageblade." },
    -- Spell.db2 ID 28155, Description_lang.
    [28155] = { en = "Increases your spell damage by up to 120 and your healing by up to 300. ", description = "Aumenta i danni degli incantesimi fino a 120 e le cure fino a 300." },
    -- Spell.db2 ID 28245, Description_lang.
    [28245] = { en = "Teaches you how to make an Icebane Breastplate.", description = "Insegna a preparare Icebane Breastplate." },
    -- Spell.db2 ID 7434, Description_lang.
    [7434] = { en = "Imbue a melee weapon to do 4 points of additional damage to beasts for 30 minutes.", description = "Imbeve un’arma da mischia, facendole infliggere 4 danni aggiuntivi alle bestie per 30 minuti." },
    -- Spell.db2 ID 7439, Description_lang.
    [7439] = { en = "Imbue a cloak with 4 points of resistance against all magic for 60 minutes.", description = "Imbeve un mantello, conferendo 4 punti di resistenza a tutta la magia per 60 minuti." },
    -- Spell.db2 ID 7448, Description_lang.
    [7448] = { en = "Imbue a piece of chest armor for 60 minutes so it has a 5% chance per hit of giving you 25 points of damage absorption.", description = "Imbeve un pezzo di armatura per il torace per 60 minuti. Ogni colpo ha il 5% di probabilità di conferire 25 punti di assorbimento dei danni." },
    -- Spell.db2 ID 7451, Description_lang.
    [7451] = { en = "Imbue a piece of chest armor with regenerative properties that increase the wearers spirit by 3 for 60 minutes.", description = "Imbeve un pezzo di armatura per il torace con proprietà rigenerative che aumentano di 3 lo Spirito di chi lo indossa per 60 minuti." },
    -- Spell.db2 ID 7745, Description_lang.
    [7745] = { en = "Permanently enchant a Two-Handed Melee Weapon to do 4 additional points of damage.", description = "Incanta permanentemente a Two-Handed Melee Weapon per infliggere 4 danni aggiuntivi." },
    -- Spell.db2 ID 7766, Description_lang.
    [7766] = { en = "Permanently enchant bracers so they increase the wearer's Spirit by 3.", description = "Incanta permanentemente bracers per aumentare di 3 Spirit di chi lo indossa." },
    -- Spell.db2 ID 7769, Description_lang.
    [7769] = { en = "Imbue bracers with wisdom that increases the wearers intellect by 4 for 60 minutes.", description = "Imbeve i bracciali con saggezza, aumentando di 4 l’Intelletto di chi li indossa per 60 minuti." },
    -- Spell.db2 ID 7782, Description_lang.
    [7782] = { en = "Permanently enchant bracers so they increase the wearer's Strength by 3.", description = "Incanta permanentemente bracers per aumentare di 3 Strength di chi lo indossa." },
    -- Spell.db2 ID 7786, Description_lang.
    [7786] = { en = "Permanently enchant a Melee Weapon to do 2 additional points of damage to Beasts.", description = "Incanta permanentemente a Melee Weapon per infliggere 2 danni aggiuntivi alle bestie." },
    -- Spell.db2 ID 7793, Description_lang.
    [7793] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 5 to Intellect.", description = "Incanta permanentemente a Two-Handed Melee Weapon per aumentare di 5 intelletto." },
    -- Spell.db2 ID 7809, Description_lang.
    [7809] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.  More effective than Torment (Rank 1).", description = "Provoca la creatura, aumentando la probabilità che attacchi il Voidwalker. Più efficace di Torment (grado 1)." },
    -- Spell.db2 ID 7810, Description_lang.
    [7810] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.  More effective than Torment (Rank 2).", description = "Provoca la creatura, aumentando la probabilità che attacchi il Voidwalker. Più efficace di Torment (grado 2)." },
    -- Spell.db2 ID 7811, Description_lang.
    [7811] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.  More effective than Torment (Rank 3).", description = "Provoca la creatura, aumentando la probabilità che attacchi il Voidwalker. Più efficace di Torment (grado 3)." },
    -- Spell.db2 ID 7813, Description_lang.
    [7813] = { en = "Soothes the target, increasing the chance that it will attack something else.  More effective than Soothing Kiss (Rank 1).", description = "Calma il bersaglio, aumentando la probabilità che attacchi qualcos’altro. Più efficace di Soothing Kiss (grado 1)." },
    -- Spell.db2 ID 7853, Description_lang.
    [7853] = { en = "Imbue a piece of chest armor with regenerative properties that increase the wearers spirit by 6 for 60 minutes.", description = "Imbeve un pezzo di armatura per il torace con proprietà rigenerative che aumentano di 6 lo Spirito di chi lo indossa per 60 minuti." },
    -- Spell.db2 ID 7855, Description_lang.
    [7855] = { en = "Imbue a piece of chest armor for 60 minutes so it has a 5% chance per hit of giving you 50 points of damage absorption.", description = "Imbeve un pezzo di armatura per il torace per 60 minuti. Ogni colpo ha il 5% di probabilità di conferire 50 punti di assorbimento dei danni." },
    -- Spell.db2 ID 7863, Description_lang.
    [7863] = { en = "Permanently enchant a pair of boots so they increase the wearer's Stamina by 3.", description = "Incanta permanentemente a pair of boots per aumentare di 3 Stamina di chi lo indossa." },
    -- Spell.db2 ID 7865, Description_lang.
    [7865] = { en = "Imbue a cloak to provide 10 additional points of armor for 60 minutes.", description = "Imbeve un mantello, conferendo 10 punti armatura aggiuntivi per 60 minuti." },
    -- Spell.db2 ID 7867, Description_lang.
    [7867] = { en = "Permanently enchant a pair of boots so they increase the wearer's Agility by 3.", description = "Incanta permanentemente a pair of boots per aumentare di 3 Agility di chi lo indossa." },
    -- Spell.db2 ID 9991, Description_lang.
    [9991] = { en = "You carry the Touch of Zanzil. The poison courses through your veins. Seek aid!", description = "Sei affetto dal Touch of Zanzil. Il veleno ti scorre nelle vene. Cerca aiuto!" },
    -- Spell.db2 ID 11774, Description_lang.
    [11774] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.  More effective than Torment (Rank 4).", description = "Provoca la creatura, aumentando la probabilità che attacchi il Voidwalker. Più efficace di Torment (grado 4)." },
    -- Spell.db2 ID 11775, Description_lang.
    [11775] = { en = "Taunts the creature, increasing the chance that it will attack the Voidwalker.  More effective than Torment (Rank 5).", description = "Provoca la creatura, aumentando la probabilità che attacchi il Voidwalker. Più efficace di Torment (grado 5)." },
    -- Spell.db2 ID 11784, Description_lang.
    [11784] = { en = "Soothes the target, increasing the chance that it will attack something else.  More effective than Soothing Kiss (Rank 2).", description = "Calma il bersaglio, aumentando la probabilità che attacchi qualcos’altro. Più efficace di Soothing Kiss (grado 2)." },
    -- Spell.db2 ID 11785, Description_lang.
    [11785] = { en = "Soothes the target, increasing the chance that it will attack something else.  More effective than Soothing Kiss (Rank 3).", description = "Calma il bersaglio, aumentando la probabilità che attacchi qualcos’altro. Più efficace di Soothing Kiss (grado 3)." },
    -- Spell.db2 ID 13380, Description_lang.
    [13380] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 5 to Spirit.", description = "Incanta permanentemente a Two-Handed Melee Weapon per aumentare di 5 spirito." },
    -- Spell.db2 ID 13419, Description_lang.
    [13419] = { en = "Permanently enchant a cloak to grant +3 Agility.", description = "Incanta permanentemente a cloak per conferire +3 Agility." },
    -- Spell.db2 ID 13464, Description_lang.
    [13464] = { en = "Permanently enchant a shield to increase its armor by 30.", description = "Incanta permanentemente a shield per aumentare di 30 its armor." },
    -- Spell.db2 ID 13503, Description_lang.
    [13503] = { en = "Permanently enchant a Melee Weapon to do 2 additional points of damage.", description = "Incanta permanentemente a Melee Weapon per infliggere 2 danni aggiuntivi." },
    -- Spell.db2 ID 13529, Description_lang.
    [13529] = { en = "Permanently enchant a Two-handed Melee Weapon to do 5 additional points of damage.", description = "Incanta permanentemente a Two-handed Melee Weapon per infliggere 5 danni aggiuntivi." },
    -- Spell.db2 ID 13612, Description_lang.
    [13612] = { en = "Permanently enchant gloves to grant +2 mining skill.", description = "Incanta permanentemente gloves per conferire +2 mining skill." },
    -- Spell.db2 ID 13617, Description_lang.
    [13617] = { en = "Permanently enchant gloves to grant +2 herbalism skill.", description = "Incanta permanentemente gloves per conferire +2 herbalism skill." },
    -- Spell.db2 ID 13620, Description_lang.
    [13620] = { en = "Permanently enchant gloves to grant +2 fishing skill.", description = "Incanta permanentemente gloves per conferire +2 fishing skill." },
    -- Spell.db2 ID 13653, Description_lang.
    [13653] = { en = "Permanently enchant a Melee Weapon to do 6 additional points of damage to Beasts.", description = "Incanta permanentemente a Melee Weapon per infliggere 6 danni aggiuntivi alle bestie." },
    -- Spell.db2 ID 13687, Description_lang.
    [13687] = { en = "Permanently enchant boots to give +4 Spirit.", description = "Incanta permanentemente boots per conferire +4 Spirit." },
    -- Spell.db2 ID 13693, Description_lang.
    [13693] = { en = "Permanently enchant a Melee Weapon to do 3 additional points of damage.", description = "Incanta permanentemente a Melee Weapon per infliggere 3 danni aggiuntivi." },
    -- Spell.db2 ID 13695, Description_lang.
    [13695] = { en = "Permanently enchant a Two-handed Melee Weapon to do 6 additional points of damage.", description = "Incanta permanentemente a Two-handed Melee Weapon per infliggere 6 danni aggiuntivi." },
    -- Spell.db2 ID 13698, Description_lang.
    [13698] = { en = "Permanently enchant gloves to grant +5 skinning skill.", description = "Incanta permanentemente gloves per conferire +5 skinning skill." },
    -- Spell.db2 ID 13817, Description_lang.
    [13817] = { en = "Permanently enchant a shield to give +7 Stamina.", description = "Incanta permanentemente a shield per conferire +7 Stamina." },
    -- Spell.db2 ID 13841, Description_lang.
    [13841] = { en = "Permanently enchant gloves to grant +5 mining skill.", description = "Incanta permanentemente gloves per conferire +5 mining skill." },
    -- Spell.db2 ID 13868, Description_lang.
    [13868] = { en = "Permanently enchant gloves to grant +5 herbalism skill.", description = "Incanta permanentemente gloves per conferire +5 herbalism skill." },
    -- Spell.db2 ID 13933, Description_lang.
    [13933] = { en = "Permanently enchant a shield to give +8 Frost Resistance.", description = "Incanta permanentemente a shield per conferire +8 Frost Resistance." },
    -- Spell.db2 ID 13937, Description_lang.
    [13937] = { en = "Permanently enchant a two-handed melee weapon to do +7 damage.", description = "Incanta permanentemente a two-handed melee weapon per aumentare i danni di 7." },
    -- Spell.db2 ID 13943, Description_lang.
    [13943] = { en = "Permanently enchant a Melee Weapon to do 4 additional points of damage.", description = "Incanta permanentemente a Melee Weapon per infliggere 4 danni aggiuntivi." },
    -- Spell.db2 ID 14274, Description_lang.
    [14274] = { en = "Distract the target, causing threat.  More effective than Distracting Shot (Rank 1).", description = "Distrae il bersaglio e genera minaccia. Più efficace di Distracting Shot (grado 1)." },
    -- Spell.db2 ID 15629, Description_lang.
    [15629] = { en = "Distract the target, causing threat.  More effective than Distracting Shot (Rank 2).", description = "Distrae il bersaglio e genera minaccia. Più efficace di Distracting Shot (grado 2)." },
    -- Spell.db2 ID 15630, Description_lang.
    [15630] = { en = "Distract the target, causing threat.  More effective than Distracting Shot (Rank 3).", description = "Distrae il bersaglio e genera minaccia. Più efficace di Distracting Shot (grado 3)." },
    -- Spell.db2 ID 15631, Description_lang.
    [15631] = { en = "Distract the target, causing threat.  More effective than Distracting Shot (Rank 4).", description = "Distrae il bersaglio e genera minaccia. Più efficace di Distracting Shot (grado 4)." },
    -- Spell.db2 ID 15632, Description_lang.
    [15632] = { en = "Distract the target, causing threat.  More effective than Distracting Shot (Rank 5).", description = "Distrae il bersaglio e genera minaccia. Più efficace di Distracting Shot (grado 5)." },
    -- Spell.db2 ID 16188, Description_lang.
    [16188] = { en = "When activated, your next Nature spell with a casting time less than 10 sec. becomes an instant cast spell.", description = "Quando viene attivata, il tuo prossimo incantesimo di natura con tempo di lancio inferiore a 10 secondi diventa istantaneo." },
    -- Spell.db2 ID 16739, Description_lang.
    [16739] = { en = "Transforms caster to look like a member of the opposing faction.", description = "Trasforma l’incantatore, facendolo sembrare un membro della fazione avversaria." },
    -- Spell.db2 ID 17116, Description_lang.
    [17116] = { en = "When activated, your next Nature spell becomes an instant cast spell.", description = "Quando viene attivata, il tuo prossimo incantesimo di natura diventa istantaneo." },
    -- Spell.db2 ID 17233, Description_lang.
    [17233] = { en = "Heals an ally for an amount equal to the caster's maximum health. Drains all of the caster's remaining mana when used.", description = "Cura un alleato di una quantità pari alla salute massima dell’incantatore. Al lancio consuma tutto il mana rimanente dell’incantatore." },
    -- Spell.db2 ID 17481, Description_lang.
    [17481] = { en = "Summons and dismisses Baron Rivendare's steed.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura Rivendare’s Deathcharger. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 18562, Description_lang.
    [18562] = { en = "Instantly heals a target with an active Rejuvenation or Regrowth effect for an amount equal to the full duration of the periodic effect of one of those spells.", description = "Cura istantaneamente un bersaglio affetto da Rejuvenation o Regrowth di una quantità pari all’intera cura periodica rimanente di uno dei due incantesimi." },
    -- Spell.db2 ID 20012, Description_lang.
    [20012] = { en = "Permanently enchant gloves to grant +10 Agility.", description = "Incanta permanentemente gloves per conferire +10 Agility." },
    -- Spell.db2 ID 20013, Description_lang.
    [20013] = { en = "Permanently enchant gloves to grant +10 Strength.", description = "Incanta permanentemente gloves per conferire +10 Strength." },
    -- Spell.db2 ID 20016, Description_lang.
    [20016] = { en = "Permanently enchant a shield to give +9 Spirit.", description = "Incanta permanentemente a shield per conferire +9 Spirit." },
    -- Spell.db2 ID 20017, Description_lang.
    [20017] = { en = "Permanently enchant a shield to give +9 Stamina.", description = "Incanta permanentemente a shield per conferire +9 Stamina." },
    -- Spell.db2 ID 20020, Description_lang.
    [20020] = { en = "Permanently enchant boots to give +7 Stamina.", description = "Incanta permanentemente boots per conferire +7 Stamina." },
    -- Spell.db2 ID 20023, Description_lang.
    [20023] = { en = "Permanently enchant boots to give +7 Agility.", description = "Incanta permanentemente boots per conferire +7 Agility." },
    -- Spell.db2 ID 20024, Description_lang.
    [20024] = { en = "Permanently enchant boots to give +5 Spirit.", description = "Incanta permanentemente boots per conferire +5 Spirit." },
    -- Spell.db2 ID 20025, Description_lang.
    [20025] = { en = "Permanently enchant a piece of chest armor to grant +4 to all stats.", description = "Incanta permanentemente a piece of chest armor per conferire +4 to all stats." },
    -- Spell.db2 ID 20026, Description_lang.
    [20026] = { en = "Permanently enchant a piece of chest armor to grant +10 Stamina.", description = "Incanta permanentemente a piece of chest armor per conferire +10 Stamina." },
    -- Spell.db2 ID 20028, Description_lang.
    [20028] = { en = "Permanently enchant a piece of chest armor to give +10 Intellect.", description = "Incanta permanentemente a piece of chest armor per conferire +10 Intellect." },
    -- Spell.db2 ID 20030, Description_lang.
    [20030] = { en = "Permanently enchant a two-handed melee weapon to do +9 damage.", description = "Incanta permanentemente a two-handed melee weapon per aumentare i danni di 9." },
    -- Spell.db2 ID 20031, Description_lang.
    [20031] = { en = "Permanently enchant a Melee Weapon to do 5 additional points of damage.", description = "Incanta permanentemente a Melee Weapon per infliggere 5 danni aggiuntivi." },
    -- Spell.db2 ID 20035, Description_lang.
    [20035] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 9 to Spirit.", description = "Incanta permanentemente a Two-Handed Melee Weapon per aumentare di 9 spirito." },
    -- Spell.db2 ID 20036, Description_lang.
    [20036] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 9 to intellect.", description = "Incanta permanentemente a Two-Handed Melee Weapon per aumentare di 9 intelletto." },
    -- Spell.db2 ID 21358, Description_lang.
    [21358] = { en = "Dowses a rune of the Firelords.", description = "Individua una runa dei Firelords." },
    -- Spell.db2 ID 21931, Description_lang.
    [21931] = { en = "Permanently enchant a weapon to grant up to 15 additional frost damage when casting frost spells.", description = "Incanta permanentemente un’arma, aumentando fino a 15 i danni da gelo quando si lanciano incantesimi di gelo." },
    -- Spell.db2 ID 22010, Description_lang.
    [22010] = { en = "Your Greater Heals now have a heal over time component equivalent to a rank 5 Renew.", description = "I tuoi incantesimi Greater Heal ora applicano un effetto di cura periodica equivalente a Renew (grado 5)." },
    -- Spell.db2 ID 22430, Description_lang.
    [22430] = { en = "Transmutes a Scale of Onyxia into a Refined Scale of Onyxia.", description = "Trasforma una Scale of Onyxia in una Refined Scale of Onyxia." },
    -- Spell.db2 ID 22593, Description_lang.
    [22593] = { en = "Permanently adds 5 fire resistance to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza al fuoco a un oggetto per le spalle." },
    -- Spell.db2 ID 22594, Description_lang.
    [22594] = { en = "Permanently adds 5 frost resistance to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza al gelo a un oggetto per le spalle." },
    -- Spell.db2 ID 22596, Description_lang.
    [22596] = { en = "Permanently adds 5 shadow resistance to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza al ombra a un oggetto per le spalle." },
    -- Spell.db2 ID 22597, Description_lang.
    [22597] = { en = "Permanently adds 5 nature resistance to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza al natura a un oggetto per le spalle." },
    -- Spell.db2 ID 22598, Description_lang.
    [22598] = { en = "Permanently adds 5 arcane resistance to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza al arcana a un oggetto per le spalle." },
    -- Spell.db2 ID 22599, Description_lang.
    [22599] = { en = "Permanently adds 5 resistance to all magic schools to a shoulder slot item.", description = "Aggiunge permanentemente 5 punti di resistenza a tutte le scuole di magia a un oggetto per le spalle." },
    -- Spell.db2 ID 22641, Description_lang.
    [22641] = { en = "Charge an enemy, knocking it silly for 30 seconds. Also knocks you down, stunning you for a short period of time. Any damage caused will revive the target.", description = "Carica un nemico, stordendolo per 30 secondi. La carica ti fa cadere e ti stordisce per un breve periodo. Qualsiasi danno subito risveglia il bersaglio." },
    -- Spell.db2 ID 22749, Description_lang.
    [22749] = { en = "Permanently enchant a Melee Weapon to add up to 30 damage to spells.", description = "Incanta permanentemente un’arma da mischia per aumentare fino a 30 i danni degli incantesimi." },
    -- Spell.db2 ID 22750, Description_lang.
    [22750] = { en = "Permanently enchant a Melee Weapon to add up to 55 points of healing to healing spells and up to 19 points of damage to damage spells.", description = "Incanta permanentemente un’arma da mischia per aumentare fino a 55 le cure degli incantesimi di cura e fino a 19 i danni degli incantesimi offensivi." },
    -- Spell.db2 ID 22840, Description_lang.
    [22840] = { en = "Permanently adds 1% haste to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente il 1% di velocità di lancio a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 22844, Description_lang.
    [22844] = { en = "Permanently adds +8 to your Healing and Damage from spells to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aumenta permanentemente di 8 le cure e i danni degli incantesimi da un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 22846, Description_lang.
    [22846] = { en = "Permanently adds 1% dodge to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente il 1% di schivata a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 23004, Description_lang.
    [23004] = { en = "Summons an Alarm-O-Bot for 10 minutes that occasionally sends out a pulse that detects nearby stealthy or invisible enemies.", description = "Evoca un Alarm-O-Bot per 10 minuti. A intervalli, emette un impulso che rileva i nemici furtivi o invisibili nelle vicinanze." },
    -- Spell.db2 ID 23008, Description_lang.
    [23008] = { en = "Blasts open nearly any locked door.", description = "Fa saltare quasi tutte le porte chiuse a chiave." },
    -- Spell.db2 ID 23222, Description_lang.
    [23222] = { en = "Summons and dismisses a Swift Yellow Mechanostrider.   This is a very fast mount.", description = "Evoca e congeda la cavalcatura Tecnostruzzo Giallo Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23223, Description_lang.
    [23223] = { en = "Summons and dismisses a Swift White Mechanostrider.   This is a very fast mount.", description = "Evoca e congeda la cavalcatura Tecnostruzzo Bianco Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23225, Description_lang.
    [23225] = { en = "Summons and dismisses a Swift Green Mechanostrider.   This is a very fast mount.", description = "Evoca e congeda la cavalcatura Tecnostruzzo Verde Rapido. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 23273, Description_lang.
    [23273] = { en = "Dispels all Charm, Fear and Polymorph effects.", description = "Dissolve tutti gli effetti di Charm, Fear e Polymorph." },
    -- Spell.db2 ID 23572, Description_lang.
    [23572] = { en = "After casting your Healing Wave or Lesser Healing Wave spell, gives you a 25% chance to gain Mana equal to 35% of the base cost of the spell.", description = "Dopo aver lanciato Healing Wave o Lesser Healing Wave, hai il 25% di probabilità di recuperare mana pari al 35% del costo base dell’incantesimo." },
    -- Spell.db2 ID 23725, Description_lang.
    [23725] = { en = "Heals yourself for 15% of your maximum health, and increases your maximum health by 15% for 20 sec.", description = "Ti cura del 15% della salute massima e aumenta la tua salute massima del 15% per 20 secondi." },
    -- Spell.db2 ID 23799, Description_lang.
    [23799] = { en = "Permanently enchant a melee weapon to grant +15 strength.", description = "Incanta permanentemente a melee weapon per conferire +15 strength." },
    -- Spell.db2 ID 23800, Description_lang.
    [23800] = { en = "Permanently enchant a melee weapon to grant +15 Agility.", description = "Incanta permanentemente a melee weapon per conferire +15 Agility." },
    -- Spell.db2 ID 23803, Description_lang.
    [23803] = { en = "Permanently enchant a melee weapon to grant +22 Spirit.", description = "Incanta permanentemente a melee weapon per conferire +22 Spirit." },
    -- Spell.db2 ID 23804, Description_lang.
    [23804] = { en = "Permanently enchant a melee weapon to grant +22 Intellect.", description = "Incanta permanentemente a melee weapon per conferire +22 Intellect." },
    -- Spell.db2 ID 23989, Description_lang.
    [23989] = { en = "When activated, this ability immediately finishes the cooldown on all your other Hunter abilities.", description = "Quando viene attivata, questa abilità azzera immediatamente il tempo di recupero di tutte le altre abilità da Cacciatore." },
    -- Spell.db2 ID 24149, Description_lang.
    [24149] = { en = "Permanently adds 10 Stamina, 7 Defense, and 15 Shield Block value to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 tempra, 7 difesa, and 15 valore di blocco con lo scudo a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24160, Description_lang.
    [24160] = { en = "Permanently adds 10 Stamina, 7 Defense, and increases healing by up to 24 to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 tempra, 7 difesa, and aumenta le cure fino a 24 a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24161, Description_lang.
    [24161] = { en = "Permanently adds 28 Attack Power and 1% Dodge to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 28 potenza d’attacco and 1% Dodge a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24162, Description_lang.
    [24162] = { en = "Permanently adds 24 Ranged Attack Power, 10 Stamina, and 1% Chance to Hit to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 24 Ranged potenza d’attacco, 10 tempra, and 1% probabilità di colpire a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24163, Description_lang.
    [24163] = { en = "Permanently adds 15 Intellect and increases all healing and spell damage by up to 13 to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 15 intelletto and increases all healing and spell damage by up to 13 a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24164, Description_lang.
    [24164] = { en = "Permanently adds 18 to all healing and damage spells and 1% chance to hit with spells to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 18 to tutti gli incantesimi di cura e danno and 1% probabilità di colpire con gli incantesimi a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24165, Description_lang.
    [24165] = { en = "Permanently adds 10 Stamina and increases spell damage and healing by up to 18 to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 tempra and aumenta i danni degli incantesimi e le cure fino a 18 a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24167, Description_lang.
    [24167] = { en = "Permanently adds 10 Stamina, 4 mana per 5 sec., and increases healing by up to 24 to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 tempra, 4 punti mana ogni 5 secondi, and aumenta le cure fino a 24 a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24168, Description_lang.
    [24168] = { en = "Permanently adds 10 Stamina, 10 Intellect, and increases healing by up to 24 to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 tempra, 10 intelletto, and aumenta le cure fino a 24 a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 24325, Description_lang.
    [24325] = { en = "Load with 5 Zulian Mudskunks, and then cast from Pagle's Point in Zul'Gurub.", description = "Carica 5 Zulian Mudskunks e lancia da Pagle’s Point a Zul’Gurub." },
    -- Spell.db2 ID 24340, Description_lang.
    [24340] = { en = "Do damage divided up evenly among all affected targets", description = "Infligge danni ripartiti equamente tra tutti i bersagli colpiti." },
    -- Spell.db2 ID 24346, Description_lang.
    [24346] = { en = "Turns you into a fish and increases your movement speed, but does not allow casting or attack.", description = "Ti trasforma in un pesce e aumenta la tua velocità di movimento, ma non puoi lanciare incantesimi né attaccare." },
    -- Spell.db2 ID 24420, Description_lang.
    [24420] = { en = "Permanently adds to a shoulder slot item increased healing done by spells and effects up to 33.", description = "Aumenta permanentemente fino a 33 le cure degli incantesimi e degli effetti su un oggetto per le spalle." },
    -- Spell.db2 ID 24421, Description_lang.
    [24421] = { en = "Permanently adds to a shoulder slot item increased damage and healing done by magical spells and effects up to 18.", description = "Aumenta permanentemente fino a 18 i danni e le cure degli incantesimi e degli effetti magici su un oggetto per le spalle." },
    -- Spell.db2 ID 24531, Description_lang.
    [24531] = { en = "Instantly clears the cooldowns of Aimed Shot, Multishot, Volley, and Arcane Shot.", description = "Azzera istantaneamente i tempi di recupero di Aimed Shot, Multishot, Volley e Arcane Shot." },
    -- Spell.db2 ID 24696, Description_lang.
    [24696] = { en = "Right Click to summon and dismiss your Murky.", description = "Clic destro per evocare o congedare Murky." },
    -- Spell.db2 ID 25080, Description_lang.
    [25080] = { en = "Permanently enchant gloves to increase agility by 15.", description = "Incanta permanentemente gloves per aumentare di 15 agility." },
    -- Spell.db2 ID 25112, Description_lang.
    [25112] = { en = "Casts your Summon Voidwalker spell with no mana or Soul Shard requirements.", description = "Lancia l’incantesimo Summon Voidwalker senza richiedere mana o Soul Shard." },
    -- Spell.db2 ID 25118, Description_lang.
    [25118] = { en = "While applied to target weapon it restores 5 mana to the caster every 5 seconds and increases healing done by up to 10. Lasts for 30 minutes.", description = "Applicato all’arma bersaglio, ripristina 5 punti mana all’incantatore ogni 5 secondi e aumenta le cure fino a 10. Dura 30 minuti." },
    -- Spell.db2 ID 25120, Description_lang.
    [25120] = { en = "While applied to target weapon it restores 10 mana to the caster every 5 seconds and increases healing by up to 20. Lasts for 30 minutes.", description = "Applicato all’arma bersaglio, ripristina 10 punti mana all’incantatore ogni 5 secondi e aumenta le cure fino a 20. Dura 30 minuti." },
    -- Spell.db2 ID 25122, Description_lang.
    [25122] = { en = "While applied to target weapon it increases spell damage and healing by up to 36 and increases Spell Critical chance by 1%. Lasts for 30 minutes.", description = "Applicato all’arma bersaglio, aumenta i danni degli incantesimi e le cure fino a 36 e aumenta dell’1% la probabilità di colpo critico degli incantesimi. Dura 30 minuti." },
    -- Spell.db2 ID 25123, Description_lang.
    [25123] = { en = "While applied to target weapon it restores 15 mana to the caster every 5 seconds and increases the effect of healing spells by up to 30. Lasts for 30 minutes.", description = "Applicato all’arma bersaglio, ripristina 15 punti mana all’incantatore ogni 5 secondi e aumenta fino a 30 l’effetto degli incantesimi di cura. Dura 30 minuti." },
    -- Spell.db2 ID 25793, Description_lang.
    [25793] = { en = "Place the torch in the mouth of High Chief Winterfall's cave to summon the demon that is corrupting the Winterfall furbolgs.  Bring some friends before planting it...", description = "Posiziona la torcia all’ingresso della caverna di High Chief Winterfall per evocare il demone che corrompe i furbolg Winterfall. Porta con te degli alleati prima di piantarla..." },
    -- Spell.db2 ID 26045, Description_lang.
    [26045] = { en = "Right Click to summon and dismiss your snowman.", description = "Clic destro per evocare o congedare il tuo pupazzo di neve." },
    -- Spell.db2 ID 26368, Description_lang.
    [26368] = { en = "Clears all debuffs", description = "Rimuove tutti gli effetti negativi." },
    -- Spell.db2 ID 26468, Description_lang.
    [26468] = { en = "Right Click to summon and dismiss your snowman.", description = "Clic destro per evocare o congedare il tuo pupazzo di neve." },
    -- Spell.db2 ID 26469, Description_lang.
    [26469] = { en = "Right Click to summon and dismiss your snowman. Requires a Snowball to summon.", description = "Clic destro per evocare o congedare il tuo pupazzo di neve. Per evocarlo serve una Snowball." },
    -- Spell.db2 ID 26528, Description_lang.
    [26528] = { en = "Right Click to summon and dismiss your reindeer. Requires a Snowball to summon.", description = "Clic destro per evocare o congedare la tua renna. Per evocarla serve una Snowball." },
    -- Spell.db2 ID 26529, Description_lang.
    [26529] = { en = "Right Click to summon and dismiss your reindeer.", description = "Clic destro per evocare o congedare la tua renna." },
    -- Spell.db2 ID 26530, Description_lang.
    [26530] = { en = "Right Click to summon and dismiss your reindeer.", description = "Clic destro per evocare o congedare la tua renna." },
    -- Spell.db2 ID 26531, Description_lang.
    [26531] = { en = "Right Click to summon and dismiss your snowman.", description = "Clic destro per evocare o congedare il tuo pupazzo di neve." },
    -- Spell.db2 ID 26532, Description_lang.
    [26532] = { en = "Right Click to summon and dismiss your helper. Requires a Snowball to summon.", description = "Clic destro per evocare o congedare il tuo aiutante. Per evocarlo serve una Snowball." },
    -- Spell.db2 ID 26533, Description_lang.
    [26533] = { en = "Right Click to summon and dismiss your helper.", description = "Clic destro per evocare o congedare il tuo aiutante." },
    -- Spell.db2 ID 26534, Description_lang.
    [26534] = { en = "Right Click to summon and dismiss your helper.", description = "Clic destro per evocare o congedare il tuo aiutante." },
    -- Spell.db2 ID 26536, Description_lang.
    [26536] = { en = "Right Click to summon and dismiss your helper.", description = "Clic destro per evocare o congedare il tuo aiutante." },
    -- Spell.db2 ID 26537, Description_lang.
    [26537] = { en = "Right Click to summon and dismiss your helper.", description = "Clic destro per evocare o congedare il tuo aiutante." },
    -- Spell.db2 ID 26541, Description_lang.
    [26541] = { en = "Right Click to summon and dismiss your helper. Requires a Snowball to summon.", description = "Clic destro per evocare o congedare il tuo aiutante. Per evocarlo serve una Snowball." },
    -- Spell.db2 ID 26558, Description_lang.
    [26558] = { en = "Do damage divided up evenly among all affected targets", description = "Infligge danni ripartiti equamente tra tutti i bersagli colpiti." },
    -- Spell.db2 ID 27662, Description_lang.
    [27662] = { en = "Shoot a player, and Kwee Q. Peddlefeet will find them!  (Only works on players with no current critter pets.)", description = "Spara a un giocatore e Kwee Q. Peddlefeet lo troverà! (Funziona solo sui giocatori che non hanno già un animaletto.)" },
    -- Spell.db2 ID 27705, Description_lang.
    [27705] = { en = "Right Click to combine 10 loaves of Homemade Bread into a Sack of Homemade Bread.", description = "Clic destro per unire 10 pagnotte di Homemade Bread e creare un Sack of Homemade Bread." },
    -- Spell.db2 ID 27707, Description_lang.
    [27707] = { en = "Right Click to combine 10 Dwarven Homebrews into a Case of Homebrew.", description = "Clic destro per unire 10 Dwarven Homebrews e creare un Case of Homebrew." },
    -- Spell.db2 ID 27776, Description_lang.
    [27776] = { en = "When struck in combat has a chance of returning 350 mana to the wearer. ", description = "Quando viene colpito in combattimento, ha una probabilità di restituire 350 punti mana a chi lo indossa." },
    -- Spell.db2 ID 27781, Description_lang.
    [27781] = { en = "When struck in combat has a chance of returning 300 mana, 10 rage, or 40 energy to the wearer. ", description = "Quando viene colpito in combattimento, ha una probabilità di restituire a chi lo indossa 300 punti mana, 10 punti rabbia o 40 punti energia." },
    -- Spell.db2 ID 27837, Description_lang.
    [27837] = { en = "Permanently enchant a two-handed melee weapon to grant +25 Agility.", description = "Incanta permanentemente a two-handed melee weapon per conferire +25 Agility." },
    -- Spell.db2 ID 28137, Description_lang.
    [28137] = { en = "Slime nearby targets", description = "Ricopre di melma i bersagli vicini." },
    -- Spell.db2 ID 28163, Description_lang.
    [28163] = { en = "Permanently adds 10 frost resistance to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 punti di resistenza al gelo a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 28164, Description_lang.
    [28164] = { en = "Permanently adds 10 frost resistance to a leg or head slot item. Does not stack with other enchantments for the selected equipment slot.", description = "Aggiunge permanentemente 10 punti di resistenza al gelo a un oggetto per gambe o testa. Non si cumula con altri incantamenti applicati allo stesso slot dell’equipaggiamento." },
    -- Spell.db2 ID 28266, Description_lang.
    [28266] = { en = "Pull everybody towards you", description = "Attira tutti verso di te." },
    -- Spell.db2 ID 28353, Description_lang.
    [28353] = { en = "Raise two skeletons from a fallen squire.", description = "Rianima due scheletri dai resti di uno scudiero caduto." },
    -- Spell.db2 ID 28863, Description_lang.
    [28863] = { en = "Summon a Void Zone that deals shadow damage to enemies that stand within it", description = "Evoca una Void Zone che infligge danni da ombra ai nemici al suo interno." },
    -- Spell.db2 ID 28884, Description_lang.
    [28884] = { en = "Do damage divided up evenly among all affected targets", description = "Infligge danni ripartiti equamente tra tutti i bersagli colpiti." },
    -- Spell.db2 ID 29059, Description_lang.
    [29059] = { en = "Summons and dismisses a skeletal steed.  This is a very fast mount.", description = "Evoca e congeda la cavalcatura skeletal steed. È una cavalcatura molto veloce." },
    -- Spell.db2 ID 29162, Description_lang.
    [29162] = { en = "When struck has a 15% chance of reducing the attacker's movement speed by 50% for 5 secs.", description = "Quando vieni colpito, hai il 15% di probabilità di ridurre del 50% la velocità di movimento dell’attaccante per 5 secondi." },
    -- Spell.db2 ID 29467, Description_lang.
    [29467] = { en = "Permanently adds to a shoulder slot item increased damage and healing done by magical spells and effects up to 15 and also increases your chance to land a critical strike with spells by 1%.", description = "Aumenta permanentemente fino a 15 i danni e le cure degli incantesimi e degli effetti magici su un oggetto per le spalle. Aumenta inoltre del 1% la probabilità di infliggere colpi critici con gli incantesimi." },
    -- Spell.db2 ID 29475, Description_lang.
    [29475] = { en = "Permanently adds to a shoulder slot item increased healing done by magical spells and effects up to 31 and also increases your mana regen by 5 mana per 5 sec.", description = "Aumenta permanentemente fino a 31 le cure degli incantesimi e degli effetti magici su un oggetto per le spalle e aumenta la rigenerazione del mana di 5 punti ogni 5 secondi." },
    -- Spell.db2 ID 29483, Description_lang.
    [29483] = { en = "Permanently adds to a shoulder slot item increased Attack Power by 26 and also increases your chance to land a critical strike by 1%.", description = "Aumenta permanentemente di 26 la potenza d’attacco e dell’1% la probabilità di infliggere colpi critici con un oggetto per le spalle." },
    -- Spell.db2 ID 691, Description_lang.
    [691] = { en = "Summons a Felhunter under the command of the Warlock.", description = "Evoca un Felhunter al servizio dello Stregone." },
    -- Spell.db2 ID 6650, Description_lang.
    [6650] = { en = "Coats a sword or dagger with poison that lasts for 30 minutes.\r\nEach strike has a chance of poisoning the enemy which instantly inflicts 10-30 damage.", description = "Ricopre una spada o un pugnale di veleno per 30 minuti. Ogni colpo ha una probabilità di avvelenare il nemico, infliggendo istantaneamente da 10 a 30 danni." },
    -- Spell.db2 ID 7428, Description_lang.
    [7428] = { en = "Permanently enchant bracers so that the defense skill of the wearer is increased by 3.", description = "Incanta permanentemente i bracciali per aumentare di 3 l’abilità Difesa di chi li indossa." },
    -- Spell.db2 ID 7620, Description_lang.
    [7620] = { en = "Equip a fishing pole and find a body of water to fish.  Right-Click on the bob in the water when it splashes to catch your fish.  Higher skill increases your chance of fishing successfully in higher level areas.\r\n", description = "Equipaggia una canna da pesca e trova uno specchio d’acqua. Fai clic destro sul galleggiante quando sussulta per pescare. Un’abilità più alta aumenta la probabilità di pescare con successo nelle zone di livello superiore." },
    -- Spell.db2 ID 7720, Description_lang.
    [7720] = { en = "Triggered by ritual of summoning to summon a player\r\n", description = "Si attiva con il rituale di evocazione per evocare un giocatore." },
    -- Spell.db2 ID 7776, Description_lang.
    [7776] = { en = "Permanently enchant a piece of chest armor so that it increases the Intellect of the wearer by 3.", description = "Incanta permanentemente un pezzo di armatura per il torace, aumentando di 3 l’Intelletto di chi lo indossa." },
    -- Spell.db2 ID 7788, Description_lang.
    [7788] = { en = "Permanently enchant a Melee Weapon to do 1 additional point of damage.", description = "Incanta permanentemente un’arma da mischia per infliggere 1 danno aggiuntivo." },
    -- Spell.db2 ID 7859, Description_lang.
    [7859] = { en = "Permanently enchant a bracer so it increases the wearer's Spirit by 4.", description = "Incanta permanentemente un bracciale per aumentare di 4 lo Spirito di chi lo indossa." },
    -- Spell.db2 ID 8643, Description_lang.
    [8643] = { en = "Finishing move that stuns the target.  Lasts longer per combo point:\r\n   1 point  : 2 seconds\r\n   2 points: 3 seconds\r\n   3 points: 4 seconds\r\n   4 points: 5 seconds\r\n   5 points: 6 seconds", description = "Colpo di grazia che stordisce il bersaglio. La durata aumenta con i punti combo:\n1 punto: 2 secondi\n2 punti: 3 secondi\n3 punti: 4 secondi\n4 punti: 5 secondi\n5 punti: 6 secondi." },
    -- Spell.db2 ID 8998, Description_lang.
    [8998] = { en = "Cower, causing no damage but lowering your threat a small amount, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci di poco la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 9000, Description_lang.
    [9000] = { en = "Cower, causing no damage but lowering your threat a medium amount, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci moderatamente la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 9892, Description_lang.
    [9892] = { en = "Cower, causing no damage but lowering your threat a large amount, making the enemy less likely to attack you.", description = "Ti acquatti senza infliggere danni e riduci notevolmente la minaccia, rendendo il nemico meno propenso ad attaccarti." },
    -- Spell.db2 ID 12459, Description_lang.
    [12459] = { en = "Attaches a permanent scope to a bow or gun that increases its damage by 5.", description = "Applica un mirino permanente a un arco o a un’arma da fuoco, aumentando i danni di 5." },
    -- Spell.db2 ID 12460, Description_lang.
    [12460] = { en = "Attaches a permanent scope to a bow or gun that increases its damage by 7.", description = "Applica un mirino permanente a un arco o a un’arma da fuoco, aumentando i danni di 7." },
    -- Spell.db2 ID 13522, Description_lang.
    [13522] = { en = "Permanently enchant a cloak so that it increases resistance to shadow by 10.", description = "Incanta permanentemente un mantello per aumentare di 10 la resistenza all’ombra." },
    -- Spell.db2 ID 13536, Description_lang.
    [13536] = { en = "Permanently enchant a bracer so it increases the wearer's Strength by 4.", description = "Incanta permanentemente un bracciale per aumentare di 4 la Forza di chi lo indossa." },
    -- Spell.db2 ID 13655, Description_lang.
    [13655] = { en = "Permanently enchant a Melee Weapon to do 6 additional damage against Elementals.", description = "Incanta permanentemente un’arma da mischia per infliggere 6 danni aggiuntivi agli elementali." },
    -- Spell.db2 ID 13689, Description_lang.
    [13689] = { en = "Permanently enchant a shield to give +2% chance to block.", description = "Incanta permanentemente uno scudo per aumentare del 2% la probabilità di bloccare." },
    -- Spell.db2 ID 13882, Description_lang.
    [13882] = { en = "Permanently enchant a cloak to give 3 Agility.", description = "Incanta permanentemente un mantello per aumentare di 3 l’Agilità." },
    -- Spell.db2 ID 13915, Description_lang.
    [13915] = { en = "Permanently enchant a melee weapon to have a chance of stunning and doing heavy damage to demons.", description = "Incanta permanentemente un’arma da mischia, conferendole una probabilità di stordire i demoni e infliggere ingenti danni." },
    -- Spell.db2 ID 13947, Description_lang.
    [13947] = { en = "Permanently enchant gloves to grant a minor movement bonus while mounted.", description = "Incanta permanentemente i guanti per aumentare leggermente la velocità di movimento in sella." },
    -- Spell.db2 ID 13948, Description_lang.
    [13948] = { en = "Permanently enchant gloves to grant a +1% attack and casting speed bonus.", description = "Incanta permanentemente i guanti per aumentare dell’1% la velocità d’attacco e di lancio." },
    -- Spell.db2 ID 14185, Description_lang.
    [14185] = { en = "When activated, this ability immediately finishes the cooldown on your other Rogue abilities.", description = "Quando viene attivata, questa abilità azzera immediatamente il tempo di recupero di tutte le altre abilità da Ladro." },
    -- Spell.db2 ID 18540, Description_lang.
    [18540] = { en = "Begins a ritual that sacrifices a random participant to summon a doomguard.  The doomguard must be immediately subjugated or it will attack the ritual participants.  Requires the caster and 4 additional party members to complete the ritual.  In order to participate, all players must right-click the portal and not move until the ritual is complete.", description = "Inizia un rituale che sacrifica un partecipante a caso per evocare un Doomguard. Il Doomguard deve essere immediatamente soggiogato, altrimenti attaccherà i partecipanti al rituale. Per completare il rituale servono l’incantatore e altri 4 membri del gruppo. Per partecipare, tutti i giocatori devono fare clic destro sul portale e restare immobili fino al termine del rituale." },
    -- Spell.db2 ID 20014, Description_lang.
    [20014] = { en = "Permanently enchant a cloak to give 5 to all resistances.", description = "Incanta permanentemente un mantello per conferire 5 punti di resistenza a tutte le scuole di magia." },
    -- Spell.db2 ID 20015, Description_lang.
    [20015] = { en = "Permanently enchant a cloak to give 70 additional armor.", description = "Incanta permanentemente un mantello per aumentare l’armatura di 70." },
    -- Spell.db2 ID 20029, Description_lang.
    [20029] = { en = "Permanently enchant a melee weapon to often chill the target reducing their movement and attack speed.", description = "Incanta permanentemente un’arma da mischia, conferendole una probabilità di raggelare spesso il bersaglio e ridurne la velocità di movimento e d’attacco." },
    -- Spell.db2 ID 20032, Description_lang.
    [20032] = { en = "Permanently enchant a melee weapon to often steal life from the enemy and give it to the wielder.", description = "Incanta permanentemente un’arma da mischia, conferendole una probabilità di sottrarre spesso salute al nemico e trasferirla a chi la impugna." },
    -- Spell.db2 ID 20033, Description_lang.
    [20033] = { en = "Permanently enchant a melee weapon to often inflict a curse on the target reducing their melee damage.", description = "Incanta permanentemente un’arma da mischia, conferendole una probabilità di maledire spesso il bersaglio e ridurne i danni in mischia." },
    -- Spell.db2 ID 20271, Description_lang.
    [20271] = { en = "Unleash the energy of a Seal spell upon an enemy. Does not consume the Seal. Refer to individual Seals for Judgement effect.", description = "Scatena l’energia di un incantesimo Seal contro un nemico. Non consuma il Seal. Consulta i singoli Seal per conoscere l’effetto di Judgement." },
    -- Spell.db2 ID 20736, Description_lang.
    [20736] = { en = "Distract the target, causing threat.", description = "Distrae il bersaglio e genera minaccia." },
    -- Spell.db2 ID 21960, Description_lang.
    [21960] = { en = "Forces the spirits of the first centaur Kahns to manifest in the physical world.", description = "Costringe gli spiriti dei primi centauri Kahns a manifestarsi nel mondo fisico." },
    -- Spell.db2 ID 22779, Description_lang.
    [22779] = { en = "Attaches a permanent scope to a bow or gun that increases its chance to hit by 3%.", description = "Applica un mirino permanente a un arco o a un’arma da fuoco, aumentando del 3% la probabilità di colpire." },
    -- Spell.db2 ID 22988, Description_lang.
    [22988] = { en = "Consumed by the fury of Illidan: 1400 Attack Power bonus versus Demons. 20% bonus chance to hit. 30% melee haste.", description = "La furia di Illidan ti travolge: bonus di 1400 alla potenza d’attacco contro i demoni, probabilità di colpire aumentata del 20% e velocità d’attacco in mischia aumentata del 30%." },
    -- Spell.db2 ID 23065, Description_lang.
    [23065] = { en = "Throw rock to a friendly target.   If they have free room in their pack they will catch it!", description = "Lancia una pietra a un bersaglio amico. Se ha spazio libero nella borsa, la prenderà!" },
    -- Spell.db2 ID 24263, Description_lang.
    [24263] = { en = "Create the Empowered Mojo Bundle.", description = "Crea l’Empowered Mojo Bundle." },
    -- Spell.db2 ID 24302, Description_lang.
    [24302] = { en = "Replaces the fishing line on your fishing pole with a high test eternium line.", description = "Sostituisce il filo della canna da pesca con un filo di eternium ad alta resistenza." },
    -- Spell.db2 ID 24422, Description_lang.
    [24422] = { en = "Permanently adds 30 attack power to a shoulder slot item.", description = "Aggiunge permanentemente 30 punti di potenza d’attacco a un oggetto per le spalle." },
    -- Spell.db2 ID 25073, Description_lang.
    [25073] = { en = "Permanently enchant gloves to increase shadow damage by up to 20.", description = "Incanta permanentemente i guanti per aumentare fino a 20 i danni da ombra." },
    -- Spell.db2 ID 25074, Description_lang.
    [25074] = { en = "Permanently enchant gloves to increase frost damage by up to 20.", description = "Incanta permanentemente i guanti per aumentare fino a 20 i danni da gelo." },
    -- Spell.db2 ID 25078, Description_lang.
    [25078] = { en = "Permanently enchant gloves to increase fire damage by up to 20.", description = "Incanta permanentemente i guanti per aumentare fino a 20 i danni da fuoco." },
    -- Spell.db2 ID 25079, Description_lang.
    [25079] = { en = "Permanently enchant gloves to increase the caster's healing spells by up to 35 and damage spells by up to 12.", description = "Incanta permanentemente i guanti per aumentare fino a 35 le cure degli incantesimi e fino a 12 i danni degli incantesimi offensivi." },
    -- Spell.db2 ID 25081, Description_lang.
    [25081] = { en = "Permanently enchant a cloak to give 15 fire resistance.", description = "Incanta permanentemente un mantello per conferire 15 punti di resistenza al fuoco." },
    -- Spell.db2 ID 25082, Description_lang.
    [25082] = { en = "Permanently enchant a cloak to give 15 nature resistance.", description = "Incanta permanentemente un mantello per conferire 15 punti di resistenza alla natura." },
    -- Spell.db2 ID 25084, Description_lang.
    [25084] = { en = "Permanently enchant a cloak to decrease threat caused by the wearer by 2%.", description = "Incanta permanentemente un mantello per ridurre del 2% la minaccia generata da chi lo indossa." },
    -- Spell.db2 ID 25086, Description_lang.
    [25086] = { en = "Permanently enchant a cloak to give a 1% chance to dodge.", description = "Incanta permanentemente un mantello, conferendo l’1% di probabilità di schivare." },
    -- Spell.db2 ID 27241, Description_lang.
    [27241] = { en = "Right Click to summon and dismiss your Gurky.", description = "Clic destro per evocare o congedare Gurky." },
    -- Spell.db2 ID 27615, Description_lang.
    [27615] = { en = "Finishing move that stuns the target. ", description = "Colpo di grazia che stordisce il bersaglio. La durata aumenta con i punti combo: 1 punto: 1 secondo; 2 punti: 2 secondi; 3 punti: 3 secondi; 4 punti: 4 secondi; 5 punti: 5 secondi." },
    -- Spell.db2 ID 28200, Description_lang.
    [28200] = { en = "Your next 5 damage or healing spells cast within 20 seconds will grant a bonus of up to 40 damage and up to 75 healing, stacking up to 5 times. Expires after 6 damage or healing spells or 20 seconds, whichever occurs first. ", description = "I tuoi prossimi 5 incantesimi di danno o cura lanciati entro 20 secondi forniscono un bonus fino a 40 danni e fino a 75 cure, cumulabile fino a 5 volte. L’effetto termina dopo 6 incantesimi di danno o cura oppure dopo 20 secondi, a seconda di quale evento si verifichi per primo." },
    -- Spell.db2 ID 28719, Description_lang.
    [28719] = { en = "On Healing Touch critical hits, you regain 30% of the mana cost of the spell.", description = "Quando infliggi un colpo critico con Healing Touch, recuperi mana pari al 30% del costo dell’incantesimo." },
    -- Spell.db2 ID 28740, Description_lang.
    [28740] = { en = "Right Click to summon and dismiss Whiskers the rat.", description = "Clic destro per evocare o congedare Whiskers, il ratto." },
    -- Spell.db2 ID 28891, Description_lang.
    [28891] = { en = "While applied to target weapon it increases attack power against undead by 100. Lasts for 1 hour.", description = "Applicato all’arma bersaglio, aumenta di 100 la potenza d’attacco contro i non morti. Dura 1 ora." },
    -- Spell.db2 ID 28898, Description_lang.
    [28898] = { en = "While applied to target weapon it increases spell damage against undead by up to 60. Lasts for 1 hour.", description = "Applicato all’arma bersaglio, aumenta fino a 60 i danni degli incantesimi contro i non morti. Dura 1 ora." },
    -- Spell.db2 ID 29480, Description_lang.
    [29480] = { en = "Permanently adds to a shoulder slot item increased Stamina by 16 and also grants 100 armor. ", description = "Aggiunge permanentemente 16 Tempra e 100 armatura a un oggetto per le spalle." },
}
for id, description in pairs(verifiedSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
end
