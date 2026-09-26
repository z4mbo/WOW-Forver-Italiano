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
    UnitName = function() return "Tester" end
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
        AddTooltipPostCall = function(_, callback) itemCallback = callback end,
    }
    Enum = { TooltipDataType = { Item = 1 } }
    hooksecurefunc = function(name, callback) hooks[name] = callback end
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
    QuestInfoTitleHeader = makeText("A New Plague")
    QuestInfoDescriptionText = makeText("English NPC quest description")
    QuestInfoRewardText = makeText("Good work, <name>.")
    QuestProgressTitleText = makeText("A New Plague")
    QuestProgressText = makeText("Have you gathered the blood, <name>?")
    QuestLogQuestCount = makeText("|cffffd100Quests: |r|cffffffff4/40|r")
    TestTooltipTextLeft1 = makeText("Hearthstone")
    testTooltip = { GetName = function() return "TestTooltip" end }
    """
)

for raw in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8").splitlines():
    entry = raw.strip()
    if entry.endswith(".lua"):
        lua.execute((ADDON / entry.replace("\\", "/")).read_text(encoding="utf-8"), "WOWForverItaliano", ns)

lua.execute(
    """
    for _, frame in ipairs(frames) do
        if frame.OnEvent then frame:OnEvent("ADDON_LOADED", "WOWForverItaliano") end
    end
    assert(NS.enabled())
    assert(NS.data.items[6948].name == "Pietra del Ritorno")
    assert(QuestLogQuestCount.text == "Missioni: 4/40")
    hooks.QuestInfo_ShowTitle()
    assert(QuestInfoTitleHeader.text == NS.data.quests[367].title)
    hooks.QuestInfo_ShowRewardText()
    assert(not QuestInfoRewardText.text:find("<name>", 1, true))
    assert(QuestInfoRewardText.text:find("Tester", 1, true))
    currentQuest = 99999 -- Forever can assign a different ID than Classic.
    QuestInfoTitleHeader.text = "Rovistare ad Albamorta"
    hooks.QuestInfo_Display()
    assert(QuestInfoDescriptionText.text == NS.data.quests[3902].description)
    currentQuest = 367 -- A reused beta ID must not apply old dialogue.
    QuestInfoTitleHeader.text = "Unknown Forever Quest"
    QuestInfoDescriptionText.text = "New beta dialogue"
    hooks.QuestInfo_Display()
    assert(QuestInfoDescriptionText.text == "New beta dialogue")
    itemCallback(testTooltip, { id = 6948 })
    assert(TestTooltipTextLeft1.text == "Pietra del Ritorno")
    local rendered = NS.renderText("Ciao <name>, <class> <race>!")
    assert(rendered == "Ciao Tester, Guerriero Non Morto!")
    assert(NS.renderText("Prima frase.$b$bSeconda frase.") == "Prima frase.\\n\\nSeconda frase.")
    WFI_DB.enabled = false
    assert(not NS.enabled())
    """
)

print("Mocked quest, item, colored UI, token, and enable/disable smoke checks passed")
