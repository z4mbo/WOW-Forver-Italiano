local addonName, ns = ...

-- Follow first-party social/collection redraws that can occur after the
-- existing general UI pass, especially wardrobe side-tab changes.
local roots = {
    "GuildFrame", "CommunitiesFrame", "FriendsFrame", "PVEFrame",
    "LFGParentFrame", "CollectionsJournal", "MountJournal", "PetJournal",
    "ToyBox", "HeirloomJournal", "WardrobeCollectionFrame", "WardrobeFrame",
}
local hooked = {}
local buttonHooks = setmetatable({}, { __mode = "k" })
local scheduled = false
local translations = {}
local scheduleRefresh

local function rebuildTranslations()
    translations = {}
    for _, sourceTable in ipairs({ ns.data.ui or {}, ns.data.guildCollections or {} }) do
        for source, target in pairs(sourceTable) do
            if ns.safeText(source) and ns.safeText(target) then
                translations[source] = target
            end
        end
    end
end

local function safeMethod(object, method)
    if not object or type(object[method]) ~= "function" then return nil end
    local ok, result = pcall(object[method], object)
    if ok then return result end
end

local function translateRegion(region, collectionContext)
    if safeMethod(region, "GetObjectType") ~= "FontString" then return end
    local source = ns.safeText(safeMethod(region, "GetText"))
    if not source then return end
    local target = translations[source]
    -- Blizzard's page counter is formatted at runtime from the exact audited
    -- global "Page %d / %d". Keep both client-provided numbers intact.
    if not target and collectionContext then
        local current, total = source:match("^Page (%d+) / (%d+)$")
        if current and total then target = "Pagina " .. current .. " / " .. total end
    end
    if target then ns.translateFontString(region, target) end
end

local function scan(frame, budget, collectionContext)
    if not frame or budget <= 0 or safeMethod(frame, "IsShown") == false then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local ok, regions = pcall(function() return { frame:GetRegions() } end)
        if ok then
            for i = 1, #regions do translateRegion(regions[i], collectionContext) end
        end
    end
    if type(frame.GetChildren) == "function" then
        local ok, children = pcall(function() return { frame:GetChildren() } end)
        if ok then
            for i = 1, #children do
                local child = children[i]
                if child and not buttonHooks[child] and type(child.HookScript) == "function" then
                    local kind = safeMethod(child, "GetObjectType")
                    if (kind == "Button" or kind == "CheckButton") and
                       not (type(InCombatLockdown) == "function" and InCombatLockdown()) then
                        local success = pcall(child.HookScript, child, "OnClick", function()
                            scheduleRefresh()
                        end)
                        if success then buttonHooks[child] = true end
                    end
                end
                budget = scan(child, budget, collectionContext)
                if budget <= 0 then break end
            end
        end
    end
    return budget
end

local function refresh()
    scheduled = false
    if not ns.enabled() or (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    for i = 1, #roots do
        local name = roots[i]
        local root = _G[name]
        local inCollections = name == "CollectionsJournal" or name == "MountJournal" or
            name == "PetJournal" or name == "ToyBox" or name == "HeirloomJournal" or
            name == "WardrobeCollectionFrame" or name == "WardrobeFrame"
        if root then scan(root, 1800, inCollections) end
    end
end

scheduleRefresh = function()
    if scheduled then return end
    scheduled = true
    if C_Timer and type(C_Timer.After) == "function" then
        C_Timer.After(0.1, refresh)
        C_Timer.After(0.6, refresh)
        C_Timer.After(1.25, refresh)
        C_Timer.After(2.0, refresh)
    else
        refresh()
    end
end

local function installHooks()
    for i = 1, #roots do
        local name = roots[i]
        local root = _G[name]
        if root and not hooked[name] and type(root.HookScript) == "function" then
            local ok = pcall(root.HookScript, root, "OnShow", scheduleRefresh)
            if ok then hooked[name] = true end
        end
    end
    if type(hooksecurefunc) ~= "function" then return end
    for _, name in ipairs({
        "GuildRoster_Update", "GuildInfoFrame_Update", "GuildNewsFrame_Update",
        "CommunitiesFrame_Update", "CommunitiesFrame_UpdateCommunities",
        "CollectionsJournal_Update", "MountJournal_OnShow", "PetJournal_UpdatePetList",
        "ToyBox_UpdatePages", "HeirloomsJournal_Update", "WardrobeCollectionFrame_UpdateItems",
    }) do
        if type(_G[name]) == "function" and not hooked[name] then
            local ok = pcall(hooksecurefunc, name, scheduleRefresh)
            if ok then hooked[name] = true end
        end
    end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
    "GUILD_ROSTER_UPDATE", "GUILD_MOTD", "GUILD_RANKS_UPDATE",
    "CLUB_ADDED", "CLUB_REMOVED", "CLUB_UPDATED", "CLUB_MEMBER_UPDATED",
    "NEW_MOUNT_ADDED", "NEW_PET_ADDED", "NEW_TOY_ADDED", "NEW_HEIRLOOM_ADDED",
    "TRANSMOG_COLLECTION_UPDATED",
}) do pcall(events.RegisterEvent, events, event) end

events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then rebuildTranslations() end
    installHooks()
    scheduleRefresh()
end)

rebuildTranslations()
installHooks()
scheduleRefresh()
