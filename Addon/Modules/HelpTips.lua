local addonName, ns = ...

-- Blizzard's HelpTip manager owns a frame pool of the tutorial bubbles. Hook
-- that API and inspect only its active frames; walking named globals misses
-- pooled, unnamed HelpTip frames and could otherwise encourage broad UI scans.
local MAX_NODES_PER_TIP = 32
local translations = {}
local hooked = false

local function indexTranslations()
    translations = {}
    for _, sourceTable in ipairs({ ns.data.helpTips or {}, ns.data.ui or {} }) do
        for source, target in pairs(sourceTable) do
            if ns.safeText(source) and ns.safeText(target) then
                translations[source] = target
            end
        end
    end
end

local function translateRegion(region)
    if not region or type(region.GetObjectType) ~= "function" or
       region:GetObjectType() ~= "FontString" or type(region.GetText) ~= "function" then
        return
    end
    if type(region.IsShown) == "function" and not region:IsShown() then return end

    local source = ns.safeText(region:GetText())
    if not source then return end
    local plain = source:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    local target = translations[plain]
    if target then ns.translateFontString(region, target) end
end

local function scanTip(frame, remaining, seen)
    if not frame or remaining <= 0 or seen[frame] then return remaining end
    seen[frame] = true
    if type(frame.IsShown) == "function" and not frame:IsShown() then return remaining end
    remaining = remaining - 1

    if type(frame.GetRegions) == "function" then
        local ok, regions = pcall(function() return { frame:GetRegions() } end)
        if ok then
            for i = 1, #regions do
                local success = pcall(translateRegion, regions[i])
                if not success then
                    -- A bad/refusing Blizzard region must not stop its siblings.
                end
            end
        end
    end
    if remaining > 0 and type(frame.GetChildren) == "function" then
        local ok, children = pcall(function() return { frame:GetChildren() } end)
        if ok then
            for i = 1, #children do
                remaining = scanTip(children[i], remaining, seen)
                if remaining <= 0 then break end
            end
        end
    end
    return remaining
end

local function translateActiveTips()
    if not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    local manager = HelpTip
    local pool = manager and manager.framePool
    if not pool or type(pool.EnumerateActive) ~= "function" then return end

    -- Pool enumeration and frame access are guarded because client UI objects
    -- can refuse insecure reads in some states. Only active Blizzard tips are
    -- ever traversed, with a small per-tip node budget.
    pcall(function()
        for tip in pool:EnumerateActive() do
            scanTip(tip, MAX_NODES_PER_TIP, setmetatable({}, { __mode = "k" }))
        end
    end)
end

local function installHook()
    if hooked or not (HelpTip and type(HelpTip.Show) == "function") or
       type(hooksecurefunc) ~= "function" then return end
    local ok = pcall(hooksecurefunc, HelpTip, "Show", translateActiveTips)
    if ok then hooked = true end
end

local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_ENABLED",
}) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName ~= addonName and hooked then return end
    installHook()
    translateActiveTips()
end)

indexTranslations()
installHook()
translateActiveTips()
