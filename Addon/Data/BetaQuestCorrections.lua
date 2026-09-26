local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = ns.data.quests or {}

-- Source audit: installed Forever beta enUS questcache.wdb, client build 1.60.1.70009.
-- Records were read-only parsed as repeated <quest ID, data size, data block> entries;
-- the quest ID in the entry header was checked against the ID inside each data block.
-- All 10 IDs shared with the addon's quest tables have matching English titles.
-- These translations use cached beta text, not the similarly named Classic variants.

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

addBetaText(747, "The Hunt Begins",
    "Grull Hawkwind al Campo Narache vuole che tu gli porti 7 piume di corridore delle pianure e 7 porzioni di carne di corridore delle pianure.",
    "Hai l'aria di chi promette bene e saprai dimostrare il tuo valore alla tribù. Forse presto sarai accolto nella grande città di Picco del Tuono. Ma prima dovrai dimostrare a mio padre, il Capo Hawkwind, di esserne degno.$b$bQui sull'Altopiano della Nuvola Rossa siamo orgogliosi delle nostre abilità di caccia. I tauren cacciano per necessità e per sport. Le nostre scorte di carne sono quasi esaurite e ci servono piume per confezionare gli abiti. Dai la caccia ai corridori delle pianure nei dintorni e dimostra il tuo valore facendo rifornimento al villaggio.")

addBetaText(753, "A Humble Task",
    "Prendi una brocca d'acqua dal pozzo.$b$bRiporta la brocca al Capo Hawkwind a Campo Narache, a nord-ovest del pozzo.",
    "Ho percorso molti sentieri nella mia vita e queste vecchie gambe non hanno più il vigore di un tempo. Posso ancora svolgere i miei doveri verso la tribù. A volte, però, ci metto un po' più di tempo.$b$bMa tu sembri un $c impaziente. Mettiamo alla prova tutta questa energia giovanile. Prendi una brocca d'acqua dal pozzo e portala a mio figlio, il Capo, a Campo Narache.$b$bRicorda: anche un compito umile può attirare l'attenzione degli anziani.")

addBetaText(750, "The Hunt Continues",
    "Grull Hawkwind al Campo Narache vuole che tu gli porti 10 pelli di puma di montagna.",
    "Un tauren esperto nella caccia sa che la preda non serve solo come trofeo. Gli animali delle pianure ci permettono di sopravvivere. Farai una buona impressione sugli anziani se riporterai alcune preziose pelli di puma di montagna. Puoi trovare questi animali sulle colline a sud.$b$bAi nostri figli servono vestiti e le tende hanno bisogno di essere riparate.")
