local addonName, ns = ...

local function processTooltip(tooltip, data)
    if not ns.enabled() or type(data) ~= "table" then return end
    local id = data.id
    if type(issecretvalue) == "function" and issecretvalue(id) then return end
    if type(id) ~= "number" or id <= 0 then return end

    local nameRegion
    local tooltipName
    if tooltip and type(tooltip.GetName) == "function" then
        tooltipName = tooltip:GetName()
        if type(tooltipName) == "string" then
            nameRegion = _G[tooltipName .. "TextLeft1"]
        end
    end
    local englishName = nameRegion and type(nameRegion.GetText) == "function" and ns.safeText(nameRegion:GetText()) or nil
    local items = ns.data.items
    local entry = type(items) == "table" and items[id] or nil
    if englishName and (type(entry) ~= "table" or englishName ~= entry.name) then
        ns.captureItem(id, { name = englishName })
    end
    if type(entry) ~= "table" or not ns.safeText(entry.name) then return end
    if not nameRegion then return end
    -- If a beta build changes the item ID/name pairing, do not display a wrong
    -- translation. Color codes and item quality remain controlled by the client.
    if ns.safeText(entry.en) and englishName and englishName ~= entry.en and englishName ~= entry.name then
        return
    end
    ns.translateFontString(nameRegion, entry.name)
    if ns.safeText(entry.enDescription) and ns.safeText(entry.description) then
        ns.translateTooltipBody(tooltipName, entry.enDescription, entry.description)
    end
end

local function initialize()
    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType then return end
    if type(TooltipDataProcessor.AddTooltipPostCall) ~= "function" then return end
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, processTooltip)
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, _, loadedName)
    if loadedName ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")
    initialize()
end)
