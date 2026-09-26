local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.characterPanels = ns.data.characterPanels or {}

-- Exact English strings observed in the WoW Forever beta character panels.
for source, translation in pairs({
    ["Horde"] = "Orda",
    ["Darkspear Trolls"] = "Troll Lanciascura",
    ["Orgrimmar"] = "Orgrimmar",
    ["Thunder Bluff"] = "Picco del Tuono",
    ["Undercity"] = "Sepulcra",
    ["Daggers"] = "Pugnali",
    ["Thrown"] = "Armi da lancio",
    ["Unarmed"] = "Senz'armi",
    ["Armor Proficiencies"] = "Competenze nelle armature",
    ["Cloth"] = "Stoffa",
    ["Leather"] = "Cuoio",
    ["Language: Gutterspeak"] = "Lingua: Reiettico",
    ["Language: Orcish"] = "Lingua: Orchesco",
}) do
    ns.data.characterPanels[source] = translation
end
