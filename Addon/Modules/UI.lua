local addonName, ns = ...

-- Only text in these ordinary panels is changed. The action bars, unit frames,
-- nameplates and secure combat UI are intentionally outside this visual pass.
local panelNames = {
    "QuestFrame", "QuestMapFrame", "ObjectiveTrackerFrame",
    "ObjectiveTrackerBlocksFrame", "GossipFrame", "CharacterFrame",
    "MerchantFrame", "GameMenuFrame", "FriendsFrame", "WorldMapFrame",
    "CollectionsJournal", "PVEFrame", "SettingsPanel", "MailFrame",
    "BankFrame", "AuctionHouseFrame", "ProfessionsFrame", "AchievementFrame",
    "SpellBookFrame", "PlayerSpellsFrame", "PlayerTalentFrame", "LFGParentFrame",
    "QuestInfoFrame", "QuestInfoRewardsFrame", "MapQuestInfoRewardsFrame",
    "MinimapCluster", "QuestLogCount",
}

local pending = false
local inPass = false
local translatedText = {}
local panelHooked = {}
local spellbookButtonsHooked = setmetatable({}, { __mode = "k" })
local hookSpellbookTabMethods, hookSpellbookButtons
local hookQuestCounter

local function indexTranslations()
    translatedText = {}
    for source, translated in pairs(ns.data.ui or {}) do
        if ns.safeText(source) and ns.safeText(translated) then
            translatedText[source] = translated
        end
    end
    for _, entry in pairs(ns.data.quests or {}) do
        if type(entry) == "table" and ns.safeText(entry.enTitle) and ns.safeText(entry.title) then
            translatedText[entry.enTitle] = entry.title
        end
    end
    for _, entry in pairs(ns.data.items or {}) do
        if type(entry) == "table" and ns.safeText(entry.en) and ns.safeText(entry.name) then
            translatedText[entry.en] = entry.name
        end
    end
    for _, entry in pairs(ns.data.spells or {}) do
        if type(entry) == "table" and ns.safeText(entry.en) and ns.safeText(entry.name) then
            translatedText[entry.en] = entry.name
            local englishBase = entry.en:match("^(.-)%s*%(Rank %d+%)$")
            local italianBase = entry.name:match("^(.-)%s*%(Grado %d+%)$")
            if englishBase and italianBase then
                translatedText[englishBase] = italianBase
            end
        end
    end
    for source, translated in pairs(ns.data.objectives or {}) do
        if ns.safeText(source) and ns.safeText(translated) then
            translatedText[source] = translated
        end
    end
end

local function translationFor(source)
    local safe = ns.safeText(source)
    if not safe then return nil end
    -- Some beta labels embed WoW color escapes. GetText shows the visible
    -- English words but also returns those hidden formatting bytes.
    local plain = safe:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if translatedText[plain] then return translatedText[plain] end
    for _, rule in ipairs(ns.data.uiPatterns or {}) do
        if type(rule) == "table" and ns.safeText(rule.pattern) and
           ns.safeText(rule.replacement) and plain:match(rule.pattern) then
            return (plain:gsub(rule.pattern, rule.replacement))
        end
    end
    -- Quest list and tracker titles include a level prefix such as "[3] ".
    local prefix, title = safe:match("^(%[%d+%]%s*)(.+)$")
    if prefix and translatedText[title] then
        return prefix .. translatedText[title]
    end
    -- Item objectives are rendered with a live progress counter.
    local progress, itemName = safe:match("^(%s*%-?%s*%d+/%d+%s+)(.+)$")
    if progress and translatedText[itemName] then
        return progress .. translatedText[itemName]
    end
    return nil
end

local function translateRegion(region)
    if not region or type(region.GetObjectType) ~= "function" or region:GetObjectType() ~= "FontString" then
        return
    end
    if type(region.GetText) ~= "function" then return end
    local translated = translationFor(region:GetText())
    if translated then ns.translateFontString(region, translated) end
end

local function scan(frame, budget)
    if not frame or budget <= 0 then return budget end
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do translateRegion(regions[i]) end
    end
    if type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = scan(children[i], budget)
            if budget <= 0 then break end
        end
    end
    return budget
end

local function refresh()
    pending = false
    if inPass or not ns.enabled() then return end
    if type(InCombatLockdown) == "function" and InCombatLockdown() then return end
    if hookSpellbookTabMethods then hookSpellbookTabMethods() end
    if hookSpellbookButtons then hookSpellbookButtons() end
    if hookQuestCounter then hookQuestCounter() end
    inPass = true
    for i = 1, #panelNames do
        local panel = _G[panelNames[i]]
        if panel then scan(panel, 3000) end
    end
    -- Forever's quest counter is a named FontString. Its parent may not expose
    -- it through GetRegions in this beta, so visit the label directly as well.
    translateRegion(_G.QuestLogQuestCount)
    inPass = false
end

hookQuestCounter = function()
    local counter = _G.QuestLogQuestCount
    if not counter or panelHooked.QuestLogQuestCountText or type(hooksecurefunc) ~= "function" then
        return
    end
    -- The beta rewrites this label during its map update, sometimes after our
    -- scheduled pass. Translate each new English value without polling.
    local ok = pcall(hooksecurefunc, counter, "SetText", function(self)
        local translated = translationFor(self:GetText())
        if translated then ns.translateFontString(self, translated) end
    end)
    if ok then panelHooked.QuestLogQuestCountText = true end
end

local function scheduleRefresh()
    if pending then return end
    pending = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0.1, refresh)
        -- Several beta panels populate counters and labels after their initial
        -- show/update callback. Give that later content one bounded second pass.
        C_Timer.After(0.6, refresh)
    else
        refresh()
    end
end

hookSpellbookTabMethods = function()
    if type(hooksecurefunc) ~= "function" then return end
    local methodNames = { "SetTab", "SetCategory", "SelectTab", "SetSpellTab" }
    for _, frameName in ipairs({ "PlayerSpellsFrame", "SpellBookFrame" }) do
        local frame = _G[frameName]
        if frame then
            for _, methodName in ipairs(methodNames) do
                local key = frameName .. "." .. methodName
                if not panelHooked[key] and type(frame[methodName]) == "function" then
                    local ok = pcall(hooksecurefunc, frame, methodName, scheduleRefresh)
                    if ok then panelHooked[key] = true end
                end
            end
            local tabSystem = frame.TabSystem
            if tabSystem then
                for _, methodName in ipairs(methodNames) do
                    local key = frameName .. ".TabSystem." .. methodName
                    if not panelHooked[key] and type(tabSystem[methodName]) == "function" then
                        local ok = pcall(hooksecurefunc, tabSystem, methodName, scheduleRefresh)
                        if ok then panelHooked[key] = true end
                    end
                end
            end
        end
    end
    if not panelHooked.PlayerSpellsTabEvent and EventRegistry and
       type(EventRegistry.RegisterCallback) == "function" then
        local ok = pcall(EventRegistry.RegisterCallback, EventRegistry,
            "PlayerSpellsFrame.TabSet", scheduleRefresh)
        if ok then panelHooked.PlayerSpellsTabEvent = true end
    end
end

hookSpellbookButtons = function()
    if type(InCombatLockdown) == "function" and InCombatLockdown() then return end
    local function visit(frame)
        if not frame then return end
        if type(frame.GetObjectType) == "function" then
            local objectType = frame:GetObjectType()
            if (objectType == "Button" or objectType == "CheckButton") and
               not spellbookButtonsHooked[frame] and type(frame.HookScript) == "function" then
                local ok = pcall(frame.HookScript, frame, "OnClick", scheduleRefresh)
                if ok then spellbookButtonsHooked[frame] = true end
            end
        end
        if type(frame.GetChildren) == "function" then
            local children = { frame:GetChildren() }
            for i = 1, #children do visit(children[i]) end
        end
    end
    visit(_G.PlayerSpellsFrame)
    visit(_G.SpellBookFrame)
end

local function installPanelHooks()
    for i = 1, #panelNames do
        local name = panelNames[i]
        local panel = _G[name]
        if panel and not panelHooked[name] and type(panel.HookScript) == "function" then
            panel:HookScript("OnShow", scheduleRefresh)
            panelHooked[name] = true
        end
    end
end

local function installUpdateHooks()
    if type(hooksecurefunc) ~= "function" then return end
    for _, name in ipairs({
        "QuestLogQuests_Update", "QuestMapFrame_ShowQuestDetails", "QuestInfo_Display",
    }) do
        if type(_G[name]) == "function" and not panelHooked[name] then
            local ok = pcall(hooksecurefunc, name, scheduleRefresh)
            if ok then panelHooked[name] = true end
        end
    end
    -- The extracted professions frame redraws its current page from these
    -- methods after tabs/recipe responses change; refresh the visible labels.
    local professions = _G.ProfessionsFrame
    if professions then
        for _, method in ipairs({ "Refresh", "UpdateTabs", "SetTab" }) do
            local key = "ProfessionsFrame." .. method
            if type(professions[method]) == "function" and not panelHooked[key] then
                local ok = pcall(hooksecurefunc, professions, method, scheduleRefresh)
                if ok then panelHooked[key] = true end
            end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
    "QUEST_DETAIL", "QUEST_GREETING", "QUEST_PROGRESS", "QUEST_COMPLETE",
    "GOSSIP_SHOW", "MERCHANT_SHOW", "BANKFRAME_OPENED",
    "GET_ITEM_INFO_RECEIVED", "QUEST_LOG_UPDATE", "QUEST_WATCH_UPDATE",
    "SPELLS_CHANGED", "TRADE_SKILL_SHOW", "ZONE_CHANGED", "ZONE_CHANGED_NEW_AREA",
    "OPEN_RECIPE_RESPONSE", "TRADE_SKILL_LIST_UPDATE", "TRADE_SKILL_DATA_SOURCE_CHANGED",
}) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then
        indexTranslations()
    end
    installPanelHooks()
    installUpdateHooks()
    scheduleRefresh()
end)

indexTranslations()
installPanelHooks()
installUpdateHooks()
