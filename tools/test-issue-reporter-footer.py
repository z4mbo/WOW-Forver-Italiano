"""Regression check for Forever beta's GameTooltip Issue Reporter footer."""

from pathlib import Path

from lupa import LuaRuntime


ADDON = Path(__file__).resolve().parent.parent / "Addon"
lua = LuaRuntime(unpack_returned_tuples=True)
namespace = lua.table()
lua.globals().NAMESPACE = namespace
lua.execute(
    """
    WFI_DB = {}
    issecretvalue = function() return false end
    InCombatLockdown = function() return false end
    CreateFrame = function()
        local frame = {
            RegisterEvent = function() end,
            SetScript = function(self, script, callback) self[script] = callback end,
        }
        watcherFrame = frame
        return frame
    end
    C_Timer = { After = function(_, callback) callback() end }
    Enum = { TooltipDataType = { Spell = 2, Unit = 3, SpellBookItem = 4 } }
    TooltipDataProcessor = {
        AddTooltipPostCall = function(kind, callback)
            if kind == 2 then spellCallback = callback end
            if kind == 3 then unitCallback = callback end
            if kind == 4 then spellBookItemCallback = callback end
        end,
    }
    hooksecurefunc = function(target, method, callback)
        local original = target[method]
        target[method] = function(self, ...)
            original(self, ...)
            callback(self, ...)
        end
    end
    local function textRegion(value)
        return {
            text = value, color = "blue",
            GetText = function(self) return self.text end,
            SetText = function(self, text) self.text = text end,
            IsProtected = function() return false end,
        }
    end
    newTextRegion = textRegion
    lineCount = 3
    GameTooltipTextLeft1 = textRegion("Cannibalism")
    GameTooltipTextLeft2 = textRegion("Press F6 to submit an issue for this Spell")
    GameTooltipTextLeft3 = textRegion("An unrelated Press F6 line")
    GameTooltip = {
        IsShown = function() return true end,
        NumLines = function() return lineCount end,
        GetOwner = function() return nil end,
        HookScript = function(self, script, callback)
            if script == "OnUpdate" then error("tooltip OnUpdate unavailable") end
            self[script] = callback
        end,
        SetText = function() end,
        AddLine = function(_, text) GameTooltipTextLeft2.text = text end,
        AddDoubleLine = function() end,
    }
    """
)
for entry in ("Core.lua", "Data/SpellbookUI.lua", "Modules/UITooltips.lua"):
    lua.execute((ADDON / entry).read_text(encoding="utf-8"), "WOWForverItaliano", namespace)

lua.execute(
    """
    spellCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Spell"])
    assert(GameTooltipTextLeft2.color == "blue")
    assert(GameTooltipTextLeft1.text == "Cannibalism")
    assert(GameTooltipTextLeft3.text == "An unrelated Press F6 line")

    GameTooltipTextLeft2.text = ""
    spellBookItemCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "") -- The reporter has not added its line yet.
    GameTooltip:AddLine("Press F6 to submit an issue for this Spell")
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Spell"])
    GameTooltipTextLeft2.text = "Press F6 to submit an issue for this Spell"
    spellBookItemCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Spell"])

    GameTooltipTextLeft2.text = "Press F6 to submit an issue for this Creature"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Creature"])
    assert(GameTooltipTextLeft2.color == "blue")

    -- The beta reporter may set the existing line after post-call and OnShow.
    GameTooltipTextLeft2:SetText("Press F6 to submit an issue for this Creature")
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Creature"])

    -- Also recover a direct late write which bypasses tooltip methods/hooks.
    GameTooltipTextLeft2.text = "Press F6 to submit an issue for this Creature"
    watcherFrame:OnUpdate(0.11)
    assert(GameTooltipTextLeft2.text == NAMESPACE.data.ui["Press F6 to submit an issue for this Creature"])

    -- The live footer includes an invisible ten-byte WoW color prefix.
    GameTooltipTextLeft7 = newTextRegion("|cff00aaffPress F6 to submit an issue for this Creature")
    lineCount = 7
    watcherFrame:OnUpdate(0.11)
    assert(GameTooltipTextLeft7.text == "|cff00aaff" ..
        NAMESPACE.data.ui["Press F6 to submit an issue for this Creature"])

    GameTooltipTextLeft7:SetText("|cFF00AAFFPress F6 to submit an issue for this Spell|r")
    assert(GameTooltipTextLeft7.text == "|cFF00AAFF" ..
        NAMESPACE.data.ui["Press F6 to submit an issue for this Spell"] .. "|r")
    GameTooltipTextLeft7:SetText("|cff00aaffPress F6 to submit an issue for this Unknown")
    assert(GameTooltipTextLeft7.text == "|cff00aaffPress F6 to submit an issue for this Unknown")

    WFI_DB.enabled = false
    GameTooltipTextLeft2.text = "Press F6 to submit an issue for this Creature"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "Press F6 to submit an issue for this Creature")
    """
)

print("Issue Reporter footer exact-match checks passed")
