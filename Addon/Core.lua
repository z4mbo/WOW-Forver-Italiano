local addonName, ns = ...

ns.data = ns.data or {}
ns.version = "0.1.0-beta"

local function isSafeString(value)
    if type(issecretvalue) == "function" and issecretvalue(value) then
        return false
    end
    return type(value) == "string"
end

function ns.safeText(value)
    if isSafeString(value) and value ~= "" then
        return value
    end
    return nil
end

function ns.enabled()
    return type(WFI_DB) == "table" and WFI_DB.enabled ~= false
end

local function substitute(value, pattern, replacement)
    if value:match(pattern) then
        if not ns.safeText(replacement) then return nil end
        value = value:gsub(pattern, function() return replacement end)
    end
    return value
end

function ns.renderText(value)
    value = ns.safeText(value)
    if not value then return nil end

    local playerName = type(UnitName) == "function" and ns.safeText(UnitName("player")) or nil
    value = substitute(value, "<[Nn][Aa][Mm][Ee]>", playerName)
    if not value then return nil end
    value = substitute(value, "%$[nN]", playerName)
    if not value then return nil end

    local className, classToken
    if type(UnitClass) == "function" then className, classToken = UnitClass("player") end
    className = (ns.data.classes and ns.data.classes[classToken]) or ns.safeText(className)
    value = substitute(value, "<[Cc][Ll][Aa][Ss][Ss]>", className)
    if not value then return nil end
    value = substitute(value, "%$[cC]", className)
    if not value then return nil end

    local raceName, raceToken
    if type(UnitRace) == "function" then raceName, raceToken = UnitRace("player") end
    raceName = (ns.data.races and ns.data.races[raceToken]) or ns.safeText(raceName)
    value = substitute(value, "<[Rr][Aa][Cc][Ee]>", raceName)
    if not value then return nil end
    return substitute(value, "%$[rR]", raceName)
end

function ns.translateFontString(fontString, translated)
    if not ns.enabled() or not fontString then
        return false
    end
    if type(InCombatLockdown) == "function" and InCombatLockdown() then
        return false
    end
    if type(fontString.SetText) ~= "function" then
        return false
    end
    if type(fontString.IsProtected) == "function" and fontString:IsProtected() then
        return false
    end
    local rendered = ns.renderText(translated)
    if not rendered then return false end
    fontString:SetText(rendered)
    return true
end

local function capture(kind, id, fields)
    if type(WFI_DB) ~= "table" or WFI_DB.capture ~= true then
        return
    end
    if type(id) ~= "number" or id <= 0 or type(fields) ~= "table" then
        return
    end
    if type(WFI_DB.seen) ~= "table" then
        WFI_DB.seen = { quests = {}, items = {}, spells = {} }
    end
    local bucket = WFI_DB.seen[kind]
    if type(bucket) ~= "table" then
        bucket = {}
        WFI_DB.seen[kind] = bucket
    end
    local existing = bucket[id] or {}
    for key, value in pairs(fields) do
        local safe = ns.safeText(value)
        if type(key) == "string" and safe and #safe <= 12000 then
            existing[key] = safe
        end
    end
    bucket[id] = existing
end

function ns.captureQuest(id, fields)
    capture("quests", id, fields)
end

function ns.captureItem(id, fields)
    capture("items", id, fields)
end

function ns.captureSpell(id, fields)
    capture("spells", id, fields)
end

function ns.translateTooltipBody(tooltipName, english, italian)
    if not ns.safeText(tooltipName) or not ns.safeText(english) or
       not ns.safeText(italian) then return end
    for i = 2, 30 do
        local line = _G[tooltipName .. "TextLeft" .. i]
        if line and type(line.GetText) == "function" and line:GetText() == english then
            ns.translateFontString(line, italian)
        end
    end
end

local function count(tableValue)
    local n = 0
    if type(tableValue) == "table" then
        for _ in pairs(tableValue) do n = n + 1 end
    end
    return n
end

local function say(message)
    local chat = DEFAULT_CHAT_FRAME
    if chat and type(chat.AddMessage) == "function" then
        chat:AddMessage("|cff45c59aWFI|r " .. message)
    end
end

local function slash(input)
    local command = type(input) == "string" and input:lower():match("^%s*(%S+)") or nil
    if command == "on" then
        WFI_DB.enabled = true
        say("Traduzione attivata. Riapri la finestra o usa /reload per aggiornare il testo già visibile.")
    elseif command == "off" then
        WFI_DB.enabled = false
        say("Traduzione disattivata. Usa /reload per ripristinare il testo già visibile.")
    elseif command == "capture" then
        local value = input:lower():match("^%s*capture%s+(%S+)")
        if value == "on" then
            WFI_DB.capture = true
            say("Raccolta testi attivata. I testi incontrati sono salvati localmente in WFI_DB.")
        elseif value == "off" then
            WFI_DB.capture = false
            say("Raccolta testi disattivata.")
        else
            say("Uso: /wfi capture on oppure /wfi capture off")
        end
    elseif command == "status" then
        say(string.format("v%s • %d etichette UI • %d oggetti • %d missioni • %d incantesimi • raccolta %s",
            ns.version, count(ns.data.ui), count(ns.data.items), count(ns.data.quests),
            count(ns.data.spells),
            WFI_DB.capture and "attiva" or "disattiva"))
    else
        say("Comandi: /wfi on, /wfi off, /wfi status, /wfi capture on|off")
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(_, _, loadedName)
    if loadedName ~= addonName then return end
    if type(WFI_DB) ~= "table" then WFI_DB = {} end
    SLASH_WFI1 = "/wfi"
    SLASH_WFI2 = "/italiano"
    SlashCmdList.WFI = slash
end)
