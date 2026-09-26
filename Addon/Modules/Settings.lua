local addonName, ns = ...

-- Translate visible Blizzard settings text only. This module does not load or
-- inspect third-party add-on panels and never changes widget behavior/text
-- during combat. Post-hooks and HookScript callbacks merely schedule a scan.
local rootNames = {
    "SettingsPanel", "GameMenuFrame",
    "VideoOptionsFrame", "SoundOptionsFrame", "KeyBindingFrame",
    "OptionsFrame", "AccessibilityOptionsFrame",
    "AudioOptionsFrame", "GraphicsOptionsFrame", "InterfaceOptionsControlsPanel",
    "InterfaceOptionsDisplayPanel", "InterfaceOptionsAudioPanel",
    "InterfaceOptionsVideoPanel", "InterfaceOptionsAccessibilityPanel",
}

local translations = {}
local hookedFrames = setmetatable({}, { __mode = "k" })
local hookedFunctions = {}
local busy, scheduled = false, false
local scheduleRefresh

local function indexTranslations()
    for source, translated in pairs(ns.data.settings or {}) do
        if ns.safeText(source) and ns.safeText(translated) then
            translations[source] = translated
        end
    end
    -- The general UI pass currently turns the verified global "AddOns" into
    -- "Add-on" before this settings-panel pass sees it. Normalize that known
    -- intermediate label so the visible game-menu entry receives the fuller
    -- Italian wording too.
    translations["Add-on"] = "Componenti aggiuntivi"
end

local function translateText(source)
    source = ns.safeText(source)
    if not source then return nil end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    if translations[plain] then return translations[plain] end
    for _, rule in ipairs(ns.data.settingsPatterns or {}) do
        if type(rule) == "table" and ns.safeText(rule.pattern) and
           ns.safeText(rule.replacement) and plain:match(rule.pattern) then
            return (plain:gsub(rule.pattern, rule.replacement))
        end
    end
    return nil
end

local function translateRegion(region)
    if not region or type(region.GetObjectType) ~= "function" or
       region:GetObjectType() ~= "FontString" or type(region.GetText) ~= "function" then
        return
    end
    local translated = translateText(region:GetText())
    if translated then ns.translateFontString(region, translated) end
end

local function scan(frame, budget, registerHooks)
    if not frame or budget <= 0 then return budget end
    if registerHooks and not hookedFrames[frame] and type(frame.HookScript) == "function" then
        -- Settings pages can change without hiding the SettingsPanel root.
        -- Observe visibility, clicks, input changes, and scrolling so virtual
        -- settings rows get another pass when a category or control changes.
        local didHook = false
        for _, scriptName in ipairs({
            "OnShow", "OnClick", "OnValueChanged", "OnTextChanged",
            "OnMouseWheel", "OnVerticalScroll", "OnSizeChanged",
        }) do
            local ok = pcall(frame.HookScript, frame, scriptName, function() scheduleRefresh() end)
            didHook = didHook or ok
        end
        if didHook then hookedFrames[frame] = true end
    end
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do translateRegion(regions[i]) end
    end
    if type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = scan(children[i], budget, registerHooks)
            if budget <= 0 then break end
        end
    end
    return budget
end

local function refresh()
    scheduled = false
    if busy or not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    busy = true
    for i = 1, #rootNames do
        local frame = _G[rootNames[i]]
        if frame then scan(frame, 5000, true) end
    end
    busy = false
end

scheduleRefresh = function()
    if scheduled then return end
    scheduled = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, refresh)
        -- Some options categories populate controls after the frame opens.
        C_Timer.After(0.4, refresh)
    else
        refresh()
    end
end

local function installFunctionHooks()
    if type(hooksecurefunc) ~= "function" then return end
    for _, name in ipairs({
        "SettingsPanel_Open", "SettingsPanel_SelectCategory",
        "InterfaceOptionsFrame_OpenToCategory", "OptionsFrame_OpenToCategory",
        "VideoOptionsFrame_OnShow", "SoundOptionsFrame_OnShow",
        "KeyBindingFrame_OnShow", "InterfaceOptionsFrame_OnShow",
    }) do
        if type(_G[name]) == "function" and not hookedFunctions[name] then
            local ok = pcall(hooksecurefunc, name, scheduleRefresh)
            if ok then hookedFunctions[name] = true end
        end
    end
    if Settings and type(Settings.OpenToCategory) == "function" and not hookedFunctions.SettingsOpenToCategory then
        local ok = pcall(hooksecurefunc, Settings, "OpenToCategory", scheduleRefresh)
        if ok then hookedFunctions.SettingsOpenToCategory = true end
    end
end

local function registerSettingsEvents()
    if not EventRegistry or type(EventRegistry.RegisterCallback) ~= "function" then return end
    for _, event in ipairs({ "SettingsPanel.CategoryChanged", "SettingsPanel.Open" }) do
        local key = "EventRegistry." .. event
        if not hookedFunctions[key] then
            local ok = pcall(EventRegistry.RegisterCallback, EventRegistry, event, scheduleRefresh)
            if ok then hookedFunctions[key] = true end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED" }) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then indexTranslations() end
    installFunctionHooks()
    registerSettingsEvents()
    scheduleRefresh()
end)

indexTranslations()
installFunctionHooks()
registerSettingsEvents()
scheduleRefresh()
