local addonName, ns = ...

-- Forever beta 1.60.1.70009 has an empty itIT SpellName for Attack (6603).
-- The client PlayerSpellsFrame copies that name into SpellBookItemMixin.Name.
local ATTACK_ID = 6603
local hookedVisuals, hookedTooltip, hookedShow = false, false, false
local hookedTooltipTypes = {}

local function isSecret(value)
    return type(issecretvalue) == "function" and issecretvalue(value)
end

local function attackName()
    return ns.data.ui and ns.safeText(ns.data.ui.Attack)
end

local function playerBook()
    local playerSpells = _G.PlayerSpellsFrame
    local book = playerSpells and playerSpells.SpellBookFrame
    if not book or type(book.IsShown) ~= "function" or not book:IsShown() then return nil end
    return book
end

local function belongsToBook(frame, book)
    for _ = 1, 12 do
        if frame == book then return true end
        if not frame or type(frame.GetParent) ~= "function" then break end
        frame = frame:GetParent()
    end
    return false
end

local function verifiedAttackItem(item)
    if not ns.enabled() or not item or not C_SpellBook or
       type(C_SpellBook.GetSpellBookItemInfo) ~= "function" then return false end
    local book = playerBook()
    if not book or not belongsToBook(item, book) then return false end
    local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
    local slot = item.slotIndex
    if bank == nil or isSecret(slot) or type(slot) ~= "number" or
       isSecret(item.spellBank) or item.spellBank ~= bank then return false end
    local ok, info = pcall(C_SpellBook.GetSpellBookItemInfo, slot, bank)
    if not ok or type(info) ~= "table" then return false end
    local id, actionID, sourceName = info.spellID, info.actionID, info.name
    if isSecret(id) or isSecret(actionID) or isSecret(sourceName) then return false end
    return id == ATTACK_ID and actionID == ATTACK_ID and sourceName == ""
end

local function repairLabel(item)
    if not verifiedAttackItem(item) then return end
    local label = item.Name
    if not label or type(label.GetText) ~= "function" then return end
    local current = label:GetText()
    if isSecret(current) or (current ~= "" and current ~= nil) then return end
    local translated = attackName()
    if translated and ns.translateFontString(label, translated) and
       type(item.UpdateTextContainer) == "function" then
        item:UpdateTextContainer()
    end
end

local function repairVisibleLabels()
    local book = playerBook()
    if not book or type(book.ForEachDisplayedSpell) ~= "function" then return end
    book:ForEachDisplayedSpell(repairLabel)
end

local function repairTooltip(allowHidden)
    local tooltip = _G.GameTooltip
    if not tooltip or (not allowHidden and
       (type(tooltip.IsShown) ~= "function" or not tooltip:IsShown())) or
       type(tooltip.GetOwner) ~= "function" then return end
    local owner = tooltip:GetOwner()
    local item = owner and type(owner.GetParent) == "function" and owner:GetParent()
    if not item or item.Button ~= owner or not verifiedAttackItem(item) then return end
    local title = _G.GameTooltipTextLeft1
    if not title or type(title.GetText) ~= "function" then return end
    local current = title:GetText()
    if isSecret(current) or (type(current) == "string" and
       current:match("%S")) then return end
    local translated = attackName()
    if translated then ns.translateFontString(title, translated) end
end

local function installHooks()
    local mixin = _G.SpellBookItemMixin
    if type(hooksecurefunc) == "function" and type(mixin) == "table" then
        if not hookedVisuals and type(mixin.UpdateVisuals) == "function" then
            local ok = pcall(hooksecurefunc, mixin, "UpdateVisuals", repairLabel)
            if ok then hookedVisuals = true end
        end
        if not hookedTooltip and type(mixin.ShowSpellBookTooltip) == "function" then
            local ok = pcall(hooksecurefunc, mixin, "ShowSpellBookTooltip", function()
                repairTooltip()
                if C_Timer and type(C_Timer.After) == "function" then
                    C_Timer.After(0, repairTooltip)
                end
            end)
            if ok then hookedTooltip = true end
        end
    end
    if TooltipDataProcessor and Enum and Enum.TooltipDataType and
       type(TooltipDataProcessor.AddTooltipPostCall) == "function" then
        for _, kind in ipairs({ "Spell", "SpellBookItem" }) do
            local dataType = Enum.TooltipDataType[kind]
            if dataType and not hookedTooltipTypes[kind] then
                local ok = pcall(TooltipDataProcessor.AddTooltipPostCall, dataType,
                    function(tooltip, data)
                        if tooltip ~= _G.GameTooltip or type(data) ~= "table" then return end
                        local id = data.id
                        if isSecret(id) or (type(id) == "number" and id ~= ATTACK_ID) then return end
                        repairTooltip(true)
                    end)
                if ok then hookedTooltipTypes[kind] = true end
            end
        end
    end
    local book = _G.PlayerSpellsFrame and _G.PlayerSpellsFrame.SpellBookFrame
    if not hookedShow and book and type(book.HookScript) == "function" then
        local ok = pcall(book.HookScript, book, "OnShow", function()
            if C_Timer and type(C_Timer.After) == "function" then
                C_Timer.After(0, repairVisibleLabels)
            else
                repairVisibleLabels()
            end
        end)
        if ok then hookedShow = true end
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("SPELLS_CHANGED")
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName ~= addonName and
       loadedName ~= "Blizzard_PlayerSpells" then return end
    installHooks()
    if event ~= "ADDON_LOADED" then repairVisibleLabels() end
end)

installHooks()
