local addonName, ns = ...

-- Translate exact, static labels only. Guild member names, community names,
-- chat messages and collection entry names are generated/user supplied and
-- are intentionally left alone unless they happen to be a complete UI label.
local roots = {
    "GuildFrame", "GuildRosterFrame", "GuildInfoFrame", "GuildNewsFrame",
    "GuildPerksFrame", "GuildControlFrame", "GuildBankFrame",
    "CommunitiesFrame", "CommunitiesFrame.Chat", "CommunitiesFrame.MemberList",
    -- These roots are separate Blizzard frames in the extracted beta client;
    -- they are not descendants of CommunitiesFrame or CollectionsJournal.
    "CommunitiesSettingsDialog", "CommunitiesAvatarPickerDialog",
    "CalendarFrame", "FriendsFrame",
    "CollectionsJournal", "MountJournal", "PetJournal", "ToyBox",
    "HeirloomJournal", "WardrobeCollectionFrame", "WardrobeFrame",
}

local hooked = {}
local buttonHooks = setmetatable({}, { __mode = "k" })
local scheduled, scanning = false, false
local translations = {}
local scheduleRefresh

local function rebuildTranslations()
    translations = {}
    for _, sourceTable in ipairs({
        (ns.data and ns.data.ui) or {},
        (ns.data and ns.data.guildCollections) or {},
    }) do
        for source, target in pairs(sourceTable) do
            if ns.safeText(source) and ns.safeText(target) then
                translations[source] = target
            end
        end
    end
end

local function tryMethod(object, method)
    if not object or type(object[method]) ~= "function" then return nil end
    local ok, result = pcall(object[method], object)
    if ok then return result end
end

local function translateRegion(region)
    if not region or tryMethod(region, "GetObjectType") ~= "FontString" then return end
    local text = tryMethod(region, "GetText")
    local source = ns.safeText(text)
    if not source then return end
    local translated = translations[source]
    if translated then ns.translateFontString(region, translated) end
end

local function scan(frame, budget)
    if not frame or budget <= 0 then return budget end
    local shown = tryMethod(frame, "IsShown")
    if shown == false then return budget end
    budget = budget - 1

    if type(frame.GetRegions) == "function" then
        local ok, regions = pcall(function() return { frame:GetRegions() } end)
        if ok then
            for i = 1, #regions do translateRegion(regions[i]) end
        end
    end
    if type(frame.GetChildren) == "function" then
        local ok, children = pcall(function() return { frame:GetChildren() } end)
        if ok then
            for i = 1, #children do
                local child = children[i]
                -- Hook buttons to refresh after a category/tab selection. HookScript
                -- appends a post-click callback and never replaces Blizzard code.
                if child and not buttonHooks[child] and type(child.HookScript) == "function" and
                   (tryMethod(child, "GetObjectType") == "Button" or
                    tryMethod(child, "GetObjectType") == "CheckButton") and
                   not (type(InCombatLockdown) == "function" and InCombatLockdown()) then
                    local okHook = pcall(child.HookScript, child, "OnClick", function()
                        scheduleRefresh()
                    end)
                    if okHook then buttonHooks[child] = true end
                end
                budget = scan(child, budget)
                if budget <= 0 then break end
            end
        end
    end
    return budget
end

local function refresh()
    scheduled = false
    if scanning or not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    scanning = true
    for i = 1, #roots do
        local frame = _G[roots[i]]
        if frame then scan(frame, 1800) end
    end
    scanning = false
end

scheduleRefresh = function()
    if scheduled then return end
    scheduled = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0.1, refresh)
        C_Timer.After(0.6, refresh)
    else
        refresh()
    end
end

local function installHooks()
    for i = 1, #roots do
        local frame = _G[roots[i]]
        if frame and not hooked[roots[i]] and type(frame.HookScript) == "function" then
            local ok = pcall(frame.HookScript, frame, "OnShow", scheduleRefresh)
            if ok then hooked[roots[i]] = true end
        end
    end
    if type(hooksecurefunc) == "function" then
        for _, name in ipairs({
            "GuildRoster_Update", "GuildInfoFrame_Update", "GuildNewsFrame_Update",
            "CommunitiesGuildInfoFrame_UpdateText", "CommunitiesGuildInfoFrame_UpdateChallenges",
            "CommunitiesGuildLogFrame_Update", "OpenCommunitiesSettingsDialog",
            "CommunitiesFrame_Update", "CommunitiesFrame_UpdateCommunities",
            "CalendarFrame_Update", "CollectionsJournal_Update", "MountJournal_OnShow",
            "PetJournal_UpdatePetList", "ToyBox_UpdatePages", "HeirloomsJournal_Update",
            "WardrobeCollectionFrame_UpdateItems",
        }) do
            if type(_G[name]) == "function" and not hooked[name] then
                local ok = pcall(hooksecurefunc, name, scheduleRefresh)
                if ok then hooked[name] = true end
            end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
    "GUILD_ROSTER_UPDATE", "GUILD_MOTD", "GUILD_RANKS_UPDATE",
    "CLUB_ADDED", "CLUB_REMOVED", "CLUB_UPDATED", "CLUB_MEMBER_UPDATED",
    "CALENDAR_UPDATE_EVENT_LIST", "CALENDAR_UPDATE_EVENT", "COMPANION_UPDATE",
    "CLUB_FINDER_RECRUITMENT_POST_RETURNED", "CLUB_FINDER_POST_UPDATED",
    "NEW_MOUNT_ADDED", "NEW_PET_ADDED", "NEW_TOY_ADDED",
    "NEW_HEIRLOOM_ADDED", "TRANSMOG_COLLECTION_UPDATED",
}) do
    pcall(events.RegisterEvent, events, event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then rebuildTranslations() end
    installHooks()
    scheduleRefresh()
end)

rebuildTranslations()
installHooks()
scheduleRefresh()
