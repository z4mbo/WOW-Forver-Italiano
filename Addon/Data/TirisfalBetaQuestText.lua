local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = ns.data.quests or {}

-- Exact quest text from the installed Forever beta enUS quest cache, build 1.60.1.70009.
-- IDs and titles are matched to their WDB records; only missing fields are filled.
local function addBetaText(id, enTitle, objectives, description)
    local quest = ns.data.quests[id]
    if not quest or quest.enTitle ~= enTitle then
        return
    end
    if quest.objectives == nil then
        quest.objectives = objectives
    end
    if quest.description == nil then
        quest.description = description
    end
end

addBetaText(364, "The Mindless Ones",
    "Il Sacerdote dell'Ombra Sarvis vuole che tu uccida 8 zombi senza mente e 8 zombi miserabili.",
    "Noi Reietti siamo in guerra con l'esercito del Flagello del Re dei Lich: orde di non morti rianimati con la negromanzia, feroci bestie del nord e spettri tormentati.$b$bLa parte settentrionale del villaggio è stata invasa dai senza mente: devono essere distrutti. Uccidili senza pietà, anche se un tempo erano nostri fratelli e sorelle. I Caduti non sono altro che schiavi del Re dei Lich.")

addBetaText(3901, "Rattling the Rattlecages",
    "Uccidi 12 scheletri tintinnanti, poi torna dal Sacerdote dell'Ombra Sarvis ad Albamorta.",
    "Hai dimostrato il tuo potenziale ai Reietti in condizioni normali, $n; ora vediamo come te la cavi sotto pressione.$B$BGli scheletri tintinnanti, altri servitori senza mente del Re dei Lich, sono avversari più temibili degli zombi che hai affrontato finora. Riducine ancora il numero e dimostra il tuo valore ai Reietti. Non indugiare: quando hai finito, torna a parlarmi.")
