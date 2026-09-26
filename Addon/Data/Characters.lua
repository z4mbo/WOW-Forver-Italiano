local ADDON_NAME, ns = ...
ns.data = ns.data or {}

ns.data.classes = {
    WARRIOR = "Guerriero",
    PALADIN = "Paladino",
    HUNTER = "Cacciatore",
    ROGUE = "Ladro",
    PRIEST = "Sacerdote",
    SHAMAN = "Sciamano",
    MAGE = "Mago",
    WARLOCK = "Stregone",
    DRUID = "Druido",
}

ns.data.races = {
    Human = "Umano",
    Dwarf = "Nano",
    NightElf = "Elfo della Notte",
    Gnome = "Gnomo",
    Orc = "Orco",
    Undead = "Non Morto",
    Scourge = "Non Morto", -- raceFile token used by some clients for Undead
    Tauren = "Tauren",
    Troll = "Troll",
}
