local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.npcs = ns.data.npcs or {}

-- Translation draft, based on exact names extracted from the installed
-- Forever beta enUS creaturecache.wdb (build 1.60.1.70009).
-- The matching itIT creaturecache.wdb contains only its 32-byte header and
-- no records; these Italian names are proposed translations, not client text.
-- Only clear, confidently translatable Deathknell/Tirisfal names are included.
local batch = {
    [1504] = { en = "Young Night Web Spider", name = "Giovane ragno Telanotte" },
    [1505] = { en = "Night Web Spider", name = "Ragno Telanotte" },
    [1506] = { en = "Scarlet Convert", name = "Convertito Scarlatto" },
    [1535] = { en = "Scarlet Warrior", name = "Guerriero Scarlatto" },
    [1568] = { en = "Undertaker Mordo", name = "Becchino Mordo" },
    [1569] = { en = "Shadow Priest Sarvis", name = "Sacerdote dell'Ombra Sarvis" },
    [1570] = { en = "Executor Arren", name = "Esecutore Arren" },
    [1736] = { en = "Deathguard Randolph", name = "Guardia della Morte Randolph" },
    [1737] = { en = "Deathguard Oliver", name = "Guardia della Morte Oliver" },
    [1739] = { en = "Deathguard Phillip", name = "Guardia della Morte Phillip" },
    [1740] = { en = "Deathguard Saltain", name = "Guardia della Morte Saltain" },
    [1741] = { en = "Deathguard Bartrand", name = "Guardia della Morte Bartrand" },
    [1934] = { en = "Tirisfal Farmer", name = "Contadino di Tirisfal" },
    [2123] = { en = "Dark Cleric Duesten", name = "Chierico oscuro Duesten" },
}

for id, entry in pairs(batch) do
    if not ns.data.npcs[id] then ns.data.npcs[id] = entry end
end
