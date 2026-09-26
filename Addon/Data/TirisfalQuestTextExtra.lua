local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = ns.data.quests or {}

-- Exact English text read from the installed Forever beta enUS quest cache:
-- _classic_beta_/Cache/WDB/enUS/questcache.wdb (quest ID 363).
-- The cache's quest title matches the existing title-only record in Quests.lua.
local quest = ns.data.quests[363]
if quest and quest.enTitle == "Rude Awakening" then
    if quest.objectives == nil then
        quest.objectives = "Parla con il Sacerdote dell'Ombra Sarvis."
    end
    if quest.description == nil then
        quest.description = "Era ora che ti svegliassi. Eravamo pronti a gettarti nel fuoco insieme agli altri, ma a quanto pare te la sei cavata.$b$bSono Mordo, il custode della cripta di Albamorta. E ora non sei più schiavo del Re dei Lich.$b$bParla con il Sacerdote dell'Ombra Sarvis nella cappella ai piedi della collina: ti dirà ciò che devi sapere."
    end
end
