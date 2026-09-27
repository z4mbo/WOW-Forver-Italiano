"""Check exact-GUID nameplate translation and recycled-plate safety."""

from pathlib import Path

from lupa import LuaRuntime


addon = Path(__file__).resolve().parents[1] / "Addon"
lua = LuaRuntime(unpack_returned_tuples=True)
ns = lua.table()
lua.execute(
    """
    WFI_DB = {}
    issecretvalue = function() return false end
    combat = false
    InCombatLockdown = function() return combat end
    local frame
    CreateFrame = function()
        frame = {
            RegisterEvent = function() end,
            UnregisterEvent = function() end,
            SetScript = function(self, _, callback) self.OnEvent = callback end,
        }
        return frame
    end
    function fire(event, unit) frame:OnEvent(event, unit) end
    hooksecurefunc = function(region, method, callback)
        local original = region[method]
        region[method] = function(self, value)
            original(self, value)
            callback(self, value)
        end
    end
    function text(value)
        return {
            value = value,
            width = 100,
            points = 1,
            GetObjectType = function() return "FontString" end,
            GetText = function(self) return self.value end,
            SetText = function(self, value) self.value = value end,
            GetNumPoints = function(self) return self.points end,
            GetPoint = function() return "BOTTOM" end,
            GetWidth = function(self) return self.width end,
            SetWidth = function(self, width) self.width = width end,
            GetUnboundedStringWidth = function(self) return #self.value * 8 end,
            IsProtected = function() return false end,
        }
    end
    local name = text("Sconosciuto")
    local plate = { UnitFrame = { name = name } }
    C_NamePlate = {
        GetNamePlateForUnit = function(unit)
            if unit == "nameplate1" then return plate end
        end,
    }
    guid = "Creature-0-4615-0-2132-1502-0001384F4F"
    source = "Sconosciuto"
    UnitGUID = function() return guid end
    UnitName = function() return source end
    plateName = name
    """
)
for path in (addon / "Core.lua", addon / "Data" / "VerifiedNPCs.lua", addon / "Modules" / "NPCs.lua"):
    lua.execute(path.read_text(encoding="utf-8"), "WOWForverItaliano", ns)
lua.execute(
    """
    fire("ADDON_LOADED", "WOWForverItaliano")
    fire("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert(plateName.value == "Zombi miserabile")
    assert(plateName.width == 132)

    -- Blizzard redraws the same plate for a different creature.
    guid = "Creature-0-4615-0-2132-9999-0001384F4F"
    plateName:SetText("Sconosciuto")
    assert(plateName.value == "Sconosciuto")
    assert(plateName.width == 100)

    -- Another verified ID receives its own translation.
    guid = "Creature-0-4615-0-2132-1501-0001384F4F"
    plateName:SetText("Sconosciuto")
    assert(plateName.value == "Zombi senza mente")
    assert(plateName.width == 140)

    -- An unverified source name cannot use the GUID alone.
    source = "Unrelated"
    plateName:SetText("Unrelated")
    assert(plateName.value == "Unrelated")
    assert(plateName.width == 100)
    source = "Sconosciuto"

    -- Combat and removal both stop writes; after combat it can recover.
    combat = true
    plateName:SetText("Sconosciuto")
    assert(plateName.value == "Sconosciuto")
    combat = false
    fire("PLAYER_REGEN_ENABLED")
    assert(plateName.value == "Zombi senza mente")
    assert(plateName.width == 140)
    fire("NAME_PLATE_UNIT_REMOVED", "nameplate1")
    assert(plateName.width == 100)
    plateName:SetText("Sconosciuto")
    assert(plateName.value == "Sconosciuto")

    -- A two-anchor layout may reserve part of the row for health.
    plateName.points = 2
    fire("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert(plateName.value == "Zombi senza mente")
    assert(plateName.width == 100)

    -- The classic plate addon starts with width zero. The translated text
    -- receives a measured width and the zero is restored on recycling.
    fire("NAME_PLATE_UNIT_REMOVED", "nameplate1")
    plateName.points = 1
    plateName.width = 0
    plateName:SetText("Sconosciuto")
    fire("NAME_PLATE_UNIT_ADDED", "nameplate1")
    assert(plateName.width == 140)
    fire("NAME_PLATE_UNIT_REMOVED", "nameplate1")
    assert(plateName.width == 0)
    """
)
print("NPC nameplate checks passed")
