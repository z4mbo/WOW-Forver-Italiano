-- Generated from the installed Retail client and beta locale extracts (exact ID and enUS text).
-- Optional pack: this file is intentionally not added to the TOC by the generator.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellAuraDescriptionOverrides = ns.data.spellAuraDescriptionOverrides or {}
local reused = {
    [2336] = { en = "Able to comprehend the common language of the opposite faction.", description = "In grado di comprendere la lingua comune della fazione opposta." },
    [12051] = { en = "Mana regeneration increased by $s1%.", description = "Rigenerazione del mana aumentata del $s1%." },
    [29001] = { en = "It's time to dance!", description = "È il momento di ballare!" },
    [29002] = { en = "It's time to dance!", description = "È il momento di ballare!" },
    [29003] = { en = "It's time to dance!", description = "È il momento di ballare!" },
    [29006] = { en = "You feel refreshed!  +$s1 Stamina!", description = "Ti senti rinnovato! +$s1 Tempra!" },
    [29040] = { en = "Mana Regeneration increased by $s1 every 5 seconds.", description = "Rigenerazione del mana aumentata di $s1 ogni 5 s." },
    [43308] = { en = "Finding Fish.", description = "Alla ricerca di pesci." },
    [45440] = { en = "Use your action bar to attack other remote control toys.", description = "Usa la barra delle azioni per attaccare gli altri giocattoli radiocomandati." },
    [63624] = { en = "Learn a Second Talent Specialization.", description = "Apprendi una Seconda Specializzazione Talenti." },
    [78159] = { en = "Increases melee haste by $8515s1%.", description = "Celerità in mischia aumentata del $8515s1%." },
}
for id, record in pairs(reused) do
    if ns.data.spellAuraDescriptionOverrides[id] == nil then
        ns.data.spellAuraDescriptionOverrides[id] = record
    end
end
