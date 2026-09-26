local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
-- Profession and crafting labels used by the WoW Forever beta UI.
local translations = {

    -- Profession names
    ["Alchemy"] = "Alchimia",
    ["Blacksmithing"] = "Forgiatura",
    ["Enchanting"] = "Incantamento",
    ["Engineering"] = "Ingegneria",
    ["Herbalism"] = "Erbalismo",
    ["Inscription"] = "Runografia",
    ["Jewelcrafting"] = "Oreficeria",
    ["Leatherworking"] = "Conciatura",
    ["Mining"] = "Estrazione",
    ["Skinning"] = "Scuoiatura",
    ["Tailoring"] = "Sartoria",
    ["Cooking"] = "Cucina",
    ["Fishing"] = "Pesca",
    ["First Aid"] = "Pronto soccorso",

    -- Profession window and skill labels
    ["Profession"] = "Professione",
    ["Professions"] = "Professioni",
    ["Profession Trainers"] = "Addestratori di professioni",
    ["Profession Equipment"] = "Equipaggiamento professioni",
    ["Profession Materials"] = "Materiali professioni",
    ["Skill"] = "Abilità",
    ["Skill Level"] = "Livello abilità",
    ["Apprentice"] = "Apprendista",
    ["Journeyman"] = "Artigiano",
    ["Expert"] = "Esperto",
    ["Artisan"] = "Maestro",
    ["Master"] = "Gran maestro",
    ["Grand Master"] = "Gran maestro",
    ["Zen Master"] = "Maestro zen",
    ["Draenor Master"] = "Maestro di Draenor",
    ["Legion Master"] = "Maestro di Legion",
    ["Unlearn"] = "Dimentica",
    ["Learn"] = "Impara",

    -- Recipes and crafting actions
    ["Recipe"] = "Ricetta",
    ["Recipes"] = "Ricette",
    ["Unlearned"] = "Non appresa",
    ["Search"] = "Cerca",
    ["Filter"] = "Filtro",
    ["Create"] = "Crea",
    ["Create All"] = "Crea tutto",
    ["Crafting"] = "Creazione",
    ["Reagents"] = "Reagenti",
    ["Optional Reagents"] = "Reagenti facoltativi",
    ["Quantity"] = "Quantità",
    ["Amount"] = "Quantità",
    ["Success"] = "Riuscito",
    ["Failure"] = "Fallimento",

    -- Recipe difficulty and gathering
    ["Medium"] = "Media",
    ["Yellow"] = "Giallo",
    ["Skinning"] = "Scuoiatura",
    ["Disenchant"] = "Disincanta",

    -- Common crafting details
    ["Item"] = "Oggetto",
    ["Requires %s (%d)"] = "Richiede %s (%d)",
    ["Requires %s"] = "Richiede %s",
    ["Uses"] = "Utilizzi",
    ["Bind on Use"] = "Si vincola all'uso",
    ["Soulbound"] = "Vincolato all'anima",
    ["Vendor"] = "Mercante",
    ["Buy"] = "Acquista",
    ["Close"] = "Chiudi",
    ["Cancel"] = "Annulla",
    ["Okay"] = "Conferma",
    ["OK"] = "OK",
}
for source, translated in pairs(translations) do
    ns.data.ui[source] = translated
end
