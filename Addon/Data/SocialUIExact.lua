local _, ns = ...
ns.data = ns.data or {}

-- Exact first-party English strings from the installed beta client's
-- WFI_DB.audit.globals capture. Player names, community names, and chat text
-- are deliberately excluded.
local translations = {
    -- Guild and community panels
    ["A guild is a tight-knit group of players who want to enjoy the game together. By joining a guild, you'll gain access to many benefits, including a shared guild bank and a guild chat channel.|n|nConsider forming a guild of your own if you have friends who also play World of Warcraft. To create a guild, talk to a Guild Master in a major city."] = "Una gilda è un gruppo affiatato di giocatori che vogliono divertirsi insieme. Entrando in una gilda avrai accesso a molti vantaggi, tra cui una banca di gilda condivisa e un canale di chat della gilda.|n|nPuoi anche creare una gilda se hai amici che giocano a World of Warcraft. Per fondarne una, parla con un maestro di gilda in una città principale.",
    ["A guild is a tight-knit group of players who want to enjoy the game together. By joining a guild, you'll gain access to many benefits, including a shared guild bank and a guild chat channel.|n|nUse this tool to find a guild that fits your playstyle."] = "Una gilda è un gruppo affiatato di giocatori che vogliono divertirsi insieme. Entrando in una gilda avrai accesso a molti vantaggi, tra cui una banca di gilda condivisa e un canale di chat della gilda.|n|nUsa questo strumento per trovare una gilda adatta al tuo stile di gioco.",
    ["Create Group"] = "Crea gruppo",
    ["Group Settings"] = "Impostazioni del gruppo",
    ["Create New Link"] = "Crea nuovo link",
    ["Generate New Link"] = "Genera nuovo link",
    ["Copy Link"] = "Copia link",
    ["Remaining Uses:"] = "Utilizzi rimanenti:",
    ["Unread Messages"] = "Messaggi non letti",
    ["Unread"] = "Non letti",
    ["Yesterday"] = "Ieri",
    ["Change"] = "Modifica",
    ["Set Member Note"] = "Imposta nota del membro",
    ["You must transfer ownership before leaving"] = "Devi trasferire la proprietà prima di uscire.",
    ["Lets you invite members of the other faction."] = "Ti permette di invitare membri dell'altra fazione.",
    ["To change the Cross-Faction setting, all members of the other faction must first be removed"] = "Per modificare l'impostazione tra fazioni, devi prima rimuovere tutti i membri dell'altra fazione.",
    ["Optional description of your group"] = "Descrizione facoltativa del gruppo",
    ["Group Description"] = "Descrizione del gruppo",
    ["Leaders and Moderators"] = "Leader e moderatori",
    ["Notification Settings"] = "Impostazioni notifiche",
    ["Create World of Warcraft Community (%s or Cross-Faction)"] = "Crea una comunità di World of Warcraft (%s o tra fazioni)",

    -- Guild management
    ["Purchase a Guild Charter"] = "Acquista un atto costitutivo della gilda",
    ["Guild Charter"] = "Atto costitutivo della gilda",
    ["Guild Challenges"] = "Sfide di gilda",
    ["Guild Challenge"] = "Sfida di gilda",
    ["Guild Dungeon Challenge"] = "Sfida delle spedizioni di gilda",
    ["Guild Raid Challenge"] = "Sfida delle incursioni di gilda",
    ["Win a Rated Battleground while in a guild group."] = "Vinci un campo di battaglia classificato in un gruppo di gilda.",
    ["Complete any level-appropriate scenario while in a guild group."] = "Completa uno scenario adatto al tuo livello in un gruppo di gilda.",
    ["This guild challenge has been completed for this week."] = "La sfida di gilda è già stata completata questa settimana.",
    ["Log"] = "Registro",
    ["Availability"] = "Disponibilità",
    ["View:"] = "Visualizza:",
    ["Player Notes:"] = "Note dei giocatori:",
    ["Click here to set a Public Note."] = "Fai clic qui per impostare una nota pubblica.",
    ["Bank Tab Permissions"] = "Permessi delle schede della banca",
    ["Rank Permissions"] = "Permessi del grado",
    ["Update Tab Text"] = "Aggiorna il testo della scheda",
    ["Guild Bank Repair"] = "Riparazioni con la banca di gilda",
    ["Use guild funds for repairs"] = "Usa i fondi della gilda per le riparazioni",
    ["Guild Name Change Alert"] = "Avviso di cambio del nome della gilda",
    ["Enter New Guild Name"] = "Inserisci il nuovo nome della gilda",
    ["Here are your guild rename options:"] = "Ecco le opzioni per cambiare il nome della gilda:",
    ["This cost will be deducted from your guild bank funds:"] = "Il costo verrà detratto dai fondi della banca di gilda:",
    ["Refund would exceed the amount the guild bank can hold"] = "Il rimborso supererebbe la capienza della banca di gilda.",
    ["Guild Request Sent"] = "Richiesta di ingresso in gilda inviata",
    ["Rank unavailable"] = "Grado non disponibile",
    ["Any Level"] = "Qualsiasi livello",
    ["Casual"] = "Informale",
    ["Moderate"] = "Moderato",
    ["Hardcore"] = "Impegnativo",
    ["New Rank"] = "Nuovo grado",
    ["Duplicate Rank"] = "Duplica grado",

    -- Friends and social controls
    ["Add Character Friend"] = "Aggiungi amico personaggio",
    ["BattleTag | Real ID"] = "BattleTag | Real ID",
    ["New Blizzard Whispers"] = "Nuovi sussurri Blizzard",
    ["Roleplaying"] = "Interpretazione",
    ["Delves"] = "Scorribande",
    ["Questing"] = "Missioni",
    ["Status: %s"] = "Stato: %s",
    ["Friends and Guildmates"] = "Amici e membri della gilda",
    ["Choose who can see your current in-game location in the Social menu"] = "Scegli chi può vedere la tua posizione attuale nel gioco dal menu Social.",
    ["Search for keywords"] = "Cerca parole chiave",
    ["Received (%d)"] = "Ricevute (%d)",
    ["Favorites %d/%d"] = "Preferiti %d/%d",
    ["Quick Join"] = "Accesso rapido",
    ["Recruit A Friend"] = "Recluta un amico",
    ["Social Features Unavailable"] = "Funzioni social non disponibili",

    -- Group finder
    ["Only the group leader can create a listing for your group."] = "Solo il capogruppo può creare un annuncio per il gruppo.",
    ["Only the group leader can modify your group's listing."] = "Solo il capogruppo può modificare l'annuncio del gruppo.",
    ["Minimum Mythic+ Rating"] = "Valutazione Mitica+ minima",
    ["Min. Item Level"] = "Livello oggetto minimo",
    ["Choose your Role"] = "Scegli il tuo ruolo",
    ["Activity"] = "Attività",
    ["Competitive"] = "Competitivo",
    ["Select Playstyle (required)"] = "Seleziona lo stile di gioco (obbligatorio)",
    ["Browse Groups"] = "Sfoglia i gruppi",
    ["Create Listing"] = "Crea annuncio",
    ["Auto Accept"] = "Accettazione automatica",
    ["Invited"] = "Invitato",
    ["You must enter a title for your group."] = "Devi inserire un titolo per il tuo gruppo.",
    ["Make a selection."] = "Effettua una scelta.",
    ["New Players Welcome"] = "Nuovi giocatori benvenuti",
    ["Available Roles:"] = "Ruoli disponibili:",
    ["The group does not need this role."] = "Il gruppo non ha bisogno di questo ruolo.",
    ["This activity doesn't support cross-faction groups.|n|nYour group will only appear to %s players."] = "Questa attività non supporta gruppi tra fazioni.|n|nIl tuo gruppo sarà visibile solo ai giocatori %s.",

    -- Collections and appearances
    ["Items"] = "Oggetti",
    ["Page %d / %d"] = "Pagina %d / %d",
    ["All specializations"] = "Tutte le specializzazioni",
    ["Current specialization only"] = "Solo specializzazione attuale",
    ["Enter Outfit Name:"] = "Inserisci il nome del completo:",
    ["Enter Custom Set Name:"] = "Inserisci il nome del set personalizzato:",
    ["You already have an outfit named %s. Would you like to overwrite it?"] = "Hai già un completo chiamato %s. Vuoi sovrascriverlo?",
    ["That name is unavailable. Please choose a different name and try again."] = "Questo nome non è disponibile. Scegline un altro e riprova.",
    ["You don't have any Custom Sets"] = "Non hai set personalizzati.",
    ["Create outfits from Set appearances you've collected."] = "Crea completi usando gli aspetti dei set che hai collezionato.",
    ["View all the appearance sets you can collect for your class here."] = "Qui puoi vedere tutti i set di aspetti che puoi collezionare per la tua classe.",
    ["No valid items equipped."] = "Non hai equipaggiato oggetti validi.",
    ["You haven't collected this appearance"] = "Non hai collezionato questo aspetto.",
    ["This appearance can't be used by your character"] = "Il tuo personaggio non può usare questo aspetto.",
    ["There is no equipped item in this slot."] = "Non hai un oggetto equipaggiato in questo slot.",
    ["You cannot add any more favorites in this category."] = "Non puoi aggiungere altri preferiti in questa categoria.",
    ["View Ranged Weapon"] = "Mostra arma a distanza",
    ["You have not collected this mount."] = "Non hai collezionato questa cavalcatura.",
    ["You have no valid random companions."] = "Non hai mascotte valide da evocare casualmente.",
    ["Summon Random\nFavorite Pet"] = "Evoca mascotte preferita\ncasuale",
}

-- Existing scanners cover different roots: the general UI module visits
-- Friends/PVE/Collections, while GuildCollections visits guild/community and
-- wardrobe frames. Share exact pairs with both without replacing their tables.
ns.data.ui = ns.data.ui or {}
ns.data.guildCollections = ns.data.guildCollections or {}
for source, target in pairs(translations) do
    ns.data.ui[source] = target
    ns.data.guildCollections[source] = target
end
