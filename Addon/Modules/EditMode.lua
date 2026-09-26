local addonName, ns = ...

-- Edit Mode roots are discovered from Blizzard-style global names at runtime;
-- no retail/beta frame name is assumed to exist in this client build. Only
-- EditMode* and Blizzard_EditMode* globals are considered, never add-on panels.
local translated = {}
local hooked = setmetatable({}, { __mode = "k" })
local scheduled, scanning = false, false
local MAX_NODES = 1400

local function indexTranslations()
    translated = {}
    for source, target in pairs(ns.data.ui or {}) do
        if ns.safeText(source) and ns.safeText(target) then
            translated[source] = target
        end
    end
end

local function editModeGlobal(name)
    return type(name) == "string" and
        (name:match("^EditMode[%w_]*$") or name:match("^Blizzard_EditMode[%w_]*$"))
end

local function frameLike(frame)
    local kind = type(frame)
    return (kind == "table" or kind == "userdata") and
        type(frame.GetObjectType) == "function"
end

local function translateRegion(region)
    if not region or type(region.GetObjectType) ~= "function" or
       region:GetObjectType() ~= "FontString" or type(region.GetText) ~= "function" then
        return
    end
    if type(region.IsShown) == "function" and not region:IsShown() then return end
    local source = ns.safeText(region:GetText())
    if not source then return end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local target = translated[plain]
    -- Group labels are generated from the fixed Edit Mode group number rather
    -- than a localization global. Restrict the match to a numeric label.
    if not target then
        local groupNumber = plain:match("^Group ([1-8])$")
        if groupNumber then target = "Gruppo " .. groupNumber end
    end
    if target then ns.translateFontString(region, target) end
end

-- Edit Mode temporarily replaces quest tracker preview text. Re-apply only
-- translations whose exact English objective is in our objective data, while
-- retaining its live numeric progress prefix.
local function translateObjectiveRegion(region)
    if not region or type(region.GetObjectType) ~= "function" or
       region:GetObjectType() ~= "FontString" or type(region.GetText) ~= "function" then
        return
    end
    local source = ns.safeText(region:GetText())
    if not source then return end
    local objectives = ns.data.objectives or {}
    local target = objectives[source]
    if not target then
        local prefix, objective = source:match("^(%s*%-?%s*%d+/%d+%s+)(.+)$")
        if prefix and objectives[objective] then
            target = prefix .. objectives[objective]
        end
    end
    if target then ns.translateFontString(region, target) end
end

local function visitObjectives(frame, budget, seen)
    if not frame or budget <= 0 or seen[frame] then return budget end
    seen[frame] = true
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do translateObjectiveRegion(regions[i]) end
    end
    if budget > 0 and type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = visitObjectives(children[i], budget, seen)
            if budget <= 0 then break end
        end
    end
    return budget
end

local function visit(frame, budget, seen)
    if not frame or budget <= 0 or seen[frame] then return budget end
    seen[frame] = true
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1

    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do translateRegion(regions[i]) end
    end
    if budget > 0 and type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = visit(children[i], budget, seen)
            if budget <= 0 then break end
        end
    end
    return budget
end

local function collectRoots()
    local roots = {}
    for name, frame in pairs(_G) do
        if editModeGlobal(name) and frameLike(frame) and
           type(frame.GetChildren) == "function" then
            roots[#roots + 1] = frame
        end
    end
    return roots
end

local function refresh()
    scheduled = false
    if scanning or not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    scanning = true
    local budget, seen = MAX_NODES, setmetatable({}, { __mode = "k" })
    local roots = collectRoots()
    for i = 1, #roots do
        if budget <= 0 then break end
        budget = visit(roots[i], budget, seen)
    end
    local objectiveTracker = _G.ObjectiveTrackerFrame
    if objectiveTracker then
        visitObjectives(objectiveTracker, MAX_NODES, setmetatable({}, { __mode = "k" }))
    end
    scanning = false
end

local function schedule()
    if scheduled then return end
    scheduled = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0, refresh)
        C_Timer.After(0.4, refresh)
    else
        refresh()
    end
end

local function installHooks()
    for name, frame in pairs(_G) do
        if editModeGlobal(name) and frameLike(frame) and not hooked[frame] and
           type(frame.HookScript) == "function" then
            local ok = pcall(frame.HookScript, frame, "OnShow", schedule)
            if ok then
                pcall(frame.HookScript, frame, "OnHide", schedule)
                hooked[frame] = true
            end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
}) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName ~= addonName then return end
    installHooks()
    schedule()
end)

indexTranslations()
installHooks()
schedule()
