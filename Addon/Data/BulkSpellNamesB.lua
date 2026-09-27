-- Translated from exact same-ID enUS sources in local SpellName.db2.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}
local translatedSpellNames = {
    [475] = { en = "Remove Lesser Curse", name = "Rimuovi Maledizione Minore" },
    [553] = { en = "Bloodlust II", name = "Sete di Sangue II" },
    [818] = { en = "Basic Campfire", name = "Fuoco da Campo Base" },
    [822] = { en = "Magic Resistance", name = "Resistenza alla Magia" },
    [1186] = { en = "Conjure: Lockpick", name = "Crea: Grimaldello" },
    [1377] = { en = "Create Soulstone (Minor)", name = "Crea Pietra dell'Anima (Minore)" },
    [1398] = { en = "Fear II", name = "Paura II" },
    [2154] = { en = "Journeyman Leatherworking", name = "Conciatore Praticante" },
    [2155] = { en = "Apprentice Leatherworking", name = "Apprendista Conciatore" },
    [3170] = { en = "Minor Troll's Blood Elixir", name = "Elisir del Sangue di Troll Minore" },
    [3174] = { en = "Potion of Poison Cleansing", name = "Pozione di Purificazione dal Veleno" },
    [3176] = { en = "Lesser Troll's Blood Elixir", name = "Elisir del Sangue di Troll Inferiore" },
    [3369] = { en = "Potion Strength II", name = "Pozione della Forza II" },
    [3450] = { en = "Elixir of Lesser Fortitude", name = "Elisir della Fermezza" },
    [3451] = { en = "Troll's Blood Elixir", name = "Elisir del Sangue di Troll" },
    [3560] = { en = "Resist Frost", name = "Resistenza al Gelo" },
    [3812] = { en = "Expert Leatherworking", name = "Conciatore Esperto" },
    [3920] = { en = "Crafted Light Shot", name = "Proiettile Leggero Fabbricato" },
    [3926] = { en = "Copper Modulator", name = "Modulatore di Rame" },
    [3930] = { en = "Crafted Heavy Shot", name = "Proiettile Pesante Fabbricato" },
    [3947] = { en = "Crafted Solid Shot", name = "Proiettile Solido Fabbricato" },
    [4123] = { en = "Heroic Strength", name = "Forza Eroica" },
    [7414] = { en = "Apprentice Enchanting", name = "Apprendista Incantatore" },
    [7415] = { en = "Journeyman Enchanting", name = "Incantatore Praticante" },
    [7416] = { en = "Expert Enchanting", name = "Incantatore Esperto" },
    [8615] = { en = "Apprentice Skinning", name = "Apprendista Scuoiatore" },
    [8619] = { en = "Journeyman Skinning", name = "Scuoiatore Praticante" },
    [8620] = { en = "Expert Skinning", name = "Scuoiatore Esperto" },
    [9060] = { en = "Light Leather Quiver", name = "Faretra di Cuoio Leggero" },
    [9062] = { en = "Small Leather Ammo Pouch", name = "Sacca per Munizioni Piccola di Cuoio" },
    [9193] = { en = "Heavy Quiver", name = "Faretra Pesante" },
    [9194] = { en = "Heavy Leather Ammo Pouch", name = "Sacca per Munizioni di Cuoio Pesante" },
    [9931] = { en = "Mithril Plate Pants", name = "Pantaloni di Scaglie di Mithril" },
    [9937] = { en = "Mithril Plate Bracers", name = "Bracciali di Scaglie di Mithril" },
    [9942] = { en = "Mithril Plate Gloves", name = "Guanti di Scaglie di Mithril" },
    [9952] = { en = "Ornate Mithril Shoulders", name = "Spallacci di Mithril Ornati" },
    [9966] = { en = "Mithril Plate Shoulders", name = "Spallacci di Scaglie di Mithril" },
    [10843] = { en = " Heavy Mageweave Bandage", name = "Benda Pesante di Telamagica" },
    [11477] = { en = "Potion of Demon Slaying", name = "Pozione di Uccisione dei Demoni" },
    [11522] = { en = " Restorative Potion", name = "Pozione Rigenerativa" },
    [12596] = { en = "Hi-Impact Mithril Slugs", name = "Pallottole Impattanti di Mithril" },
    [12621] = { en = "Mithril Gyro-Shot", name = "Girocolpi di Mithril" },
    [12719] = { en = "Explosive Arrow", name = "Freccia Esplosiva" },
    [14930] = { en = "Quickdraw Quiver", name = "Faretra Zampa Lesta" },
    [14932] = { en = "Thick Leather Ammo Pouch", name = "Sacca per Munizioni di Cuoio Spesso" },
    [17632] = { en = "Alchemist's Stone", name = "Pietra dell'Alchimista" },
    [18632] = { en = " Heavy Runecloth Bandage", name = "Benda Pesante di Telarunica" },
    [19800] = { en = "Thorium Shells", name = "Cartucce di Torio" },
    [23621] = { en = " Wild Leather Boots", name = "Stivali di Cuoio Selvatico" },
    [23622] = { en = " Wild Leather Cloak", name = "Mantello di Cuoio Selvatico" },
    [23623] = { en = " Wild Leather Helmet", name = "Elmetto di Cuoio Selvatico" },
    [23625] = { en = " Wild Leather Leggings", name = "Gambiere di Cuoio Selvatico" },
    [23626] = { en = " Wild Leather Shoulders", name = "Spallacci di Cuoio Selvatico" },
    [23627] = { en = " Wild Leather Vest", name = "Veste di Cuoio Selvatico" },
    [28252] = { en = " Icebane Bracers", name = "Bracciali della Rovina dei Ghiacci" },
    [28253] = { en = " Icebane Gauntlets", name = "Guanti Lunghi della Rovina dei Ghiacci" },
    [28255] = { en = " Polar Gloves", name = "Guanti Polari" },
    [28256] = { en = " Polar Bracers", name = "Bracciali Polari" },
    [28257] = { en = " Icy Scale Breastplate", name = "Pettorale Corazzato di Scaglie Ghiacciate" },
    [28259] = { en = " Icy Scale Bracers", name = "Bracciali di Scaglie Ghiacciate" },
    [28260] = { en = " Glacial Vest", name = "Veste Glaciale" },
    [28261] = { en = " Glacial Gloves", name = "Guanti Glaciali" },
    [28263] = { en = " Glacial Cloak", name = "Mantello Glaciale" },
    [30021] = { en = "Crystal Infused Bandage", name = "Benda Infusa di Cristalli" },
}
for id, record in pairs(translatedSpellNames) do
    local current = ns.data.spells[id]
    if current == nil then
        ns.data.spells[id] = record
    elseif type(current) == "table" and current.name == nil and
           (current.en == nil or current.en == record.en) then
        current.en = current.en or record.en
        current.name = record.name
    end
end
