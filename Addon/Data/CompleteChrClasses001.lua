-- Exact Forever beta ChrClasses.db2 gaps from the verified local catalogue.
-- The English values are source guards; both fields currently share these sources.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.extraClientTexts = ns.data.extraClientTexts or {}
ns.data.ui = ns.data.ui or {}

local records = {
    { field = "ChrClasses.Name_lang", id = 1, en = "Warrior", it = "Guerriero" },
    { field = "ChrClasses.Name_male_lang", id = 1, en = "Warrior", it = "Guerriero" },
    { field = "ChrClasses.Name_lang", id = 2, en = "Paladin", it = "Paladino" },
    { field = "ChrClasses.Name_male_lang", id = 2, en = "Paladin", it = "Paladino" },
    { field = "ChrClasses.Name_lang", id = 3, en = "Hunter", it = "Cacciatore" },
    { field = "ChrClasses.Name_male_lang", id = 3, en = "Hunter", it = "Cacciatore" },
    { field = "ChrClasses.Name_lang", id = 4, en = "Rogue", it = "Ladro" },
    { field = "ChrClasses.Name_male_lang", id = 4, en = "Rogue", it = "Ladro" },
    { field = "ChrClasses.Name_lang", id = 5, en = "Priest", it = "Sacerdote" },
    { field = "ChrClasses.Name_male_lang", id = 5, en = "Priest", it = "Sacerdote" },
    { field = "ChrClasses.Name_lang", id = 7, en = "Shaman", it = "Sciamano" },
    { field = "ChrClasses.Name_male_lang", id = 7, en = "Shaman", it = "Sciamano" },
    { field = "ChrClasses.Name_lang", id = 8, en = "Mage", it = "Mago" },
    { field = "ChrClasses.Name_male_lang", id = 8, en = "Mage", it = "Mago" },
    { field = "ChrClasses.Name_lang", id = 9, en = "Warlock", it = "Stregone" },
    { field = "ChrClasses.Name_male_lang", id = 9, en = "Warlock", it = "Stregone" },
    { field = "ChrClasses.Name_lang", id = 11, en = "Druid", it = "Druido" },
    { field = "ChrClasses.Name_male_lang", id = 11, en = "Druid", it = "Druido" },
}

for _, record in ipairs(records) do
    local entries = ns.data.extraClientTexts[record.field]
    if entries == nil then
        entries = {}
        ns.data.extraClientTexts[record.field] = entries
    end
    if entries[record.id] == nil then
        entries[record.id] = { en = record.en, it = record.it }
    end
    if ns.data.ui[record.en] == nil then
        ns.data.ui[record.en] = record.it
    end
end
