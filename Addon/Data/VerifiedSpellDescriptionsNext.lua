-- Additional verified spell descriptions from the local Forever beta Spell.db2 dump.
-- English text copied from enUS Description_lang; itIT was blank or identical.
-- Dynamic spell tokens are preserved verbatim.
local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.spells = ns.data.spells or {}

local verifiedSpellDescriptions = {
    -- Fireball
    [133] = { en = "Hurls a fiery ball that causes $s1 Fire damage and an additional $o2 Fire damage over $d.", description = "Scaglia una palla di fuoco che infligge $s1 danni da fuoco e altri $o2 danni da fuoco in $d." },
    -- Frost Armor
    [168] = { en = "Increases Armor by $s1.  If an enemy strikes the caster, they may have their movement slowed by $6136s1% and the time between their attacks increased by $6136s2% for $6136d.  Only one type of Armor spell can be active on the Mage at any time.  Lasts $d.", description = "Aumenta l'armatura di $s1. Se un nemico colpisce l'incantatore, può subirne un rallentamento del movimento del $6136s1% e un aumento del tempo tra gli attacchi del $6136s2% per $6136d. Sul mago può essere attivo un solo incantesimo di armatura alla volta. Dura $d." },
    -- Frostbolt
    [205] = { en = "Launches a bolt of frost at the enemy, causing ${$m2$*$<frostdamage>} to ${$M2*$<frostdamage>}  Frost damage and slowing movement speed by $s1% for $d.", description = "Scaglia un dardo di gelo contro il nemico, infliggendo da ${$m2$*$<frostdamage>} a ${$M2*$<frostdamage>} danni da gelo e riducendone la velocità di movimento del $s1% per $d." },
    -- Heroic Strike
    [284] = { en = "A strong attack that increases melee damage by $s1 and causes a high amount of threat.", description = "Un potente attacco che aumenta i danni in mischia di $s1 e genera molta minaccia." },
    -- Lightning Shield
    [324] = { en = "The caster is surrounded by $n balls of lightning.  When a spell, melee or ranged attack hits the caster, the attacker will be struck for $26364s1 Nature damage.  This expends one lightning ball.  Only one ball will fire every few seconds.  Lasts $d.", description = "L'incantatore è circondato da $n sfere di fulmini. Quando viene colpito da un incantesimo o da un attacco in mischia o a distanza, l'attaccante subisce $26364s1 danni da natura. La sfera si consuma. Può attivarsi una sola sfera ogni pochi secondi. Dura $d." },
    -- Healing Wave
    [331] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Entangling Roots
    [339] = { en = "Roots the target in place and causes $o2 Nature damage over $d.  Damage caused may interrupt the effect.  You may $?s17245[have up to ${$17245m1+1} $ltarget:targets;][only have 1 target] Rooted at a time.", description = "Immobilizza il bersaglio e gli infligge $o2 danni da natura in $d. I danni inflitti possono interrompere l'effetto. Puoi tenere immobilizzati $?s17245[fino a ${$17245m1+1} $ltarget:targets;][solo 1 bersaglio] alla volta." },
    -- Immolate
    [348] = { en = "Burns the enemy for ${$m2*$<mult>} Fire damage and then an additional $o1 Fire damage over $d.", description = "Brucia il nemico infliggendo ${$m2*$<mult>} danni da fuoco, poi infligge altri $o1 danni da fuoco in $d." },
    -- Devotion Aura
    [465] = { en = "Gives $s1 additional armor to party members within $a1 yards.  Players may only have one Aura on them per Paladin at any one time.", description = "Fornisce $s1 armatura aggiuntiva ai membri del gruppo entro $a1 m. Ogni paladino può applicare una sola Aura a ciascun giocatore." },
    -- Thorns
    [467] = { en = "Thorns sprout from the friendly target causing $s1 Nature damage to attackers when hit.  Lasts $d.", description = "Ricopre il bersaglio amico di spine che infliggono $s1 danni da natura a chi lo colpisce. Dura $d." },
    -- Lightning Bolt
    [529] = { en = "Casts a bolt of lightning at the target for $s1 Nature damage.", description = "Scaglia un fulmine contro il bersaglio, infliggendo $s1 danni da natura." },
    -- Water Walking
    [546] = { en = "Allows the friendly target to walk across water for $d. Any damage will cancel the effect.", description = "Permette al bersaglio amico di camminare sull'acqua per $d. Qualsiasi danno subito annulla l'effetto." },
    -- Healing Wave
    [547] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Conjure Food
    [587] = { en = "Conjures $s1 $lmuffin:muffins;, providing the mage and $ghis:her; allies with something to eat.\n\nConjured items disappear if logged out for more than 15 minutes.", description = "Crea $s1 $lmuffin:muffins;, così il mago e $ghis:her; alleati hanno qualcosa da mangiare.\n\nGli oggetti evocati scompaiono se si resta disconnessi per più di 15 minuti." },
    -- Inner Fire
    [588] = { en = "A burst of Holy energy fills the caster, increasing armor by $s1.  Each melee or ranged damage hit against the priest will remove one charge.  Lasts $d or until $n charges are used.", description = "Un'esplosione di energia sacra avvolge l'incantatore e ne aumenta l'armatura di $s1. Ogni colpo in mischia o a distanza rimuove una carica. Dura $d o fino all'esaurimento di $n cariche." },
    -- Smite
    [591] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con energia sacra, infliggendo $s1 danni sacri." },
    -- Power Word: Shield
    [592] = { en = "Draws on the soul of the party member to shield them, absorbing $s1 damage.  Lasts $d.  While the shield holds, spellcasting will not be interrupted by damage.  Once shielded, the target cannot be shielded again for $6788d.", description = "Attinge all'anima del membro del gruppo per proteggerlo, assorbendo $s1 danni. Dura $d. Finché lo scudo regge, i danni non interrompono il lancio degli incantesimi. Dopo aver ricevuto lo scudo, il bersaglio non può riceverne un altro per $6788d." },
    -- Shadow Word: Pain
    [594] = { en = "A word of darkness that causes $o1 Shadow damage over $d.", description = "Una parola oscura infligge $o1 danni da ombra in $d." },
    -- Dampen Magic
    [604] = { en = "Dampens magic used against the targeted party member, decreasing damage taken from spells by up to $s1 and healing spells by up to $s2.  Lasts $d.", description = "Attenua la magia diretta contro il membro del gruppo selezionato, riducendo fino a $s1 i danni subiti dagli incantesimi e fino a $s2 le cure ricevute. Dura $d." },
    -- Holy Light
    [639] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Divine Shield
    [642] = { en = "Protects the paladin from all damage and spells for $d, but reduces all damage you deal by $s3%.  Applies Forbearance for $25771d. Cannot be cast while Forbearance is active.", description = "Protegge il paladino da tutti i danni e gli incantesimi per $d, ma riduce del $s3% tutti i danni inflitti. Applica Indulgenza per $25771d. Non può essere lanciato mentre Indulgenza è attiva." },
    -- Devotion Aura
    [643] = { en = "Gives $s1 additional armor to party members within $a1 yards.  Players may only have one Aura on them per Paladin at any one time.", description = "Fornisce $s1 armatura aggiuntiva ai membri del gruppo entro $a1 m. Ogni paladino può applicare una sola Aura a ciascun giocatore." },
    -- Demon Skin
    [687] = { en = "Protects the caster, increasing armor by $m1 and increases health regeneration by $s2 health per 5 sec. for $d.", description = "Protegge l'incantatore, aumentandone l'armatura di $m1 e la rigenerazione della salute di $s2 ogni 5 s per $d." },
    -- Drain Life
    [689] = { en = "Transfers $s1 health every $t1 second from the target to the caster. Lasts $d.", description = "Trasferisce $s1 punti salute dal bersaglio all'incantatore ogni $t1 s. Dura $d." },
    -- Shadow Bolt
    [695] = { en = "Sends a shadowy bolt at the enemy, causing $s1 Shadow damage.", description = "Scaglia un dardo d'ombra contro il nemico, infliggendo $s1 danni da ombra." },
    -- Demon Skin
    [696] = { en = "Protects the caster, increasing armor by $m1 and increases health regeneration by $s2 health per 5 sec. for $d.", description = "Protegge l'incantatore, aumentandone l'armatura di $m1 e la rigenerazione della salute di $s2 ogni 5 s per $d." },
    -- Ritual of Summoning
    [698] = { en = "Begins a ritual that summons the targeted group member.  Requires the caster and 2 additional party members to complete the ritual.  In order to participate, all players must be out of combat and right-click the portal and not move until the ritual is complete.", description = "Avvia un rituale per evocare il membro del gruppo selezionato. Per completarlo servono l'incantatore e altri 2 membri del gruppo. Tutti i partecipanti devono essere fuori dal combattimento, fare clic sul portale e restare immobili fino al termine del rituale." },
    -- Curse of Weakness
    [702] = { en = "Physical damage caused by the target is reduced by $s1 for $d. Only one Curse per Warlock can be active on any one target.", description = "Riduce di $s1 i danni fisici inflitti dal bersaglio per $d. Ogni stregone può mantenere una sola Maledizione attiva sullo stesso bersaglio." },
    -- Garrote
    [703] = { en = "Garrote the enemy, causing $o1 damage over $d, increased by your Attack Power.  Must be stealthed and behind the target.  Awards $s2 combo $lpoint:points;.", description = "Garrotta il nemico, infliggendo $o1 danni in $d, aumentati dalla potenza d'attacco. Devi essere in Furtività e alle spalle del bersaglio. Genera $s2 $lpoint:points; combo." },
    -- Curse of Recklessness
    [704] = { en = "Curses the target with recklessness, reducing the target's armor by $s2 for $d. Cursed enemies will not flee and will ignore Fear and Horror effects. Only one Curse per Warlock can be active on any one target.", description = "Maledice il bersaglio, riducendone l'armatura di $s2 per $d. I nemici maledetti non fuggono e ignorano gli effetti di Paura e Terrore. Ogni stregone può mantenere una sola Maledizione attiva sullo stesso bersaglio." },
    -- Demon Armor
    [706] = { en = "Protects the caster, increasing armor by $s1, Shadow resistance by $s2 and increases health regeneration by $s3 health per 5 sec. for $d.", description = "Protegge l'incantatore, aumentandone l'armatura di $s1, la resistenza all'ombra di $s2 e la rigenerazione della salute di $s3 ogni 5 s per $d." },
    -- Immolate
    [707] = { en = "Burns the enemy for ${$m2*$<mult>} Fire damage and then an additional $o1 Fire damage over $d.", description = "Brucia il nemico infliggendo ${$m2*$<mult>} danni da fuoco, poi infligge altri $o1 danni da fuoco in $d." },
    -- Banish
    [710] = { en = "Banishes the enemy target, preventing all action but making it invulnerable for up to $d.  Only one target can be banished at a time.  Only works on Demons and Elementals.", description = "Esilia il nemico, impedendogli di agire ma rendendolo invulnerabile per un massimo di $d. Si può esiliare un solo bersaglio alla volta. Funziona solo su demoni ed elementali." },
    -- Hellfire
    [711] = { en = "Blasts all enemies in a 10 yard radius with $s1 flame damage.", description = "Brucia tutti i nemici entro 10 m, infliggendo $s1 danni da fuoco." },
    -- Lightwell
    [724] = { en = "Creates a holy Lightwell near the priest.  Members of your raid or party can click the Lightwell to restore $7001o1 health over $7001d.  Being attacked cancels the effect.  Lightwell lasts for $d or 5 charges.", description = "Crea un Pozzo di Luce sacra vicino al sacerdote. I membri del gruppo o dell'incursione possono usarlo per ripristinare $7001o1 punti salute in $7001d. Subire un attacco annulla l'effetto. Il Pozzo di Luce dura $d o 5 cariche." },
    -- Tranquility
    [740] = { en = "Regenerates all nearby party members within $a yards for $?$p456322[${$m1*2}][$s1] every $t1 sec for $d.  Druid must channel to maintain the spell.", description = "Rigenera la salute di tutti i membri del gruppo vicini entro $a m, ripristinando $?$p456322[${$m1*2}][$s1] ogni $t1 s per $d. Il druido deve canalizzare l'incantesimo." },
    -- Health Funnel
    [755] = { en = "Gives $s1 health to the caster's pet every second for $d as long as the caster channels. Generates reduced threat.", description = "Ripristina $s1 punti salute al famiglio dell'incantatore ogni secondo per $d, finché l'incantatore canalizza l'incantesimo. Genera meno minaccia." },
    -- Firestone
    [758] = { en = "Imbues your weapon with Fire, increasing your spell critical strike chance by $23480s2% and the damage done by your Fire spells by up to $23480s1.", description = "Imbeve l'arma di fuoco, aumentando del $23480s2% la probabilità di colpo critico degli incantesimi e fino a $23480s1 i danni inflitti dagli incantesimi di fuoco." },
    -- Conjure Mana Agate
    [759] = { en = "Conjures a mana agate that can be used to instantly restore $5405s1 mana.\n\nConjured items disappear if logged out for more than 15 minutes.", description = "Crea un'agata del mana che ripristina istantaneamente $5405s1 mana.\n\nGli oggetti evocati scompaiono se si resta disconnessi per più di 15 minuti." },
    -- Cat Form
    [768] = { en = "Shapeshift into cat form, increasing melee attack power by $3025s1 plus Agility.  Also protects the caster from Polymorph effects and allows the use of various cat abilities.\n\nThe act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.", description = "Si trasforma in felino, aumentando la potenza d'attacco in mischia di $3025s1 più l'agilità. Protegge inoltre dagli effetti di Polimorfia e consente di usare varie abilità da felino.\n\nLa trasformazione rimuove Polimorfia e gli effetti che limitano il movimento." },
    -- Swipe
    [769] = { en = "Swipe $x1 nearby enemies, inflicting $s1 damage.", description = "Colpisce $x1 nemici vicini, infliggendo $s1 danni." },
    -- Faerie Fire
    [770] = { en = "Decrease the armor of the target by $s1 for $d.  While affected, the target cannot stealth or turn invisible.", description = "Riduce l'armatura del bersaglio di $s1 per $d. Finché è affetto, il bersaglio non può entrare in Furtività né diventare invisibile." },
    -- Rejuvenation
    [774] = { en = "Heals the target for $o1 over $d.", description = "Cura il bersaglio di $o1 punti salute in $d." },
    -- Faerie Fire
    [778] = { en = "Decrease the armor of the target by $s1 for $d.  While affected, the target cannot stealth or turn invisible.", description = "Riduce l'armatura del bersaglio di $s1 per $d. Finché è affetto, il bersaglio non può entrare in Furtività né diventare invisibile." },
    -- Swipe
    [779] = { en = "Swipe $x1 nearby enemies, inflicting $s1 damage.", description = "Colpisce $x1 nemici vicini, infliggendo $s1 danni." },
    -- Swipe
    [780] = { en = "Swipe $x1 nearby enemies, inflicting $s1 damage.", description = "Colpisce $x1 nemici vicini, infliggendo $s1 danni." },
    -- Disengage
    [781] = { en = "Attempts to disengage from the target by reducing threat. Disables auto-attack.", description = "Tenta di allontanarsi dal bersaglio riducendo la minaccia. Disattiva l'attacco automatico." },
    -- Thorns
    [782] = { en = "Thorns sprout from the friendly target causing $s1 Nature damage to attackers when hit.  Lasts $d.", description = "Ricopre il bersaglio amico di spine che infliggono $s1 danni da natura a chi lo colpisce. Dura $d." },
    -- Travel Form
    [783] = { en = "Transforms the druid into a travel form, increasing movement speed by $5419s1%.  Also protects the caster from Polymorph effects.  Only useable outdoors.\n\nThe act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.", description = "Si trasforma in una forma da viaggio, aumentando la velocità di movimento del $5419s1%. Protegge inoltre dagli effetti di Polimorfia. Utilizzabile solo all'aperto.\n\nLa trasformazione rimuove Polimorfia e gli effetti che limitano il movimento." },
    -- Lesser Armor
    [834] = { en = "Increases armor by $s1 for $d.", description = "Aumenta l'armatura di $s1 per $d." },
    -- Frostbolt
    [837] = { en = "Launches a bolt of frost at the enemy, causing ${$m2$*$<frostdamage>} to ${$M2*$<frostdamage>}  Frost damage and slowing movement speed by $s1% for $d.", description = "Scaglia un dardo di gelo contro il nemico, infliggendo da ${$m2$*$<frostdamage>} a ${$M2*$<frostdamage>} danni da gelo e riducendone la velocità di movimento del $s1% per $d." },
    -- Cleave
    [845] = { en = "A sweeping attack that does your weapon damage plus $s1 to the target and a second nearby enemy.", description = "Attacca con un ampio fendente, infliggendo al bersaglio e a un secondo nemico vicino i danni dell'arma più $s1." },
    -- Frost Nova
    [865] = { en = "Blasts enemies near the caster for ${$m1*$<frostdamage>} to ${$M1*$<frostdamage>} Frost damage and freezes them in place for up to $d.  Damage caused may interrupt the effect.", description = "Colpisce i nemici vicini all'incantatore, infliggendo da ${$m1*$<frostdamage>} a ${$M1*$<frostdamage>} danni da gelo e congelandoli sul posto per un massimo di $d. I danni inflitti possono interrompere l'effetto." },
    -- Shield Wall
    [871] = { en = "Reduces the damage taken from all attacks by $s1% for $d.", description = "Riduce del $s1% i danni subiti da tutti gli attacchi per $d." },
    -- Invisibility
    [885] = { en = "Turns the caster invisible for $d, though this spell is unstable and may end early.", description = "Rende invisibile l'incantatore per $d, ma l'effetto è instabile e può terminare in anticipo." },
    -- Healing Wave
    [913] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Lightning Bolt
    [915] = { en = "Casts a bolt of lightning at the target for $s1 Nature damage.", description = "Scaglia un fulmine contro il bersaglio, infliggendo $s1 danni da natura." },
    -- Lightning Shield
    [945] = { en = "The caster is surrounded by $n balls of lightning.  When a spell, melee or ranged attack hits the caster, the attacker will be struck for $26367s1 Nature damage.  This expends one lightning ball.  Only one ball will fire every few seconds.  Lasts $d.", description = "L'incantatore è circondato da $n sfere di fulmini. Quando viene colpito da un incantesimo o da un attacco in mischia o a distanza, l'attaccante subisce $26367s1 danni da natura. La sfera si consuma. Può attivarsi una sola sfera ogni pochi secondi. Dura $d." },
    -- Smite
    [1004] = { en = "Smite an enemy for $s1 Holy damage.", description = "Colpisce un nemico con energia sacra, infliggendo $s1 danni sacri." },
    -- Holy Light
    [1026] = { en = "Heals a friendly target for $s1.", description = "Cura un bersaglio amico di $s1 punti salute." },
    -- Mark of the Wild
    [1126] = { en = "Increases the friendly target's armor by $s1 for $d.", description = "Aumenta l'armatura del bersaglio amico di $s1 per $d." },
    -- Power Word: Fortitude
    [1243] = { en = "Power infuses the target, increasing their Stamina by $s1 for $d.", description = "Infuse il bersaglio di potere, aumentandone la tempra di $s1 per $d." },
    -- Arcane Intellect
    [1459] = { en = "Increases the target's Intellect by $s1 for $d.", description = "Aumenta l'intelletto del bersaglio di $s1 per $d." },
}

ns.data.spellDescriptionOverrides = ns.data.spellDescriptionOverrides or {}
for id, description in pairs(verifiedSpellDescriptions) do
    ns.data.spellDescriptionOverrides[id] = description
    local entry = ns.data.spells[id]
    if type(entry) == "table" then
        entry.enDescription = description.en
        entry.description = description.description
    end
end
