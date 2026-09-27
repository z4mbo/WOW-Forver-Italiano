"""Exact-source quest association on Forever's Wretched Zombie tooltip."""

from pathlib import Path

from lupa import LuaRuntime


ADDON = Path(__file__).resolve().parents[1] / "Addon"
lua = LuaRuntime(unpack_returned_tuples=True)
ns = lua.table()
lua.globals().NAMESPACE = ns
lua.execute(
    """
    WFI_DB = {}
    issecretvalue = function() return false end
    InCombatLockdown = function() return false end
    CreateFrame = function()
        return { RegisterEvent = function() end, SetScript = function() end }
    end
    Enum = { TooltipDataType = { Unit = 3 } }
    TooltipDataProcessor = {
        AddTooltipPostCall = function(_, callback) unitCallback = callback end,
    }
    local function line(value)
        return {
            text = value,
            GetText = function(self) return self.text end,
            SetText = function(self, value) self.text = value end,
            IsProtected = function() return false end,
        }
    end
    GameTooltipTextLeft1 = line("Wretched Zombie")
    GameTooltipTextLeft2 = line("The Mindless Ones")
    GameTooltipTextLeft3 = line("Player")
    GameTooltipTextLeft4 = line("8/8 (null)")
    GameTooltipTextLeft5 = line("Unrelated")
    guid = "Creature-0-4615-0-2132-1502-0001384F4F"
    UnitGUID = function(unit) return unit == "mouseover" and guid or nil end
    GameTooltip = {
        shown = true,
        IsShown = function(self) return self.shown end,
        GetUnit = function() return "Wretched Zombie", "mouseover" end,
        NumLines = function() return 5 end,
        HookScript = function(self, script, callback) self[script] = callback end,
    }
    objective = { finished = true, numFulfilled = 8,
                  numRequired = 8, text = "8/8 (null)" }
    C_QuestLog = {
        GetQuestObjectives = function(id)
            if id == 364 then return { {}, objective } end
        end,
    }
    function reset()
        GameTooltipTextLeft2.text = "The Mindless Ones"
        GameTooltipTextLeft4.text = "8/8 (null)"
    end
    """
)
for name in (
    "Core.lua",
    "Data/TirisfalTitles.lua",
    "Data/TrackerObjectives.lua",
    "Modules/QuestTooltip.lua",
):
    lua.execute((ADDON / name).read_text(encoding="utf-8"), "WOWForverItaliano", ns)

lua.execute(
    """
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "I senza mente")
    assert(GameTooltipTextLeft4.text == "8/8 Zombi miserabili uccisi")

    reset()
    GameTooltipTextLeft4.text = ""
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "I senza mente")
    GameTooltipTextLeft4.text = "8/8 (null)"
    GameTooltip:OnUpdate(0.11)
    assert(GameTooltipTextLeft4.text == "8/8 Zombi miserabili uccisi")

    reset()
    guid = "Creature-0-4615-0-2132-1501-0001384F4F"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "I senza mente")
    assert(GameTooltipTextLeft4.text == "8/8 (null)")

    reset()
    guid = "Creature-0-4615-0-2132-9999-0001384F4F"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "The Mindless Ones")
    assert(GameTooltipTextLeft4.text == "8/8 (null)")

    reset()
    guid = "Creature-0-4615-0-2132-1502-0001384F4F"
    unitCallback(GameTooltip, { id = 1501 })
    assert(GameTooltipTextLeft2.text == "The Mindless Ones")

    reset()
    GameTooltipTextLeft2.text = "Another Quest"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft4.text == "8/8 (null)")

    reset()
    GameTooltipTextLeft4.text = "Other objective"
    GameTooltipTextLeft5.text = "8/8 (null)"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft5.text == "8/8 (null)")
    GameTooltipTextLeft5.text = "Unrelated"

    reset()
    objective.finished = false
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft4.text == "8/8 (null)")
    objective.finished = true

    reset()
    objective.text = "8/8 Some other objective"
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft4.text == "8/8 (null)")
    objective.text = "8/8 (null)"

    reset()
    WFI_DB.enabled = false
    unitCallback(GameTooltip, {})
    assert(GameTooltipTextLeft2.text == "The Mindless Ones")
    assert(GameTooltipTextLeft4.text == "8/8 (null)")
    """
)
print("Quest tooltip exact-match checks passed")
