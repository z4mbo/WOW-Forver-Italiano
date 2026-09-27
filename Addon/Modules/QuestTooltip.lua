local addonName, ns = ...

-- The Forever beta can show quest 364's second objective as a literal
-- "8/8 (null)" on a Wretched Zombie's GameTooltip. Match the displayed
-- creature and live quest objective before changing the shared tooltip.
local hooked = false
local elapsed = 0

local function creatureID(guid)
    if type(issecretvalue) == "function" and issecretvalue(guid) then return nil end
    if type(guid) ~= "string" then return nil end
    local id = guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
    return id and tonumber(id) or nil
end

local function displayedCreature(tooltip)
    if type(tooltip.GetUnit) ~= "function" or type(UnitGUID) ~= "function" then return nil end
    local ok, _, unit = pcall(tooltip.GetUnit, tooltip)
    if not ok or type(unit) ~= "string" or
       (type(issecretvalue) == "function" and issecretvalue(unit)) then return nil end
    local guidOK, guid = pcall(UnitGUID, unit)
    return guidOK and creatureID(guid) or nil
end

local function validSecondObjective()
    if type(C_QuestLog) ~= "table" or
       type(C_QuestLog.GetQuestObjectives) ~= "function" then return false end
    local ok, objectives = pcall(C_QuestLog.GetQuestObjectives, 364)
    local objective = ok and type(objectives) == "table" and objectives[2]
    return type(objective) == "table" and objective.finished == true and
        objective.numFulfilled == 8 and objective.numRequired == 8 and
        ns.safeText(objective.text) == "8/8 (null)"
end

local function refresh(tooltip, data)
    if tooltip ~= _G.GameTooltip or not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) or
       (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) then return end
    local id = displayedCreature(tooltip)
    if id ~= 1501 and id ~= 1502 then return end
    if type(data) == "table" then
        if type(issecretvalue) == "function" and issecretvalue(data.id) then return end
        if type(data.id) == "number" and data.id ~= id then return end
    end

    local entry = ns.data.quests and ns.data.quests[364]
    if type(entry) ~= "table" or entry.enTitle ~= "The Mindless Ones" or
       not ns.safeText(entry.title) then return end
    local count = type(tooltip.NumLines) == "function" and tooltip:NumLines() or 0
    if type(count) ~= "number" then return end
    count = math.min(count, 30)
    local title, titleIndex
    for i = 2, count do
        local line = _G["GameTooltipTextLeft" .. i]
        local shown = line and type(line.GetText) == "function" and ns.safeText(line:GetText())
        if shown == entry.enTitle or shown == entry.title then
            title, titleIndex = line, i
        end
    end
    if not title then return end
    if ns.safeText(title:GetText()) == entry.enTitle then
        ns.translateFontString(title, entry.title)
    end
    if id ~= 1502 then return end
    -- In this client a quest's objective follows its title, possibly after
    -- the player-name line. Do not borrow a null line from another quest.
    local objective
    for i = titleIndex + 1, math.min(titleIndex + 2, count) do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and type(line.GetText) == "function" and
           ns.safeText(line:GetText()) == "8/8 (null)" then
            objective = line
            break
        end
    end
    if not objective then return end
    if not validSecondObjective() then return end
    local translated = ns.data.objectives and ns.data.objectives["Wretched Zombie slain"]
    if ns.safeText(translated) then
        ns.translateFontString(objective, "8/8 " .. translated)
    end
end

local function install()
    if hooked then return end
    local tooltip = _G.GameTooltip
    if not tooltip or type(tooltip.HookScript) ~= "function" or
       not TooltipDataProcessor or not Enum or not Enum.TooltipDataType or
       not Enum.TooltipDataType.Unit or
       type(TooltipDataProcessor.AddTooltipPostCall) ~= "function" then return end
    local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, Enum.TooltipDataType.Unit,
        function(current, data) refresh(current, data) end)
    if not ok then return end
    tooltip:HookScript("OnShow", function(self) refresh(self) end)
    -- Quest association lines may be filled after the Unit post-call/OnShow.
    tooltip:HookScript("OnUpdate", function(self, seconds)
        elapsed = elapsed + (type(seconds) == "number" and seconds or 0)
        if elapsed < 0.1 then return end
        elapsed = 0
        refresh(self)
    end)
    hooked = true
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name ~= addonName then return end
    install()
end)
install()
