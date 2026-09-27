"""Exercise verified NPC tooltip lookup, including the beta's unknown name."""

from pathlib import Path

from lupa import LuaRuntime


addon = Path(__file__).resolve().parents[1] / "Addon"
lua = LuaRuntime(unpack_returned_tuples=True)
ns = lua.table()
lua.execute(
    """
    WFI_DB = {}
    issecretvalue = function() return false end
    InCombatLockdown = function() return false end
    CreateFrame = function()
        frame = { RegisterEvent = function() end,
                  UnregisterEvent = function() end,
                  SetScript = function(self, _, callback) self.OnEvent = callback end }
        return frame
    end
    Enum = { TooltipDataType = { Unit = 3 } }
    TooltipDataProcessor = {
        AddTooltipPostCall = function(_, callback) unitCallback = callback end,
    }
    guid = "Creature-0-4615-0-2132-1502-0001384F4F"
    unitName = "Sconosciuto"
    UnitGUID = function(unit) return unit == "mouseover" and guid or nil end
    UnitName = function(unit) return unit == "mouseover" and unitName or nil end
    GameTooltipTextLeft1 = {
        value = "Sconosciuto",
        GetText = function(self) return self.value end,
        SetText = function(self, value) self.value = value end,
        IsProtected = function() return false end,
    }
    GameTooltip = {
        GetName = function() return "GameTooltip" end,
        GetUnit = function() return unitName, "mouseover" end,
    }
    """
)
for name in ("Core.lua", "Data/VerifiedNPCs.lua", "Modules/NPCs.lua"):
    lua.execute((addon / name).read_text(encoding="utf-8"), "WOWForverItaliano", ns)
lua.execute('frame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')
lua.execute(
    """
    -- The post-call has no usable data.id; the displayed GUID is authoritative.
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft1.value == "Zombi miserabile")

    -- Exact verified English text is also accepted for that GUID.
    GameTooltipTextLeft1.value = "Wretched Zombie"
    unitName = "Wretched Zombie"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft1.value == "Zombi miserabile")

    -- A different creature, conflicting tooltip ID, or unrelated source
    -- cannot borrow this translation.
    GameTooltipTextLeft1.value = "Sconosciuto"
    unitName = "Sconosciuto"
    guid = "Creature-0-4615-0-2132-9999-0001384F4F"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft1.value == "Sconosciuto")
    guid = "Creature-0-4615-0-2132-1502-0001384F4F"
    unitCallback(GameTooltip, { id = 1501 })
    assert(GameTooltipTextLeft1.value == "Sconosciuto")
    GameTooltipTextLeft1.value = "Other"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft1.value == "Other")
    GameTooltipTextLeft1.value = "Wretched Zombie"
    unitName = "Other"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft1.value == "Wretched Zombie")
    unitName = "Sconosciuto"

    -- A numeric ID alone never authorizes the generic unknown placeholder.
    GameTooltip.GetUnit = nil
    GameTooltipTextLeft1.value = "Sconosciuto"
    unitCallback(GameTooltip, { id = 1502 })
    assert(GameTooltipTextLeft1.value == "Sconosciuto")
    GameTooltipTextLeft1.value = "Wretched Zombie"
    unitCallback(GameTooltip, { id = 1502 })
    assert(GameTooltipTextLeft1.value == "Zombi miserabile")
    """
)
print("NPC tooltip checks passed")
