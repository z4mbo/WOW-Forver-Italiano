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

-- Only the locally checked Spell.db2 batch uses this renderer. The client
-- expands spell tokens before a FontString can be read, so a literal lookup
-- cannot match these descriptions. Keep the ID gate as well as the complete
-- English-template match; no individual words are substituted in isolation.
local verifiedDynamicIDs = {}
for _, id in ipairs({
    20577, 1752, 1757, 1758, 1759, 1760, 1766, 1776, 1784, 1856,
    1943, 2098, 2589, 2590, 2591, 5171, 5277, 6770, 8676, 8681,
    8721, 8724, 11267, 11268, 11269, 11273, 11274, 11275, 11279,
    11280, 11281, 11285, 11286, 11289, 11290, 11293, 11294,
    11297, 11300, 11305, 11341, 11342, 11343, 11357, 11358,
    11400, 20572, 20574,
    133, 168, 205, 284, 324, 331, 339, 348, 465, 467, 529,
    546, 547, 587, 588, 591, 592, 594, 604, 639, 642, 643,
    687, 689, 695, 696, 698, 702, 703, 704, 706, 707, 710,
    711, 724, 740, 755, 758, 759, 768, 769, 770, 774, 778,
    779, 780, 781, 782, 783, 834, 837, 845, 865, 871, 885,
    913, 915, 945, 1004, 1026, 1126, 1243, 1459,
}) do verifiedDynamicIDs[id] = true end

local function splitSpellTemplate(value)
    local parts, tokens, position = {}, {}, 1
    while position <= #value do
        local dollar = value:find("$", position, true)
        if not dollar then
            parts[#parts + 1] = value:sub(position)
            break
        end
        parts[#parts + 1] = value:sub(position, dollar - 1)
        local tail = value:sub(dollar)
        local token = tail:match("^%$%b{}") or
            tail:match("^%$l[%a]+:[%a]+;") or
            tail:match("^%$%d*[%a]+%d*")
        if not token then return nil end
        tokens[#tokens + 1] = token
        if #tokens > 24 then return nil end
        position = dollar + #token
    end
    if #parts == #tokens then parts[#parts + 1] = "" end
    return parts, tokens
end

local function spellTokenKind(token)
    if token == "$lpoint:points;" or token == "$lpoint:punti;" then
        return "point"
    end
    if token:match("^%$%d*d$") then return "duration" end
    return "number"
end

local function spellLiteralPattern(literal)
    local pattern, index = {}, 1
    while index <= #literal do
        local character = literal:sub(index, index)
        if character:match("%s") then
            repeat index = index + 1
                character = literal:sub(index, index)
            until index > #literal or not character:match("%s")
            pattern[#pattern + 1] = "%s+"
        else
            pattern[#pattern + 1] = character:gsub("([^%w])", "%%%1")
            index = index + 1
        end
    end
    return table.concat(pattern)
end

local dynamicTemplateCache = {}
local function compiledSpellTemplate(id, english, italian)
    local cached = dynamicTemplateCache[id]
    if cached and cached.english == english and cached.italian == italian then
        return cached
    end
    if #english > 1600 or #italian > 1600 then return nil end
    local enParts, enTokens = splitSpellTemplate(english)
    local itParts, itTokens = splitSpellTemplate(italian)
    if not enParts or not itParts or #enTokens == 0 or
       #enTokens ~= #itTokens then return nil end
    local pattern = { "^" }
    for index, token in ipairs(enTokens) do
        local kind = spellTokenKind(token)
        if kind ~= "point" and token ~= itTokens[index] then return nil end
        if kind == "point" and spellTokenKind(itTokens[index]) ~= "point" then return nil end
        pattern[#pattern + 1] = spellLiteralPattern(enParts[index])
        if kind == "point" then
            pattern[#pattern + 1] = "(points?)"
        elseif kind == "duration" then
            pattern[#pattern + 1] = "([%d][%d%.,]*%s*[%a%.]*)"
        else
            pattern[#pattern + 1] = "([%d][%d%.,]*)"
        end
    end
    pattern[#pattern + 1] = spellLiteralPattern(enParts[#enParts])
    pattern[#pattern + 1] = "$"
    cached = { english = english, italian = italian,
        pattern = table.concat(pattern), tokens = enTokens, itParts = itParts }
    dynamicTemplateCache[id] = cached
    return cached
end

local durationUnits = {
    sec = "s", secs = "s", second = "s", seconds = "s",
    min = "min", mins = "min", minute = "min", minutes = "min",
    hr = "hour", hrs = "hour", hour = "hour", hours = "hour",
    day = "day", days = "day",
}

local function renderDynamicSpell(template, source)
    if #source > 2400 then return nil end
    local values = { source:match(template.pattern) }
    if #values ~= #template.tokens then return nil end
    local result = {}
    for index, token in ipairs(template.tokens) do
        local value, kind = values[index], spellTokenKind(token)
        if kind == "point" then
            if value ~= "point" and value ~= "points" then return nil end
            value = value == "point" and "punto" or "punti"
        elseif kind == "duration" then
            if #value > 32 then return nil end
            local number, unit = value:match("^(%d[%d%.,]*)%s*([%a%.]*)$")
            if not number or #number > 20 then return nil end
            if unit ~= "" then
                local mapped = durationUnits[unit:gsub("%.$", ""):lower()]
                if not mapped then return nil end
                if mapped == "hour" then
                    mapped = tonumber(number) == 1 and "ora" or "ore"
                elseif mapped == "day" then
                    mapped = tonumber(number) == 1 and "giorno" or "giorni"
                end
                value = number .. " " .. mapped
            end
        elseif #value > 20 or not value:match("^%d[%d%.,]*$") then
            return nil
        end
        result[#result + 1] = template.itParts[index]
        result[#result + 1] = value
    end
    result[#result + 1] = template.itParts[#template.itParts]
    return table.concat(result)
end

local function translateDynamicSpellBody(tooltipName, id, english, italian)
    if not verifiedDynamicIDs[id] then return false end
    local template = compiledSpellTemplate(id, english, italian)
    if not template then return false end
    local translated = false
    for i = 2, 30 do
        local line = _G[tooltipName .. "TextLeft" .. i]
        local source = line and type(line.GetText) == "function" and ns.safeText(line:GetText())
        if source then
            local rendered = renderDynamicSpell(template, source)
            if rendered and ns.translateFontString(line, rendered) then translated = true end
        end
    end
    return translated
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

-- Eviscerate's client description includes dynamic damage values after its
-- fixed sentence. Match only this ID and its anchored English text, then
-- localize the combo-point rows while retaining the client's numeric ranges.
local function translateEviscerateBody(tooltipName, id)
    if id ~= 2098 then return end
    local prefix = "Finishing move that causes damage per combo point, increased by Attack Power:"
    for i = 2, 30 do
        local line = _G[tooltipName .. "TextLeft" .. i]
        local source = line and type(line.GetText) == "function" and ns.safeText(line:GetText())
        if source then
            local translated = source
            if translated:sub(1, #prefix) == prefix then
                translated = "Mossa finale che infligge danni in base ai punti combo. I danni aumentano con la potenza d'attacco:" ..
                    translated:sub(#prefix + 1)
            end
            translated = translated:gsub("1 point%s*:%s*(%d+%s*[-–]%s*%d+)%s*damage", "1 punto: %1 danni")
            translated = translated:gsub("([2-5]) points:%s*(%d+%s*[-–]%s*%d+)%s*damage", "%1 punti: %2 danni")
            if translated ~= source then ns.translateFontString(line, translated) end
        end
    end
end

-- This beta can return no description for a spell whose local Spell.db2 has
-- verified text. Only 7744 has a token-free body that can be inserted without
-- guessing effect values. A yellow left line is treated as an existing body.
local function addMissingStaticBody(tooltip, tooltipName, id, italian)
    if id ~= 7744 or not ns.safeText(italian) or
       italian:find("$", 1, true) or not C_Spell or
       type(C_Spell.GetSpellDescription) ~= "function" or
       type(tooltip.NumLines) ~= "function" or
       type(tooltip.AddLine) ~= "function" or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    local ok, clientBody = pcall(C_Spell.GetSpellDescription, id)
    if not ok or (type(issecretvalue) == "function" and issecretvalue(clientBody)) or
       clientBody ~= "" then return end
    local count = tooltip:NumLines()
    if type(issecretvalue) == "function" and issecretvalue(count) then return end
    if type(count) ~= "number" or count < 1 or count > 30 then return end
    local footerLine, footerValue, footerIndex, translatedFooter
    for i = 2, count do
        local line = _G[tooltipName .. "TextLeft" .. i]
        if line and type(line.GetText) == "function" then
            local value = line:GetText()
            if type(issecretvalue) == "function" and issecretvalue(value) then return end
            if ns.safeText(value) and value:match("%S") then
                if value == italian then return end
                local footer = "Press F6 to submit an issue for this Spell"
                translatedFooter = ns.data.ui and ns.data.ui[footer]
                local visibleValue = value:gsub("|[cC]%x%x%x%x%x%x%x%x", "")
                    :gsub("|[rR]", "")
                if visibleValue == footer or visibleValue == translatedFooter then
                    footerLine, footerValue, footerIndex = line, value, i
                else
                    if type(line.GetTextColor) ~= "function" then return end
                    local red, green, blue = line:GetTextColor()
                    if type(issecretvalue) == "function" and
                       (issecretvalue(red) or issecretvalue(green) or
                        issecretvalue(blue)) then return end
                    if type(red) ~= "number" or type(green) ~= "number" or
                       type(blue) ~= "number" then return end
                    if red > 0.8 and green > 0.6 and green < 0.95 and
                       blue < 0.35 then return end
                end
            end
        end
    end
    tooltip:AddLine(italian, 1, 0.82, 0, true)
    if footerLine and footerIndex == count and
       type(footerLine.SetText) == "function" and
       (type(footerLine.IsProtected) ~= "function" or
        not footerLine:IsProtected()) then
        local lastLine = _G[tooltipName .. "TextLeft" .. (count + 1)]
        if lastLine and type(lastLine.SetText) == "function" and
           (type(lastLine.IsProtected) ~= "function" or
            not lastLine:IsProtected()) then
            local prefix = footerValue:match("^(|[cC]%x%x%x%x%x%x%x%x)") or ""
            local suffix = footerValue:match("(|[rR])$") or ""
            local finalFooter = prefix ..
                (ns.safeText(translatedFooter) or "Press F6 to submit an issue for this Spell") ..
                suffix
            footerLine:SetText(italian)
            lastLine:SetText(finalFooter)
        end
    end
end

-- In a SpellBookItem tooltip, data.id is not a reliable spell ID. The stock
-- item owns the button passed to SetSpellBookItem; resolve its current slot
-- from the player bank and confirm it against the item's cached spell.
local function playerSpellBookItemID(tooltip)
    if tooltip ~= _G.GameTooltip or type(tooltip.GetOwner) ~= "function" or
       not C_SpellBook or type(C_SpellBook.GetSpellBookItemInfo) ~= "function" then
        return nil
    end
    local owner = tooltip:GetOwner()
    local item = owner and type(owner.GetParent) == "function" and owner:GetParent()
    if not item or item.Button ~= owner then return nil end
    local book = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.SpellBookFrame
    local frame, belongs = item, false
    for _ = 1, 12 do
        if frame == book and book then belongs = true; break end
        if not frame or type(frame.GetParent) ~= "function" then break end
        frame = frame:GetParent()
    end
    if not belongs then return nil end
    local slot, bank = item.slotIndex, item.spellBank
    if type(issecretvalue) == "function" and
       (issecretvalue(slot) or issecretvalue(bank)) then return nil end
    local playerBank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
    if type(slot) ~= "number" or playerBank == nil or bank ~= playerBank then return nil end
    local ok, info = pcall(C_SpellBook.GetSpellBookItemInfo, slot, bank)
    if not ok or type(info) ~= "table" then return nil end
    local id = info.spellID
    local cached = item.spellBookItemInfo and item.spellBookItemInfo.spellID
    if type(issecretvalue) == "function" and
       (issecretvalue(id) or issecretvalue(cached)) then return nil end
    if type(id) ~= "number" or id <= 0 or id ~= cached then return nil end
    return id
end

-- Spell tooltips carry an ID, so a same-named spell from another beta build
-- cannot accidentally receive a translation from this pack.
local function processTooltip(tooltip, data, fromSpellBook)
    if not ns.enabled() then return end
    local bookID = fromSpellBook and playerSpellBookItemID(tooltip) or nil
    if fromSpellBook and not bookID then return end
    local id = bookID or (type(data) == "table" and data.id)
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
    local hasName = type(entry) == "table" and ns.safeText(entry.name)
    local nameMatches = false
    if hasName then
        local englishBase, italianBase = displayName(entry.en, entry.name)
        nameMatches = englishName == entry.en or englishName == englishBase or
            englishName == entry.name or englishName == italianBase
        if not nameMatches then return end
        ns.translateFontString(nameRegion,
            englishName == englishBase and italianBase or entry.name)
    end

    -- The verified DB2 batch also contains ranks without a name translation.
    -- Its ID-keyed override can translate their bodies while leaving the
    -- client-provided name alone.
    local overrides = ns.data.spellDescriptionOverrides
    local body = type(overrides) == "table" and overrides[id] or nil
    local english = type(body) == "table" and body.en or nil
    local italian = type(body) == "table" and body.description or nil
    if not ns.safeText(english) or not ns.safeText(italian) then
        english = type(entry) == "table" and entry.enDescription or nil
        italian = type(entry) == "table" and entry.description or nil
    end
    if ns.safeText(english) and ns.safeText(italian) then
        ns.translateTooltipBody(tooltipName, english, italian)
        translateDynamicSpellBody(tooltipName, id, english, italian)
        if nameMatches and (not fromSpellBook or bookID) then
            addMissingStaticBody(tooltip, tooltipName, id, italian)
        end
    end
    if nameMatches then translateEviscerateBody(tooltipName, id) end
    translateTooltipLabels(tooltipName)
end

local hookedBookTooltip = false
local bookTooltipElapsed = 0
local function observeBookTooltip(tooltip, elapsed)
    bookTooltipElapsed = bookTooltipElapsed +
        (type(elapsed) == "number" and elapsed or 0)
    if bookTooltipElapsed < 0.1 then return end
    bookTooltipElapsed = 0
    if not ns.enabled() or
       (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) or
       playerSpellBookItemID(tooltip) ~= 7744 then return end
    local body = ns.data.spellDescriptionOverrides and
        ns.data.spellDescriptionOverrides[7744]
    local italian = type(body) == "table" and ns.safeText(body.description)
    if not italian then return end
    local count = type(tooltip.NumLines) == "function" and tooltip:NumLines()
    if type(issecretvalue) == "function" and issecretvalue(count) then return end
    if type(count) ~= "number" or count < 1 or count > 30 then return end
    for i = 2, count do
        local line = _G["GameTooltipTextLeft" .. i]
        if line and type(line.GetText) == "function" then
            local value = line:GetText()
            if type(issecretvalue) == "function" and issecretvalue(value) then return end
            if value == italian then return end
        end
    end
    processTooltip(tooltip, nil, true)
end

local function installBookTooltipObserver()
    if hookedBookTooltip then return end
    local tooltip = _G.GameTooltip
    if not tooltip or type(tooltip.HookScript) ~= "function" then return end
    local ok = pcall(tooltip.HookScript, tooltip, "OnUpdate", observeBookTooltip)
    if ok then hookedBookTooltip = true end
end

local initializedTooltipTypes = false
local function initialize()
    installBookTooltipObserver()
    if initializedTooltipTypes then return end
    if not TooltipDataProcessor or not Enum or not Enum.TooltipDataType or
       type(TooltipDataProcessor.AddTooltipPostCall) ~= "function" then return end
    for _, kind in ipairs({ "Spell", "SpellBookItem" }) do
        local dataType = Enum.TooltipDataType[kind]
        if dataType then
            TooltipDataProcessor.AddTooltipPostCall(dataType, function(tooltip, data)
                processTooltip(tooltip, data, kind == "SpellBookItem")
            end)
        end
    end
    initializedTooltipTypes = true
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function(self, _, loadedName)
    if loadedName == addonName or loadedName == "Blizzard_PlayerSpells" or
       loadedName == nil then initialize() end
end)

installBookTooltipObserver()
