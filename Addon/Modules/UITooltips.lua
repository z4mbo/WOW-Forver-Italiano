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
    if not ns.enabled() or (type(InCombatLockdown) == "function" and InCombatLockdown()) then
        return
    end
    local tooltip = _G.GameTooltip
    if not tooltip or (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) then
        return
    end
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
    if hooked then return end
    local tooltip = _G.GameTooltip
    if not tooltip then return end
    if type(tooltip.HookScript) == "function" then
        local ok = pcall(tooltip.HookScript, tooltip, "OnShow", schedule)
        if not ok then return end
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
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then
        indexTranslations()
    end
    installHooks()
end)

indexTranslations()
installHooks()
