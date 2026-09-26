local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}

-- HUD Edit Mode labels from the Forever beta client globals or the observed
-- Edit Mode screenshot. Global-backed keys retain their exact client text,
-- including formatting escapes where present.
local translations = {
    ["HUD Edit Mode"] = "Modifica HUD",
    ["Layout:"] = "Disposizione:",
    -- These are exact labels captured in the beta Edit Mode UI.
    ["Party"] = "Gruppo",
    ["Damage Done"] = "Danni inflitti",
    ["Modern (Preset)"] = "Moderno (predefinito)",
    ["Edit Mode Transparency"] = "Trasparenza della modalità modifica",
    ["Show Grid"] = "Mostra griglia",
    ["Snap to Elements"] = "Allinea agli elementi",
    ["Advanced Options"] = "Opzioni avanzate",
    ["Frames"] = "Riquadri",
    ["Target and Focus"] = "Bersaglio e focus",
    ["Pet Frame"] = "Riquadro della mascotte",
    ["Party Frames"] = "Riquadri del gruppo",
    ["Boss Frames"] = "Riquadri dei boss",
    ["Raid Frames"] = "Riquadri dell'incursione",
    ["Combat"] = "Combattimento",
    ["Buffs and Debuffs"] = "Benefici e penalità",
    ["Cast Bar"] = "Barra di lancio",
    ["Stance Bar"] = "Barra delle posture",
    ["Extra Abilities"] = "Abilità aggiuntive",
    ["Pet Bar"] = "Barra della mascotte",
    ["Possess Bar"] = "Barra di controllo",
    ["Encounter Bar"] = "Barra dell'incontro",
    ["Cooldown Manager"] = "Gestione dei tempi di recupero",
    ["Personal Resource Display"] = "Visualizzazione risorse personali",
    ["Damage Meter"] = "Misuratore dei danni",
    ["External Defensives"] = "Difese esterne",
    ["Totem Bar"] = "Barra dei totem",
    ["Loss of Control"] = "Perdita di controllo",
    ["Swing Timer"] = "Timer degli attacchi",
    ["Misc"] = "Varie",
    ["Status Bar 2"] = "Barra di stato 2",
    ["Status Bar %d"] = "Barra di stato %d",
    ["Vehicle Exit Button"] = "Pulsante per scendere dal veicolo",
    ["HUD Tooltip"] = "Descrizione HUD",
    ["Equipment Durability"] = "Durabilità dell'equipaggiamento",
    ["Duration Bars"] = "Barre della durata",
    ["Loot Window"] = "Finestra del bottino",
    ["Raid Warnings"] = "Avvisi incursione",
    ["Group Finder"] = "Ricerca gruppi",
    ["Collapse options |A:editmode-up-arrow:16:11:0:3|a"] = "Comprimi opzioni |A:editmode-up-arrow:16:11:0:3|a",
    ["Revert All Changes"] = "Annulla tutte le modifiche",
    ["Save"] = "Salva",

    -- The client supplies the preset name through %s; the screenshot shows
    -- the rendered value "Modern (Preset)". This is the exact format string.
    ["%s (Preset)"] = "%s (predefinito)",
}

for source, translated in pairs(translations) do
    ns.data.ui[source] = translated
end
