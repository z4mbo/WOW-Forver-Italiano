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
    if not nameRegion then return end
    local descriptions = ns.data.itemDescriptionOverrides
    local body = type(descriptions) == "table" and descriptions[id] or nil
    local catalogueMatches = type(entry) == "table" and ns.safeText(entry.name) and
        (englishName == entry.en or englishName == entry.name or
         (ns.safeText(entry.itSource) and englishName == entry.itSource))
    local overrideMatches = type(body) == "table" and
        ns.safeText(body.enName) and
        (englishName == body.enName or englishName == body.itName or
         (catalogueMatches and
          (englishName == entry.name or englishName == entry.itSource)))
    -- Both paths require the exact item ID and its observed source/display
    -- name. The description path may run without translating the item name.
    if not catalogueMatches and not overrideMatches then return end
    if catalogueMatches then
        -- Color codes and item quality remain controlled by the client.
        ns.translateFontString(nameRegion, entry.name)
        if ns.safeText(entry.enDescription) and ns.safeText(entry.description) then
            ns.translateTooltipBody(tooltipName, entry.enDescription, entry.description)
        end
    end
    if overrideMatches and ns.safeText(body.enDescription) and
       ns.safeText(body.description) then
        ns.translateTooltipBody(tooltipName, body.enDescription, body.description)
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
