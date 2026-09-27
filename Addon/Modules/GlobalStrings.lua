local addonName, ns = ...

-- GlobalStrings.db2 rows have stable tags in the installed beta. Update only
-- a client global whose current value is the exact English source for that
-- tag; later Blizzard panels can then use the Italian value directly.
local function apply()
    if not ns.enabled() or
       (type(InCombatLockdown) == "function" and InCombatLockdown()) then return end
    for tag, record in pairs(ns.data.globalStrings or {}) do
        if type(tag) == "string" and tag:match("^[A-Z][A-Za-z0-9_]*$") and
           type(record) == "table" and ns.safeText(record.en) and
           ns.safeText(record.it) then
            local current = rawget(_G, tag)
            if type(issecretvalue) ~= "function" or not issecretvalue(current) then
                if current == record.en or
                   (ns.safeText(record.badIt) and current == record.badIt) then
                    rawset(_G, tag, record.it)
                end
            end
        end
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event, loadedName)
    if event ~= "ADDON_LOADED" or loadedName == addonName or
       type(loadedName) == "string" and loadedName:match("^Blizzard_") then
        apply()
    end
end)
