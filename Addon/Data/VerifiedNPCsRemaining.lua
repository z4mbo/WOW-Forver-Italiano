local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.npcs = ns.data.npcs or {}

-- Exact enUS names from the installed Forever beta creaturecache.wdb
-- (build 1.60.1.70009); Italian values below translate clear generic names.
ns.data.npcs[416] = { en = "Imp", name = "Imp" }
ns.data.npcs[721] = { en = "Rabbit", name = "Coniglio" }
ns.data.npcs[3207] = { en = "Hexed Troll", name = "Troll maledetto" }
ns.data.npcs[3300] = { en = "Adder", name = "Vipera" }
ns.data.npcs[3579] = { en = "Stoneclaw Totem", name = "Totem Artiglio di Pietra" }
ns.data.npcs[4075] = { en = "Rat", name = "Ratto" }
ns.data.npcs[5873] = { en = "Stoneskin Totem", name = "Totem della Pelle di Pietra" }
ns.data.npcs[5667] = { en = "Venya Marthand", name = "Venya Marthand" }
ns.data.npcs[5907] = { en = "Kranal Fiss", name = "Kranal Fiss" }
ns.data.npcs[6784] = { en = "Calvin Montague", name = "Calvin Montague" }
ns.data.npcs[3209] = { en = "Brave Windfeather", name = "Valoroso Windfeather" }
ns.data.npcs[3210] = { en = "Brave Proudsnout", name = "Valoroso Proudsnout" }
ns.data.npcs[3211] = { en = "Brave Lightninghorn", name = "Valoroso Lightninghorn" }
ns.data.npcs[3213] = { en = "Brave Running Wolf", name = "Valoroso Running Wolf" }
ns.data.npcs[3214] = { en = "Brave Greathoof", name = "Valoroso Greathoof" }
ns.data.npcs[5888] = { en = "Seer Ravenfeather", name = "Veggente Ravenfeather" }
ns.data.npcs[10676] = { en = "Raider Jhash", name = "Incursore Jhash" }
ns.data.npcs[10682] = { en = "Raider Kerr", name = "Incursore Kerr" }
ns.data.npcs[11944] = { en = "Vorn Skyseer", name = "Vorn Skyseer" }
ns.data.npcs[11945] = { en = "Claire Willower", name = "Claire Willower" }
ns.data.npcs[12922] = { en = "Imp Minion", name = "Servitore di imp" }
ns.data.npcs[246143] = { en = "Frightened Paladin", name = "Paladino spaventato" }
ns.data.npcs[249363] = { en = "Yala Windwatcher", name = "Yala Windwatcher" }
ns.data.npcs[250868] = { en = "Vuldren", name = "Vuldren" }
ns.data.npcs[250873] = { en = "Juvenile Vuldren", name = "Giovane Vuldren" }
ns.data.npcs[250926] = { en = "Scrawny Ursera", name = "Ursera smunta" }
ns.data.npcs[250937] = { en = "Ursera Scavenger", name = "Ursera rovistatrice" }
ns.data.npcs[251143] = { en = "Roiling Winds", name = "Venti turbolenti" }
ns.data.npcs[251145] = { en = "Al'Aketh Brute", name = "Bruto Al'Aketh" }
ns.data.npcs[251160] = { en = "Al'Aketh Convert", name = "Convertito Al'Aketh" }
ns.data.npcs[251169] = { en = "Pesky Cirrusfly", name = "Cirrusfly fastidiosa" }
ns.data.npcs[251245] = { en = "Prideclaw", name = "Prideclaw" }
ns.data.npcs[251306] = { en = "Hoarder", name = "Accumulatore" }
ns.data.npcs[251361] = { en = "Rorian the Dayseeker", name = "Rorian il Cercatore del Giorno" }
ns.data.npcs[251363] = { en = "Dalia the Collector", name = "Dalia la Collezionista" }
ns.data.npcs[251402] = { en = "Cirrusfly Soldier", name = "Soldato Cirrusfly" }
ns.data.npcs[251404] = { en = "Cirrusfly Queen", name = "Regina Cirrusfly" }
ns.data.npcs[251428] = { en = "Hoarder", name = "Accumulatore" }
ns.data.npcs[251437] = { en = "Fireflies", name = "Lucciole" }
ns.data.npcs[251448] = { en = "Al'Aketh Neophyte", name = "Neofita Al'Aketh" }
ns.data.npcs[251451] = { en = "Al'Aketh Ambusher", name = "Imboscato Al'Aketh" }
ns.data.npcs[251559] = { en = "Hoarder", name = "Accumulatore" }
ns.data.npcs[251617] = { en = "Peeps", name = "Peeps" }
ns.data.npcs[251661] = { en = "Galestrider", name = "Galestrider" }
ns.data.npcs[251906] = { en = "Teeri Wellwind", name = "Teeri Wellwind" }
ns.data.npcs[253474] = { en = "Peacekeeper", name = "Pacificatore" }
ns.data.npcs[254100] = { en = "Zephras Citizen", name = "Cittadino di Zephras" }
ns.data.npcs[255979] = { en = "Thendal Grove Ranger", name = "Guardaboschi del Bosco di Thendal" }
ns.data.npcs[256930] = { en = "Captured Bandit", name = "Bandito catturato" }
ns.data.npcs[256935] = { en = "Malduko Cloudcrush", name = "Malduko Cloudcrush" }
ns.data.npcs[259377] = { en = "Injured Deathguard", name = "Guardia della Morte ferita" }
ns.data.npcs[266849] = { en = "Ridgeshade Lurker", name = "Ridgeshade furtivo" }
ns.data.npcs[266850] = { en = "Ridgeshade Creeper", name = "Ridgeshade strisciante" }
ns.data.npcs[267321] = { en = "Karne Grayhoof", name = "Karne Grayhoof" }
ns.data.npcs[267323] = { en = "Clarence Gillian", name = "Clarence Gillian" }
ns.data.npcs[267599] = { en = "Energizing Vortex", name = "Vortice energizzante" }
ns.data.npcs[273458] = { en = "Wisp", name = "Fuoco fatuo" }
ns.data.npcs[273459] = { en = "Haal", name = "Haal" }
ns.data.npcs[273460] = { en = "Meeri", name = "Meeri" }
ns.data.npcs[275103] = { en = "Deathguard Veteran", name = "Veterano della Guardia della Morte" }
ns.data.npcs[276061] = { en = "Decrepit Harvester", name = "Mietitore decrepito" }
ns.data.npcs[3883] = { en = "Moodan Sungrain", name = "Moodan Sungrain" }
ns.data.npcs[5749] = { en = "Kayla Smithe", name = "Kayla Smithe" }
ns.data.npcs[244808] = { en = "Aramis Hammerhand", name = "Aramis Hammerhand" }
ns.data.npcs[251115] = { en = "Urs'anah", name = "Urs'anah" }
ns.data.npcs[251362] = { en = "Ailee Farheart", name = "Ailee Farheart" }
ns.data.npcs[251364] = { en = "Destin Thriceforged", name = "Destin Thriceforged" }
ns.data.npcs[251365] = { en = "Jolee Brightmeadows", name = "Jolee Brightmeadows" }
ns.data.npcs[251366] = { en = "Aetheen of the Gales", name = "Aetheen of the Gales" }
ns.data.npcs[251368] = { en = "Elatrell Featherlight", name = "Elatrell Featherlight" }
ns.data.npcs[251371] = { en = "Falorne Fallwind", name = "Falorne Fallwind" }
ns.data.npcs[251373] = { en = "Xyton Silverwind", name = "Xyton Silverwind" }
ns.data.npcs[251374] = { en = "Windshaper Boro", name = "Plasmatore dei venti Boro" }
ns.data.npcs[251376] = { en = "Tai'ree Farsight", name = "Tai'ree Farsight" }
ns.data.npcs[251379] = { en = "Dorii Brightwhisper", name = "Dorii Brightwhisper" }
ns.data.npcs[251389] = { en = "Akeri Duskblade", name = "Akeri Duskblade" }
ns.data.npcs[251487] = { en = "Ventaari Brightwish", name = "Ventaari Brightwish" }
ns.data.npcs[251537] = { en = "Uualia Suncrest", name = "Uualia Suncrest" }
ns.data.npcs[251902] = { en = "Illaya Amberwind", name = "Illaya Amberwind" }
ns.data.npcs[251904] = { en = "Sania Silverstream", name = "Sania Silverstream" }
ns.data.npcs[251905] = { en = "Zerril Softbreeze", name = "Zerril Softbreeze" }
ns.data.npcs[251913] = { en = "Aedi Thriceforged", name = "Aedi Thriceforged" }
ns.data.npcs[251964] = { en = "Blademaster Ren", name = "Maestro di spada Ren" }
ns.data.npcs[251965] = { en = "Fevrath Skyhammer", name = "Fevrath Skyhammer" }
ns.data.npcs[251991] = { en = "Taleen Shimmerthread", name = "Taleen Shimmerthread" }
ns.data.npcs[251993] = { en = "Indari Sunseam", name = "Indari Sunseam" }
ns.data.npcs[252095] = { en = "Hanaa Nightwind", name = "Hanaa Nightwind" }
ns.data.npcs[254081] = { en = "Naeluna Swiftmend", name = "Naeluna Swiftmend" }
ns.data.npcs[254082] = { en = "Aarnor Galestrike", name = "Aarnor Galestrike" }
ns.data.npcs[254087] = { en = "Miriaan Mistblade", name = "Miriaan Mistblade" }
ns.data.npcs[254088] = { en = "Corsan Earthrazer", name = "Corsan Earthrazer" }
ns.data.npcs[254089] = { en = "Coriella Calmbreeze", name = "Coriella Calmbreeze" }
ns.data.npcs[254358] = { en = "Veena Vericloud", name = "Veena Vericloud" }
ns.data.npcs[254360] = { en = "Belandiel Farflight", name = "Belandiel Farflight" }
ns.data.npcs[255002] = { en = "Ryff", name = "Ryff" }
ns.data.npcs[257018] = { en = "Naleeia Tattermend", name = "Naleeia Tattermend" }
ns.data.npcs[257019] = { en = "Nyassa Swiftdraught", name = "Nyassa Swiftdraught" }
ns.data.npcs[257020] = { en = "Nasalanna Windsinger", name = "Nasalanna Windsinger" }
ns.data.npcs[257021] = { en = "Halassa Fernbreeze", name = "Halassa Fernbreeze" }
ns.data.npcs[257022] = { en = "Messana Crestwind", name = "Messana Crestwind" }
ns.data.npcs[257024] = { en = "Mendalass Tattermend", name = "Mendalass Tattermend" }
ns.data.npcs[257421] = { en = "Tephri Thriceforged", name = "Tephri Thriceforged" }
ns.data.npcs[257551] = { en = "Valreaa Valewind", name = "Valreaa Valewind" }
ns.data.npcs[257554] = { en = "Halaan Hawk-Eye", name = "Halaan Hawk-Eye" }
ns.data.npcs[263113] = { en = "Myriaal Mistwake", name = "Myriaal Mistwake" }
ns.data.npcs[263664] = { en = "Raan Wildwind", name = "Raan Wildwind" }
ns.data.npcs[267324] = { en = "Margaret Weaver", name = "Margaret Weaver" }
ns.data.npcs[267325] = { en = "Walter Mason", name = "Walter Mason" }
ns.data.npcs[267326] = { en = "Florence Nightshade", name = "Florence Nightshade" }
ns.data.npcs[267330] = { en = "Nawka Wildsong", name = "Nawka Wildsong" }
ns.data.npcs[267331] = { en = "Vartha Rockmane", name = "Vartha Rockmane" }
ns.data.npcs[267332] = { en = "Garan Sunstrider", name = "Garan Sunstrider" }
