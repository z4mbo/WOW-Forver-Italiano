local addonName, ns = ...
local events

local unknownTargetName = "Sconosciuto"
local trackedNameplates = setmetatable({}, { __mode = "k" })
local hookedNameplateNames = setmetatable({}, { __mode = "k" })
local expandedNameplateWidths = setmetatable({}, { __mode = "k" })

-- TargetFrame.name is the visible target-name FontString in this client. Only
-- replace its localized UNKNOWNOBJECT placeholder for a verified Forever
-- creature ID; never infer an NPC from the placeholder alone.
local function creatureIdFromGUID(guid)
    if type(issecretvalue) == "function" and issecretvalue(guid) then return nil end
    if type(guid) ~= "string" then return nil end
    local id = guid:match("^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
    return id and tonumber(id) or nil
end

local function targetNameRegion()
    local frame = TargetFrame
    local main = frame and frame.TargetFrameContent and
        frame.TargetFrameContent.TargetFrameContentMain
    local nameRegion = frame and frame.name
    -- The beta exposes this same visible region through both paths. Bail out
    -- if another UI replaces one path with a different/unknown FontString.
    if not nameRegion or not main or main.Name ~= nameRegion then return nil end
    return nameRegion
end

local function refreshUnknownTargetName()
    if not ns.enabled() or type(UnitGUID) ~= "function" or
       type(UnitName) ~= "function" then return end
    local id = creatureIdFromGUID(UnitGUID("target"))
    if not id then return end

    local entry = ns.data.npcs and ns.data.npcs[id]
    if type(entry) ~= "table" or not ns.safeText(entry.en) or
       not ns.safeText(entry.name) then return end
    local sourceName = ns.safeText(UnitName("target"))
    if sourceName ~= unknownTargetName and sourceName ~= entry.en then return end

    local nameRegion = targetNameRegion()
    if not nameRegion or type(nameRegion.GetText) ~= "function" or
       ns.safeText(nameRegion:GetText()) ~= sourceName then return end
    ns.translateFontString(nameRegion, entry.name)
end

-- The installed Forever beta's nameplate has a UnitFrame.name FontString.
-- A plate can be recycled, so resolve its current unit through C_NamePlate
-- every time Blizzard changes the text; the hook never owns the unit token.
local function nameplateNameRegion(unit)
    if not C_NamePlate or type(C_NamePlate.GetNamePlateForUnit) ~= "function" then return end
    local ok, plate = pcall(C_NamePlate.GetNamePlateForUnit, unit)
    if not ok or not plate or
       (type(plate.IsForbidden) == "function" and plate:IsForbidden()) then return end
    local frame = plate.UnitFrame
    if not frame or (type(frame.IsForbidden) == "function" and frame:IsForbidden()) then return end
    local name = frame.name
    if not name or (type(name.IsForbidden) == "function" and name:IsForbidden()) or
       type(name.GetObjectType) ~= "function" or
       name:GetObjectType() ~= "FontString" or
       type(name.GetText) ~= "function" or type(name.SetText) ~= "function" then return end
    return name
end

-- A single centered anchor can grow without moving the bar or its health
-- text. SetWidth(0) does not reliably display the full text on this beta, so
-- size the region from the unbounded text measurement instead. Two-anchor
-- layouts reserve space for other plate elements and remain under their owner.
local function expandNameplateName(name)
    if type(name.GetNumPoints) ~= "function" or
       type(name.GetPoint) ~= "function" or type(name.GetWidth) ~= "function" or
       type(name.SetWidth) ~= "function" or
       type(name.GetUnboundedStringWidth) ~= "function" or
       (type(name.IsProtected) == "function" and name:IsProtected()) or
       name:GetNumPoints() ~= 1 then return end
    local point = name:GetPoint(1)
    if point ~= "BOTTOM" and point ~= "TOP" and point ~= "CENTER" then return end
    local width = name:GetWidth()
    local textWidth = name:GetUnboundedStringWidth()
    if type(issecretvalue) == "function" and
       (issecretvalue(width) or issecretvalue(textWidth)) then return end
    if type(width) ~= "number" or width < 0 or width > 300 or
       type(textWidth) ~= "number" or textWidth <= 0 or
       textWidth > 300 then return end
    local expanded = math.min(300, math.ceil(textWidth + 4))
    local widths = expandedNameplateWidths[name]
    if widths and width ~= widths.expanded then
        -- The layout owner changed the width after our last write.
        expandedNameplateWidths[name] = nil
        widths = nil
    end
    if not widths and width >= expanded then return end
    if width == expanded then return end
    if widths then
        widths.expanded = expanded
    else
        expandedNameplateWidths[name] = {
            original = width, expanded = expanded, point = point,
        }
    end
    name:SetWidth(expanded)
end

local function restoreNameplateWidth(name)
    local widths = expandedNameplateWidths[name]
    if not widths or type(InCombatLockdown) ~= "function" or InCombatLockdown() or
       (type(name.IsProtected) == "function" and name:IsProtected()) then return end
    expandedNameplateWidths[name] = nil
    -- Another nameplate addon may have restyled this region since our write.
    if type(name.GetWidth) == "function" and
       type(name.GetNumPoints) == "function" and name:GetNumPoints() == 1 and
       type(name.GetPoint) == "function" and name:GetPoint(1) == widths.point and
       name:GetWidth() == widths.expanded then
        name:SetWidth(widths.original)
    end
end

local function refreshNameplateName(name)
    local unit = trackedNameplates[name]
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then return end
    if not unit or not ns.enabled() or
       type(UnitGUID) ~= "function" or type(UnitName) ~= "function" then
        restoreNameplateWidth(name)
        return
    end
    -- A recycled name region must still belong to this exact visible unit.
    if nameplateNameRegion(unit) ~= name then
        restoreNameplateWidth(name)
        return
    end
    local id = creatureIdFromGUID(UnitGUID(unit))
    local entry = id and ns.data.npcs and ns.data.npcs[id]
    if type(entry) ~= "table" or not ns.safeText(entry.en) or
       not ns.safeText(entry.name) then
        restoreNameplateWidth(name)
        return
    end
    local source = ns.safeText(UnitName(unit))
    if source ~= unknownTargetName and source ~= entry.en then
        restoreNameplateWidth(name)
        return
    end
    local shown = ns.safeText(name:GetText())
    if shown == entry.name then
        expandNameplateName(name)
        return
    end
    if shown ~= source then
        restoreNameplateWidth(name)
        return
    end
    if ns.translateFontString(name, entry.name) then expandNameplateName(name) end
end

local function trackNameplate(unit)
    if type(unit) ~= "string" or not unit:match("^nameplate%d+$") then return end
    local name = nameplateNameRegion(unit)
    if not name then return end
    trackedNameplates[name] = unit
    if not hookedNameplateNames[name] and type(hooksecurefunc) == "function" then
        local ok = pcall(hooksecurefunc, name, "SetText", function()
            refreshNameplateName(name)
        end)
        if ok then hookedNameplateNames[name] = true end
    end
    refreshNameplateName(name)
end

local function untrackNameplate(unit)
    if type(unit) ~= "string" then return end
    for name, trackedUnit in pairs(trackedNameplates) do
        if trackedUnit == unit then
            trackedNameplates[name] = nil
            restoreNameplateWidth(name)
        end
    end
end

local function initializeTargetName()
    local nameRegion = targetNameRegion()
    if nameRegion and not nameRegion.wfiUnknownTargetHooked and
       type(hooksecurefunc) == "function" then
        local ok = pcall(hooksecurefunc, nameRegion, "SetText", refreshUnknownTargetName)
        if ok then nameRegion.wfiUnknownTargetHooked = true end
    end
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("UNIT_NAME_UPDATE")
    events:RegisterEvent("PLAYER_REGEN_ENABLED")
end

-- Tooltip data.id is not always a creature ID in this beta. Prefer the GUID
-- of the unit actually displayed by the tooltip when one is available.
local function processTooltip(tooltip, data)
    if not ns.enabled() or type(data) ~= "table" or not tooltip or
       type(tooltip.GetName) ~= "function" then return end
    local id = data.id
    if type(issecretvalue) == "function" and issecretvalue(id) then return end
    local unit
    if type(tooltip.GetUnit) == "function" then
        local _, displayedUnit = tooltip:GetUnit()
        if type(issecretvalue) == "function" and issecretvalue(displayedUnit) then return end
        unit = displayedUnit
    end
    local guidId
    if type(unit) == "string" and type(UnitGUID) == "function" then
        guidId = creatureIdFromGUID(UnitGUID(unit))
    end
    if guidId and type(id) == "number" and id ~= guidId then return end
    id = guidId or id
    if type(id) ~= "number" then return end
    local entry = ns.data.npcs and ns.data.npcs[id]
    if type(entry) ~= "table" or not ns.safeText(entry.en) or
       not ns.safeText(entry.name) then return end
    local liveName
    if guidId then
        if type(UnitName) ~= "function" then return end
        liveName = ns.safeText(UnitName(unit))
        if liveName ~= entry.en and liveName ~= unknownTargetName then return end
    end

    local tooltipName = ns.safeText(tooltip:GetName())
    if not tooltipName then return end
    local nameRegion = _G[tooltipName .. "TextLeft1"]
    if not nameRegion or type(nameRegion.GetText) ~= "function" then return end
    local source = ns.safeText(nameRegion:GetText())
    if source ~= entry.en then
        -- UNKNOWNOBJECT is shared by many units. Use it only with the exact
        -- displayed creature GUID and the same live UnitName placeholder.
        if source ~= unknownTargetName or not guidId or
           liveName ~= unknownTargetName then return end
    end

    ns.translateFontString(nameRegion, entry.name)
end

local function initialize()
    initializeTargetName()
    events:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    events:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    if TooltipDataProcessor and Enum and Enum.TooltipDataType and
       Enum.TooltipDataType.Unit and
       type(TooltipDataProcessor.AddTooltipPostCall) == "function" then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, processTooltip)
    end
end

events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, event, firstArg)
    if event == "ADDON_LOADED" then
        if firstArg ~= addonName then return end
        self:UnregisterEvent("ADDON_LOADED")
        initialize()
        return
    end
    if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_REGEN_ENABLED" or
       (event == "UNIT_NAME_UPDATE" and firstArg == "target") then
        refreshUnknownTargetName()
    end
    if event == "NAME_PLATE_UNIT_ADDED" then
        trackNameplate(firstArg)
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        untrackNameplate(firstArg)
    elseif event == "UNIT_NAME_UPDATE" then
        if type(firstArg) == "string" and firstArg:match("^nameplate%d+$") then
            trackNameplate(firstArg)
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        for name in pairs(trackedNameplates) do refreshNameplateName(name) end
        for name in pairs(expandedNameplateWidths) do
            if not trackedNameplates[name] then restoreNameplateWidth(name) end
        end
    end
end)
