-- Generated from exact Description_lang translations in trusted Spell.db2 records.
-- Applied only to source-matched AuraDescription_lang IDs.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellAuraDescriptionOverrides = ns.data.spellAuraDescriptionOverrides or {}
local reused = {
    [430948] = { en = "Restores $s1 mana per $t1 sec.", description = "Rigenera $s1 mana ogni $t1 s." },
    [1288016] = { en = "Increases Armor by $s1.", description = "Aumenta l'armatura di $s1." },
    [1294666] = { en = "Restores $s1 mana.", description = "Rigenera $s1 mana." },
    [1302350] = { en = "Restores $s1 mana.", description = "Rigenera $s1 mana." },
    [1302521] = { en = "Restores $s1 mana.", description = "Rigenera $s1 mana." },
}
for id, record in pairs(reused) do
    if ns.data.spellAuraDescriptionOverrides[id] == nil then
        ns.data.spellAuraDescriptionOverrides[id] = record
    end
end
