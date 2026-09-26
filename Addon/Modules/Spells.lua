local addonName, ns = ...

local function displayName(source, translated)
    if not ns.safeText(source) or not ns.safeText(translated) then return nil end
    if source == translated then return source, translated end
    local sourceBase = source:match("^(.-)%s*%(Rank %d+%)$")
    local translatedBase = translated:match("^(.-)%s*%(Grado %d+%)$")
    if sourceBase and translatedBase then
        return sourceBase, translatedBase
    end
    return source, translated
end

local function translateTooltipLabels(tooltipName)
    for i = 2, 30 do
        for _, side in ipairs({ "Left", "Right" }) do
            local line = _G[tooltipName .. "Text" .. side .. i]
            local source = line and type(line.GetText) == "function" and ns.safeText(line:GetText())
            if source then
                local translated = ns.data.ui and ns.data.ui[source]
                if not translated then
                    for _, rule in ipairs(ns.data.uiPatterns or {}) do
                        if type(rule) == "table" and ns.safeText(rule.pattern) and
                           ns.safeText(rule.replacement) and source:match(rule.pattern) then
                            translated = source:gsub(rule.pattern, rule.replacement)
                            break
                        end
                    end
                end
                if translated then ns.translateFontString(line, translated) end
            end
        end
    end
end

-- Spell tooltips carry an ID, so a same-named spell from another beta build
-- cannot accidentally receive a translation from this pack.
local function processTooltip(tooltip, data)
    if not ns.enabled() or type(data) ~= "table" then return end
    local id = data.id
    if type(issecretvalue) == "function" and issecretvalue(id) then return end
    if type(id) ~= "number" or id <= 0 then return end
    if not tooltip or type(tooltip.GetName) ~= "function" then return end
    local tooltipName = tooltip:GetName()
    if not ns.safeText(tooltipName) then return end
    local nameRegion = _G[tooltipName .. "TextLeft1"]
    if not nameRegion or type(nameRegion.GetText) ~= "function" then return end

    local englishName = ns.safeText(nameRegion:GetText())
    local entry = ns.data.spells and ns.data.spells[id]
    if englishName and (type(entry) ~= "table" or englishName ~= entry.name) then
        ns.captureSpell(id, { name = englishName })
    end
    if type(entry) ~= "table" or not ns.safeText(entry.name) then return end
    local englishBase, italianBase = displayName(entry.en, entry.name)
    if englishName ~= entry.en and englishName ~= englishBase and
       englishName ~= entry.name and englishName ~= italianBase then return end

    ns.translateFontString(nameRegion,
        englishName == englishBase and italianBase or entry.name)
    if ns.safeText(entry.enDescription) and ns.safeText(entry.description) then
        ns.translateTooltipBody(tooltipName, entry.enDescription, entry.description)
    end
    translateTooltipLabels(tooltipName)
end

local function initialize()
    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType or
       not Enum.TooltipDataType.Spell or
       type(TooltipDataProcessor.AddTooltipPostCall) ~= "function" then return end
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, processTooltip)
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, _, loadedName)
    if loadedName ~= addonName then return end
    self:UnregisterEvent("ADDON_LOADED")
    initialize()
end)
