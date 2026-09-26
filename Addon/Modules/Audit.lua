local _, ns = ...

-- Opt-in, local-only diagnostics for the exact Forever client build.
-- Never send captured text from the addon. Contributors choose what to share.
local roots = {
    "CharacterFrame", "PaperDollFrame", "ReputationFrame", "SkillFrame",
    "TokenFrame", "CurrencyFrame", "GuildFrame", "CommunitiesFrame",
    "CollectionsJournal", "SettingsPanel", "GameMenuFrame",
    "QuestFrame", "QuestMapFrame", "ProfessionsFrame",
}

local function available()
    return type(WFI_DB) == "table" and
        not (type(InCombatLockdown) == "function" and InCombatLockdown())
end

local function auditBucket(name)
    WFI_DB.audit = type(WFI_DB.audit) == "table" and WFI_DB.audit or {}
    WFI_DB.audit[name] = type(WFI_DB.audit[name]) == "table" and WFI_DB.audit[name] or {}
    return WFI_DB.audit[name]
end

function ns.auditGlobals()
    if not available() then return 0 end
    local bucket = auditBucket("globals")
    local added = 0
    for key, value in pairs(_G) do
        if type(key) == "string" and key:match("^[A-Z][A-Z0-9_]+$") and
           not (type(issecretvalue) == "function" and issecretvalue(value)) and
           type(value) == "string" and value ~= "" and #value <= 1200 then
            if bucket[key] ~= value then
                bucket[key] = value
                added = added + 1
            end
        end
    end
    return added
end

local function collect(frame, bucket, budget)
    if not frame or budget <= 0 then return budget end
    if type(frame.IsShown) == "function" and not frame:IsShown() then return budget end
    budget = budget - 1
    if type(frame.GetRegions) == "function" then
        local regions = { frame:GetRegions() }
        for i = 1, #regions do
            local region = regions[i]
            if region and type(region.GetObjectType) == "function" and
               region:GetObjectType() == "FontString" and type(region.GetText) == "function" then
                local value = ns.safeText(region:GetText())
                if value and #value <= 1200 then bucket[value] = true end
            end
        end
    end
    if type(frame.GetChildren) == "function" then
        local children = { frame:GetChildren() }
        for i = 1, #children do
            budget = collect(children[i], bucket, budget)
            if budget <= 0 then break end
        end
    end
    return budget
end

function ns.auditVisible()
    if not available() then return 0 end
    local bucket = auditBucket("visible")
    local before = 0
    for _ in pairs(bucket) do before = before + 1 end
    for i = 1, #roots do
        local frame = _G[roots[i]]
        if frame then pcall(collect, frame, bucket, 4000) end
    end
    local after = 0
    for _ in pairs(bucket) do after = after + 1 end
    return after - before
end
