local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = {
    -- English names and IDs cross-checked against Wowhead Classic and the WoW Forever quest database.
    -- Sources: https://www.wowhead.com/classic/quest=783/a-threat-within
    -- https://www.wowhead.com/classic/guide/quests/alliance-reputation-quests-leveling
    -- https://www.wowhead.com/classic/guide/quests/horde-reputation-quests-leveling
    -- https://www.wowhead.com/classic/quest=367/a-new-plague
    -- https://www.60.tools/quests/398
    -- Human (Elwynn Forest)
    [783] = { enTitle = "A Threat Within", title = "La minaccia interiore" },
    [7] = { enTitle = "Kobold Camp Cleanup", title = "Ripulire l'accampamento dei kobold" },
    [15] = { enTitle = "Investigate Echo Ridge", title = "Indagare su Crestarossa" },
    [18] = { enTitle = "Brotherhood of Thieves", title = "La Fratellanza dei Ladri" },
    [33] = { enTitle = "Wolves Across the Border", title = "Lupi oltre il confine" },
    [6] = { enTitle = "Bounty on Garrick Padfoot", title = "Taglia su Garrick Piedelesto" },

    -- Dwarf and Gnome (shared starting zone: Dun Morogh)
    [179] = { enTitle = "Dwarven Outfitters", title = "Provviste per i nani" },
    [170] = { enTitle = "A New Threat", title = "Una nuova minaccia" },
    [233] = { enTitle = "Coldridge Valley Mail Delivery", title = "Consegna della posta nella Valle di Crestaneve" },
    [183] = { enTitle = "The Boar Hunter", title = "Il cacciatore di cinghiali" },

    -- Night Elf (Teldrassil)
    [456] = { enTitle = "The Balance of Nature", title = "L'equilibrio della natura" },
    [458] = { enTitle = "The Woodland Protector", title = "Il protettore del bosco" },
    [459] = { enTitle = "The Woodland Protector", title = "Il protettore del bosco" },

    -- Undead (Tirisfal Glades)
    [363] = { enTitle = "Rude Awakening", title = "Un brusco risveglio" },
    [356] = {
        enTitle = "Rear Guard Patrol",
        title = "Pattuglia di retroguardia",
        objectives = "Uccidi 8 orrori sanguinanti e 8 spiriti erranti, poi fai rapporto a Linnea al suo accampamento.",
        description = "I difensori del Bastione, che protegge Tirisfal dalle Terre Infette, sono sempre in allerta. Ma a volte il Flagello riesce a superarli. Il successo del Bastione dipende da una battaglia su un solo fronte: non possiamo permettere un attacco alle spalle né che venga tagliata la linea di rifornimento dei nostri difensori. Aiuta il Bastione. Pattuglia la zona a est e uccidi ogni membro del Flagello che trovi. Dedica particolare attenzione alla Fattoria di Balnir, a est. È diventata un rifugio per gli invasori del Flagello.",
        progress = "Hai un rapporto sulla tua pattuglia?",
        completion = "Molto bene. I tuoi sforzi contribuiscono a tenere a bada il Flagello. Invierò una menzione d'onore al mio superiore, Executor Zygand.",
    },
    [367] = {
        enTitle = "A New Plague",
        title = "Una nuova piaga",
        objectives = "Apothecary Johaan a Brill vuole che tu raccolga 5 fiale di sangue di segugio oscuro.",
        description = "Lady Sylvanas ha fatto appello alla Reale Società degli Speziali. La Signora Oscura crede che le nostre conoscenze, unite alla magia appena scoperta, ci daranno la chiave per sconfiggere Arthas. Ci ha sfidati a preparare una nuova piaga, più letale di qualsiasi malattia conosciuta su Azeroth. Questa nuova malattia porterà alla rovina l'esercito del Flagello di Arthas. I miei studi indicano che il sangue delle bestie potrebbe essere la chiave. Portami 5 fiale di sangue di segugio oscuro, così potrò mettere alla prova la mia teoria.",
        progress = "Hai già raccolto 5 fiale di sangue di segugio oscuro, <name>? Il tempo stringe!",
        completion = "Hai fatto un buon lavoro, <name>, e ti ringrazio per i tuoi sforzi.",
    },
    [375] = {
        enTitle = "The Chill of Death",
        title = "Il gelo della morte",
        objectives = "Porta cinque pelli di pipistrello crepuscolare e del filo grezzo a Gretchen Dedmar a Brill.",
        description = "Che freddo, ormai. La Piaga della Non Morte mi serpeggia nelle vene come un serpente gelido. Presto cadrò nello stato di incoscienza. Ma nessun destino infausto mi impedirà di servire la nostra Signora Oscura. Quando ci fu l'appello, cucii i sacchi per i cadaveri dei soldati caduti del potente esercito di Sylvanas. Ora le mie mani tremano per il freddo. Se mi portassi cinque pelli di pipistrello crepuscolare e del filo grezzo, potrei cucirmi una coperta. Aiutami, <name>, così potrò continuare a servire la causa.",
        progress = "Hai già cinque pelli di pipistrello crepuscolare e del filo grezzo, <name>?",
        completion = "Apprezzo i tuoi sforzi, <name>. Che Sylvanas riconosca un giorno il tuo coraggio...",
    },
    [398] = {
        enTitle = "Wanted: Maggot Eye",
        title = "Ricercato: Maggot Eye",
        objectives = "Uccidi Maggot Eye e torna da Executor Zygand a Brill con la sua zampa per riscuotere la ricompensa.",
        description = "Ricercato: Maggot Eye! Una bestia ripugnante persino per gli gnoll, Maggot Eye è stato condannato a morte per i suoi crimini contro i Reietti. Questo spregevole malfattore ruba cadaveri per l'esercito del Re dei Lich. È stato visto per l'ultima volta depredare le terre vicino a Garren's Haunt, a nord di Brill. La città di Brill offre una ricompensa a chiunque abbia il coraggio di giustiziarlo. Mostra a Executor Zygand la zampa del malfattore una volta compiuta l'impresa. La pietà è per i deboli.",
        progress = "Sì?",
        completion = "Le infami azioni di Maggot Eye sono state finalmente vendicate. Forse le tue gesta valorose manderanno un chiaro messaggio a chiunque voglia nuocere al nostro popolo. A nome della città di Brill, ti ringrazio, <name>.",
    },
    [3901] = { enTitle = "Rattling the Rattlecages", title = "Scuotere gli scheletri tintinnanti" },

    -- Additional Tirisfal quests encountered by the account. Exact English text: https://www.60.tools/quests/354
    [354] = {
        enTitle = "Deaths in the Family",
        title = "Morti in famiglia",
        objectives = "Porta i resti di Gregor, Nissa e Thurman a Coleman Farthing a Brill.",
        description = "La famiglia Agamand era la più prospera di Tirisfal. Lavoravo ai loro mulini... prima della Piaga. Quando arrivò per la prima volta il Flagello, gli Agamand fortificarono la loro dimora e convinsero i loro dipendenti a restare e aiutarli a difenderla. Eravamo degli sciocchi, ma almeno eravamo sciocchi leali. L'orgoglio degli Agamand ci condannò alla non morte. E ora sono diventati servitori del Flagello! Servi i Reietti sconfiggendo gli Agamand caduti vittima della Piaga. Servi me portandomi i loro resti.",
        progress = "Hai i resti degli Agamand? Quelle bestie maledette sono state finalmente distrutte?",
        completion = "La vendetta ha un sapore dolce, non credi? Quando hai distrutto gli Agamand, hai notato in loro qualche traccia di libero arbitrio? Lo spero. Spero che abbiano provato paura prima di essere ridotti in polvere. È una speranza sciocca, lo so. Ma continuo comunque a nutrirla.",
    },
    -- Exact English text: https://www.60.tools/quests/358
    [358] = {
        enTitle = "Graverobbers",
        title = "Profanatori di tombe",
        objectives = "Uccidi 8 profanatori di tombe Pellemarcia e 5 bastardi Pellemarcia; raccogli 8 essenze imbalsamanti e portale al Magistrato Sevren a Brill.",
        description = "Le fosse comuni, a sud-ovest di Garren's Haunt, furono scavate per accogliere l'impressionante numero di morti che Tirisfal subì quando arrivò la Piaga. Finora i corpi in queste tombe sono stati risparmiati dalla non morte, ma ora il Flagello manda gli gnoll Pellemarcia a raccogliere i cadaveri e usarli per rinforzare i propri eserciti. Non possiamo permetterlo! Il tuo compito è duplice: uccidi i Pellemarcia presso la fossa comune e Garren's Haunt, e raccogli da loro l'essenza imbalsamante che li tiene in vita.",
        progress = "Hai portato a termine il compito? Hai distrutto quelle bestiacce e drenato la loro essenza?",
        completion = "Eccellente, <name>. Il Flagello si sbaglia se pensa di poter usare quei cadaveri contro di noi, e i nostri Speziali studieranno il fluido che hai raccolto dagli schiavi Pellemarcia. Potrebbe contenere segreti da usare contro di loro. Come dicevo, ben fatto. Ma la nostra lotta continua, e il conflitto ti offrirà sicuramente altre occasioni per dimostrare il tuo valore ai Reietti.",
    },
    -- Exact English text: https://www.60.tools/quests/362
    [362] = {
        enTitle = "The Haunted Mills",
        title = "I mulini infestati",
        objectives = "Uccidi Devlin Agamand e porta i suoi resti a Coleman Farthing a Brill.",
        description = "Devlin Agamand era il minore dei due figli della famiglia Agamand, e in vita i due fratelli non potevano essere più diversi. Thurman era alto e gentile, mentre il fratello minore era debole e dalla lingua tagliente. Quando i Mulini Agamand caddero sotto il giogo della Piaga, non mi sorprese sapere che Devlin era caduto rapidamente. Si sente ancora il suo folle ciarlare vicino alla strada che conduce ai Mulini Agamand. Sto raccogliendo i resti degli Agamand e voglio anche il povero Devlin. Trovalo, distruggilo e portami le sue ossa.",
        progress = "Hai trovato Devlin?",
        completion = "Grazie. Le ossa di Devlin staranno bene sul mio camino. Se il mio cuore gelido può provare calore, è nel sapere che gli Agamand sono stati distrutti. Mi hanno tradito quando arrivò la Piaga: ora giuro che ridurrò in frantumi i loro resti sotto il mio tallone!",
    },
    -- Exact English text: https://www.60.tools/quests/404
    [404] = {
        enTitle = "A Putrid Task",
        title = "Un compito putrido",
        objectives = "Porta 7 artigli putridi a Deathguard Dillinger a Brill.",
        description = "Il Flagello si è infiltrato a Tirisfal e ha infestato la zona a ovest di Brill, vicino al vecchio ponte. Vai lì e respingi i morti in decomposizione e i cadaveri devastati che trovi. Disperdi le loro ossa e riportaci i loro artigli putridi: le Guardie della Morte ti ricompenseranno.",
        progress = "Hai portato a termine il compito che ti ho affidato? Hai quegli artigli putridi?",
        completion = "Ben fatto. Mi dispiace non essere stato lì a vederti ridurre quei non morti in poltiglia putrescente!",
    },
    -- Exact English text: https://www.60.tools/quests/427
    [427] = {
        enTitle = "At War With The Scarlet Crusade",
        title = "In guerra con la Crociata Scarlatta",
        objectives = "Executor Zygand di Brill vuole che tu uccida 10 guerrieri della Crociata Scarlatta.",
        description = "I documenti forniti da Executor Arren sono proprio ciò che ci serviva nella nostra battaglia contro la spregevole Crociata Scarlatta. Ora conosciamo le loro posizioni esatte in tutta Tirisfal. Ma le Guardie della Morte hanno preoccupazioni più pressanti. L'esercito del Re dei Lich cresce ogni notte. Ci serve qualcuno con la tua \"iniziativa\" per rispedire la Crociata Scarlatta nella tomba. Dimostrami che sei in grado di servire la Signora Oscura: viaggia verso ovest, fino alla torre oltre la Fattoria di Solliden, e uccidi 10 guerrieri della Crociata Scarlatta.",
        progress = "Se vuoi dimostrare il tuo valore alla Signora Oscura, uccidi 10 guerrieri della Crociata Scarlatta, <class>.",
        completion = "Eccellente, <class>. La tua abilità nel combattimento è innegabile.",
    },
    -- Exact English text: https://www.60.tools/quests/5482
    [5482] = {
        enTitle = "Doom Weed",
        title = "Erba funesta",
        objectives = "Raccogli 10 erbe funeste e riportale al Giovane Speziale Holland.",
        description = "Ora capisci in che situazione mi trovo, <name>. Quella cosa là fuori sta raccogliendo le erbe sbagliate! Ti ricompenserò se raccoglierai ciò che mi serve. Portami abbastanza erba funesta e ti darò una ricompensa adeguata. A quanto mi risulta, queste erbe infestano la vegetazione vicino alla fossa comune, a nord del cimitero di Brill. Sbrigati e fai attenzione agli gnoll della zona.",
        progress = "Spero che tu abbia buone notizie. Hai tutta l'erba funesta che mi serve?",
        completion = "Ah, la mia erba funesta. Eccellente! <Il Giovane Speziale Holland si sfrega avidamente le mani.> Mi tornerà molto utile. Oggi hai reso un ottimo servizio a me, ehm, alla Signora, <name>. Come promesso, ecco la ricompensa che meriti.",
    },

    -- Orc (Durotar)
    [788] = { enTitle = "Cutting Teeth", title = "Mettere i denti" },
    [792] = { enTitle = "Vile Familiars", title = "Famigli immondi" },
    [5441] = { enTitle = "Lazy Peons", title = "Peoni fannulloni" },

    -- Tauren (Mulgore)
    [747] = { enTitle = "The Hunt Begins", title = "Inizia la caccia" },
    [753] = { enTitle = "A Humble Task", title = "Un compito umile" },
    [750] = { enTitle = "The Hunt Continues", title = "La caccia continua" },
}
