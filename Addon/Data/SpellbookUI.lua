local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
-- Spellbook labels and the character's general spell list.
local translations = {
    ["Spellbook"] = "Libro degli incantesimi",
    ["Search abilities, keywords"] = "Cerca abilità e parole chiave",
    ["General"] = "Generale",
    ["Holy"] = "Sacro",
    ["Abilities"] = "Abilità",
    ["Spellbook & Professions"] = "Libro degli incantesimi e professioni",
    ["Passive"] = "Passiva",
    ["Attack"] = "Attacco",
    ["Press F6 to submit an issue for this Spell"] = "Premi F6 per segnalare un problema con questo incantesimo",
    ["Press F6 to submit an issue for this Creature"] = "Premi F6 per segnalare un problema relativo a questa creatura.",
    ["Armor Proficiency"] = "Armature",
    ["Languages"] = "Lingue",
    ["Dodge"] = "Schivata",
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
