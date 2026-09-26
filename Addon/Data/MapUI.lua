local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}
-- Map labels from the Forever beta client.
ns.data.ui["World"] = "Mondo"
ns.data.ui["Eastern Kingdoms"] = "Regni Orientali"
ns.data.ui["Tirisfal Glades"] = "Radure di Tirisfal"
ns.data.ui["Search Quest Log"] = "Cerca nel registro missioni"
ns.data.ui["Cursor:"] = "Cursore:"
ns.data.ui["Player:"] = "Giocatore:"
ns.data.ui["Deathknell"] = "Albamorta"
-- Pattern metadata only: consumers should match the English Lua pattern and
-- apply the replacement to the captured quest count. The count is intentionally
-- left dynamic (for example, "Quests: 4/40" -> "Missioni: 4/40").
ns.data.uiPatterns = ns.data.uiPatterns or {}
ns.data.uiPatterns[#ns.data.uiPatterns + 1] = {
    pattern = "^Quests: (%d+/%d+)$",
    replacement = "Missioni: %1",
}
