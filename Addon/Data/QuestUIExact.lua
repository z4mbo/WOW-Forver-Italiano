local _, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}

-- Exact English strings observed in the Forever beta client audit. Dynamic
-- format strings are handled below only where their audited structure is
-- unambiguous and the live values can be preserved.
local translations = {
    ["Ready for turn-in"] = "Pronta per la consegna",
    ["Shift click a quest to add or remove a quest from your quest watch list."] = "Fai Maiusc-clic su una missione per aggiungerla o rimuoverla dall'elenco delle missioni seguite.",
    ["(click to complete)"] = "(fai clic per completare)",
    ["Click to complete"] = "Fai clic per completare",
    ["Click to complete quest"] = "Fai clic per completare la missione",
    ["Click to view quest"] = "Fai clic per visualizzare la missione",
    ["Open Achievement"] = "Apri impresa",
    ["Open Achievements"] = "Apri imprese",
    ["Open Activity Details"] = "Apri dettagli attività",
    ["Open Task Details"] = "Apri dettagli attività",
    ["Close Quest Details"] = "Chiudi i dettagli della missione",
    ["Open Quest Details"] = "Apri i dettagli della missione",
    ["Open Quest Map"] = "Apri la mappa delle missioni",
    ["No results found"] = "Nessun risultato trovato",
    ["No Active Quests"] = "Nessuna missione attiva",
    ["No quests available|n|nAccept quests by talking to characters with a |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t above their head."] = "Nessuna missione disponibile|n|nAccetta missioni parlando con i personaggi che hanno un'icona |TInterface\\GossipFrame\\AvailableQuestIcon:16:16|t sopra la testa.",
    ["Campaign completed"] = "Campagna completata",
    ["Repeatable (%s left)"] = "Ripetibile (%s rimanenti)",
    ["Storyline (%s)"] = "Trama (%s)",
    ["Important"] = "Importante",
    ["Meta"] = "Meta",
    ["Calling"] = "Incarico",
    ["Storyline"] = "Trama",
    ["Bonus Objectives"] = "Obiettivi bonus",
    ["World Quests"] = "Missioni mondiali",
    ["Completed Quests"] = "Missioni completate",
    ["Objective Tracker"] = "Tracciamento obiettivi",
    ["Sort Quests"] = "Ordina missioni",
    ["Move to Top"] = "Sposta in alto",
    ["Move Up"] = "Sposta su",
    ["Move Down"] = "Sposta giù",
    ["Move to Bottom"] = "Sposta in basso",
    ["Difficulty High"] = "Difficoltà elevata",
    ["Difficulty Low"] = "Difficoltà ridotta",
    ["Remote Zones"] = "Zone distanti",
    ["On quest"] = "Missione attiva",
    ["Not on quest"] = "Missione non attiva",
    ["You are on this quest"] = "Hai questa missione",
    ["This quest has no objectives to track"] = "Questa missione non ha obiettivi da seguire",
    ["You may only watch %d quests at a time."] = "Puoi seguire al massimo %d missioni alla volta.",
    ["You can't track any more quests."] = "Non puoi seguire altre missioni.",
    ["You cannot track quests while in an Arena."] = "Non puoi seguire missioni mentre sei in un'arena.",
    ["Untrack All"] = "Smetti di seguire tutte",
    ["Track All"] = "Segui tutte",
    ["Show Travel Route"] = "Mostra il percorso",
    ["Show Final Destination"] = "Mostra la destinazione finale",
    ["Requirements:"] = "Requisiti:",
    ["Learn Spell: %s"] = "Impara l'incantesimo: %s",
    ["You will also receive:"] = "Riceverai anche:",
    ["This is a one-time Account reputation bonus"] = "Questo è un bonus reputazione dell'account una tantum",
    ["Awards a one-time Account reputation bonus"] = "Fornisce un bonus reputazione dell'account una tantum",
    ["Party Sync is Active"] = "Sincronizzazione di gruppo attiva",
    ["Waiting on party members..."] = "In attesa dei membri del gruppo...",
    ["Sync and replay quests with party members."] = "Sincronizza le missioni e rigiocale con i membri del gruppo.",
    ["Quests and levels are synced"] = "Missioni e livelli sono sincronizzati",
    ["Start Party Sync"] = "Avvia la sincronizzazione di gruppo",
    ["Stop Party Sync"] = "Interrompi la sincronizzazione di gruppo",
    ["Invite to Party Sync"] = "Invita alla sincronizzazione di gruppo",
    ["Join an ongoing Party Sync session"] = "Unisciti a una sessione di sincronizzazione di gruppo in corso",
    ["Invited to Party Sync"] = "Invitato alla sincronizzazione di gruppo",
    ["Party Sync join request"] = "Richiesta di partecipazione alla sincronizzazione di gruppo",
    ["Stop"] = "Interrompi",
    ["Request To Join"] = "Richiedi di unirti",
    ["Start"] = "Avvia",
    ["Convert"] = "Converti",
    ["Leave"] = "Lascia",
    ["Replay Quest"] = "Rigioca missione",
    ["Not a Replay Quest"] = "Non è una missione rigiocabile",
    ["Quest Disabled"] = "Missione disattivata",
    ["Disabled by Party Sync"] = "Disattivata dalla sincronizzazione di gruppo",
    ["Quest On Hold"] = "Missione in pausa",
    ["Quest Complete!"] = "Missione completata!",
    ["Quest Discovered!"] = "Missione scoperta!",
    ["Return to your normal level and quests."] = "Torna al tuo livello e alle tue missioni normali.",
    ["Return to the Great Vault to Claim your Reward"] = "Torna alla Grande Cripta per ritirare la ricompensa",
}

for source, translated in pairs(translations) do
    ns.data.ui[source] = translated
end

-- Rendered variants of audited format strings. Capture groups carry only the
-- live values through the Italian label.
ns.data.uiPatterns = ns.data.uiPatterns or {}
for _, rule in ipairs({
    { pattern = "^Repeatable %((.+) left%)$", replacement = "Ripetibile (%1 rimanenti)" },
    { pattern = "^Storyline %((.+)%)$", replacement = "Trama (%1)" },
    { pattern = "^Learn Spell: (.+)$", replacement = "Impara l'incantesimo: %1" },
}) do
    ns.data.uiPatterns[#ns.data.uiPatterns + 1] = rule
end
