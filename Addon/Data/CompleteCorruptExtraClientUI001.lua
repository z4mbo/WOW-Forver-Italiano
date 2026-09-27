-- Proven wrong beta itIT collisions, guarded by DB2 table, field, ID and English.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
ns.data.extraClientTexts = ns.data.extraClientTexts or {}
local rows = {
    { field = "AreaTable.AreaName_lang", id = 15531, en = "The Tainted Scar", badIt = "Antro di Onyxia", it = "La Faglia Corrotta" },
    { field = "AreaTable.AreaName_lang", id = 15532, en = "Storm Cliffs", badIt = "Antro di Onyxia", it = "Scogliere della Tempesta" },
    { field = "AreaTable.AreaName_lang", id = 15825, en = "The Crystal Vale", badIt = "Antro di Onyxia", it = "Valle di Cristallo" },
    { field = "AreaTable.AreaName_lang", id = 16537, en = "Northshire Valley - Camelot", badIt = "Valle di Norlanda", it = "Valle di Northshire - Camelot" },
    { field = "AreaTable.AreaName_lang", id = 16591, en = "Riverglades", badIt = "Valle di Norlanda", it = "Prati fluviali" },
    { field = "AreaTable.AreaName_lang", id = 16651, en = "Shen'dralas", badIt = "Valle delle Ossa", it = "Shen'dralas" },
    { field = "AreaTable.AreaName_lang", id = 16675, en = "Magram Front", badIt = "Valle delle Ossa", it = "Fronte Magram" },
    { field = "AreaTable.AreaName_lang", id = 16676, en = "Outcast Hideaway", badIt = "Valle delle Ossa", it = "Rifugio degli Esiliati" },
    { field = "AreaTable.AreaName_lang", id = 16677, en = "Bristleback Retreat", badIt = "Valle delle Ossa", it = "Rifugio Bristleback" },
    { field = "AreaTable.AreaName_lang", id = 16678, en = "Evenshade's Overlook", badIt = "Valle delle Ossa", it = "Belvedere di Evenshade" },
    { field = "AreaTable.AreaName_lang", id = 16685, en = "Twilight's Shroud", badIt = "Valle di Norlanda", it = "Manto del Crepuscolo" },
    { field = "AreaTable.AreaName_lang", id = 16723, en = "Sunnyglade", badIt = "Valle di Norlanda", it = "Radura soleggiata" },
    { field = "AreaTable.AreaName_lang", id = 16724, en = "Farholde Keep", badIt = "Valle di Norlanda", it = "Forte di Farholde" },
    { field = "AreaTable.AreaName_lang", id = 16725, en = "Wheeler's Grange", badIt = "Valle di Norlanda", it = "Fattoria di Wheeler" },
    { field = "AreaTable.AreaName_lang", id = 16726, en = "Bolder'ok", badIt = "Valle di Norlanda", it = "Bolder'ok" },
    { field = "AreaTable.AreaName_lang", id = 16728, en = "Eastwind Shore", badIt = "Valle di Norlanda", it = "Riva del Vento Orientale" },
    { field = "AreaTable.AreaName_lang", id = 16729, en = "Terral's Watch", badIt = "Valle di Norlanda", it = "Presidio di Terral" },
    { field = "AreaTable.AreaName_lang", id = 16731, en = "Windstead", badIt = "Valle di Norlanda", it = "Windstead" },
    { field = "AreaTable.AreaName_lang", id = 16734, en = "Elbrim's Farm", badIt = "Valle di Norlanda", it = "Fattoria di Elbrim" },
    { field = "AreaTable.AreaName_lang", id = 16736, en = "Turner's Logging Camp", badIt = "Valle di Norlanda", it = "Campo di taglio del legname di Turner" },
    { field = "AreaTable.AreaName_lang", id = 16737, en = "Bristle Hills", badIt = "Valle di Norlanda", it = "Colline Bristle" },
    { field = "AreaTable.AreaName_lang", id = 16739, en = "Poacher's Den", badIt = "Pilastro delle Ceneri", it = "Tana del Bracconiere" },
    { field = "AreaTable.AreaName_lang", id = 16740, en = "Martsirt", badIt = "Pilastro delle Ceneri", it = "Martsirt" },
    { field = "AreaTable.AreaName_lang", id = 16741, en = "Ironforge Submarine Facility", badIt = "Pilastro delle Ceneri", it = "Struttura sottomarina di Forgiardente" },
    { field = "AreaTable.AreaName_lang", id = 16742, en = "Forlorn Gardens", badIt = "Valle delle Ossa", it = "Giardini Solitari" },
    { field = "AreaTable.AreaName_lang", id = 16743, en = "Rog'mar", badIt = "Valle di Norlanda", it = "Rog'mar" },
    { field = "AreaTable.AreaName_lang", id = 16744, en = "Southern Watch", badIt = "Valle di Norlanda", it = "Presidio Meridionale" },
    { field = "Faction.Name_lang", id = 2748, en = "Shen'dorei", badIt = "Crociata Scarlatta", it = "Shen'dorei" },
    { field = "Faction.Name_lang", id = 2758, en = "Nightclaw Druids", badIt = "Crociata Scarlatta", it = "Druidi Artiglio della Notte" },
    { field = "Faction.Name_lang", id = 2759, en = "Neutral Can Attack", badIt = "Nani Ferroscuro", it = "Neutrale, può attaccare" },
    { field = "Faction.Name_lang", id = 2760, en = "Neutral Both But Horde Can Attack", badIt = "Nani Ferroscuro", it = "Entrambe le fazioni neutrali, ma l'Orda può attaccare" },
    { field = "Faction.Name_lang", id = 2761, en = "Fenwick", badIt = "Nani Ferroscuro", it = "Fenwick" },
    { field = "Faction.Name_lang", id = 2778, en = "Windshapers", badIt = "Crociata Scarlatta", it = "Plasmatori del Vento" },
    { field = "Faction.Name_lang", id = 2779, en = "High Order", badIt = "Crociata Scarlatta", it = "Ordine Supremo" },
}
for _, row in ipairs(rows) do
    local entries = ns.data.extraClientTexts[row.field]
    if entries == nil then entries = {}; ns.data.extraClientTexts[row.field] = entries end
    if entries[row.id] == nil then
        entries[row.id] = { en = row.en, it = row.it, badIt = row.badIt }
    end
    if ns.data.ui[row.en] == nil then ns.data.ui[row.en] = row.it end
end
