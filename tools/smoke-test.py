"""Exercise the addon against a small mocked Forever UI without launching WoW."""

from pathlib import Path

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parent.parent
ADDON = ROOT / "Addon"
lua = LuaRuntime(unpack_returned_tuples=True)
ns = lua.table()
lua.globals().NS = ns

lua.execute(
    """
    WFI_DB = {}
    SlashCmdList = {}
    frames = {}
    hooks = {}
    currentQuest = 367
    issecretvalue = function() return false end
    InCombatLockdown = function() return false end
    targetUnitName = "Sconosciuto"
    targetGUID = "Creature-0-4615-0-2132-1502-0001384F4F"
    UnitName = function(unit)
        if unit == "target" then return targetUnitName end
        return "Tester"
    end
    UnitGUID = function(unit)
        if unit == "target" then return targetGUID end
    end
    UnitClass = function() return "Warrior", "WARRIOR" end
    UnitRace = function() return "Undead", "Scourge" end
    GetQuestID = function() return currentQuest end
    CreateFrame = function()
        local frame = {
            RegisterEvent = function() end,
            UnregisterEvent = function() end,
            SetScript = function(self, name, callback) self[name] = callback end,
        }
        frames[#frames + 1] = frame
        return frame
    end
    C_Timer = { After = function(_, callback) callback() end }
    TooltipDataProcessor = {
        AddTooltipPostCall = function(kind, callback)
            if kind == 1 then itemCallback = callback end
            if kind == 2 then spellCallback = callback end
        end,
    }
    Enum = { TooltipDataType = { Item = 1, Spell = 2 } }
    hooksecurefunc = function(target, methodOrCallback, callback)
        if type(target) == "table" then
            local original = target[methodOrCallback]
            if type(original) ~= "function" then error("missing method") end
            target[methodOrCallback] = function(self, ...)
                local results = { original(self, ...) }
                callback(self, ...)
                return table.unpack(results)
            end
        else
            hooks[target] = methodOrCallback
        end
    end
    QuestInfo_ShowTitle = function() end
    QuestInfo_ShowDescriptionText = function() end
    QuestInfo_ShowObjectivesText = function() end
    QuestInfo_ShowRewardText = function() end
    QuestInfo_Display = function() end
    QuestFrameProgressPanel_OnShow = function() end
    QuestInfoFrame = { questLog = false }
    makeText = function(initial)
        return {
            text = initial,
            GetText = function(self) return self.text end,
            SetText = function(self, value) self.text = value end,
            IsProtected = function() return false end,
            GetObjectType = function() return "FontString" end,
        }
    end
    TargetFrame = { name = makeText("Sconosciuto"), TargetFrameContent = { TargetFrameContentMain = {} } }
    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name = TargetFrame.name
    QuestInfoTitleHeader = makeText("A New Plague")
    QuestInfoDescriptionText = makeText("English NPC quest description")
    QuestInfoRewardText = makeText("Good work, <name>.")
    QuestProgressTitleText = makeText("A New Plague")
    QuestProgressText = makeText("Have you gathered the blood, <name>?")
    QuestLogQuestCount = makeText("|cffffd100Quests: |r|cffffffff4/40|r")
    SharedLabel = makeText("Shared Label")
    GameMenuFrame = {
        IsShown = function() return true end,
        GetRegions = function() return SharedLabel end,
        GetChildren = function() end,
        HookScript = function() end,
    }
    TestTooltipTextLeft1 = makeText("Hearthstone")
    testTooltip = { GetName = function() return "TestTooltip" end }
    RogueTooltipTextLeft1 = makeText("Sventramento")
    RogueTooltipTextLeft2 = makeText("Finishing move that causes damage per combo point, increased by Attack Power:\\n1 point : 6-10 damage\\n2 points: 11-15 damage\\n3 points: 16-20 damage\\n4 points: 21-25 damage\\n5 points: 26-30 damage")
    rogueTooltip = { GetName = function() return "RogueTooltip" end }
    """
)

for raw in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8").splitlines():
    entry = raw.strip()
    if entry.endswith(".lua"):
        if entry == "Modules\\UI.lua":
            ns.data.spells[19999991] = lua.table(en="Shared Label", name="Primo nome")
            ns.data.spells[19999992] = lua.table(en="Shared Label", name="Secondo nome")
        lua.execute((ADDON / entry.replace("\\", "/")).read_text(encoding="utf-8"), "WOWForverItaliano", ns)

lua.execute(
    """
    for _, frame in ipairs(frames) do
        if frame.OnEvent then frame:OnEvent("ADDON_LOADED", "WOWForverItaliano") end
    end
    assert(NS.enabled())
    assert(NS.data.items[6948].name == "Pietra del Ritorno")
    assert(QuestLogQuestCount.text == "Missioni: 4/40")
    assert(SharedLabel.text == "Shared Label")
    hooks.QuestInfo_ShowTitle()
    assert(QuestInfoTitleHeader.text == NS.data.quests[367].title)
    hooks.QuestInfo_ShowRewardText()
    assert(not QuestInfoRewardText.text:find("<name>", 1, true))
    assert(QuestInfoRewardText.text:find("Tester", 1, true))
    currentQuest = 99999 -- Forever can assign a different ID than Classic.
    QuestInfoTitleHeader.text = "Rovistare ad Albamorta"
    hooks.QuestInfo_Display()
    assert(QuestInfoDescriptionText.text == NS.data.quests[3902].description)
    QuestInfoDescriptionText:SetText("English body returned after a late beta redraw")
    assert(QuestInfoDescriptionText.text == NS.data.quests[3902].description)
    currentQuest = 367 -- A reused beta ID must not apply old dialogue.
    QuestInfoTitleHeader.text = "Unknown Forever Quest"
    QuestInfoDescriptionText.text = "New beta dialogue"
    hooks.QuestInfo_Display()
    assert(QuestInfoDescriptionText.text == "New beta dialogue")
    itemCallback(testTooltip, { id = 6948 })
    assert(TestTooltipTextLeft1.text == "Pietra del Ritorno")
    spellCallback(rogueTooltip, { id = 2098 })
    assert(RogueTooltipTextLeft1.text == "Sventramento")
    assert(RogueTooltipTextLeft2.text:find("Mossa finale che infligge danni", 1, true))
    assert(RogueTooltipTextLeft2.text:find("1 punto: 6-10 danni", 1, true))
    assert(RogueTooltipTextLeft2.text:find("5 punti: 26-30 danni", 1, true))
    assert(not RogueTooltipTextLeft2.text:find("Finishing move", 1, true))
    TargetFrame.name:SetText("Sconosciuto")
    assert(TargetFrame.name.text == "Zombi miserabile")
    targetGUID = "Creature-0-4615-0-2132-1502-00023850B5"
    targetUnitName = "Wretched Zombie"
    TargetFrame.name:SetText("Sconosciuto")
    assert(TargetFrame.name.text == "Sconosciuto")
    targetUnitName = "Sconosciuto"
    targetGUID = "Creature-0-4615-0-2132-1501-0001384F4F"
    TargetFrame.name:SetText("Sconosciuto")
    assert(TargetFrame.name.text == "Zombi senza mente")
    targetGUID = "Creature-0-4615-0-2132-99999-0001384F4F"
    TargetFrame.name:SetText("Sconosciuto")
    assert(TargetFrame.name.text == "Sconosciuto")
    local rendered = NS.renderText("Ciao <name>, <class> <race>!")
    assert(rendered == "Ciao Tester, Guerriero Non Morto!")
    assert(NS.renderText("Prima frase.$b$bSeconda frase.") == "Prima frase.\\n\\nSeconda frase.")
    WFI_DB.enabled = false
    assert(not NS.enabled())
    """
)

print("Mocked quest, item, colored UI, token, and enable/disable smoke checks passed")
