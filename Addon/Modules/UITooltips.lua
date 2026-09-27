local addonName, ns = ...

-- Translate only known, exact labels on Blizzard's shared GameTooltip when its
-- owner belongs to a known stock UI panel or micro-menu button. This avoids
-- treating item, spell, unit, or third-party tooltip text as UI labels.
local stockRoots = {
    "CharacterFrame", "PaperDollFrame", "CharacterStatsPane",
    "ReputationFrame", "SkillFrame", "TradeSkillFrame", "CurrencyFrame",
    "TokenFrame", "InspectFrame", "InspectPaperDollFrame",
    "SettingsPanel", "GameMenuFrame", "QuestFrame", "QuestMapFrame",
    "ObjectiveTrackerFrame", "GossipFrame", "MerchantFrame", "FriendsFrame",
    "WorldMapFrame", "CollectionsJournal", "PVEFrame", "MailFrame",
    "BankFrame", "AuctionHouseFrame", "ProfessionsFrame", "AchievementFrame",
    "SpellBookFrame", "PlayerSpellsFrame", "PlayerTalentFrame", "LFGParentFrame",
    "MinimapCluster", "MicroMenuContainer",
}

-- These Blizzard micro-menu controls commonly own tooltips without living
-- below their panel's frame tree.
local stockOwners = {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton",
    "AchievementMicroButton", "QuestLogMicroButton", "GuildMicroButton",
    "LFDMicroButton", "CollectionsMicroButton", "EJMicroButton",
    "MainMenuMicroButton", "HelpMicroButton", "StoreMicroButton",
}

local translationSources = {
    "ui", "characterPanels", "settings", "guildCollections",
}
local translations = {}
local hooked = false
local pending = false
local hookedTooltipTypes = {}
local hookedFooterLines = setmetatable({}, { __mode = "k" })
local footerElapsed = 0

-- Forever beta's Issue Reporter appends these exact footer lines to spell and
-- creature tooltips, including tooltips whose owner is outside a stock panel.
-- Keep this allowlist separate from the general UI labels below.
local issueReporterFooters = {
    ["Press F6 to submit an issue for this Spell"] = true,
    ["Press F6 to submit an issue for this Creature"] = true,
}

local function issueReporterSource(value)
    local source = ns.safeText(value)
    if not source then return nil end
    -- The live beta footer has a WoW |cAARRGGBB prefix in GetText even though
    -- the visible words exactly match the keys above. Keep matching exact
    -- after removing only outer color markup, then reuse it for the Italian.
    local prefix = source:match("^(|c%x%x%x%x%x%x%x%x)") or ""
    local suffix = source:match("(|r)$") or ""
    source = source:sub(#prefix + 1, #source - #suffix)
    if issueReporterFooters[source] then return source, prefix, suffix end
    return nil
end

local function translateIssueReporterFooters()
    if not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    local data = ns.data and ns.data.ui
    if type(data) ~= "table" then return end
    local tooltip = _G.GameTooltip
    if not tooltip then return end
    local count = type(tooltip.NumLines) == "function" and tooltip:NumLines() or 30
    if type(count) ~= "number" then return end
    for i = 1, count do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and type(line.GetText) == "function" then
            local source, prefix, suffix = issueReporterSource(line:GetText())
            if source then
                local translated = ns.safeText(data[source])
                if translated then ns.translateFontString(line, prefix .. translated .. suffix) end
            end
        end
    end
end

-- The reporter can rewrite an already-created line after the Unit post-call
-- and after OnShow. Watch only GameTooltip's own left lines and exact sources.
local function hookIssueReporterLines()
    local tooltip = _G.GameTooltip
    if not tooltip or type(hooksecurefunc) ~= "function" then return end
    local count = type(tooltip.NumLines) == "function" and tooltip:NumLines() or 30
    if type(count) ~= "number" then return end
    for i = 1, count do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and not hookedFooterLines[line] and type(line.SetText) == "function" then
            local ok = pcall(hooksecurefunc, line, "SetText", function(_, value)
                local source, prefix, suffix = issueReporterSource(value)
                if source and
                   ns.enabled() and
                   (type(InCombatLockdown) ~= "function" or not InCombatLockdown()) then
                    local translated = ns.data.ui and ns.safeText(ns.data.ui[source])
                    if translated then ns.translateFontString(line, prefix .. translated .. suffix) end
                end
            end)
            if ok then hookedFooterLines[line] = true end
        end
    end
end

local function retryVisibleFooter(_, elapsed)
    -- The beta reporter can fill its line after both the Unit/Spell post-call
    -- and OnShow, without going through GameTooltip:AddLine. Retry only this
    -- two-string allowlist while the shared tooltip is visible.
    footerElapsed = footerElapsed + (type(elapsed) == "number" and elapsed or 0)
    if footerElapsed < 0.1 then return end
    footerElapsed = 0
    local tooltip = _G.GameTooltip
    if not tooltip or (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) then return end
    hookIssueReporterLines()
    translateIssueReporterFooters()
end

local function isStockOwner(owner)
    if not owner then return false end
    local knownOwners = {}
    for i = 1, #stockOwners do knownOwners[stockOwners[i]] = true end
    for i = 1, #stockRoots do knownOwners[stockRoots[i]] = true end

    local frame = owner
    for _ = 1, 10 do
        if not frame then break end
        local name = type(frame.GetName) == "function" and frame:GetName() or nil
        if type(name) == "string" and knownOwners[name] and _G[name] == frame then
            return true
        end
        if type(frame.GetParent) ~= "function" then break end
        frame = frame:GetParent()
    end
    return false
end

local function indexTranslations()
    translations = {}
    for i = 1, #translationSources do
        local source = ns.data[translationSources[i]]
        if type(source) == "table" then
            for english, italian in pairs(source) do
                if ns.safeText(english) and ns.safeText(italian) then
                    translations[english] = italian
                end
            end
        end
    end
end

local function translateTooltip()
    pending = false
    hookIssueReporterLines()
    if not ns.enabled() or (type(InCombatLockdown) == "function" and InCombatLockdown()) then
        return
    end
    local tooltip = _G.GameTooltip
    if not tooltip or (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) then
        return
    end
    translateIssueReporterFooters()
    if type(tooltip.GetOwner) ~= "function" or not isStockOwner(tooltip:GetOwner()) then
        return
    end

    for i = 1, 30 do
        for _, side in ipairs({ "Left", "Right" }) do
            local line = _G["GameTooltipText" .. side .. i]
            if line and type(line.GetText) == "function" then
                local text = ns.safeText(line:GetText())
                local translated = text and translations[text]
                if translated then ns.translateFontString(line, translated) end
            end
        end
    end
end

local function schedule()
    if pending then return end
    pending = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, translateTooltip)
    else
        translateTooltip()
    end
end

local function installHooks()
    if TooltipDataProcessor and Enum and Enum.TooltipDataType and
       type(TooltipDataProcessor.AddTooltipPostCall) == "function" then
        for _, kind in ipairs({ "Spell", "SpellBookItem", "Unit" }) do
            local dataType = Enum.TooltipDataType[kind]
            if dataType and not hookedTooltipTypes[kind] then
                local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, dataType,
                    function(tooltip)
                        if tooltip == _G.GameTooltip then schedule() end
                    end)
                if ok then hookedTooltipTypes[kind] = true end
            end
        end
    end
    if hooked then return end
    local tooltip = _G.GameTooltip
    if not tooltip then return end
    hookIssueReporterLines()
    if type(tooltip.HookScript) == "function" then
        pcall(tooltip.HookScript, tooltip, "OnShow", schedule)
    end
    if type(hooksecurefunc) == "function" then
        for _, method in ipairs({ "SetText", "AddLine", "AddDoubleLine" }) do
            if type(tooltip[method]) == "function" then
                pcall(hooksecurefunc, tooltip, method, schedule)
            end
        end
    end
    hooked = true
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
-- Run the late footer check on our own frame so it does not depend on
-- GameTooltip accepting or running an OnUpdate hook.
events:SetScript("OnUpdate", retryVisibleFooter)
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then
        indexTranslations()
    end
    installHooks()
end)

indexTranslations()
installHooks()
