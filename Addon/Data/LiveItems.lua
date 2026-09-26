local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.items = ns.data.items or {}

-- Item IDs and names verified against the Forever records on 60.tools.
-- https://www.60.tools/items/11127-scavenged-goods
-- https://www.60.tools/items/11848-flax-belt
-- https://www.60.tools/items/11849-rustmetal-bracers
-- https://www.60.tools/items/11850-short-duskbat-cape
ns.data.items[11127] = { en = "Scavenged Goods", name = "Beni recuperati" }
ns.data.items[11848] = { en = "Flax Belt", name = "Cintura di lino" }
ns.data.items[11849] = { en = "Rustmetal Bracers", name = "Bracciali di metallo arrugginito" }
ns.data.items[11850] = { en = "Short Duskbat Cape", name = "Mantello corto di pipistrello crepuscolare" }
