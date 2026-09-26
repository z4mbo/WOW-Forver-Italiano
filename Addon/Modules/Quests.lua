local _, ns = ...

-- Forever 1.60.x uses the Mainline quest panels. Work on the displayed text,
-- rather than replacing Blizzard's quest APIs (which other addons also use).
local hooked = {}

local function validQuestID(value)
    if issecretvalue and issecretvalue(value) then
        return nil
    end
    if type(value) == "number" and value > 0 then
        return value
    end
    return nil
end

local function currentQuestID(questLog)
    local getter
    if questLog then
        getter = C_QuestLog and C_QuestLog.GetSelectedQuest
    else
        getter = GetQuestID
    end
    if type(getter) ~= "function" then
        return nil
    end

    local ok, value = pcall(getter)
    return ok and validQuestID(value) or nil
end

local function titleMatches(entry, title)
    title = ns.safeText(title)
    if not title or type(entry) ~= "table" then return false end
    title = title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    title = title:gsub("|T.-|t", ""):gsub("^%[%d+%]%s*", "")
    return title == entry.enTitle or title == entry.title
end

local function questInfoID()
    local frame = _G.QuestInfoFrame
    local id = currentQuestID(frame and frame.questLog)

    -- During an NPC offer Forever can populate the title before GetQuestID()
    -- becomes available. Match the visible title only when it identifies one
    -- quest unambiguously; the generic UI pass may already have translated it.
    local titles = {}
    if not (frame and frame.questLog) and type(GetTitleText) == "function" then
        local ok, sourceTitle = pcall(GetTitleText)
        if ok and ns.safeText(sourceTitle) then titles[#titles + 1] = sourceTitle end
    end
    local titleFrame = _G.QuestInfoTitleHeader
    if titleFrame and type(titleFrame.GetText) == "function" then
        local title = ns.safeText(titleFrame:GetText())
        if title then titles[#titles + 1] = title end
    end
    local currentEntry = id and ns.data.quests and ns.data.quests[id]
    if currentEntry then
        for i = 1, #titles do
            if titleMatches(currentEntry, titles[i]) then return id end
        end
    end
    for i = 1, #titles do
        local match
        for questID, entry in pairs(ns.data.quests or {}) do
            if titleMatches(entry, titles[i]) then
                if match and match ~= questID then match = nil; break end
                match = questID
            end
        end
        if match then return match end
    end
    -- A beta server can repurpose a Classic ID. No matching visible title
    -- means there is no verified basis for replacing its quest text.
    return nil
end

local function canTranslate()
    if InCombatLockdown and InCombatLockdown() then
        return false
    end
    return not ns.enabled or ns.enabled()
end

local function apply(id, field, frame, alternateField, capture)
    if not id or not frame or type(frame.GetText) ~= "function" then
        return
    end

    if capture and ns.captureQuest then
        local original = ns.safeText(frame:GetText())
        if original and original ~= "" then
            ns.captureQuest(id, { [field] = original })
        end
    end

    if not canTranslate() then
        return
    end

    local quests = ns.data and ns.data.quests
    local entry = quests and quests[id]
    if type(entry) ~= "table" then
        return
    end

    local translated = ns.safeText(entry[field])
    if (not translated or translated == "") and alternateField then
        translated = ns.safeText(entry[alternateField])
    end
    if translated and translated ~= "" then
        ns.translateFontString(frame, translated)
    end
end

local function applyInfo(field, globalName, alternateField, capture)
    apply(questInfoID(), field, _G[globalName], alternateField, capture)
end

local function applyProgress(capture)
    local id = currentQuestID(false)
    local title = _G.QuestProgressTitleText
    if not (id and title and type(title.GetText) == "function" and
            titleMatches(ns.data.quests and ns.data.quests[id], title:GetText())) then
        return
    end
    apply(id, "title", _G.QuestProgressTitleText, nil, capture)
    apply(id, "progress", _G.QuestProgressText, nil, capture)
end

local function hook(name, callback)
    if hooked[name] or type(_G[name]) ~= "function" or type(hooksecurefunc) ~= "function" then
        return
    end
    local ok = pcall(hooksecurefunc, name, callback)
    if ok then
        hooked[name] = true
    end
end

local trackerHooked = false

local function installTrackerHook()
    local tracker = _G.QuestObjectiveTracker
    if trackerHooked or not tracker or
       type(tracker.UpdateSingle) ~= "function" or
       type(hooksecurefunc) ~= "function" then
        return
    end
    local ok = pcall(hooksecurefunc, tracker, "UpdateSingle", function(self, quest)
        if not canTranslate() or not quest or type(quest.GetID) ~= "function" then return end
        local id = validQuestID(quest:GetID())
        local entry = id and ns.data.quests and ns.data.quests[id]
        if type(entry) ~= "table" or not ns.safeText(entry.enTitle) or
           not ns.safeText(entry.title) then return end
        local block = type(self.GetExistingBlock) == "function" and self:GetExistingBlock(id)
        if not block or not block.HeaderText then return end
        local shown = ns.safeText(block.HeaderText:GetText())
        if not shown then return end
        local startPos, endPos = shown:find(entry.enTitle, 1, true)
        if startPos then
            ns.translateFontString(block.HeaderText,
                shown:sub(1, startPos - 1) .. entry.title .. shown:sub(endPos + 1))
        end
    end)
    if ok then trackerHooked = true end
end

local function installHooks()
    hook("QuestInfo_ShowTitle", function()
        applyInfo("title", "QuestInfoTitleHeader", nil, true)
    end)
    hook("QuestInfo_ShowDescriptionText", function()
        applyInfo("description", "QuestInfoDescriptionText", nil, true)
    end)
    hook("QuestInfo_ShowObjectivesText", function()
        applyInfo("objectives", "QuestInfoObjectivesText", nil, true)
    end)
    hook("QuestInfo_ShowRewardText", function()
        -- GetRewardText is the completion dialogue. Some early translation
        -- packs call this field "reward", so accept either spelling.
        applyInfo("completion", "QuestInfoRewardText", "reward", true)
    end)
    -- Forever's NPC offer panel can write the description again after
    -- QuestInfo_ShowDescriptionText. Translate after its complete redraw too.
    hook("QuestInfo_Display", function()
        local id = questInfoID()
        apply(id, "title", _G.QuestInfoTitleHeader)
        apply(id, "description", _G.QuestInfoDescriptionText)
        apply(id, "objectives", _G.QuestInfoObjectivesText)
        apply(id, "completion", _G.QuestInfoRewardText, "reward")
    end)
    hook("QuestFrameProgressPanel_OnShow", function()
        applyProgress(true)
    end)
    -- The map renders its detail text through QuestInfo_Display and can set
    -- the title again after the individual QuestInfo callbacks have run.
    hook("QuestMapFrame_ShowQuestDetails", function(id)
        id = validQuestID(id)
        if id ~= questInfoID() then return end
        apply(id, "title", _G.QuestInfoTitleHeader, nil, true)
        apply(id, "description", _G.QuestInfoDescriptionText, nil, true)
        apply(id, "objectives", _G.QuestInfoObjectivesText, nil, true)
    end)
    installTrackerHook()
end

local function refreshVisible()
    local info = _G.QuestInfoFrame
    local offer = _G.QuestFrameDetailPanel
    if (info and info.IsVisible and info:IsVisible()) or
       (offer and offer.IsVisible and offer:IsVisible()) then
        applyInfo("title", "QuestInfoTitleHeader")
        applyInfo("description", "QuestInfoDescriptionText")
        applyInfo("objectives", "QuestInfoObjectivesText")
        applyInfo("completion", "QuestInfoRewardText", "reward")
    end
    local progress = _G.QuestFrameProgressPanel
    if progress and progress.IsVisible and progress:IsVisible() then
        applyProgress(false)
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("QUEST_DETAIL")
events:RegisterEvent("QUEST_PROGRESS")
events:RegisterEvent("QUEST_COMPLETE")
events:SetScript("OnEvent", function(_, event)
    if event == "ADDON_LOADED" then
        installHooks()
    elseif event == "PLAYER_REGEN_ENABLED" then
        refreshVisible()
    elseif event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or
           event == "QUEST_COMPLETE" then
        refreshVisible()
        if C_Timer and type(C_Timer.After) == "function" then
            C_Timer.After(0, refreshVisible)
            C_Timer.After(0.2, refreshVisible)
        end
    end
end)

installHooks()
