local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}

-- Spellbook labels and the character's general spell list.
local translations = {
    ["SpellBook"] = "Libro degli incantesimi",
    ["Spellbook"] = "Libro degli incantesimi",
    ["Search abilities"] = "Cerca abilità",
    ["Search abilities, keywords"] = "Cerca abilità e parole chiave",
    ["Search abilities, keywords..."] = "Cerca abilità e parole chiave...",
    ["Search keywords..."] = "Cerca parole chiave...",
    ["Search..."] = "Cerca...",
    ["General"] = "Generale",
    ["Holy"] = "Sacro",
    ["Rank 1"] = "Grado 1",
    ["Passive"] = "Passiva",
    ["Racial"] = "Razziale",
    ["Racial Passive"] = "Passiva razziale",

    ["Attack"] = "Attacco",
    ["Will of the Forsaken"] = "Volontà dei Reietti",
    ["Languages"] = "Lingue",
    ["Cannibalize"] = "Cannibalizzare",
    ["Armor Proficiency"] = "Uso armature",
    ["Touch of the Grave"] = "Tocco della Tomba",
    ["Shoot"] = "Sparare",
    ["Dodge"] = "Schivata",
    ["Underwater Breathing"] = "Respirazione subacquea",
}

for english, italian in pairs(translations) do
    ns.data.ui[english] = italian
end

-- Numeric tooltip fields vary by spell. UI.lua applies these Lua patterns
-- after exact-label lookups, preserving the live values in the translation.
ns.data.uiPatterns = ns.data.uiPatterns or {}
local patterns = {
    { pattern = "^(%d+) Mana$", replacement = "%1 mana" },
    { pattern = "^(%d+) yd range$", replacement = "%1 iarde" },
    { pattern = "^(%d+%.?%d*) sec cast$", replacement = "Tempo di lancio: %1 s" },
    { pattern = "^Rank (%d+)$", replacement = "Grado %1" },
    { pattern = "^Page (%d+/%d+)$", replacement = "Pagina %1" },
}
for _, rule in ipairs(patterns) do
    ns.data.uiPatterns[#ns.data.uiPatterns + 1] = rule
end
