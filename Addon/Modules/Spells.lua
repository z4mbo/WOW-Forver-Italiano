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

-- The client expands DB2 spell tokens before a FontString can be read. Every
-- dynamic replacement is gated by an exact spell ID, a locally verified
-- English/Italian pair in spellDescriptionOverrides, and an anchored match
-- of the whole rendered English body. Unsupported tokens remain untouched.

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
            tail:match("^%$[lL][^:;]+:[^:;]+;") or
            tail:match("^%$[gG][^:;]+:[^;]+;") or
            tail:match("^%$%*%d+;[%a]%d+") or
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
    if token:match("^%$[lL][^:;]+:[^:;]+;$") then return "plural" end
    if token:match("^%$[gG][^:;]+:[^;]+;$") then return "gender" end
    if token:match("^%$%d*d$") then return "duration" end
    return "number"
end

local function conditionalForms(token, kind)
    if kind == "plural" then
        return token:match("^%$[lL]([^:;]+):([^:;]+);$")
    end
    return token:match("^%$[gG]([^:;]+):([^;]+);$")
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
    -- The client renders source tokens in English order, while a verified
    -- Italian sentence can naturally move those values to a different place.
    -- Pair ordinary placeholders by their exact DB2 token and retain the
    -- positional rule for conditional forms, whose source and target words
    -- necessarily differ.
    local itEnglishIndices, usedEnglishTokens = {}, {}
    local englishConditionalIndices = { plural = {}, gender = {} }
    local italianConditionalIndices = { plural = {}, gender = {} }
    local italianConditionalOrdinals = {}
    for index, token in ipairs(enTokens) do
        local kind = spellTokenKind(token)
        if kind == "plural" or kind == "gender" then
            local key = kind == "plural" and "plural" or "gender"
            local indices = englishConditionalIndices[key]
            indices[#indices + 1] = index
        end
    end
    for index, token in ipairs(itTokens) do
        local kind = spellTokenKind(token)
        if kind == "plural" or kind == "gender" then
            local key = kind == "plural" and "plural" or "gender"
            local indices = italianConditionalIndices[key]
            indices[#indices + 1] = index
            italianConditionalOrdinals[index] = #indices
        end
    end
    for _, key in ipairs({ "plural", "gender" }) do
        local englishIndices = englishConditionalIndices[key]
        local italianIndices = italianConditionalIndices[key]
        if #englishIndices ~= #italianIndices then return nil end
        -- A single selector is unambiguous even when Italian moves it. If a
        -- template repeats a selector kind, keep those selectors positional
        -- because the translated forms do not identify which source form
        -- each occurrence represents.
        if #englishIndices > 1 then
            for ordinal, englishIndex in ipairs(englishIndices) do
                if italianIndices[ordinal] ~= englishIndex then return nil end
            end
        end
    end
    for italianIndex, italianToken in ipairs(itTokens) do
        local kind = spellTokenKind(italianToken)
        if kind == "plural" or kind == "gender" then
            local key = kind == "plural" and "plural" or "gender"
            local ordinal = italianConditionalOrdinals[italianIndex]
            local englishIndex = englishConditionalIndices[key][ordinal]
            if not englishIndex then return nil end
            itEnglishIndices[italianIndex] = englishIndex
            usedEnglishTokens[englishIndex] = true
        else
            local englishIndex
            for candidate, englishToken in ipairs(enTokens) do
                local candidateKind = spellTokenKind(englishToken)
                if not usedEnglishTokens[candidate] and
                   candidateKind ~= "plural" and candidateKind ~= "gender" and
                   englishToken == italianToken then
                    englishIndex = candidate
                    break
                end
            end
            if not englishIndex then return nil end
            itEnglishIndices[italianIndex] = englishIndex
            usedEnglishTokens[englishIndex] = true
        end
    end
    for index in ipairs(enTokens) do
        if not usedEnglishTokens[index] then return nil end
    end
    for index, token in ipairs(enTokens) do
        local kind = spellTokenKind(token)
        pattern[#pattern + 1] = spellLiteralPattern(enParts[index])
        if kind == "plural" or kind == "gender" then
            pattern[#pattern + 1] = "([%a%s%'%-]+)"
        elseif kind == "duration" then
            pattern[#pattern + 1] = "([%d][%d%.,]*%s*[%a%.]*)"
        else
            pattern[#pattern + 1] = "([%d][%d%.,]*)"
        end
    end
    pattern[#pattern + 1] = spellLiteralPattern(enParts[#enParts])
    pattern[#pattern + 1] = "$"
    cached = { english = english, italian = italian,
        pattern = table.concat(pattern), tokens = enTokens,
        itTokens = itTokens, itParts = itParts,
        itEnglishIndices = itEnglishIndices }
    dynamicTemplateCache[id] = cached
    return cached
end

local durationUnits = {
    sec = "s", secs = "s", second = "s", seconds = "s",
    min = "min", mins = "min", minute = "min", minutes = "min",
    hr = "hour", hrs = "hour", hour = "hour", hours = "hour",
    day = "day", days = "day",
}

local function italianDuration(value)
    local number, unit = value:match("^(%d[%d%.,]*)%s*([%a%.]*)$")
    if not number or #number > 20 then return nil end
    if unit == "" then return number end
    local mapped = durationUnits[unit:gsub("%.$", ""):lower()]
    if not mapped then return nil end
    if mapped == "hour" then
        mapped = tonumber(number) == 1 and "ora" or "ore"
    elseif mapped == "day" then
        mapped = tonumber(number) == 1 and "giorno" or "giorni"
    end
    return number .. " " .. mapped
end

local function renderDynamicSpell(template, source)
    if #source > 2400 then return nil end
    local values = { source:match(template.pattern) }
    if #values ~= #template.tokens then return nil end
    local result = {}
    for index, italianToken in ipairs(template.itTokens) do
        local englishIndex = template.itEnglishIndices[index]
        local token, value = template.tokens[englishIndex], values[englishIndex]
        local kind = spellTokenKind(token)
        if kind == "plural" or kind == "gender" then
            local englishSingular, englishPlural = conditionalForms(token, kind)
            local italianSingular, italianPlural = conditionalForms(italianToken, kind)
            if token == "$lpoint:points;" and
               template.itTokens[index] == "$lpoint:punti;" then
                italianSingular = "punto"
            end
            if value == englishSingular then
                value = italianSingular
            elseif value == englishPlural then
                value = italianPlural
            else
                return nil
            end
        elseif kind == "duration" then
            if #value > 32 then return nil end
            value = italianDuration(value)
            if not value then return nil end
        elseif #value > 20 or not value:match("^%d[%d%.,]*$") then
            return nil
        end
        result[#result + 1] = template.itParts[index]
        result[#result + 1] = value
    end
    result[#result + 1] = template.itParts[#template.itParts]
    return table.concat(result)
end

-- A subset of DB2 templates embeds another spell's complete description with
-- $@spelldesc<ID>. Expand it only from an exact, ID-keyed verified pair whose
-- body is token-free; expressions and nested templates remain client-owned.
local function expandReferencedSpellDescriptions(value, field)
    if type(value) ~= "string" then return nil end
    local expanded, changed, references = value, false, {}
    local position = 1
    while true do
        local first, last, idText = expanded:find("%$@spelldesc(%d+)", position)
        if not first then break end
        local registry = ns.data.spellDescriptionOverrides
        local target = registry and registry[tonumber(idText)]
        if type(target) ~= "table" or not ns.safeText(target.en) or
           not ns.safeText(target.description) then return nil end
        local english, italian = target.en, target.description
        if english:find("$", 1, true) or italian:find("$", 1, true) or
           #english > 1200 or #italian > 1200 then return nil end
        references[#references + 1] = tonumber(idText)
        local prefix, suffix = expanded:sub(1, first - 1), expanded:sub(last + 1)
        local replacement = field == "description" and italian or english
        expanded = prefix .. replacement .. suffix
        changed = true
        position = first + #replacement
    end
    return changed and expanded or nil, references
end

local function translateDynamicSpellBody(tooltipName, id, english, italian, registry)
    local override = registry and registry[id]
    if type(override) ~= "table" or override.en ~= english or
       override.description ~= italian then return false end
    local expandedEnglish, englishReferences =
        expandReferencedSpellDescriptions(english, "en")
    local expandedItalian, italianReferences =
        expandReferencedSpellDescriptions(italian, "description")
    englishReferences = englishReferences or {}
    italianReferences = italianReferences or {}
    if expandedEnglish and expandedItalian then
        if #englishReferences ~= #italianReferences then return false end
        for index, referenceID in ipairs(englishReferences) do
            if italianReferences[index] ~= referenceID then return false end
        end
        english, italian = expandedEnglish, expandedItalian
    elseif expandedEnglish then
        english = expandedEnglish
    elseif #italianReferences > 0 then
        return false
    end
    local template = compiledSpellTemplate(id, english, italian)
    if not template then
        if #english > 1600 or #italian > 1600 or
           english:find("$", 1, true) or italian:find("$", 1, true) then
            return false
        end
        local translated = false
        for i = 2, 30 do
            local line = _G[tooltipName .. "TextLeft" .. i]
            local source = line and type(line.GetText) == "function" and
                ns.safeText(line:GetText())
            if source == english and ns.translateFontString(line, italian) then
                translated = true
            end
        end
        return translated
    end
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

-- The two conditional templates below contain nested client directives that
-- the ordinary spell-template matcher cannot parse. Accept only their fully
-- rendered English sentences for these exact IDs and preserve numeric values.
local function translateConditionalSpellBody(tooltipName, id)
    if id ~= 339 and id ~= 740 then return end
    for i = 2, 30 do
        local line = _G[tooltipName .. "TextLeft" .. i]
        local source = line and type(line.GetText) == "function" and
            ns.safeText(line:GetText())
        if source then
            local translated
            if id == 339 then
                local damage, duration, limit = source:match(
                    "^Roots the target in place and causes ([%d][%d%.,]*) Nature damage over ([%d][%d%.,]*%s*[%a%.]+)%.%s+Damage caused may interrupt the effect%.%s+You may have up to ([%d]+) targets Rooted at a time%.$")
                if not damage then
                    damage, duration = source:match(
                        "^Roots the target in place and causes ([%d][%d%.,]*) Nature damage over ([%d][%d%.,]*%s*[%a%.]+)%.%s+Damage caused may interrupt the effect%.%s+You may only have 1 target Rooted at a time%.$")
                    if damage then limit = "1" end
                end
                local when = duration and italianDuration(duration)
                if damage and when and limit then
                    local target = limit == "1" and "un solo bersaglio" or
                        ("fino a " .. limit .. " bersagli")
                    translated = "Immobilizza il bersaglio e gli infligge " .. damage ..
                        " danni da natura nell'arco di " .. when ..
                        ". I danni inflitti possono interrompere l'effetto. " ..
                        "Puoi mantenere immobilizzati " .. target .. " alla volta."
                end
            else
                local range, amount, interval, unit, duration, durationUnit =
                    source:match(
                    "^Regenerates all nearby party members within ([%d][%d%.,]*) yards for ([%d][%d%.,]*) every ([%d][%d%.,]*) ([%a%.]+) for ([%d][%d%.,]*) ([%a%.]+)%.%s+Druid must channel to maintain the spell%.$")
                local every = interval and unit and italianDuration(interval .. " " .. unit)
                local when = duration and durationUnit and
                    italianDuration(duration .. " " .. durationUnit)
                if range and amount and every and when then
                    translated = "Rigenera la salute dei membri del gruppo vicini " ..
                        "entro " .. range .. " m, ripristinando " .. amount ..
                        " ogni " .. every .. " per " .. when ..
                        ". Il druido deve canalizzare l'incantesimo."
                end
            end
            if translated then ns.translateFontString(line, translated) end
        end
    end
end

-- This beta can return no description for a spell whose local Spell.db2 has
-- verified text. Insert only a token-free body after an exact spellbook ID and
-- source-name match. A yellow left line is treated as an existing body.
local function addMissingStaticBody(tooltip, tooltipName, id, italian)
    if not ns.safeText(italian) or
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
    local nameOverrides = ns.data.spellNameOverrides
    local nameOverride = type(nameOverrides) == "table" and nameOverrides[id] or nil
    local exactNameOverride = type(nameOverride) == "table" and
        ns.safeText(nameOverride.en) and ns.safeText(nameOverride.name) and
        englishName == nameOverride.en
    if englishName and not exactNameOverride and
       (type(entry) ~= "table" or englishName ~= entry.name) then
        ns.captureSpell(id, { name = englishName })
    end
    local hasName = type(entry) == "table" and ns.safeText(entry.name)
    local nameMatches = false
    if exactNameOverride then
        nameMatches = true
        ns.translateFontString(nameRegion, nameOverride.name)
    elseif hasName then
        local englishBase, italianBase = displayName(entry.en, entry.name)
        nameMatches = englishName == entry.en or englishName == englishBase or
            englishName == entry.name or englishName == italianBase or
            (ns.safeText(entry.itSource) and englishName == entry.itSource)
        if not nameMatches then return end
        ns.translateFontString(nameRegion,
            englishName == englishBase and italianBase or entry.name)
    end
    local sourceNames = ns.data.spellSourceNames
    local sourceName = type(sourceNames) == "table" and sourceNames[id] or nil
    local sourceNameMatches = type(sourceName) == "table" and
        ns.safeText(sourceName.en) and
        (englishName == sourceName.en or englishName == sourceName.it)

    -- Rank, profession level, racial, and pet-family subtext is a separate
    -- localized Spell.db2 field. It can appear on its own tooltip line.
    local subtexts = ns.data.spellSubtextOverrides
    local subtext = type(subtexts) == "table" and subtexts[id] or nil
    if type(subtext) == "table" and ns.safeText(subtext.en) and
       ns.safeText(subtext.subtext) then
        ns.translateTooltipBody(tooltipName, subtext.en, subtext.subtext)
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
        translateDynamicSpellBody(tooltipName, id, english, italian, overrides)
        if (nameMatches or sourceNameMatches) and
           (not fromSpellBook or bookID) then
            addMissingStaticBody(tooltip, tooltipName, id, italian)
        end
    end
    -- Some older catalogue records normalized line endings to LF. The beta
    -- client stores these 17 exact descriptions with CRLF, so match that
    -- verified source independently while retaining the older record.
    local betaAliases = ns.data.spellDescriptionBetaOverrides
    local betaBody = type(betaAliases) == "table" and betaAliases[id] or nil
    if type(betaBody) == "table" and ns.safeText(betaBody.en) and
       ns.safeText(betaBody.description) then
        ns.translateTooltipBody(tooltipName, betaBody.en,
            betaBody.description)
        translateDynamicSpellBody(tooltipName, id, betaBody.en,
            betaBody.description, betaAliases)
    end
    local auraOverrides = ns.data.spellAuraDescriptionOverrides
    local aura = type(auraOverrides) == "table" and auraOverrides[id] or nil
    local auraEnglish = type(aura) == "table" and aura.en or nil
    local auraItalian = type(aura) == "table" and aura.description or nil
    if ns.safeText(auraEnglish) and ns.safeText(auraItalian) then
        ns.translateTooltipBody(tooltipName, auraEnglish, auraItalian)
        translateDynamicSpellBody(tooltipName, id, auraEnglish, auraItalian,
            auraOverrides)
    end
    if nameMatches then translateEviscerateBody(tooltipName, id) end
    translateConditionalSpellBody(tooltipName, id)
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
       (type(tooltip.IsShown) == "function" and not tooltip:IsShown()) then return end
    local id = playerSpellBookItemID(tooltip)
    if not id then return end
    local body = ns.data.spellDescriptionOverrides and
        ns.data.spellDescriptionOverrides[id]
    local italian = type(body) == "table" and ns.safeText(body.description)
    if not italian or italian:find("$", 1, true) then return end
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
