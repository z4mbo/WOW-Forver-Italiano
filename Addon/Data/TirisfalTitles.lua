local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = ns.data.quests or {}

-- Classic quest IDs and English titles cross-checked against QuestieDB and Wowhead Classic.
-- Sources: https://github.com/Questie/QuestieDB/blob/master/data/Classic/classicQuestDB.lua
-- https://www.wowhead.com/classic/quests/eastern-kingdoms/tirisfal-glades
-- Full text sources: https://www.60.tools/quests/3902 and https://www.60.tools/quests/380
local titles = {
    [8] = { enTitle = "A Rogue's Deal", title = "Un patto da ladro" },
    [355] = { enTitle = "Speak with Sevren", title = "Parla con Sevren" },
    [359] = { enTitle = "Forsaken Duties", title = "Doveri dei Reietti" },
    [360] = { enTitle = "Return to the Magistrate", title = "Ritorno dal Magistrato" },
    [361] = { enTitle = "A Letter Undelivered", title = "Una lettera mai consegnata" },
    [364] = { enTitle = "The Mindless Ones", title = "I senza mente" },
    [365] = { enTitle = "Fields of Grief", title = "Campi di dolore" },
    [366] = { enTitle = "Return the Book", title = "Restituisci il libro" },
    [368] = { enTitle = "A New Plague", title = "Una nuova piaga" },
    [369] = { enTitle = "A New Plague", title = "Una nuova piaga" },
    [370] = { enTitle = "At War With The Scarlet Crusade", title = "In guerra con la Crociata Scarlatta" },
    [371] = { enTitle = "At War With The Scarlet Crusade", title = "In guerra con la Crociata Scarlatta" },
    [372] = { enTitle = "At War With The Scarlet Crusade", title = "In guerra con la Crociata Scarlatta" },
    [373] = { enTitle = "The Unsent Letter", title = "La lettera mai spedita" },
    [374] = { enTitle = "Proof of Demise", title = "Prova della sconfitta" },
    [377] = { enTitle = "Crime and Punishment", title = "Delitto e castigo" },
    [380] = {
        enTitle = "Night Web's Hollow",
        title = "La tana di Telanotte",
        objectives = "Executor Arren vuole che tu uccida 10 giovani ragni Telanotte e 8 ragni Telanotte.",
        description = "Una delle nostre maggiori difficoltà è procurarci le risorse naturali di cui abbiamo bisogno per sopravvivere. L'oro era scarso persino all'apice del potere dell'Alleanza. A nord-ovest c'è una miniera d'oro invasa dai ragni. Abbiamo bisogno dell'oro della miniera, ma non possiamo certo estrarlo mentre i ragni ci strisciano intorno. Ho pochi uomini da dedicare a questo compito, quindi dovremo procedere un po' alla volta. Vai lassù e vedi cosa riesci a fare per noi, <Name>.",
        progress = "Fa' attenzione al veleno dei ragni, <name>. Se senti un bruciore intenso, forse dovresti farlo controllare.",
        completion = "Mh, è già qualcosa. Ci vorranno alcune settimane o mesi per ripulire del tutto il nido. Poi dovremo scendere laggiù con delle torce per bruciare le ragnatele. Hai fatto bene il tuo dovere, <name>; sono certo che troverò qualcos'altro da farti fare.",
        reward = "Scegli una ricompensa: Gilet di lino, Gambali di pelle zombi oppure Gilet di maglia robusta.",
    },
    [381] = { enTitle = "The Scarlet Crusade", title = "La Crociata Scarlatta" },
    [382] = { enTitle = "The Red Messenger", title = "Il messaggero rosso" },
    [383] = { enTitle = "Vital Intelligence", title = "Informazioni vitali" },
    [405] = { enTitle = "The Prodigal Lich", title = "Il lich prodigo" },
    [407] = { enTitle = "Fields of Grief", title = "Campi di dolore" },
    [408] = { enTitle = "The Family Crypt", title = "La cripta di famiglia" },
    [409] = { enTitle = "Proving Allegiance", title = "Dimostrare la propria lealtà" },
    [410] = { enTitle = "The Dormant Shade", title = "L'ombra dormiente" },
    [411] = { enTitle = "The Prodigal Lich Returns", title = "Il ritorno del lich prodigo" },
    [426] = { enTitle = "The Mills Overrun", title = "I mulini invasi" },
    [431] = { enTitle = "Candles of Beckoning", title = "Candele di richiamo" },
    [445] = { enTitle = "Delivery to Silverpine Forest", title = "Consegna a Silverpine Forest" },
    [492] = { enTitle = "A New Plague", title = "Una nuova piaga" },
    [5481] = { enTitle = "Gordo's Task", title = "L'incarico di Gordo" },
    [3902] = {
        enTitle = "Scavenging Deathknell",
        title = "Rovistare ad Albamorta",
        objectives = "Cerca ad Albamorta e nei dintorni 6 pezzi di equipaggiamento recuperato e riportali alla Guardia della Morte Saltain.",
        description = "Ehi, tu! Se cerchi un modo per renderti utile, ascolta bene! Ci servono nuove reclute appena emerse dalla terra che vadano ad Albamorta in cerca di equipaggiamento utilizzabile. Molto probabilmente lo troverai in pile di casse. Presto sorgeranno altre reclute e, se non vogliamo che vadano in giro nude, è meglio mettersi a rovistare! Al lavoro, miserabile sacco d'ossa! Non ricompenserò chi non si dà da fare.",
        progress = "Sei riuscito a recuperare qualche oggetto utile? Non c'è da vergognarsi a riutilizzare ciò che è stato scartato. Nessuno ci farà l'elemosina: noi Reietti sapremo cavarcela da soli!",
        completion = "Ottimo lavoro, <name>, sapevo che non eri inutile. Tieni, prendi uno degli oggetti migliori che ho trovato tra quelli raccolti finora.",
        reward = "Scegli una ricompensa: Cintura di lino, Bracciali di metallo arrugginito oppure Mantello corto di pipistrello crepuscolare.",
    },
}

for id, quest in pairs(titles) do
    if not ns.data.quests[id] then
        ns.data.quests[id] = quest
    end
end
