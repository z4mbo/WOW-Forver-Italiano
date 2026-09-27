-- Generated from exact local beta DB2 English sources and GPT Luna low translations.
-- Each runtime match is also gated by the original ID and source text.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}
local records = {
    [1320227] = { en = "[DNT] Tim's Test Visual 4", name = "[DNT] Effetto visivo di test di Tim 4" },
    [1320269] = { en = "Toofbreak", name = "Rompidenti" },
    [1320330] = { en = "Black Horn Necklace", name = "Collana del corno nero" },
    [1320332] = { en = "Black Horn Necklace", name = "Collana del corno nero" },
    [1320446] = { en = "[DNT] Test Spell", name = "[DNT] Incantesimo di test" },
    [1320496] = { en = "Carrying Unstable Potion", name = "Trasporto di pozione instabile" },
    [1320512] = { en = "Cosmetic Lightning", name = "Fulmine cosmetico" },
    [1320579] = { en = "Desert Winds", name = "Venti del deserto" },
    [1320580] = { en = "Desert Winds", name = "Venti del deserto" },
    [1320658] = { en = "Unleash Swarm", name = "Scatena lo sciame" },
    [1320758] = { en = "Summon Spawn of Grubthor", name = "Evoca Progenie di Grubthor" },
    [1320864] = { en = "Repair the Atal'ai Spear", name = "Ripara la lancia Atal'ai" },
    [1320898] = { en = "Toss Crystal Heart", name = "Lancia cuore di cristallo" },
    [1320904] = { en = "Conjure Pylon Protector", name = "Evoca protettore del pilone" },
    [1320922] = { en = "Stock Crate", name = "Cassa di rifornimenti" },
    [1320925] = { en = "Ablaze", name = "In fiamme" },
    [1320965] = { en = "Mend Windstone", name = "Riparare la pietravento" },
    [1320971] = { en = "Gather Data", name = "Raccogli dati" },
    [1320972] = { en = "Gather Data", name = "Raccogli dati" },
    [1321139] = { en = "Night Watchman's Torch", name = "Torcia del guardiano notturno" },
    [1321197] = { en = "Spirit Wolves", name = "Lupi spirituali" },
    [1321320] = { en = "Shiny Silver Coin", name = "Moneta d'argento lucente" },
    [1321323] = { en = "Shiny Silver Coin", name = "Moneta d'argento lucente" },
    [1321337] = { en = "DNT", name = "DNT" },
    [1321339] = { en = "DNT", name = "DNT" },
    [1321343] = { en = "DNT", name = "DNT" },
    [1321449] = { en = "Create Area Trigger", name = "Crea attivatore d'area" },
    [1321558] = { en = "Siphon the Grave", name = "Prosciuga la tomba" },
    [1321560] = { en = "Siphon the Grave", name = "Prosciuga la tomba" },
    [1321586] = { en = "Rotmending", name = "Cura della putrefazione" },
    [1321587] = { en = "Rotmending", name = "Cura della putrefazione" },
    [1321960] = { en = "Move to Highest Threat Target Primer", name = "Spostati sul bersaglio con la minaccia più alta: innesco" },
}
for id, record in pairs(records) do
    local current = ns.data.spells[id]
    if current == nil then
        ns.data.spells[id] = record
    elseif type(current) == "table" and
           (current.name == nil or current.name == record.en) and
           (current.en == nil or current.en == record.en) then
        current.en = current.en or record.en
        current.name = record.name
    end
end
