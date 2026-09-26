local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.settings = ns.data.settings or {}

-- Exact English strings observed in the WoW Forever beta Graphics/Controls settings.
for source, translation in pairs({
    ["Gamepad (Alpha)"] = "Gamepad (Alfa)",
    ["Ping System"] = "Sistema di ping",
    ["Mouse"] = "Mouse",
    ["Antialiasing"] = "Antialiasing",
    ["Image-Based Techniques"] = "Tecniche basate sulle immagini",
    ["Multisample Alpha-Test"] = "Test alfa a campionamento multiplo",
}) do
    ns.data.settings[source] = translation
end
