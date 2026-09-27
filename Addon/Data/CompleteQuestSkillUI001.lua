-- Exact English strings from local Forever beta GlobalStrings.db2; translated with GPT Luna low.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
ns.data.globalStrings = ns.data.globalStrings or {}
local records = {
    ["Feral Combat"] = "Combattimento ferino",
    ["Higher skill allows you to learn higher level recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] = "Una competenza più alta ti permette di apprendere ricette di livello superiore. Le ricette si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e come bottino dai mostri.",
    ["Poisons"] = "Veleni",
    ["Test Profession [DNT]"] = "Professione di prova [DNT]",
    ["Astral Perfect Victory"] = "Vittoria perfetta astrale",
    ["Beast Training"] = "Addestramento delle bestie",
    ["Companions"] = "Compagni",
    ["Comprehension"] = "Comprensione",
    ["Elite"] = "Elite",
    ["Engraving"] = "Incisione",
    ["Explorer Imp"] = "Imp esploratore",
    ["GENERIC (DND)"] = "GENERICO (Non disturbare)",
    ["Galestrider Riding"] = "Equitazione Galestrider",
    ["Higher alchemy skill allows you to learn higher level alchemy recipes.  Alchemy recipes can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di alchimia più alta ti permette di apprendere ricette di alchimia di livello superiore. Le ricette di alchimia si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Higher cooking skill allows you to learn higher level cooking recipes.  Recipes can be found on trainers around the world as well as from quests and as drops from monsters."] = "Una competenza di cucina più alta ti permette di apprendere ricette di cucina di livello superiore. Le ricette si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e come bottino dai mostri.",
    ["Higher defense makes you harder to hit and makes monsters less likely to land a crushing blow."] = "Una difesa più alta rende più difficile colpirti e riduce la probabilità che i mostri mettano a segno un colpo devastante.",
    ["Higher enchanting skill allows you to learn more powerful formulae.  Formulae can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di incantamento più alta ti permette di apprendere formule più potenti. Le formule si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Higher engineering skill allows you to learn higher level engineering schematics.  Schematics can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di ingegneria più alta ti permette di apprendere progetti di ingegneria di livello superiore. I progetti si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Higher engraving skill allows you to learn higher level runes and apply them to your armor and weapons.  Runes can be found hidden throughout the world."] = "Una competenza di incisione più alta ti permette di apprendere rune di livello superiore e applicarle alla tua armatura e alle tue armi. Le rune si trovano nascoste in tutto il mondo.",
    ["Higher first aid skill allows you to learn higher level first aid abilities.  First aid abilities can be found on trainers around the world as well as from quests and as drops from monsters."] = "Una competenza di pronto soccorso più alta ti permette di apprendere abilità di pronto soccorso di livello superiore. Le abilità si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e come bottino dai mostri.",
    ["Higher fishing skill increases your chance of catching fish in bodies of water around the world.  If you are having trouble catching fish in a given area, move to a lower level area or purchase a fishing lure and try again."] = "Una competenza di pesca più alta aumenta la probabilità di pescare nei corsi d'acqua di tutto il mondo. Se hai difficoltà a pescare in una determinata zona, spostati in un'area di livello inferiore oppure acquista un'esca da pesca e riprova.",
    ["Higher herbalism skill allows you to harvest more difficult herbs around the world.  If you cannot harvest a specific herb, then increase your skill by harvesting easier to gather herbs in lower level areas."] = "Una competenza di erbalismo più alta ti permette di raccogliere erbe più difficili da trovare in tutto il mondo. Se non riesci a raccogliere una determinata erba, aumenta la tua competenza raccogliendo erbe più facili nelle aree di livello inferiore.",
    ["Higher leatherworking skill allows you to learn higher level leatherworking patterns.  Leatherworking patterns can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di lavorazione del cuoio più alta ti permette di apprendere modelli di livello superiore. I modelli di lavorazione del cuoio si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Higher mining skill allows you to harvest more difficult minerals nodes around the world.  If you cannot harvest a specific mineral, then increase your skill by mining easier to mine minerals in lower level areas."] = "Una competenza di estrazione mineraria più alta ti permette di estrarre minerali più difficili da trovare in tutto il mondo. Se non riesci a estrarre un determinato minerale, aumenta la tua competenza estraendo minerali più facili nelle aree di livello inferiore.",
    ["Higher riding skill allows you to ride faster and more exotic beasts."] = "Una competenza di equitazione più alta ti permette di cavalcare bestie più veloci ed esotiche.",
    ["Higher skinning skill allows you to skin hides from higher level monsters around the world.    Once your skill is above 100, you can divide your skill by 5 to determine the highest level of monster you can skin."] = "Una competenza di scuoiatura più alta ti permette di scuoiere mostri di livello superiore in tutto il mondo.    Quando la tua competenza supera 100, dividila per 5 per determinare il livello massimo dei mostri che puoi scuoiere.",
    ["Higher smithing skill allows you to learn higher level smithing plans.  Blacksmithing plans can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di forgiatura più alta ti permette di apprendere progetti di forgiatura di livello superiore. I progetti di Forgiatura si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Higher tailoring skill allows you to learn higher level tailoring patterns.  Tailoring patterns can be found on trainers around the world as well as from quests and monsters."] = "Una competenza di sartoria più alta ti permette di apprendere modelli di sartoria di livello superiore. I modelli di sartoria si trovano presso gli addestratori in tutto il mondo, si ottengono dalle missioni e dai mostri.",
    ["Language: Gutterspeak"] = "Lingua: Gergo dei bassifondi",
    ["Lockpicking"] = "Scassinamento",
    ["Meditation"] = "Meditazione",
    ["Misc specialization handling spells go here."] = "Qui vanno gli incantesimi per la gestione delle specializzazioni varie.",
    ["Pet - Bird of Prey"] = "Famiglio - Rapace",
    ["Pet - Crocilisk"] = "Famiglio - Crocilisco",
    ["Pet - Felguard"] = "Famiglio - Vilguardia",
    ["Pet - Fox"] = "Famiglio - Volpe",
    ["Pet - Generic"] = "Famiglio - Generico",
    ["PvP"] = "PvP",
    ["PvP Season Journey"] = "Viaggio della stagione PvP",
    ["Riding"] = "Equitazione",
    ["Runes"] = "Rune",
    ["To Have Loved and Lost"] = "Aver amato e perduto",
    ["Toxic Soil"] = "Terreno tossico",
    ["Your companions."] = "I tuoi compagni.",
    ["Your mounts."] = "Le tue cavalcature.",
}
for source, translated in pairs(records) do
    if ns.data.ui[source] == nil then ns.data.ui[source] = translated end
end
local globalTags = {
}
for tag, record in pairs(globalTags) do
    if ns.data.globalStrings[tag] == nil then ns.data.globalStrings[tag] = record end
end
