-- Corrected translations for reviewed mixed spell descriptions (quality snapshot rows 1-60).
-- Each en value is copied exactly from the snapshot; this pack replaces the existing entry.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
local verifiedSpellDescriptionCorrections = {
    [657] = { en = "Teaches Create Greater Healthstone.", description = "Insegna a creare una Pietra della Salute Superiore." },
    [1385] = { en = "Learn Summon Voidwalker.", description = "Apprendi l'incantesimo «Evoca Ombra del Vuoto»." },
    [1403] = { en = "Learn Summon Succubus.", description = "Apprendi l'incantesimo «Evoca Succube»." },
    [17586] = { en = "Teaches you how to make a Major Healing Potion.", description = "Ti insegna a preparare una Pozione di Cura Maggiore." },
    [18821] = { en = "Reduces the Attack Speed and Casting Speed penalty of your Subjugate Demon spell by $s1% and reduces the resist chance by $s3%.", description = "Riduce del $s1% la penalità alla velocità d'attacco e di lancio del tuo incantesimo Assoggetta Demone e riduce del $s3% la probabilità di resistenza." },
    [18823] = { en = "Reduces the Attack Speed and Casting Speed penalty of your Subjugate Demon spell by $s1% and reduces the resist chance by $s3%.", description = "Riduce del $s1% la penalità alla velocità d'attacco e di lancio del tuo incantesimo Assoggetta Demone e riduce del $s3% la probabilità di resistenza." },
    [18824] = { en = "Reduces the Attack Speed and Casting Speed penalty of your Subjugate Demon spell by $s1% and reduces the resist chance by $s3%.", description = "Riduce del $s1% la penalità alla velocità d'attacco e di lancio del tuo incantesimo Assoggetta Demone e riduce del $s3% la probabilità di resistenza." },
    [18825] = { en = "Reduces the Attack Speed and Casting Speed penalty of your Subjugate Demon spell by $s1% and reduces the resist chance by $s3%.", description = "Riduce del $s1% la penalità alla velocità d'attacco e di lancio del tuo incantesimo Assoggetta Demone e riduce del $s3% la probabilità di resistenza." },
    [20012] = { en = "Permanently enchant gloves to grant +10 Agility.", description = "Incanta permanentemente i guanti conferendo +10 Agilità." },
    [20013] = { en = "Permanently enchant gloves to grant +10 Strength.", description = "Incanta permanentemente i guanti conferendo +10 Forza." },
    [20016] = { en = "Permanently enchant a shield to give +9 Spirit.", description = "Incanta permanentemente uno scudo conferendo +9 Spirito." },
    [20020] = { en = "Permanently enchant boots to give +7 Stamina.", description = "Incanta permanentemente gli stivali conferendo +7 Tempra." },
    [20023] = { en = "Permanently enchant boots to give +7 Agility.", description = "Incanta permanentemente gli stivali conferendo +7 Agilità." },
    [20025] = { en = "Permanently enchant a piece of chest armor to grant +4 to all stats.", description = "Incanta permanentemente un pezzo di armatura per il torso conferendo +4 a tutte le statistiche." },
    [20026] = { en = "Permanently enchant a piece of chest armor to grant +10 Stamina.", description = "Incanta permanentemente un pezzo di armatura per il torso conferendo +10 Tempra." },
    [20028] = { en = "Permanently enchant a piece of chest armor to give +10 Intellect.", description = "Incanta permanentemente un pezzo di armatura per il torso conferendo +10 Intelletto." },
    [1229504] = { en = "Craft a Faction Banner.", description = "Crea uno stendardo di fazione." },
}
for id, record in pairs(verifiedSpellDescriptionCorrections) do
    ns.data.spellDescriptionOverrides[id] = record
end
