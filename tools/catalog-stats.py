"""Count distinct entries in the addon catalogue from its actual TOC load order."""

from pathlib import Path

from lupa import LuaRuntime


ROOT = Path(__file__).resolve().parent.parent
ADDON = ROOT / "Addon"
TOC = ADDON / "WOWForverItaliano.toc"

lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(
    """
    WFI_DB = {}
    SlashCmdList = {}
    CreateFrame = function()
        return { RegisterEvent = function() end, SetScript = function() end }
    end
    """
)
namespace = lua.table()
for row in TOC.read_text(encoding="utf-8-sig").splitlines():
    name = row.strip()
    if not name or name.startswith("##") or not name.lower().endswith(".lua"):
        continue
    if not name.startswith("Data\\") and name != "Core.lua":
        continue
    lua.execute((ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                "WOWForverItaliano", namespace)


def count(table):
    return sum(1 for _ in table) if table is not None else 0


data = namespace.data
labels = set()
for source in (data["ui"], data["characterPanels"], data["guildCollections"],
               data["settings"], data["helpTips"]):
    if source is not None:
        labels.update(source.keys())

quest_descriptions = sum(1 for _, q in data["quests"].items()
                         if q["description"] is not None)
quest_dialogues = sum(1 for _, q in data["quests"].items()
                      if q["progress"] is not None and q["completion"] is not None)
item_descriptions = sum(1 for _, item in data["items"].items()
                        if item["description"] is not None)
spell_ids_with_descriptions = {
    id for id, entry in data["spells"].items() if entry["description"] is not None
}
spell_ids_with_descriptions.update(data["spellDescriptionOverrides"].keys())

print(f"ui_labels={len(labels)}")
print(f"npc_ids={count(data['npcs'])}")
print(f"quest_ids={count(data['quests'])}")
print(f"quest_descriptions={quest_descriptions}")
print(f"quest_dialogues={quest_dialogues}")
print(f"item_ids={count(data['items'])}")
print(f"item_descriptions={item_descriptions}")
print(f"spell_name_ids={count(data['spells'])}")
print(f"spell_description_override_ids={count(data['spellDescriptionOverrides'])}")
print(f"spell_ids_with_descriptions={len(spell_ids_with_descriptions)}")
