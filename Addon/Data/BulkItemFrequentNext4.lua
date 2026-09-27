-- Item description priority snapshot ranks 451-600; source-backed Italian overrides.

local _, ns = ...

ns.data = ns.data or {}

ns.data.itemDescriptionOverrides = ns.data.itemDescriptionOverrides or {}



local frequentItemDescriptions = {

    [215153] = { enName = "Schematic: Whirling Truesilver Gearwall", itName = "Progetto: Spallacci di Mithril Decorati", enDescription = "Teaches you how to make a Whirling Truesilver Gearwall.", description = "Ti insegna a creare un Ingranaggio d’Argento Vero Rotante." },

    [215155] = { enName = "Plans: Tempered Interference-Negating Helmet", itName = "Plans: Tempered Interference-Negating Helmet", enDescription = "Teaches you how to make a Tempered Interference-Negating Helmet", description = "Ti insegna a creare un Elmo Temperato Anti-interferenza." },

    [215156] = { enName = "Schematic: Hyperconductive Goldwrap", itName = "Schema: Mantello Paracadute", enDescription = "Teaches you how to make a Hyperconductive Goldwap", description = "Ti insegna a creare un Copricapo Dorato Iperconduttivo." },

    [215163] = { enName = "Recipe: Mildly-Irradiated Rejuvenation Potion", itName = "Ricetta: Trasmutazione - Mithril in Verargento", enDescription = "Teaches you how to brew a Mildly Irradiated Rejuvenation Potion.", description = "Ti insegna a preparare una Pozione di Rinvigorimento Lievemente Irradiata." },

    [215367] = { enName = "Pattern: Faintly Glowing Leather", itName = "Modello: Cintura della Barbarie", enDescription = "Teaches you how to craft a bundle of Faintly Glowing Leather. ", description = "Ti insegna a creare un fascio di Cuoio Debolmente Luminescente." },

    [215368] = { enName = "Pattern: Hyperconductive Arcano-Filament", itName = "Modello: Cintura della Barbarie", enDescription = "Teaches you how to craft a spool of Hyperconductive Arcano-Filament. ", description = "Ti insegna a creare una bobina di Arcano-Filamento Iperconduttivo." },

    [215369] = { enName = "Pattern: Invoker's Cord", itName = "Modello: Guanti della Fenice", enDescription = "Teaches you how to sew Invoker's Cord.", description = "Ti insegna a cucire la Cintura dell’Invocatore." },

    [215370] = { enName = "Pattern: Invoker's Mantle", itName = "Modello: Guanti della Fenice", enDescription = "Teaches you how to sew Invoker's Mantle.", description = "Ti insegna a cucire il Manto dell’Invocatore." },

    [215383] = { enName = "Plans: Reflective Truesilver Braincage", itName = "Progetto: Spallacci di Mithril Decorati", enDescription = "Teaches you how to make a Reflective Truesilver Braincage.", description = "Ti insegna a creare una Gabbia Cranica Riflettente in Argento Vero." },

    [215384] = { enName = "Plans: Low-Background Truesilver Plates", itName = "Progetto: Spallacci di Mithril Decorati", enDescription = "Teaches you how to make Low-Background Truesilver Plates.", description = "Ti insegna a creare Piastre d’Argento Vero a Bassa Radiazione." },

    [215422] = { enName = "Pattern: Glowing Hyperconductive Scale Coif", itName = "Modello: Stivali Foschi", enDescription = "Teaches you how to craft a Glowing Hyperconductive Scale Coif.", description = "Ti insegna a creare un Copricapo Luminescente di Scaglie Iperconduttive." },

    [215423] = { enName = "Pattern: Gneuro-Conductive Channeler's Hood", itName = "Modello: Stivali Foschi", enDescription = "Teaches you how to craft a Gneuro-Conductive Channeler's Hood.", description = "Ti insegna a creare un Cappuccio del Canalizzatore Gneuroconduttivo." },

    [215424] = { enName = "Pattern: Rad-Resistant Scale Hood", itName = "Modello: Stivali Foschi", enDescription = "Teaches you how to craft a Rad-Resistant Scale Hood.", description = "Ti insegna a creare un Cappuccio di Scaglie Resistente alle Radiazioni." },

    [215432] = { enName = "Schematic: Ez-Thro Radiation Bomb", itName = "Progetto: Spallacci di Mithril Decorati", enDescription = "Teaches you how to make an Ez-Thro Radiation Bombs.", description = "Ti insegna a creare Bombe di Radiazioni Ez-Thro." },

    [215443] = { enName = "Shattered Orb Fragment", itName = "Messaggio Piegato Accuratamente", enDescription = "The remains of the shattered orb glow faintly and are warm to the touch.", description = "I resti del globo frantumato brillano debolmente e sono caldi al tatto." },

    [215456] = { enName = "Singed Message", enDescription = "Told you so.", description = "Te l’avevo detto." },

    [215458] = { enName = "Enclosed Message", enDescription = "Seriously, DO NOT try to open the final box. You already got what you wanted.", description = "Sul serio, NON provare ad aprire la scatola finale. Hai già ottenuto ciò che volevi." },

    [215459] = { enName = "Enclosed Message", enDescription = "Stop now. This is your final warning.", description = "Fermati subito. Questo è il tuo ultimo avvertimento." },

    [215460] = { enName = "Enclosed Message", enDescription = "BEWARE! The box beside this note should never be opened.", description = "ATTENZIONE! La scatola accanto a questo messaggio non deve mai essere aperta." },

    [215468] = { enName = "Orders from the Grand Crusader", itName = "Lettera Stantia", enDescription = "The letter is crumpled and there are flecks of dried blood on it.", description = "La lettera è stropicciata e macchiata di sangue secco." },

    [215683] = { enName = "Geomancy: The Stone-Cold Truth", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Theories on the origin and usage of elemental magic. A fine addition to any library's collection.", description = "Teorie sull’origine e l’uso della magia elementale. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215815] = { enName = "Defensive Magics 101", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "An introductory guide to defensive magic and barriers. A fine addition to any library's collection.", description = "Una guida introduttiva alla magia difensiva e alle barriere. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215816] = { enName = "A Web of Lies: Debunking Myths and Legends", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "An incomplete thesis claiming spiders are harmless, but nevertheless a fine addition to any library's collection.", description = "Una tesi incompleta secondo cui i ragni sarebbero innocui, ma comunque un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215817] = { enName = "Demons and You", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "A strange text defending demons, yet nevertheless a fine addition to any library's collection.", description = "Uno strano testo in difesa dei demoni, ma comunque un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215820] = { enName = "Mummies: A Guide to the Unsavory Undead", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Tales frightening enough to scare even the most hardy of warriors. A fine addition to any library's collection.", description = "Racconti abbastanza spaventosi da intimorire anche il guerriero più coraggioso. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215822] = { enName = "RwlRwlRwlRwl!", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "The strange passages are faint but somewhat readable despite water damage. A fine addition to any library's collection.", description = "I passaggi strani sono sbiaditi, ma in parte leggibili nonostante i danni causati dall’acqua. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [215824] = { enName = "A Luddite's Guide to Caring for Your Demonic Pet", itName = "A Luddite's Guide to Caring for Your Demonic Pet", enDescription = "Contains useful tips for keeping pet imps out of your reagents. A fine addition to any library's collection.", description = "Contiene consigli utili per tenere i folletti domestici lontani dai reagenti. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [216637] = { enName = "A Pile of Random Parts", itName = "Granata Corrosa", enDescription = "Someone somewhere may find this stuff useful, but it just looks like junk to you.", description = "Forse qualcuno, da qualche parte, troverà utile questa roba, ma a te sembra solo spazzatura." },

    [216748] = { enName = "Grimoire of Portal of Summoning", enDescription = "Teaches you Portal of Summoning.", description = "Insegna Portale d’Evocazione." },

    [217161] = { enName = "Torn Mystical Scroll", itName = "Torn Mystical Scroll", enDescription = "It appears to be a list of instructions of some kind, featuring the word \"soap.\"", description = "Sembra una lista di istruzioni di qualche tipo, con la parola «sapone»." },

    [217609] = { enName = "Talisman of Kazdor", enDescription = "The talisman bears a countenance of sheer malice. You avoid staring at it directly.", description = "Il talismano ha un’espressione di pura malvagità. Eviti di guardarlo direttamente." },

    [219404] = { enName = "Shadowscythe", itName = "Gemma di Mana di Dalaran", enDescription = "The ephemeral echo of one of Elune's powerful lost artifacts.", description = "L’eco effimera di uno dei potenti artefatti perduti di Elune." },

    [219405] = { enName = "Ogre Magi Text", itName = "Gemma di Mana di Dalaran", enDescription = "This text is written with the indecipherable scrawl of a madman.", description = "Questo testo è scritto con la grafia indecifrabile di un folle." },

    [219406] = { enName = "Unhatched Green Dragon Egg", itName = "Gemma di Mana di Dalaran", enDescription = "A healthy green dragon egg, but shimmering from the energy of the dream.", description = "Un uovo di drago verde in salute, ma scintillante per l’energia del Sogno." },

    [219414] = { enName = "Shattered Eggshells", itName = "Gemma di Mana di Dalaran", enDescription = "Whatever life they once held has been consumed by the nightmare.", description = "Qualunque vita contenessero è stata consumata dall’incubo." },

    [219447] = { enName = "Dream-Touched Dragon Egg", itName = "Gemma di Mana di Dalaran", enDescription = "A glowing green dragon egg.", description = "Un uovo di drago verde luminoso." },

    [219448] = { enName = "Dreamengine", itName = "Gemma di Mana di Dalaran", enDescription = "A machine to manufacture nightmares.", description = "Una macchina per fabbricare incubi." },

    [219449] = { enName = "Azsharan Prophecy", itName = "Gemma di Mana di Dalaran", enDescription = "An ancient prophecy on a delicate scroll.", description = "Un’antica profezia su una pergamena delicata." },

    [219488] = { enName = "Star-Touched Dragonegg", itName = "Gemma di Mana di Dalaran", enDescription = "A radiant dragon egg.", description = "Un uovo di drago radioso." },

    [219490] = { enName = "Elunar Relic", itName = "Gemma di Mana di Dalaran", enDescription = "A lost gift from Elune to the Wildkin.", description = "Un dono perduto che Elune fece ai Selvatici." },

    [219491] = { enName = "Dreampearl", itName = "Gemma di Mana di Dalaran", enDescription = "Recovered from a shell beneath the Dreaming Sea.", description = "Recuperata da una conchiglia sotto il Mare Onirico." },

    [219518] = { enName = "Harpy Screed", itName = "Gemma di Mana di Dalaran", enDescription = "Delirious rantings of the Harpy Queen.", description = "Deliri sconclusionati della Regina delle Arpie." },

    [219519] = { enName = "Mad Keeper's Notes", itName = "Gemma di Mana di Dalaran", enDescription = "Battle plans of a Keeper of the Grove gone mad.", description = "Piani di battaglia di un Custode del Bosco impazzito." },

    [219759] = { enName = "Charla's Field Report", itName = "Gemma di Mana di Dalaran", enDescription = "Field Report from the Twilight Grove", description = "Rapporto dal Bosco del Crepuscolo." },

    [219770] = { enName = "Gemeron's Field Report", itName = "Gemma di Mana di Dalaran", enDescription = "Field Report from Bough Shadow.", description = "Rapporto da Ombra dei Rami." },

    [219771] = { enName = "Thandros' Field Report", itName = "Gemma di Mana di Dalaran", enDescription = "Field Report from Dream Bough.", description = "Rapporto da Ramo del Sogno." },

    [219772] = { enName = "Fallia's Field Report", itName = "Gemma di Mana di Dalaran", enDescription = "Field Report from Seradane.", description = "Rapporto da Seradane." },

    [219776] = { enName = "Intelligence Report: Vul'gol Ogre Mound", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Vul'gol Ogre Mound", description = "Rapporto d’intelligence dal Tumulo degli Ogre di Vul’gol." },

    [219778] = { enName = "Intelligence Report: Rotting Orchard", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from the Rotting Orchard", description = "Rapporto d’intelligence dal Frutteto Putrescente." },

    [219803] = { enName = "Intelligence Report: Yorgen Farmstead", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from the Yorgen Farmstead", description = "Rapporto d’intelligence dalla Fattoria degli Yorgen." },

    [219918] = { enName = "Bloody Missive", itName = "Missiva Ammuffita", enDescription = "This crumpled letter is thick with blood and gore. Gross.", description = "Questa lettera stropicciata è intrisa di sangue e viscere. Che schifo." },

    [219924] = { enName = "Intelligence Report: Forest Song", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Forest Song", description = "Rapporto d’intelligence da Canzone della Foresta." },

    [219925] = { enName = "Intelligence Report: Satyrnaar", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Satyrnaar", description = "Rapporto d’intelligence da Satyrnaar." },

    [219926] = { enName = "Intelligence Report: Warsong Lumber Camp", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from the Warsong Lumber Camp", description = "Rapporto d’intelligence dal Campo di Taglio dei Warsong." },

    [219928] = { enName = "Intelligence Report: Agol'watha", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Agol'watha", description = "Rapporto d’intelligence da Agol’watha." },

    [219937] = { enName = "Intelligence Report: Shaol'watha", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Shaol'watha", description = "Rapporto d’intelligence da Shaol’watha." },

    [219938] = { enName = "Intelligence Report: Skulk Rock", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Skulk Rock", description = "Rapporto d’intelligence dalla Roccia dei Predatori." },

    [219957] = { enName = "Intelligence Report: Oneiros", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from Oneiros", description = "Rapporto d’intelligence da Oneiros." },

    [219958] = { enName = "Intelligence Report: Twin Colossals", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from the Twin Colossals", description = "Rapporto d’intelligence dai Due Colossi." },

    [219959] = { enName = "Intelligence Report: Ruins of Ravenwind", itName = "Gemma di Mana di Dalaran", enDescription = "Intelligence report from the Ruins of Ravenwind", description = "Rapporto d’intelligence dalle Rovine di Ravenwind." },

    [220167] = { enName = "Shimmering Grave Dust", itName = "Nucleo Infernale di Kroshius", enDescription = "Grave dust from the resting place of one murdered by those most loved...", description = "Polvere tombale dal luogo di riposo di una persona uccisa da chi le era più caro…" },

    [220168] = { enName = "Triple-Brewed Molten Lager", itName = "Nucleo Infernale di Kroshius", enDescription = "An elixir of fire, created with steady hands and an unsteady mind...", description = "Un elisir di fuoco, creato con mani ferme e mente instabile…" },

    [220169] = { enName = "Symbol of Faith", itName = "Nucleo Infernale di Kroshius", enDescription = "A symbol of faith, gifted from one with newly discovered purpose...", description = "Un simbolo di fede, donato da qualcuno che ha appena trovato uno scopo…" },

    [220345] = { enName = "Sanguine Sorcery", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Outlines a variety of powerful blood rituals. A controversial addition to any library's collection.", description = "Descrive diversi potenti rituali del sangue. Un’aggiunta controversa alla collezione di qualsiasi biblioteca." },

    [220346] = { enName = "Legends of the Tidesages", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Covered in illegible notes and diagrams scrawled by an unsteady hand. It could still be a decent addition to any library's collection.", description = "Ricoperto di appunti e diagrammi illeggibili tracciati da una mano tremante. Potrebbe comunque essere una discreta aggiunta a qualsiasi biblioteca." },

    [220347] = { enName = "The Liminal and the Arcane", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "The words swim on the page, defying attempts to read them. A puzzling addition to any library's collection.", description = "Le parole si muovono sulla pagina, sfuggendo a ogni tentativo di lettura. Un’aggiunta enigmatica alla collezione di qualsiasi biblioteca." },

    [220348] = { enName = "Everyday Etiquette", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "A guide to the role of elementary magic in polite Highborne society.  A fine addition to any library's collection.", description = "Una guida al ruolo della magia elementale nella società cortese degli Altomaghi. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [220349] = { enName = "Stonewrought Design", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Sturdy architectural techniques capable of withstanding all but the most cataclysmic disasters.  A fine addition to any library's collection.", description = "Tecniche architettoniche robuste, capaci di resistere a tutto tranne che ai disastri più catastrofici. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [220350] = { enName = "Venomous Journeys", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Notes on the mind-altering properties of various toxins and venoms.  A fine addition to any library's collection.", description = "Appunti sulle proprietà che alterano la mente di diverse tossine e diversi veleni. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [220352] = { enName = "A Mind of Metal", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Dwarven techniques for applying magic to metallurgy, strip-mining and heavy industry.  An informative, if bleak, addition to any library's collection.", description = "Tecniche dei nani per applicare la magia alla metallurgia, all’estrazione mineraria intensiva e all’industria pesante. Un’aggiunta istruttiva, seppur cupa, alla collezione di qualsiasi biblioteca." },

    [220353] = { enName = "Conjurer's Codex", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "A pre-war collection of spells and arcane theories that have largely fallen out of modern use.  A fine addition to any library's collection.", description = "Una raccolta prebellica di incantesimi e teorie arcane, ormai in gran parte caduti in disuso. Un’ottima aggiunta alla collezione di qualsiasi biblioteca." },

    [220775] = { enName = "Engineering Exchange Ticket", enDescription = "It just says 'I.O.U' with a smiley face next to it.", description = "C’è scritto solo «pagherò a vista», con una faccina sorridente accanto." },

    [220914] = { enName = "Broken Geode Hammer", enDescription = "The head has split open.", description = "La testa si è spaccata." },

    [220915] = { enName = "Idol of the Raging Shambler", enDescription = "Kill 5 enemies with Nature damage while affected by Barkskin. Then, use this idol to learn a new ability.", description = "Uccidi 5 nemici con danni da Natura mentre sei sotto l’effetto di Pelle di Corteccia. Poi usa questo idolo per apprendere una nuova abilità." },

    [221314] = { enName = "Wanted Notice", itName = "Avviso di Assemblea Cittadina", enDescription = "A crude sketch of a Dark Iron dwarf", description = "Un rozzo schizzo di un nano Ferroscuro." },

    [221324] = { enName = "Brittle Key", itName = "Brittle Key", enDescription = "Attaching this crumbling key to your keyring would be impossible.", description = "Sarebbe impossibile aggiungere questa chiave sgretolata al portachiavi." },

    [221325] = { enName = "EZ-Splode Blasting Charge", itName = "Carica Grande di Nitronite", enDescription = "The slow-burning fuse is already lit!", description = "La miccia a combustione lenta è già accesa!" },

    [221336] = { enName = "Schematic: Goblin Mining Helmet", itName = "Progetto: Catena per Arma d'Acciaio", enDescription = "Teaches you how to craft Goblin Mining Helmet.", description = "Ti insegna a creare un Elmo da Miniera Goblin." },

    [221370] = { enName = "Precious Medallion", enDescription = "The back reads: 'Jabbey + Enie'", description = "Sul retro c’è scritto: «Jabbey + Enie»." },

    [221372] = { enName = "Mangled Coin Purse", enDescription = "The contents were likely damaged in combat.", description = "Probabilmente il contenuto è stato danneggiato in combattimento." },

    [221491] = { enName = "Shadowtooth Bag", itName = "Borsa di Rifornimenti", enDescription = "Contains a random Darkmoon card.", description = "Contiene una carta della Fiera di Lunacupa casuale." },

    [221497] = { enName = "Old Key", itName = "Chiave della Gabbia della Pantera", enDescription = "An old key.", description = "Una vecchia chiave." },

    [221545] = { enName = "Deciphered Warlock Notes", enDescription = "Hurried scribbles about a ritual of summoning.", description = "Appunti frettolosi su un rituale di evocazione." },

    [221547] = { enName = "Coded Warlock Notes", enDescription = "Scrawled notes written in code.", description = "Appunti scarabocchiati in codice." },

    [221549] = { enName = "Wastewander Cipher", enDescription = "A partial cipher written by the Wastewander.", description = "Un cifrario incompleto scritto dai Predoni del Deserto." },

    [221974] = { enName = "Grimtotem Necklace", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "A necklace collected from a diseased Grimtotem Shaman.", description = "Una collana raccolta da uno sciamano Totem Funesto malato." },

    [221975] = { enName = "Broken Woodpaw Staff", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "Part of a staff collected from a diseased Woodpaw Mystic.", description = "Parte di un bastone raccolto da un mistico Zampalesta malato." },

    [221976] = { enName = "Diseased Nature Staff", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "The staff is barely held together, but the ancient magic within may still be of use.", description = "Il bastone è a malapena intatto, ma l’antica magia che contiene potrebbe ancora essere utile." },

    [221978] = { enName = "Explorer's Soul", itName = "Frammento d'Anima", enDescription = "Learn to summon an Explorer Imp.", description = "Impara a evocare un Folletto Esploratore." },

    [223163] = { enName = "Formula: Scroll of Spatial Mending", itName = "Formula: Incanta Arma - Cacciatore di Demoni", enDescription = "Teaches you to create a Scroll of Spatial Mending.", description = "Ti insegna a creare una Pergamena di Riparazione Spaziale." },

    [225676] = { enName = "Molten Obsidian Core", enDescription = "Cool it down before it melts!", description = "Raffreddalo prima che si sciolga!" },

    [225838] = { enName = "Voltaic Icon", enDescription = "Learn a new ability after defeating 3 enemies with a single cast of Chain Lightning.", description = "Apprendi una nuova abilità dopo aver sconfitto 3 nemici con un solo lancio di Catena di Fulmini." },

    [225942] = { enName = "Tainted Boar Meat", enDescription = "Probably just needs some sauce.", description = "Probabilmente basta aggiungere un po’ di salsa." },

    [225943] = { enName = "Rancid Hunk of Flesh", enDescription = "Would make even the lowliest scavenger retch.", description = "Farebbe vomitare anche il più miserabile degli spazzini." },

    [225954] = { enName = "Charred Spell Notes", itName = "Ricetta: Stufato delle Marche Occidentali", enDescription = "A charred and torn page that once held arcane secrets for Engraving abilities, now burnt beyond use.", description = "Una pagina bruciacchiata e strappata che un tempo conteneva segreti arcani sulle abilità d’Incisione, ormai carbonizzata e inutilizzabile." },

    [226201] = { enName = "Squire Cuthbert's Blade", itName = "Messaggio Piegato Accuratamente", enDescription = "The sword is dented and chipped, but it feels well-balanced in your hand.", description = "La spada è ammaccata e scheggiata, ma in mano ti sembra ben bilanciata." },

    [226404] = { enName = "Tarnished Undermine Real", itName = "Bijou Rosso degli Hakkari", enDescription = "This currency is slowly being phased out of circulation, but it still enjoys a very favorable exchange rate throughout the Eastern Kingdoms and Kalimdor.", description = "Questa valuta sta lentamente uscendo dalla circolazione, ma mantiene ancora un tasso di cambio molto favorevole in tutti i Regni Orientali e a Kalimdor." },

    [226420] = { enName = "Finely Crafted Bust", itName = "Idolo d'Onice", enDescription = "A finely crafted work of art. This item would not look out of place in a private collection or museum.", description = "Un’opera d’arte finemente realizzata. Questo oggetto non sfigurerebbe in una collezione privata o in un museo." },

    [226526] = { enName = "Busted Gizmo", enDescription = "Might be salvagable...?", description = "Forse si può recuperare…?" },

    [226856] = { enName = "Guided Buoyancy Accelerant", itName = "Pozione della Velocità di Nuoto", enDescription = "Property of D.E.L.T.A  Deepsea Exploration and Liquefaction Technologies Alliance", description = "Proprietà dell’Alleanza D.E.L.T.A. — Tecnologie di Esplorazione e Liquefazione delle Profondità Marine." },

    [227041] = { enName = "Scourge Shadow Scalpel", itName = "Nucleo Infernale di Kroshius", enDescription = "This device channels and directs foul necrotic energies to dissolve flesh, metal, or any other material mundane or magical. This may be able to disrupt the shield protecting Arkonos.", description = "Questo dispositivo convoglia e dirige energie necrotiche corrotte per dissolvere carne, metallo e qualsiasi altro materiale, comune o magico. Potrebbe riuscire a interrompere lo scudo che protegge Arkonos." },

    [227285] = { enName = "Fantastic Inventions", itName = "Fantastic Inventions", enDescription = "A well-worn tome with countless chapters of mechanisms, schematics, experimental drawings, and universal philosophy.", description = "Un tomo consumato, con innumerevoli capitoli dedicati a meccanismi, schemi, disegni sperimentali e filosofia universale." },

    [227337] = { enName = "Feline Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Fists|r and |cnRARE_BLUE_COLOR:Feralheart Girdle|r (Feral DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Pugni Feralheart|r e |cnRARE_BLUE_COLOR:Cintura Feralheart|r (specializzazione DPS ferina)" },

    [227338] = { enName = "Astral Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Hands|r and |cnRARE_BLUE_COLOR:Feralheart Sash|r (Balance Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Feralheart|r e |cnRARE_BLUE_COLOR:Fascia Feralheart|r (specializzazione Equilibrio)" },

    [227339] = { enName = "Guardian's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Grips|r and |cnRARE_BLUE_COLOR:Feralheart Waistguard|r (Feral Tank Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Feralheart|r e |cnRARE_BLUE_COLOR:Cintura Feralheart|r (specializzazione tank ferina)" },

    [227340] = { enName = "Mender's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Gauntlets|r and |cnRARE_BLUE_COLOR:Feralheart Cord|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Feralheart|r e |cnRARE_BLUE_COLOR:Cordone Feralheart|r (specializzazione Rigenerazione)" },

    [227341] = { enName = "Pursuer's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Beastmaster's Gauntlets|r and |cnRARE_BLUE_COLOR:Beastmaster's Belt|r (Ranged DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti del Beastmaster|r e |cnRARE_BLUE_COLOR:Cintura del Beastmaster|r (specializzazione DPS a distanza)" },

    [227343] = { enName = "Merciful Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Fists|r and |cnRARE_BLUE_COLOR:Soulforge Cord|r (Holy Specialization)", description = "|cnEPIC_PURPLE_COLOR:Pugni Soulforge|r e |cnRARE_BLUE_COLOR:Cordone Soulforge|r (specializzazione Sacro)" },

    [227344] = { enName = "Radiant Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Gauntlets|r and |cnRARE_BLUE_COLOR:Soulforge Belt|r Retribution Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Soulforge|r e |cnRARE_BLUE_COLOR:Cintura Soulforge|r specializzazione Castigo)" },

    [227345] = { enName = "Divine Will Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Handguards|r and |cnRARE_BLUE_COLOR:Soulforge Waistguard|r Protection Specialization)", description = "|cnEPIC_PURPLE_COLOR:Paramani Soulforge|r e |cnRARE_BLUE_COLOR:Cintura Soulforge|r specializzazione Protezione)" },

    [227346] = { enName = "Dawn Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Mitts|r and |cnRARE_BLUE_COLOR:Virtuous Belt|r Healer Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Virtuous|r e |cnRARE_BLUE_COLOR:Cintura Virtuous|r specializzazione curativa)" },

    [227347] = { enName = "Twilight Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Hands|r and |cnRARE_BLUE_COLOR:Virtuous Cord|r Shadow Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Virtuous|r e |cnRARE_BLUE_COLOR:Cordone Virtuous|r specializzazione Ombra)" },

    [227348] = { enName = "Thrill's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Darkmantle Grips|r and |cnRARE_BLUE_COLOR:Darkmantle Belt|r (Melee DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti Darkmantle|r e |cnRARE_BLUE_COLOR:Cintura Darkmantle|r (specializzazione DPS da mischia)" },

    [227350] = { enName = "Relief's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Grasp of the Five Thunders|r and |cnRARE_BLUE_COLOR:Sash of the Five Thunders|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Presa dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Cintura dei Cinque Tuoni|r (specializzazione Rigenerazione)" },

    [227351] = { enName = "Eruption's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Gauntlets of the Five Thunders|r and |cnRARE_BLUE_COLOR:Cord of the Five Thunders|r (Elemental Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Cordone dei Cinque Tuoni|r (specializzazione Elementale)" },

    [227352] = { enName = "Impact's Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Fists of the Five Thunders|r and |cnRARE_BLUE_COLOR:Girdle of the Five Thunders|r (Enhancement DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Pugni dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Cintura dei Cinque Tuoni|r (specializzazione DPS Potenziamento)" },

    [227354] = { enName = "Corrupted Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Deathmist Wraps|r and |cnRARE_BLUE_COLOR:Deathmist Belt|r (Ranged DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Fasce Deathmist|r e |cnRARE_BLUE_COLOR:Cintura Deathmist|r (specializzazione DPS a distanza)" },

    [227356] = { enName = "Immoveable Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Handguard of Heroism|r and |cnRARE_BLUE_COLOR:Waistguard of Heroism|r (Protection Specialization)", description = "|cnEPIC_PURPLE_COLOR:Paramani dell’Eroismo|r e |cnRARE_BLUE_COLOR:Cintura dell’Eroismo|r (specializzazione Protezione)" },

    [227357] = { enName = "Unstoppable Gloves and Belt Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Gauntlets of Heroism|r and |cnRARE_BLUE_COLOR:Belt of Heroism|r (Melee DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Guanti dell’Eroismo|r e |cnRARE_BLUE_COLOR:Cintura dell’Eroismo|r (specializzazione DPS da mischia)" },

    [227359] = { enName = "Feline Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Walkers|r,  |cnRARE_BLUE_COLOR:Feralheart Trousers|r, and |cnRARE_BLUE_COLOR:Feralheart Epaulets|r (Feral DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Stivali Feralheart|r, |cnRARE_BLUE_COLOR:Pantaloni Feralheart|r e |cnRARE_BLUE_COLOR:Paraspalle Feralheart|r (specializzazione DPS ferina)" },

    [227360] = { enName = "Astral Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Galoshes|r,  |cnRARE_BLUE_COLOR:Feralheart Kilt|r, and |cnRARE_BLUE_COLOR:Feralheart Spaulders|r (Balance Specialization)", description = "|cnEPIC_PURPLE_COLOR:Stivali Feralheart|r, |cnRARE_BLUE_COLOR:Gonnellino Feralheart|r e |cnRARE_BLUE_COLOR:Paraspalle Feralheart|r (specializzazione Equilibrio)" },

    [227361] = { enName = "Guardian's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Treads|r,  |cnRARE_BLUE_COLOR:Feralheart Legguards|r, and |cnRARE_BLUE_COLOR:Feralheart Pauldrons|r (Feral Tank Specialization)", description = "|cnEPIC_PURPLE_COLOR:Calzari Feralheart|r, |cnRARE_BLUE_COLOR:Paragambe Feralheart|r e |cnRARE_BLUE_COLOR:Paraspalle Feralheart|r (specializzazione tank ferina)" },

    [227365] = { enName = "Mender's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Sandals|r,  |cnRARE_BLUE_COLOR:Feralheart Pants|r, and |cnRARE_BLUE_COLOR:Feralheart Mantle|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Sandali Feralheart|r, |cnRARE_BLUE_COLOR:Pantaloni Feralheart|r e |cnRARE_BLUE_COLOR:Manto Feralheart|r (specializzazione Rigenerazione)" },

    [227366] = { enName = "Pursuer's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Beastmaster's Treads|r,  |cnRARE_BLUE_COLOR:Beastmaster's Pants|r, and |cnRARE_BLUE_COLOR:Beastmaster's Mantle|r (Ranged DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Stivali del Beastmaster|r, |cnRARE_BLUE_COLOR:Pantaloni del Beastmaster|r e |cnRARE_BLUE_COLOR:Manto del Beastmaster|r (specializzazione DPS a distanza)" },

    [227368] = { enName = "Merciful Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Treads|r,  |cnRARE_BLUE_COLOR:Soulforge Leggings|r, and |cnRARE_BLUE_COLOR:Soulforge Epaulets|r (Holy Specialization)", description = "|cnEPIC_PURPLE_COLOR:Calzari Soulforge|r, |cnRARE_BLUE_COLOR:Gambali Soulforge|r e |cnRARE_BLUE_COLOR:Paraspalle Soulforge|r (specializzazione Sacro)" },

    [227369] = { enName = "Radiant Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Warboots|r,  |cnRARE_BLUE_COLOR:Soulforge Legplates|r, and |cnRARE_BLUE_COLOR:Soulforge Spaulders|r (Retribution Specialization)", description = "|cnEPIC_PURPLE_COLOR:Stivali da guerra Soulforge|r, |cnRARE_BLUE_COLOR:Piastre per le gambe Soulforge|r e |cnRARE_BLUE_COLOR:Paraspalle Soulforge|r (specializzazione Castigo)" },

    [227370] = { enName = "Divine Will Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Sabatons|r,  |cnRARE_BLUE_COLOR:Soulforge Legguards|r, and |cnRARE_BLUE_COLOR:Soulforge Pauldrons|r (Protection Specialization)", description = "|cnEPIC_PURPLE_COLOR:Schinieri Soulforge|r, |cnRARE_BLUE_COLOR:Paragambe Soulforge|r e |cnRARE_BLUE_COLOR:Paraspalle Soulforge|r (specializzazione Protezione)" },

    [227371] = { enName = "Dawn Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Sandals|r,  |cnRARE_BLUE_COLOR:Virtuous Skirt|r, and |cnRARE_BLUE_COLOR:Virtuous Mantle|r (Healer Specialization)", description = "|cnEPIC_PURPLE_COLOR:Sandali Virtuous|r, |cnRARE_BLUE_COLOR:Gonnellino Virtuous|r e |cnRARE_BLUE_COLOR:Manto Virtuous|r (specializzazione curativa)" },

    [227372] = { enName = "Twilight Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Slippers|r,  |cnRARE_BLUE_COLOR:Virtuous Leggings|r, and |cnRARE_BLUE_COLOR:Virtuous Epaulets|r (Shadow Specialization)", description = "|cnEPIC_PURPLE_COLOR:Pantofole Virtuous|r, |cnRARE_BLUE_COLOR:Gambali Virtuous|r e |cnRARE_BLUE_COLOR:Paraspalle Virtuous|r (specializzazione Ombra)" },

    [227373] = { enName = "Thrill's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Darkmantle Footpads|r,  |cnRARE_BLUE_COLOR:Darkmantle Pants|r, and |cnRARE_BLUE_COLOR:Darkmantle Spaulders|r (Melee DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Calzari Darkmantle|r, |cnRARE_BLUE_COLOR:Pantaloni Darkmantle|r e |cnRARE_BLUE_COLOR:Paraspalle Darkmantle|r (specializzazione DPS da mischia)" },

    [227375] = { enName = "Relief's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Greaves of the Five Thunders|r,  |cnRARE_BLUE_COLOR:Leggings of the Five Thunders|r, and |cnRARE_BLUE_COLOR:Mantle of the Five Thunders|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Schinieri dei Cinque Tuoni|r, |cnRARE_BLUE_COLOR:Gambali dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Manto dei Cinque Tuoni|r (specializzazione Rigenerazione)" },

    [227376] = { enName = "Eruption's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Slippers of the Five Thunders|r,  |cnRARE_BLUE_COLOR:Kilt of the Five Thunders|r, and |cnRARE_BLUE_COLOR:Pauldrons of the Five Thunders|r (Elemental Specialization)", description = "|cnEPIC_PURPLE_COLOR:Pantofole dei Cinque Tuoni|r, |cnRARE_BLUE_COLOR:Gonnellino dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Paraspalle dei Cinque Tuoni|r (specializzazione Elementale)" },

    [227377] = { enName = "Impact's Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Treads of the Five Thunders|r,  |cnRARE_BLUE_COLOR:Legplates of the Five Thunders|r, and |cnRARE_BLUE_COLOR:Spaulders of the Five Thunders|r (Enhancement DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Calzari dei Cinque Tuoni|r, |cnRARE_BLUE_COLOR:Piastre per le gambe dei Cinque Tuoni|r e |cnRARE_BLUE_COLOR:Paraspalle dei Cinque Tuoni|r (specializzazione DPS Potenziamento)" },

    [227379] = { enName = "Corrupted Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Deathmist Sandals|r,  |cnRARE_BLUE_COLOR:Deathmist Leggings|r, and |cnRARE_BLUE_COLOR:Deathmist Mantle|r (Ranged DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Sandali Deathmist|r, |cnRARE_BLUE_COLOR:Gambali Deathmist|r e |cnRARE_BLUE_COLOR:Manto Deathmist|r (specializzazione DPS a distanza)" },

    [227381] = { enName = "Immoveable Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Sabatons of Heroism|r,  |cnRARE_BLUE_COLOR:Legguards of Heroism|r, and |cnRARE_BLUE_COLOR:Pauldrons of Heroism|r (Tank Specialization)", description = "|cnEPIC_PURPLE_COLOR:Schinieri dell’Eroismo|r, |cnRARE_BLUE_COLOR:Paragambe dell’Eroismo|r e |cnRARE_BLUE_COLOR:Paraspalle dell’Eroismo|r (specializzazione tank)" },

    [227382] = { enName = "Unstoppable Boots, Legs, and Shoulders Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Battleboots of Heroism|r,  |cnRARE_BLUE_COLOR:Legplates of Heroism|r, and |cnRARE_BLUE_COLOR:Spaulders of Heroism|r (Melee DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Stivali da battaglia dell’Eroismo|r, |cnRARE_BLUE_COLOR:Piastre per le gambe dell’Eroismo|r e |cnRARE_BLUE_COLOR:Paraspalle dell’Eroismo|r (specializzazione DPS da mischia)" },

    [227383] = { enName = "Feline Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Cap|r and |cnEPIC_PURPLE_COLOR:Feralheart Tunic|r (Feral DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Elmo Feralheart|r e |cnEPIC_PURPLE_COLOR:Tunica Feralheart|r (specializzazione DPS ferina)" },

    [227384] = { enName = "Astral Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Cowl|r and |cnEPIC_PURPLE_COLOR:Feralheart Vest|r (Balance Specialization)", description = "|cnEPIC_PURPLE_COLOR:Cappuccio Feralheart|r e |cnEPIC_PURPLE_COLOR:Corazza Feralheart|r (specializzazione Equilibrio)" },

    [227385] = { enName = "Guardian's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Faceguard|r and |cnEPIC_PURPLE_COLOR:Feralheart Armor|r (Feral Tank Specialization)", description = "|cnEPIC_PURPLE_COLOR:Maschera protettiva Feralheart|r e |cnEPIC_PURPLE_COLOR:Armatura Feralheart|r (specializzazione tank ferina)" },

    [227387] = { enName = "Mender's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Feralheart Headdress|r and |cnEPIC_PURPLE_COLOR:Feralheart Embrace|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Copricapo Feralheart|r e |cnEPIC_PURPLE_COLOR:Veste Feralheart|r (specializzazione Rigenerazione)" },

    [227388] = { enName = "Pursuer's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Beastmaster's Cap|r and |cnEPIC_PURPLE_COLOR:Beastmaster's Tunic|r (Ranged DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Elmo del Beastmaster|r e |cnEPIC_PURPLE_COLOR:Tunica del Beastmaster|r (specializzazione DPS a distanza)" },

    [227390] = { enName = "Merciful Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Crown|r and |cnEPIC_PURPLE_COLOR:Soulforge Embrace|r (Holy Specialization)", description = "|cnEPIC_PURPLE_COLOR:Corona Soulforge|r e |cnEPIC_PURPLE_COLOR:Veste Soulforge|r (specializzazione Sacro)" },

    [227391] = { enName = "Radiant Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Greathelm|r and |cnEPIC_PURPLE_COLOR:Soulforge Breastplate|r (Retribution Specialization)", description = "|cnEPIC_PURPLE_COLOR:Elmo possente Soulforge|r e |cnEPIC_PURPLE_COLOR:Corazza Soulforge|r (specializzazione Castigo)" },

    [227392] = { enName = "Divine Will Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Soulforge Faceguard|r and |cnEPIC_PURPLE_COLOR:Soulforge Chestguards|r (Protection Specialization)", description = "|cnEPIC_PURPLE_COLOR:Maschera protettiva Soulforge|r e |cnEPIC_PURPLE_COLOR:Corazza Soulforge|r (specializzazione Protezione)" },

    [227393] = { enName = "Dawn Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Crown|r and |cnEPIC_PURPLE_COLOR:Virtuous Robe|r (Healer Specialization)", description = "|cnEPIC_PURPLE_COLOR:Corona Virtuous|r e |cnEPIC_PURPLE_COLOR:Veste Virtuous|r (specializzazione curativa)" },

    [227394] = { enName = "Twilight Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Virtuous Cowl|r and |cnEPIC_PURPLE_COLOR:Virtuous Gown|r (Shadow Specialization)", description = "|cnEPIC_PURPLE_COLOR:Cappuccio Virtuous|r e |cnEPIC_PURPLE_COLOR:Abito Virtuous|r (specializzazione Ombra)" },

    [227395] = { enName = "Thrill's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Darkmantle Capl|r and |cnEPIC_PURPLE_COLOR:Darkmantle Tunic|r (Melee DPS Specialization)", description = "|cnEPIC_PURPLE_COLOR:Elmo Darkmantle|r e |cnEPIC_PURPLE_COLOR:Tunica Darkmantle|r (specializzazione DPS da mischia)" },

    [227397] = { enName = "Relief's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Crown of the Five Thunders|r and |cnEPIC_PURPLE_COLOR:Tunic of the Five Thunders|r (Restoration Specialization)", description = "|cnEPIC_PURPLE_COLOR:Corona dei Cinque Tuoni|r e |cnEPIC_PURPLE_COLOR:Tunica dei Cinque Tuoni|r (specializzazione Rigenerazione)" },

    [227398] = { enName = "Eruption's Helm and Chestpiece Set", itName = "Incarico in Combattimento", enDescription = "|cnEPIC_PURPLE_COLOR:Coif of the Five Thunders|r and |cnEPIC_PURPLE_COLOR:Vest of the Five Thunders|r (Elemental Specialization)", description = "|cnEPIC_PURPLE_COLOR:Cappuccio dei Cinque Tuoni|r e |cnEPIC_PURPLE_COLOR:Corazza dei Cinque Tuoni|r (specializzazione Elementale)" },

}

for itemID, entry in pairs(frequentItemDescriptions) do

    if ns.data.itemDescriptionOverrides[itemID] == nil then

        ns.data.itemDescriptionOverrides[itemID] = entry

    end

end
