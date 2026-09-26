local _, ns = ...

-- Translate only the complete-state quest objective form observed in the
-- Forever beta. The objective wording must already exist in the verified
-- objective dictionary; its live numeric progress is copied unchanged.
local hooked = {}
local pending = false

local function canTranslate()
    return (not ns.enabled or ns.enabled()) and
        (type(InCombatLockdown) ~= "function" or not InCombatLockdown())
end

local function translateObjective(fontString)
    if not canTranslate() or not fontString or type(fontString.GetText) ~= "function" then
        return
    end
    local source = ns.safeText(fontString:GetText())
    if not source then return end

    local prefix, objective = source:match("^(%s*%-?%s*%d+/%d+%s+)(.-)%s+%(%s*Complete%s*%)$")
    local translated = objective and ns.data.objectives and ns.data.objectives[objective]
    if translated then
        ns.translateFontString(fontString, prefix .. translated .. " (Completato)")
    end
end

local function scan(frame, budget)
    if not frame or budget <= 0 then return budget end
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1

    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do
            local region = regions[i]
            if region and type(region.GetObjectType) == "function" and
               region:GetObjectType() == "FontString" then
                translateObjective(region)
            end
        end
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
    if not canTranslate() then return end
    for _, name in ipairs({ "QuestFrame", "QuestMapFrame", "ObjectiveTrackerFrame" }) do
        local frame = _G[name]
        if frame then scan(frame, 1800) end
    end
end

local function schedule()
    if pending then return end
    pending = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, refresh)
    else
        refresh()
    end
end

local function installHooks()
    if type(hooksecurefunc) ~= "function" then return end
    for _, name in ipairs({ "QuestLogQuests_Update", "QuestMapFrame_UpdateAll", "QuestMapFrame_ShowQuestDetails" }) do
        if not hooked[name] and type(_G[name]) == "function" then
            local ok = pcall(hooksecurefunc, name, schedule)
            if ok then hooked[name] = true end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "ADDON_LOADED", "QUEST_LOG_UPDATE", "QUEST_WATCH_UPDATE", "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE", "PLAYER_REGEN_ENABLED" }) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName ~= "WOWForverItaliano" then return end
    installHooks()
    schedule()
end)

installHooks()
schedule()
