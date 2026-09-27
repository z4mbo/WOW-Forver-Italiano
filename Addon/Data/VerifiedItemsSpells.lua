-- Additional tooltip descriptions verified against the Forever beta spellbook.
-- Source: https://www.60.tools/spellbook/warlock
-- The source identifies Forever beta client build 1.60.1.70009 and each spell ID.
-- This file augments existing name entries; it does not invent or replace IDs.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

local verifiedSpellDescriptions = {
    -- Warrior; descriptions copied from the Forever build's spellbook entries.
    [2457] = {
        en = "A balanced combat stance.",
        description = "Un assetto di combattimento equilibrato.",
    },
    [78] = {
        en = "A strong attack that increases melee damage by 11 and causes a high amount of threat.",
        description = "Un attacco potente che aumenta di 11 i danni in mischia e genera molta minaccia.",
    },
    [100] = {
        en = "Charge an enemy, generate 9 Rage, and Stun it for 1 sec. Cannot be used in combat.",
        description = "Carica un nemico, generando 9 rabbia e stordendolo per 1 s. Non si può usare in combattimento.",
    },
    [772] = {
        en = "Wounds the target causing them to bleed for 15 damage over 9 sec.",
        description = "Ferisce il bersaglio, facendogli perdere 15 punti salute in 9 s.",
    },
    [6546] = {
        en = "Wounds the target causing them to bleed for 28 damage over 12 sec.",
        description = "Ferisce il bersaglio, facendogli perdere 28 punti salute in 12 s.",
    },
    [6547] = {
        en = "Wounds the target causing them to bleed for 45 damage over 15 sec.",
        description = "Ferisce il bersaglio, facendogli perdere 45 punti salute in 15 s.",
    },
    [6343] = {
        en = "Blasts nearby enemies, increasing the time between their attacks by 20% for 10 sec and doing 10 damage to them. Will affect up to 4 targets.",
        description = "Colpisce i nemici vicini, aumentando del 20% l'intervallo tra i loro attacchi per 10 s e infliggendo loro 10 danni. Colpisce fino a 4 bersagli.",
    },
    [1715] = {
        en = "Maims the enemy, causing 5 damage and slowing the enemy's movement by 40% for 15 sec.",
        description = "Azzoppa il nemico, infliggendo 5 danni e rallentandone il movimento del 40% per 15 s.",
    },
    [7372] = {
        en = "Maims the enemy, causing 18 damage and slowing the enemy's movement by 45% for 15 sec.",
        description = "Azzoppa il nemico, infliggendo 18 danni e rallentandone il movimento del 45% per 15 s.",
    },
    [7373] = {
        en = "Maims the enemy, causing 45 damage and slowing the enemy's movement by 50% for 15 sec.",
        description = "Azzoppa il nemico, infliggendo 45 danni e rallentandone il movimento del 50% per 15 s.",
    },
    [7384] = {
        en = "Instantly overpower the enemy, causing weapon damage plus 5. Only useable after the target dodges. The Overpower cannot be blocked, dodged or parried.",
        description = "Sopraffà istantaneamente il nemico, infliggendo i danni dell'arma più 5. Si può usare solo dopo che il bersaglio ha schivato. Sopraffazione non può essere bloccata, schivata o parata.",
    },
    [694] = {
        en = "A mocking attack that causes 22 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.",
        description = "Un colpo provocatorio che infligge 22 danni, genera una moderata quantità di minaccia e costringe il bersaglio a concentrarsi su di te per 6 s.",
    },
    [7400] = {
        en = "A mocking attack that causes 31 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.",
        description = "Un colpo provocatorio che infligge 31 danni, genera una moderata quantità di minaccia e costringe il bersaglio a concentrarsi su di te per 6 s.",
    },
    [7402] = {
        en = "A mocking attack that causes 46 damage, a moderate amount of threat and forces the target to focus attacks on you for 6 sec.",
        description = "Un colpo provocatorio che infligge 46 danni, genera una moderata quantità di minaccia e costringe il bersaglio a concentrarsi su di te per 6 s.",
    },
    [6673] = {
        en = "The warrior shouts, increasing the melee attack power of all party members within 20 yards by 9. Lasts 3 min.",
        description = "Il guerriero lancia un grido che aumenta di 9 la potenza d'attacco in mischia di tutti i membri del gruppo entro 20 m. Dura 3 min.",
    },
    [1160] = {
        en = "Reduces the melee attack power of all enemies within 0 yards by 49 for 45 sec.",
        description = "Riduce di 49 la potenza d'attacco in mischia di tutti i nemici entro 0 m per 45 s.",
    },
    [6190] = {
        en = "Reduces the melee attack power of all enemies within 0 yards by 77 for 45 sec.",
        description = "Riduce di 77 la potenza d'attacco in mischia di tutti i nemici entro 0 m per 45 s.",
    },
    [1680] = {
        en = "In a whirlwind of steel you attack up to 4 enemies within 0 yards, causing weapon damage to each enemy.",
        description = "Con un turbine d'acciaio, attacchi fino a 4 nemici entro 0 m, infliggendo a ciascuno i danni dell'arma.",
    },
    [6552] = {
        en = "Pummel the target for 20 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.",
        description = "Colpisce il bersaglio infliggendo 20 danni. Interrompe anche il lancio degli incantesimi e impedisce di lanciare incantesimi di quella scuola per 4 s.",
    },
    [2687] = {
        en = "Generates 10 rage at the cost of health, and then generates an additional 10 rage over 10 sec. The warrior is considered in combat for the duration.",
        description = "Genera 10 punti rabbia al costo di salute, poi ne genera altri 10 in 10 s. Per tutta la durata, il guerriero è considerato in combattimento.",
    },
    [71] = {
        en = "A defensive combat stance. Decreases damage taken by 10% and damage caused by 10%. Increases all threat generated by 30%.",
        description = "Un assetto di combattimento difensivo. Riduce del 10% i danni subiti e quelli inflitti. Aumenta del 30% tutta la minaccia generata.",
    },
    [7386] = {
        en = "Sunders the target's armor, reducing it by 90 per Sunder Armor and causes a high amount of threat. Can be applied up to 5 times. Lasts 30 sec.",
        description = "Fende l'armatura del bersaglio, riducendola di 90 per ogni Fendere Armatura e generando molta minaccia. Si accumula fino a 5 volte. Dura 30 s.",
    },
    [355] = {
        en = "Taunts the target to attack you, but has no effect if the target is already attacking you.",
        description = "Provoca il bersaglio affinché attacchi te, ma non ha effetto se ti sta già attaccando.",
    },
    [72] = {
        en = "Bashes the target with your shield for 6 damage. It also interrupts spellcasting and prevents any spell in that school from being cast for 6 sec.",
        description = "Colpisce il bersaglio con lo scudo infliggendo 6 danni. Interrompe anche il lancio degli incantesimi e impedisce di lanciare incantesimi di quella scuola per 6 s.",
    },

    -- Paladin; IDs and English tooltip strings are from the Forever spellbook.
    [7328] = {
        en = "Brings a dead player back to life with 65 health and 120 mana. Cannot be cast when in combat.",
        description = "Riporta in vita un giocatore morto con 65 punti salute e 120 mana. Non si può lanciare in combattimento.",
    },
    [20154] = {
        en = "Fills the Paladin with holy spirit for 30 sec, granting each melee attack an additional 1.24 to 4.32 Holy damage. Slower weapons cause more Holy damage per swing. Only one Seal can be active on the Paladin at any one time.",
        description = "Infuse il paladino di spirito sacro per 30 s, aggiungendo da 1,24 a 4,32 danni sacri a ogni attacco in mischia. Le armi più lente infliggono più danni sacri a ogni colpo. Il paladino può avere un solo Sigillo attivo alla volta.",
    },
    [633] = {
        en = "Heals a friendly target for an amount equal to the Paladin's maximum health. Drains all of the Paladin's remaining Mana when used, but does not interrupt Mana regeneration.",
        description = "Cura un bersaglio amico di una quantità pari alla salute massima del paladino. Quando viene usato, consuma tutto il mana rimanente del paladino, ma non interrompe la rigenerazione del mana.",
    },
    [2800] = {
        en = "Heals a friendly target for an amount equal to the Paladin's maximum health and restores 250 of their mana. Drains all of the Paladin's remaining Mana when used, but does not interrupt Mana regeneration.",
        description = "Cura un bersaglio amico di una quantità pari alla salute massima del paladino e gli restituisce 250 mana. Quando viene usato, consuma tutto il mana rimanente del paladino, ma non interrompe la rigenerazione del mana.",
    },
    [10310] = {
        en = "Heals a friendly target for an amount equal to the Paladin's maximum health and restores 550 of their mana. Drains all of the Paladin's remaining Mana when used, but does not interrupt Mana regeneration.",
        description = "Cura un bersaglio amico di una quantità pari alla salute massima del paladino e gli restituisce 550 mana. Quando viene usato, consuma tutto il mana rimanente del paladino, ma non interrompe la rigenerazione del mana.",
    },
    [19742] = {
        en = "Places a Blessing on the friendly target, restoring 12 mana every 5 seconds for 1 hour. Players may only have one Blessing on them per Paladin at any one time.",
        description = "Benedice il bersaglio amico, ripristinando 12 mana ogni 5 s per 1 ora. Ogni paladino può avere una sola Benedizione attiva su un giocatore alla volta.",
    },
    [879] = {
        en = "Causes 74 to 84 Holy damage to an Undead or Demon target.",
        description = "Infligge da 74 a 84 danni sacri a un bersaglio non morto o demone.",
    },
    [498] = {
        en = "You are protected from all physical attacks and spells for 6 sec, but during that time you cannot attack or use physical abilities yourself. Applies Forbearance for 1 min. Cannot be cast while Forbearance is active.",
        description = "Ti protegge da tutti gli attacchi fisici e dagli incantesimi per 6 s, ma durante questo periodo non puoi attaccare né usare abilità fisiche. Applica Pazienza per 1 min. Non si può lanciare mentre Pazienza è attiva.",
    },
    [853] = { en = "Stuns the target for 3 sec.", description = "Stordisce il bersaglio per 3 s." },
    [5588] = { en = "Stuns the target for 4 sec.", description = "Stordisce il bersaglio per 4 s." },
    [5589] = { en = "Stuns the target for 5 sec.", description = "Stordisce il bersaglio per 5 s." },
    [10308] = { en = "Stuns the target for 6 sec.", description = "Stordisce il bersaglio per 6 s." },
    [1022] = {
        en = "A targeted party member is protected from all physical attacks for 6 sec, but during that time they cannot attack or use physical abilities. Players may only have one Blessing on them per Paladin at any one time. Applies Forbearance for 1 min. Cannot be cast while Forbearance is active.",
        description = "Un membro del gruppo viene protetto da tutti gli attacchi fisici per 6 s, ma durante questo periodo non può attaccare né usare abilità fisiche. Ogni paladino può avere una sola Benedizione attiva su un giocatore alla volta. Applica Pazienza per 1 min. Non si può lanciare mentre Pazienza è attiva.",
    },
    [19740] = {
        en = "Places a Blessing on the friendly target, increasing melee attack power by 14 for 1 hour. Players may only have one Blessing on them per Paladin at any one time.",
        description = "Benedice il bersaglio amico, aumentando di 14 la potenza d'attacco in mischia per 1 ora. Ogni paladino può avere una sola Benedizione attiva su un giocatore alla volta.",
    },

    -- Rogue; Forever beta spellbook, build 1.60.1.70009, spell 2098.
    [2098] = {
        en = "Finishing move that causes damage per combo point, increased by Attack Power:",
        description = "Mossa finale che infligge danni in base ai punti combo. I danni aumentano con la potenza d'attacco:",
    },

    -- Hunter; Forever beta descriptions, including its changed base values.
    [883] = { en = "Summons your pet to you.", description = "Richiama a te il tuo famiglio." },
    [1513] = {
        en = "Scares a beast, causing it to run in fear for up to 10 sec. Damage caused may interrupt the effect. Only one beast can be feared at a time.",
        description = "Spaventa una bestia, facendola fuggire impaurita per un massimo di 10 s. I danni inflitti possono interrompere l'effetto. Si può impaurire una sola bestia alla volta.",
    },
    [13165] = {
        en = "The hunter takes on the aspects of a hawk, increasing Ranged Attack Power by 20. Only one Aspect can be active at a time.",
        description = "Il cacciatore assume l'aspetto del falco, aumentando di 20 la potenza d'attacco a distanza. Si può avere un solo Aspetto attivo alla volta.",
    },
    [982] = { en = "Revive your pet, returning it to life with 15% of its health.", description = "Rianima il famiglio, riportandolo in vita con il 15% della salute." },
    [136] = { en = "Heals your pet 20 health every second while you focus. Lasts 5 sec.", description = "Cura il famiglio di 20 punti salute ogni secondo mentre ti concentri. Dura 5 s." },
    [75] = { en = "Automatically shoots the target until cancelled.", description = "Spara automaticamente al bersaglio finché non annulli l'azione." },
    [1978] = {
        en = "Stings the target, causing 10 Nature damage over 15 sec. Only one Sting per Hunter can be active on any one target.",
        description = "Punzecchia il bersaglio, infliggendo 10 danni naturali in 15 s. Ogni cacciatore può avere un solo Pungiglione attivo sullo stesso bersaglio.",
    },
    [3044] = { en = "An instant shot that causes 20 Arcane damage.", description = "Un tiro istantaneo che infligge 20 danni arcani." },
    [5116] = { en = "Dazes the target, slowing movement speed by 50% for 4 sec.", description = "Frastorna il bersaglio, riducendone la velocità di movimento del 50% per 4 s." },
    [2643] = {
        en = "Fires several missiles, hitting 3 targets. Multi-Shot shares its cooldown with Aimed Shot.",
        description = "Scaglia diversi proiettili, colpendo 3 bersagli. Tiro Multiplo condivide il tempo di recupero con Tiro Mirato.",
    },
    [19434] = {
        en = "An aimed shot that increases ranged damage by 20. Aimed Shot shares its cooldown with Multi-Shot.",
        description = "Un tiro mirato che aumenta di 20 i danni a distanza. Tiro Mirato condivide il tempo di recupero con Tiro Multiplo.",
    },
    [1543] = {
        en = "Exposes all hidden and invisible enemies within 10 yards of the targeted area for 30 sec.",
        description = "Rivela tutti i nemici nascosti o invisibili entro 10 m dall'area bersaglio per 30 s.",
    },
    [2973] = { en = "A strong attack that deals melee weapon damage plus 5.", description = "Un attacco potente che infligge i danni dell'arma da mischia più 5." },
    [1494] = {
        en = "Shows the location of all nearby beasts on the minimap. Only one form of tracking can be active at a time.",
        description = "Mostra sulla minimappa la posizione di tutte le bestie vicine. Si può attivare una sola forma di tracciamento alla volta.",
    },
    [2974] = {
        en = "Inflicts 5 damage and reduces the enemy target's movement speed by 50% for 10 sec.",
        description = "Infligge 5 danni e riduce del 50% la velocità di movimento del bersaglio nemico per 10 s.",
    },
    [5384] = {
        en = "Feign death which may trick enemies into ignoring you. Lasts 6 min. If not cancelled, after 6 min you will actually die.",
        description = "Fingi la morte per ingannare i nemici e indurli a ignorarti. Dura 6 min. Se non annulli l'effetto, dopo 6 min morirai davvero.",
    },
    [688] = {
        en = "Summons an Imp under the command of the Warlock.",
        description = "Evoca un Imp al servizio dello Stregone.",
    },
    [697] = {
        en = "Summons a Voidwalker under the command of the Warlock.",
        description = "Evoca un'Ombra del Vuoto al servizio dello Stregone.",
    },
    [6201] = {
        en = "Creates a Minor Healthstone that can be used to instantly restore 120 health.\n\nConjured items disappear if logged out for more than 15 minutes.",
        description = "Crea una Pietra della Salute minore che ripristina istantaneamente 120 punti salute.\n\nGli oggetti evocati scompaiono se resti disconnesso per più di 15 minuti.",
    },
    [6202] = {
        en = "Creates a Lesser Healthstone that can be used to instantly restore 300 health.\n\nConjured items disappear if logged out for more than 15 minutes.",
        description = "Crea una Pietra della Salute inferiore che ripristina istantaneamente 300 punti salute.\n\nGli oggetti evocati scompaiono se resti disconnesso per più di 15 minuti.",
    },
}

for id, description in pairs(verifiedSpellDescriptions) do
    local entry = ns.data.spells[id]
    if type(entry) == "table" then
        entry.enDescription = description.en
        entry.description = description.description
    end
end

-- These tooltip lines were read from the exact item ID pages. The page's
-- displayed name must match the addon's English guard before a line is added.
local verifiedItemDescriptions = {
    [6948] = {
        en = "Use: Returns you to the player. Speak to an Innkeeper in a different place to change your home location.",
        description = "Uso: Ti riporta al luogo a cui sei legato. Parla con un locandiere in un altro luogo per cambiarlo.",
    },
    [4540] = {
        en = "Use: Restores 17 health over 18 sec. Must remain seated while eating.",
        description = "Uso: Ripristina 17 punti salute in 18 s. Devi restare seduto mentre mangi.",
    },
    [4541] = {
        en = "Use: Restores 58 health over 21 sec. Must remain seated while eating.",
        description = "Uso: Ripristina 58 punti salute in 21 s. Devi restare seduto mentre mangi.",
    },
    [4542] = {
        en = "Use: Restores 115 health over 24 sec. Must remain seated while eating.",
        description = "Uso: Ripristina 115 punti salute in 24 s. Devi restare seduto mentre mangi.",
    },
    [6451] = {
        en = "Use: Heals 640 damage over 8 sec.",
        description = "Uso: Cura 640 danni in 8 s.",
    },
    [2581] = {
        en = "Use: Heals 114 damage over 6 sec.",
        description = "Uso: Cura 114 danni in 6 s.",
    },
    [6450] = {
        en = "Use: Heals 400 damage over 8 sec.",
        description = "Uso: Cura 400 danni in 8 s.",
    },
    [858] = {
        en = "Use: Restores 160 health.",
        description = "Uso: Ripristina 160 punti salute.",
    },
    [6529] = {
        en = "Use: When applied to your fishing pole, increases Fishing by 25 for 10 min.",
        description = "Uso: Applicato alla canna da pesca, aumenta Pesca di 25 per 10 min.",
    },
    [6530] = {
        en = "Use: When applied to your fishing pole, increases Fishing by 50 for 10 min.",
        description = "Uso: Applicato alla canna da pesca, aumenta Pesca di 50 per 10 min.",
    },
    [1181] = {
        en = "Use: Increases the target's Spirit by 3 for 30 min.",
        description = "Uso: Aumenta di 3 lo Spirito del bersaglio per 30 min.",
    },
    [1180] = {
        en = "Use: Increases the target's Stamina by 4 for 30 min.",
        description = "Uso: Aumenta di 4 la Tempra del bersaglio per 30 min.",
    },
    [1191] = {
        en = "Use: Decreases target's chance to hit with attacks by 25% for 10 sec.",
        description = "Uso: Riduce del 25% la probabilità che il bersaglio colpisca con gli attacchi per 10 s.",
    },
}

for id, description in pairs(verifiedItemDescriptions) do
    local entry = ns.data.items and ns.data.items[id]
    if type(entry) == "table" then
        entry.enDescription = description.en
        entry.description = description.description
    end
end
