-- Generated from exact ItemSparse Retail enUS/itIT matches for Forever beta IDs.
-- The source ID and exact beta enUS name gate every fallback; existing names are preserved.
local _, ns = ...
ns.data = ns.data or {}
ns.data.items = ns.data.items or {}
local reused = {
    [1793] = { en = "Patched Leather Shoulderpads", name = "Spalletti di Cuoio Rattoppati" },
    [2534] = { en = "Rondel", name = "Daga a Rondelle" },
    [2613] = { en = "Double-Stitched Robes", name = "Vesti con Doppia Cucitura" },
    [3811] = { en = "Double-Stitched Cloak", name = "Mantello con Doppia Cucitura" },
    [4314] = { en = "Double-Stitched Woolen Shoulders", name = "Spallacci di Lana con Doppia Cucitura" },
    [9750] = { en = "Nomad Sash", name = "Fascia da Nomade" },
    [9751] = { en = "Nomad Sandals", name = "Grancalzari da Nomade" },
    [9752] = { en = "Nomad Bands", name = "Nastri da Nomade" },
    [9754] = { en = "Nomad Cloak", name = "Mantello da Nomade" },
    [9755] = { en = "Nomad Gloves", name = "Guanti da Nomade" },
    [11108] = { en = "Faded Photograph", name = "Fotografia Sbiadita" },
    [17716] = { en = "Snowmaster 9000", name = "Creaneve 9000" },
    [18251] = { en = "Core Armor Kit", name = "Potenziamento d'Armatura del Nucleo" },
    [18252] = { en = "Pattern: Core Armor Kit", name = "Modello: Potenziamento d'Armatura del Nucleo" },
    [18283] = { en = "Biznicks 247x128 Accurascope", name = "Ultramirino Bizz 247x128" },
    [18290] = { en = "Schematic: Biznicks 247x128 Accurascope", name = "Schema: Ultramirino Bizz 247x128" },
    [19054] = { en = "Red Dragon Orb", name = "Globo della Serpe Rossa" },
    [19055] = { en = "Green Dragon Orb", name = "Globo della Serpe Verde" },
    [19642] = { en = "iCoke Prize Voucher", name = "Buono Premio iCola" },
    [20007] = { en = "Mageblood Elixir", name = "Elisir del Sangue Magico" },
    [20011] = { en = "Recipe: Mageblood Elixir", name = "Ricetta: Elisir del Sangue Magico" },
    [22781] = { en = "Polar Bear Collar", name = "Collare dell'Orso Polare" },
    [22822] = { en = "iCoke Prize Voucher", name = "Buono Premio iCola" },
    [23224] = { en = "Summer Gift Package", name = "Pacco di Doni Estivi" },
    [23227] = { en = "iCoke Gift Box Voucher", name = "Buono per un Pacco Regalo iCola" },
    [33154] = { en = "Sinister Squashling", name = "Zucca Malefica" },
    [44803] = { en = "Spring Circlet", name = "Orecchie da Coniglio" },
    [46102] = { en = "Whistle of the Venomhide Ravasaur", name = "Fischietto del Devasauro Malapelle" },
    [46362] = { en = "Venomhide Hatchling", name = "Cucciolo di Malapelle" },
    [74610] = { en = "Lunar Lantern", name = "Lanterna Lunare" },
    [74611] = { en = "Festival Lantern", name = "Lanterna della Celebrazione" },
    [122270] = { en = "WoW Token", name = "Gettone WoW" },
    [122284] = { en = "WoW Token", name = "Gettone WoW" },
    [216696] = { en = "Hidden Pants", name = "Pantaloni Nascosti" },
    [276637] = { en = "Currency Wallet", name = "Borsellino per Valuta" },
}
for id, record in pairs(reused) do
    local current = ns.data.items[id]
    if current == nil then
        current = {}
        ns.data.items[id] = current
    end
    if type(current) == "table" and current.name == nil and
       (current.en == nil or current.en == record.en) then
        current.en = current.en or record.en
        current.name = record.name
        if current.itSource == nil and record.itSource ~= nil then
            current.itSource = record.itSource
        end
    end
end
