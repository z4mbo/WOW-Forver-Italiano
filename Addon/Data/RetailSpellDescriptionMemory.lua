-- Generated from the installed Retail client and beta locale extracts (exact ID and enUS text).
-- Optional pack: this file is intentionally not added to the TOC by the generator.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
local reused = {
    [7713] = { en = "Reduces all the attributes of nearby enemies by $s1% for $d.", description = "Riduce tutti gli attributi dei nemici vicini del $s1% per $d." },
    [19804] = { en = "Activates your Arcanite Dragonling to fight for you for $d.", description = "Attiva il Minidrago di Arcanite che combatte al tuo fianco per $d." },
    [28747] = { en = "Increases the caster's attack speed by $s2% and the Physical damage it deals by $s1% for $d.", description = "Aumenta la velocità d'attacco del $s2% e i danni fisici inflitti del $s1% per $d." },
    [29029] = { en = "Restores $25888o1 health and $25889o1 mana over $25888d.  Must remain seated while eating.  If you spend at least 10 seconds eating you will become refreshed and gain $25941s1 Mana every 5 seconds for $25941d.", description = "Rigenera $25888o1 salute e $25889o1 mana in $25888d. Devi sederti per mangiare. Se mangi per almeno 10 s diventi rinfrescato e guadagni $25941s1 mana ogni 5 s per $25941d." },
    [1247613] = { en = "|cnNORMAL_FONT_COLOR:Transmogrify the appearance of your weapons and armor|r\r\n\r\nLock Appearance:\r\n|cnNORMAL_FONT_COLOR:Prevent this appearance from being replaced by a Situation|r\r\n\r\n|cnGREEN_FONT_COLOR:<Right Click to toggle lock appearance>|r", description = "|cnNORMAL_FONT_COLOR:Trasmogrifica l'aspetto delle armi e delle armature|r\r\n\r\nBlocco aspetto:\r\n|cnNORMAL_FONT_COLOR:Impedisce che questo aspetto possa essere sostituito da uno situazionale|r\r\n\r\n|cnGREEN_FONT_COLOR:<Pulsante destro per bloccare/sbloccare l'aspetto>|r" },
    [1247917] = { en = "|cnNORMAL_FONT_COLOR:Resets all equipped gear to their original appearance|r\r\n\r\n|cnWHITE_FONT_COLOR:Lock Appearance:|r\r\n|cnNORMAL_FONT_COLOR:Prevent this appearance from being replaced by a Situation|r\r\n\r\n|cnGREEN_FONT_COLOR:<Right Click to toggle lock appearance>|r", description = "|cnNORMAL_FONT_COLOR:Ripristina tutto l'equipaggiamento indossato al suo aspetto originario|r\r\n\r\n|cnWHITE_FONT_COLOR:Blocco aspetto:|r\r\n|cnNORMAL_FONT_COLOR:Impedisce che questo aspetto possa essere sostituito da uno situazionale|r\r\n\r\n|cnGREEN_FONT_COLOR:<Pulsante destro per bloccare/sbloccare l'aspetto>|r" },
}
for id, record in pairs(reused) do
    if ns.data.spellDescriptionOverrides[id] == nil then
        ns.data.spellDescriptionOverrides[id] = record
    end
end
