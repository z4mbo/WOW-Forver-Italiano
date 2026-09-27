-- Exact beta GlobalStrings ID, tag and known wrong itIT value corrections.
local _, ns = ...
if not ns then return end
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
ns.data.globalStrings = ns.data.globalStrings or {}
ns.data.globalStringCorrections = ns.data.globalStringCorrections or {}
local records = {
    [17997] = { tag = "ACTION_SPELL_MISSED_IMMUNE", flags = 1, en = "Immune", badIt = "fallisce", it = "Immune" },
    [22446] = { tag = "LEAVE_SUMMARIES", flags = 1, en = "Leave Summaries", badIt = "Abilità", it = "Abbandona riepiloghi" },
    [25827] = { tag = "GARRISON_SHIPYARD_FOLLOWER_TYPE", flags = 1, en = "Type", badIt = "Abilità", it = "Tipo" },
    [25909] = { tag = "GARRISON_BONUS_EFFECT_TIME_ACTIVE", flags = 1, en = "|cffffd200Time Active:|r |cffffffff%s|r", badIt = "|cffffd200Tempo restante:|r |cffffffff%s|r", it = "|cffffd200Tempo attivo:|r |cffffffff%s|r" },
    [32050] = { tag = "ARTIFACTS_PERK_TAB", flags = 1, en = "Traits", badIt = "Abilità", it = "Tratti" },
    [33988] = { tag = "CHAR_CREATE_SERVER_LIMIT", flags = 2, en = "You already have the maximum number of characters allowed on this realm.", badIt = "Hai già il numero massimo di personaggi consentiti su questo account.", it = "Hai già raggiunto il numero massimo di personaggi consentito su questo reame." },
    [43934] = { tag = "EVENT_TOAST_EXPANDED_DESCRIPTION", flags = 1, en = "Left click to hide details", badIt = "Clicca col pulsante sinistro per vedere i dettagli", it = "Clic sinistro per nascondere i dettagli" },
    [49997] = { tag = "PROFESSIONS_REQUIREMENT_TABLE", flags = 1, en = "This recipe requires you to be near a special crafting station. These can often be found in dungeons or in the open world.", badIt = "È necessario specificare il destinatario per pubblicare un ordine personale.", it = "Questa ricetta richiede che tu sia vicino a una stazione di creazione speciale. Spesso si trovano nei dungeon o nel mondo aperto." },
    [49998] = { tag = "PROFESSIONS_REQUIREMENT_TOOL", flags = 1, en = "This recipe requires you to have a special tool in your inventory. Higher tier tools typically satisfy lower tier requirements.", badIt = "È necessario specificare il destinatario per pubblicare un ordine personale.", it = "Questa ricetta richiede che tu abbia uno strumento speciale nell'inventario. Gli strumenti di livello superiore soddisfano in genere i requisiti di livello inferiore." },
    [53972] = { tag = "PREMADE_GROUP_DISCORD_TEXT_INVITE", flags = 1, en = "This group has a Discord invite code.  Would you like to use it to join their ?", badIt = "Hai già un gruppo elencato nei gruppi organizzati. Vuoi rimuoverlo per avviare questa ricerca?", it = "Questo gruppo ha un codice d'invito Discord. Vuoi usarlo per unirti al loro ?" },
    [54124] = { tag = "PREMADE_GROUP_DISCORD_TEXT_LOBBY", flags = 1, en = "This group is using a Discord lobby.  Would you like to join?", badIt = "Hai già un gruppo elencato nei gruppi organizzati. Vuoi rimuoverlo per avviare questa ricerca?", it = "Questo gruppo sta usando una lobby Discord. Vuoi unirti?" },
    [54137] = { tag = "PREMADE_GROUP_DISCORD_TEXT_JOIN_VOICE_CHAT", flags = 1, en = "This group is using in-game Discord voice chat.  Would you like to join?", badIt = "Hai già un gruppo elencato nei gruppi organizzati. Vuoi rimuoverlo per avviare questa ricerca?", it = "Questo gruppo sta usando la chat vocale Discord di gioco. Vuoi unirti?" },
    [54755] = { tag = "SPELL_FAILED_CUSTOM_ERROR_1107", flags = 1, en = "You have no Stormarion Cores.", badIt = "In questo punto è già stata piazzata una trappola.", it = "Non hai nuclei Stormarion." },
    [55414] = { tag = "TRANSMOG_OUTFIT_NAME_DEFAULT", flags = 3, en = "Outfit", badIt = "Completo", it = "Completo" },
    [56609] = { tag = "SPELL_FAILED_HORSE_RIDING_REQUIREMENT", flags = 1, en = "Requires Horse Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Equitazione (cavallo)" },
    [56610] = { tag = "SPELL_FAILED_WOLF_RIDING_REQUIREMENT", flags = 1, en = "Requires Wolf Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Cavalcata del lupo" },
    [56611] = { tag = "SPELL_FAILED_RAM_RIDING_REQUIREMENT", flags = 1, en = "Requires Ram Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Cavalcata dell'ariete" },
    [56612] = { tag = "SPELL_FAILED_TIGER_RIDING_REQUIREMENT", flags = 1, en = "Requires Tiger Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Cavalcata della tigre" },
    [56613] = { tag = "SPELL_FAILED_RAPTOR_RIDING_REQUIREMENT", flags = 1, en = "Requires Raptor Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Cavalcata del raptor" },
    [56614] = { tag = "SPELL_FAILED_UNDEAD_HORSE_RIDING_REQUIREMENT", flags = 1, en = "Requires Undead Horsemanship skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Equitazione dei non morti" },
    [56615] = { tag = "SPELL_FAILED_MECHANOSTRIDER_RIDING_REQUIREMENT", flags = 1, en = "Requires Mechanostrider Piloting skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Pilotaggio del mechanostrider" },
    [56616] = { tag = "SPELL_FAILED_KODO_RIDING_REQUIREMENT", flags = 1, en = "Requires Kodo Riding skill", badIt = "Richiede Volo in Ambienti Gelidi.", it = "Richiede l'abilità Cavalcata del kodo" },
    [56908] = { tag = "12_0_Z4_FEED_THE_VOID_GAME_OVER", flags = 1, en = "Game Over", badIt = "Fine", it = "Partita terminata" },
}
for id, record in pairs(records) do
    if ns.data.globalStringCorrections[id] == nil then
        ns.data.globalStringCorrections[id] = record
    end
    if ns.data.ui[record.en] == nil then
        ns.data.ui[record.en] = record.it
    end
    if record.flags % 2 == 1 then
        local current = ns.data.globalStrings[record.tag]
        if current == nil then
            ns.data.globalStrings[record.tag] = record
        elseif type(current) == "table" and current.en == record.en and
               current.badIt == nil then
            current.badIt = record.badIt
        end
    end
end
