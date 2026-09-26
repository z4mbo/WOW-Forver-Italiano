local addonName, ns = ...

-- The module only changes visible FontString text in ordinary character UI
-- panels. All scans are deferred and skipped during combat; hooks are
-- post-hooks, so the client remains responsible for frame behavior.
local panels = {
    "CharacterFrame", "PaperDollFrame", "CharacterStatsPane",
    "ReputationFrame", "ReputationFrame.ScrollBox",
    "SkillFrame", "TradeSkillFrame", "CurrencyFrame",
    "TokenFrame", "InspectFrame", "InspectPaperDollFrame",
    "InspectPVPFrame", "InspectPVPFrameConquestBar",
}

local translations = {}
local busy, scheduled = false, false
local hooks = {}

local function addTranslations(source)
    if type(source) ~= "table" then return end
    for english, italian in pairs(source) do
        if ns.safeText(english) and ns.safeText(italian) then
            translations[english] = italian
        end
    end
end

local function translateText(text)
    text = ns.safeText(text)
    if not text then return nil end
    local plain = text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if translations[plain] then return translations[plain] end
    local standing, value, limit = plain:match("^([%a]+)%s*%((%d+)%s*/%s*(%d+)%)$")
    if standing and translations[standing] then
        return translations[standing] .. " (" .. value .. "/" .. limit .. ")"
    end
    local level, race, class = plain:match("^Level%s+(%d+)%s+([%a]+)%s+([%a]+)$")
    if level then
        race = (ns.data.races and ns.data.races[race]) or race
        class = (ns.data.classes and ns.data.classes[class:upper()]) or class
        return "Livello " .. level .. " " .. race .. " " .. class
    end
    for _, rule in ipairs(ns.data.characterPanelPatterns or {}) do
        if type(rule) == "table" and plain:match(rule.pattern) then
            return (plain:gsub(rule.pattern, rule.replacement))
        end
    end
    -- Levels and counters are generated from live values. Translate the
    -- stable words while retaining all client-provided digits and separators.
    local n = plain:match("^Level%s+(%d+)$")
    if n then return "Livello " .. n end
    local amount, maximum = plain:match("^(%d+)%s*/%s*(%d+)$")
    if amount and maximum then return amount .. "/" .. maximum end
end

local function visit(frame, budget)
    if not frame or budget <= 0 then return budget end
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do
            local region = regions[i]
            if region and type(region.GetObjectType) == "function" and
               region:GetObjectType() == "FontString" and type(region.GetText) == "function" then
                local translated = translateText(region:GetText())
                if translated then ns.translateFontString(region, translated) end
            end
        end
    end
    if type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = visit(children[i], budget)
            if budget <= 0 then break end
        end
    end
    return budget
end

local function refresh()
    scheduled = false
    if busy or not ns.enabled() or (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    busy = true
    for i = 1, #panels do
        local panel = _G[panels[i]]
        if panel then visit(panel, 2200) end
    end
    busy = false
end

local function schedule()
    if scheduled then return end
    scheduled = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, refresh)
        C_Timer.After(0.5, refresh)
    else
        refresh()
    end
end

local function installHooks()
    if type(hooksecurefunc) ~= "function" then return end
    for _, name in ipairs({
        "CharacterFrame_ShowSubFrame", "CharacterFrame_Update",
        "PaperDollFrame_UpdateStats", "ReputationFrame_Update",
        "ReputationFrame_UpdateFactions", "SkillFrame_Update",
        "TokenFrame_Update", "CurrencyFrame_Update",
        "ToggleCharacter", "InspectFrame_UnitChanged",
    }) do
        if type(_G[name]) == "function" and not hooks[name] then
            local ok = pcall(hooksecurefunc, name, schedule)
            if ok then hooks[name] = true end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
    "UNIT_STATS", "UNIT_DAMAGE", "UNIT_ATTACK_SPEED", "UNIT_RANGEDDAMAGE",
    "UNIT_RESISTANCES", "PLAYER_LEVEL_UP", "PLAYER_XP_UPDATE",
    "UPDATE_FACTION", "SKILL_LINES_CHANGED", "CURRENCY_DISPLAY_UPDATE",
}) do events:RegisterEvent(event) end

events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then
        addTranslations(ns.data.characterPanels)
        addTranslations(ns.data.ui)
    end
    installHooks()
    schedule()
end)

addTranslations(ns.data.characterPanels)
addTranslations(ns.data.ui)
installHooks()
