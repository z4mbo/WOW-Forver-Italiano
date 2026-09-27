-- Targeted text quality corrections from mixed-spell-quality.jsonl rows 61-120.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
ns.data.spellAuraDescriptionOverrides = ns.data.spellAuraDescriptionOverrides or {}

local spellFixes = {
    [20030] = { en = "Permanently enchant a two-handed melee weapon to do +9 damage.", description = "Incanta permanentemente un’arma da mischia a due mani per infliggere +9 danni." },
    [20031] = { en = "Permanently enchant a Melee Weapon to do 5 additional points of damage.", description = "Incanta permanentemente un’arma da mischia per infliggere 5 danni aggiuntivi." },
    [20035] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 9 to Spirit.", description = "Incanta permanentemente un’arma da mischia a due mani per aumentare di 9 lo Spirito." },
    [20036] = { en = "Permanently enchant a Two-Handed Melee Weapon to add 9 to intellect.", description = "Incanta permanentemente un’arma da mischia a due mani per aumentare di 9 l’Intelletto." },
    [20335] = { en = "Increases the melee attack power bonus of your Seal of the Crusader and the Holy damage increase of your Judgement of the Crusader by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco in mischia di Sigillo del Crociato e l’aumento dei danni sacri di Giudizio del Crociato." },
    [20336] = { en = "Increases the melee attack power bonus of your Seal of the Crusader and the Holy damage increase of your Judgement of the Crusader by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco in mischia di Sigillo del Crociato e l’aumento dei danni sacri di Giudizio del Crociato." },
    [20337] = { en = "Increases the melee attack power bonus of your Seal of the Crusader and the Holy damage increase of your Judgement of the Crusader by $s1%.", description = "Aumenta del $s1% il bonus alla potenza d’attacco in mischia di Sigillo del Crociato e l’aumento dei danni sacri di Giudizio del Crociato." },
    [28719] = { en = "On Healing Touch critical hits, you regain 30% of the mana cost of the spell.", description = "Quando metti a segno un colpo critico con Tocco Curativo, recuperi il 30% del mana consumato dall’incantesimo." },
    [1318318] = { en = "Reduces your damage taken by $s1% in the Battle Ring and The Maul.", description = "Riduce del $s1% i danni subiti nell’Arena della Battaglia e nel Maul." },
    [11689] = { en = "Converts ${($m1+$SPI*1)*(1+$18182m1/100)} Health into ${($m1+$SPI*1)*(1+$18182m1/100)} Mana for you. Spirit increases the amount converted.", description = "Trasforma ${($m1+$SPI*1)*(1+$18182m1/100)} punti salute in ${($m1+$SPI*1)*(1+$18182m1/100)} mana per te. Lo Spirito aumenta la quantità convertita." },
    [11687] = { en = "Converts ${($m1+$SPI*1)*(1+$18182m1/100)} Health into ${($m1+$SPI*1)*(1+$18182m1/100)} Mana for you. Spirit increases the amount converted.", description = "Trasforma ${($m1+$SPI*1)*(1+$18182m1/100)} punti salute in ${($m1+$SPI*1)*(1+$18182m1/100)} mana per te. Lo Spirito aumenta la quantità convertita." },
    [11688] = { en = "Converts ${($m1+$SPI*1)*(1+$18182m1/100)} Health into ${($m1+$SPI*1)*(1+$18182m1/100)} Mana for you. Spirit increases the amount converted.", description = "Trasforma ${($m1+$SPI*1)*(1+$18182m1/100)} punti salute in ${($m1+$SPI*1)*(1+$18182m1/100)} mana per te. Lo Spirito aumenta la quantità convertita." },
    [4736] = { en = "Teaches your tamed bird the Flight of the Peregrine ability. Flight of the Peregrine increase the movement speed of the bird.\r\nRequires: \r\nPet Level 13+", description = "Insegna al tuo uccello addomesticato l’abilità Flight of the Peregrine. Flight of the Peregrine aumenta la velocità di movimento dell’uccello.\r\nRichiede: \r\nLivello mascotte 13 o superiore" },
    [4807] = { en = "Teaches your tamed tall strider the Healing Tongue ability. Healing Tongue heals friendly targets from a short range.\r\nRequires: \r\nPet Level 22+", description = "Insegna al tuo tallstrider addomesticato l’abilità Healing Tongue. Healing Tongue cura gli alleati a breve distanza.\r\nRichiede: \r\nLivello mascotte 22 o superiore" },
    [4808] = { en = "Teaches your tamed tall strider the Healing Tongue ability. Healing Tongue heals friendly targets from a short range.\r\nRequires: \r\nPet Level 28+", description = "Insegna al tuo tallstrider addomesticato l’abilità Healing Tongue. Healing Tongue cura gli alleati a breve distanza.\r\nRichiede: \r\nLivello mascotte 28 o superiore" },
    [1317285] = { en = "Reduces your damage taken by $s1% in the Battle Ring and The Maul.", description = "Riduce del $s1% i danni subiti nell’Arena della Battaglia e nel Maul." },
    [13419] = { en = "Permanently enchant a cloak to grant +3 Agility.", description = "Incanta permanentemente un mantello per conferire +3 Agilità." },
    [13464] = { en = "Permanently enchant a shield to increase its armor by 30.", description = "Incanta permanentemente uno scudo per aumentare la sua armatura di 30." },
    [13465] = { en = "Teaches you how to permanently enchant a shield with +30 armor.", description = "Insegna a incantare permanentemente uno scudo per conferirgli +30 armatura." },
    [13503] = { en = "Permanently enchant a Melee Weapon to do 2 additional points of damage.", description = "Incanta permanentemente un’arma da mischia per infliggere 2 danni aggiuntivi." },
    [13529] = { en = "Permanently enchant a Two-handed Melee Weapon to do 5 additional points of damage.", description = "Incanta permanentemente un’arma da mischia a due mani per infliggere 5 danni aggiuntivi." },
    [13612] = { en = "Permanently enchant gloves to grant +2 mining skill.", description = "Incanta permanentemente i guanti per aumentare di 2 l’abilità Estrazione mineraria." },
    [13617] = { en = "Permanently enchant gloves to grant +2 herbalism skill.", description = "Incanta permanentemente i guanti per aumentare di 2 l’abilità Erbalismo." },
    [13653] = { en = "Permanently enchant a Melee Weapon to do 6 additional points of damage to Beasts.", description = "Incanta permanentemente un’arma da mischia per infliggere 6 danni aggiuntivi alle bestie." },
    [20017] = { en = "Permanently enchant a shield to give +9 Stamina.", description = "Incanta permanentemente uno scudo per aumentare di 9 la Tempra." },
    [13687] = { en = "Permanently enchant boots to give +4 Spirit.", description = "Incanta permanentemente gli stivali per aumentare di 4 lo Spirito." },
    [13695] = { en = "Permanently enchant a Two-handed Melee Weapon to do 6 additional points of damage.", description = "Incanta permanentemente un’arma da mischia a due mani per infliggere 6 danni aggiuntivi." },
    [13698] = { en = "Permanently enchant gloves to grant +5 skinning skill.", description = "Incanta permanentemente i guanti per aumentare di 5 l’abilità Conciatura." },
    [13699] = { en = "Teaches you how to permanently enchant gloves to give +5 skinning skill.", description = "Insegna a incantare permanentemente i guanti per aumentare di 5 l’abilità Conciatura." },
    [20024] = { en = "Permanently enchant boots to give +5 Spirit.", description = "Incanta permanentemente gli stivali per aumentare di 5 lo Spirito." },
    [1317692] = { en = "Teaches Beast Training, Feed Pet and Revive Pet.", description = "Insegna le abilità Addestramento Animale, Nutri Famiglio e Rianima Famiglio." },
    [13841] = { en = "Permanently enchant gloves to grant +5 mining skill.", description = "Incanta permanentemente i guanti per aumentare di 5 l’abilità Estrazione mineraria." },
    [13868] = { en = "Permanently enchant gloves to grant +5 herbalism skill.", description = "Incanta permanentemente i guanti per aumentare di 5 l’abilità Erbalismo." },
    [22095] = { en = "Permanently enchant a Melee Weapon to do 5 additional points of damage.", description = "Incanta permanentemente un’arma da mischia per infliggere 5 danni aggiuntivi." },
    [13937] = { en = "Permanently enchant a two-handed melee weapon to do +7 damage.", description = "Incanta permanentemente un’arma da mischia a due mani per infliggere +7 danni." },
    [13943] = { en = "Permanently enchant a Melee Weapon to do 4 additional points of damage.", description = "Incanta permanentemente un’arma da mischia per infliggere 4 danni aggiuntivi." },
    [1263425] = { en = "Craft a Faction Banner.", description = "Crea uno stendardo di fazione." },
    [7974] = { en = "Gives Flight to Lord Azrethoc.", description = "Fa volare Lord Azrethoc." },
    [13620] = { en = "Permanently enchant gloves to grant +2 fishing skill.", description = "Incanta permanentemente i guanti per aumentare di 2 l’abilità Pesca." },
}
for spellID, entry in pairs(spellFixes) do
    ns.data.spellDescriptionOverrides[spellID] = entry
end
