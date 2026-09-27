-- High-confidence wrong itIT collision from the exact Forever beta DB2 row.
-- English source and known bad Italian are both guarded at load time.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}
local records = {
    [1257451] = { en = "Netherfroth Shoulders", badIt = "Guanti della Fenice", name = "Paraspalle di schiumanetra" },
    [1257452] = { en = "Netherflame Shoulders", badIt = "Guanti della Fenice", name = "Paraspalle di fiammanetra" },
    [1257453] = { en = "Netherpearl Shoulders", badIt = "Guanti della Fenice", name = "Spallacci di perla del Nether" },
    [1257454] = { en = "Nethershine Shoulders", badIt = "Guanti della Fenice", name = "Spallacci del bagliore del Nether" },
    [1257455] = { en = "Netherlight Shoulders", badIt = "Guanti della Fenice", name = "Paraspalle di lucenetra" },
    [1257456] = { en = "Nethergeld Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di geldanetra" },
    [1257457] = { en = "Netherfroth Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di schiumanetra" },
    [1257458] = { en = "Netherflame Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di fiammanetra" },
    [1257459] = { en = "Netherpearl Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di perlanetra" },
    [1257460] = { en = "Nethershine Cuffs", badIt = "Guanti della Fenice", name = "Polsiere del bagliore del Nether" },
    [1257461] = { en = "Netherlight Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di lucenetra" },
    [1257462] = { en = "Ghostweave Cord", badIt = "Guanti della Fenice", name = "Cordone di tessuto spettrale" },
    [1257463] = { en = "Earthenweave Gloves", badIt = "Guanti della Fenice", name = "Guanti di tessitura terrestre" },
    [1257464] = { en = "Earthenweave Cord", badIt = "Guanti della Fenice", name = "Cordone di tessitura terrestre" },
    [1257465] = { en = "Runecloth Reagent Bag", badIt = "Guanti della Fenice", name = "Borsa dei reagenti di rune" },
    [1257466] = { en = "Gilded Waistcord", badIt = "Guanti della Fenice", name = "Cintura a cordone dorata" },
    [1257467] = { en = "Frothing Waistcord", badIt = "Guanti della Fenice", name = "Cintura schiumante" },
    [1257468] = { en = "Fiery Waistcord", badIt = "Guanti della Fenice", name = "Cintura ardente" },
    [1257469] = { en = "Black Waistcord", badIt = "Guanti della Fenice", name = "Cordone nero" },
    [1257470] = { en = "Golden Waistcord", badIt = "Guanti della Fenice", name = "Cintura a cordone d'oro" },
    [1257471] = { en = "Radiant Waistcord", badIt = "Guanti della Fenice", name = "Cordone radioso" },
    [1257472] = { en = "Earthenweave Boots", badIt = "Guanti della Fenice", name = "Stivali di tessitura terrestre" },
    [1257473] = { en = "Gilded Gloves", badIt = "Guanti della Fenice", name = "Guanti dorati" },
    [1257474] = { en = "Frothing Gloves", badIt = "Guanti della Fenice", name = "Guanti schiumanti" },
    [1257475] = { en = "Fiery Gloves", badIt = "Guanti della Fenice", name = "Guanti ardenti" },
    [1257476] = { en = "Black Gloves", badIt = "Guanti della Fenice", name = "Guanti neri" },
    [1257477] = { en = "Golden Gloves", badIt = "Guanti della Fenice", name = "Guanti d'oro" },
    [1257478] = { en = "Radiant Gloves", badIt = "Guanti della Fenice", name = "Guanti Radiosi" },
    [1257479] = { en = "Gilded Sandals", badIt = "Guanti della Fenice", name = "Sandali dorati" },
    [1257480] = { en = "Frothing Sandals", badIt = "Guanti della Fenice", name = "Sandali schiumanti" },
    [1257481] = { en = "Fiery Sandals", badIt = "Guanti della Fenice", name = "Sandali ardenti" },
    [1257482] = { en = "Black Sandals", badIt = "Guanti della Fenice", name = "Sandali neri" },
    [1257483] = { en = "Golden Sandals", badIt = "Guanti della Fenice", name = "Sandali d'oro" },
    [1257484] = { en = "Radiant Sandals", badIt = "Guanti della Fenice", name = "Sandali radianti" },
    [1257485] = { en = "Earthenweave Mantle", badIt = "Guanti della Fenice", name = "Manto di tessitura terrestre" },
    [1257486] = { en = "Earthenweave Vest", badIt = "Guanti della Fenice", name = "Gilet di tessitura terrestre" },
    [1257487] = { en = "Runecloth Cuffs", badIt = "Guanti della Fenice", name = "Polsiere di rune" },
    [1257488] = { en = "Earthenweave Leggings", badIt = "Guanti della Fenice", name = "Gambiere di tessitura terrestre" },
    [1257489] = { en = "Ghostweave Mantle", badIt = "Guanti della Fenice", name = "Mantello in tessuto fantasma" },
    [1257490] = { en = "Ghostweave Boots", badIt = "Guanti della Fenice", name = "Stivali di tessuto spettrale" },
    [1257491] = { en = "Earthenweave Cuffs", badIt = "Guanti della Fenice", name = "Polsini di tessitura terrestre" },
    [1257492] = { en = "Mooncloth Reagent Bag", badIt = "Guanti della Fenice", name = "Borsa per reagenti di stoffa lunare" },
    [1257493] = { en = "Ghostweave Hood", badIt = "Guanti della Fenice", name = "Cappuccio di tessuto spettrale" },
    [1257494] = { en = "Earthenweave Crown", badIt = "Guanti della Fenice", name = "Corona di tessitura terrestre" },
    [1257495] = { en = "Bottomless Reagent Bag", badIt = "Guanti della Fenice", name = "Borsa senza fondo per reagenti" },
    [1269351] = { en = "Mount Hyjal Transporter", badIt = "Trasportatore di Meccania", name = "Traspositore per il Monte Hyjal" },
    [1310684] = { en = "Lone Wolf", badIt = "Fendenti Furiosi", name = "Lupo Solitario" },
}
for id, record in pairs(records) do
    local current = ns.data.spells[id]
    if current == nil then
        ns.data.spells[id] = { en = record.en, name = record.name, itSource = record.badIt }
    elseif type(current) == "table" and current.en == record.en and
           (current.name == nil or current.name == record.en or
            current.name == record.badIt) then
        current.name = record.name
        if current.itSource == nil then current.itSource = record.badIt end
    elseif type(current) == "table" and current.en == record.en and
           current.itSource == nil then
        current.itSource = record.badIt
    end
end
