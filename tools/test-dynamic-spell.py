"""Focused checks for ID-scoped client-rendered spell descriptions."""

import re
import unittest
from pathlib import Path

from lupa import LuaRuntime


ADDON = Path(__file__).resolve().parent.parent / "Addon"
BATCH = (ADDON / "Data/VerifiedSpellDescriptionsBatch.lua").read_text(encoding="utf-8")
BATCH_IDS = {int(value) for value in re.findall(r"^    \[(\d+)\] = \{", BATCH, re.M)}
NEXT = (ADDON / "Data/VerifiedSpellDescriptionsNext.lua").read_text(encoding="utf-8")
NEXT_IDS = {int(value) for value in re.findall(r"^    \[(\d+)\] = \{", NEXT, re.M)}
SPELL_TOKEN = re.compile(r"\$\{[^}]+\}|\$[gG][^:;]+:[^;]+;|\$[lL][^:;]+:[^:;]+;|\$\*\d+;[A-Za-z]\d+|\$\d*[A-Za-z]+\d*")


class DynamicSpellTests(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.ns = self.lua.table()
        self.lua.execute(
            """
            WFI_DB = {}
            issecretvalue = function() return false end
            InCombatLockdown = function() return false end
            CreateFrame = function()
                local frame = {
                    RegisterEvent = function() end,
                    UnregisterEvent = function() end,
                    SetScript = function(self, event, callback) self[event] = callback end,
                }
                lastFrame = frame
                return frame
            end
            TooltipDataProcessor = {
                AddTooltipPostCall = function(_, callback) spellCallback = callback end,
            }
            Enum = { TooltipDataType = { Spell = 2 } }
            makeText = function(value)
                return {
                    text = value,
                    GetText = function(self) return self.text end,
                    SetText = function(self, newValue) self.text = newValue end,
                    IsProtected = function() return false end,
                }
            end
            fireSpell = function(id, name, body)
                DynamicTooltipTextLeft1 = makeText(name)
                DynamicTooltipTextLeft2 = makeText(body)
                spellCallback({ GetName = function() return "DynamicTooltip" end }, { id = id })
                return DynamicTooltipTextLeft2:GetText()
            end
            """
        )
        for name in ("Core.lua", "Data/SpellsClasses.lua"):
            self.lua.execute((ADDON / name).read_text(encoding="utf-8"), "WOWForverItaliano", self.ns)
        # The batch only attaches descriptions to IDs with an existing name.
        for spell_id in BATCH_IDS | NEXT_IDS:
            if self.ns.data.spells[spell_id] is None:
                label = f"Test spell {spell_id}"
                self.ns.data.spells[spell_id] = self.lua.table(en=label, name=label)
        for name in ("Data/SpellTranslationMemory.lua",
                     "Data/SpellAuraTranslationMemory.lua",
                     "Data/VerifiedSpellDescriptionsBatch.lua",
                     "Data/VerifiedSpellDescriptionsNext.lua",
                     "Data/BulkSpellDescriptionsB.lua", "Modules/Spells.lua"):
            self.lua.execute((ADDON / name).read_text(encoding="utf-8"), "WOWForverItaliano", self.ns)
        self.lua.execute('lastFrame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')

    def render(self, spell_id, body, name=None):
        entry = self.ns.data.spells[spell_id]
        return self.lua.globals().fireSpell(spell_id, name or entry.en, body)

    def test_numeric_values_and_point_forms(self):
        source = "An instant strike that causes 42 damage in addition to your normal weapon damage.  Awards 1 combo point."
        translated = self.render(1752, source)
        self.assertEqual(translated, "Un colpo istantaneo che infligge 42 danni aggiuntivi rispetto ai normali danni dell'arma. Genera 1 punto combo.")
        plural = source.replace("Awards 1 combo point", "Awards 2 combo points")
        self.assertIn("Genera 2 punti combo.", self.render(1757, plural))

    def test_duration_and_multiple_numeric_tokens(self):
        source = ("When activated, regenerates 7% of total Health and 8% of total Mana "
                  "every 2 sec for 10 seconds. Only works on Humanoid or Undead "
                  "corpses within 5 yds. Any movement, action, or damage taken "
                  "while Cannibalizing will cancel the effect.")
        result = self.render(20577, source)
        self.assertIn("il 7% della salute totale", result)
        self.assertIn("il 8% del mana totale ogni 2 s per 10 s", result)
        self.assertIn("entro 5 m", result)

    def test_expression_rows(self):
        source = ("Finishing move that causes damage over time, increased by your Attack Power.  "
                  "Lasts longer per combo point:\n   1 point  : 80 damage over 8 secs\n"
                  "   2 points: 100 damage over 10 secs\n   3 points: 120 damage over 12 secs\n"
                  "   4 points: 140 damage over 14 secs\n   5 points: 160 damage over 16 secs")
        result = self.render(1943, source)
        for value in ("80", "100", "120", "140", "160"):
            self.assertIn(value + " danni", result)
        self.assertIn("1 punto:", result)
        self.assertIn("5 punti:", result)

    def test_cross_spell_tokens_and_newline(self):
        source = ("Coats a weapon with poison that lasts for 30  minutes.\n"
                  "Each strike has a 20% chance of poisoning the enemy which instantly "
                  "inflicts 45 Nature damage.  100 charges.")
        result = self.render(11341, source)
        self.assertIn("per 30 minuti.\nOgni colpo", result)
        self.assertIn("il 20%", result)
        self.assertIn("45 danni naturali. 100 cariche.", result)

    def test_full_template_and_id_guards(self):
        source = "An instant strike that causes 42 damage in addition to your normal weapon damage. Awards 1 combo point."
        self.assertNotEqual(self.render(1752, source), source)
        changed = source.replace("normal weapon damage", "spell damage")
        self.assertEqual(self.render(1752, changed), changed)
        malformed = source.replace("42 damage", "lots of damage")
        self.assertEqual(self.render(1752, malformed), malformed)
        self.assertEqual(self.render(1752, source, "Other spell"), source)
        self.assertEqual(self.lua.globals().DynamicTooltipTextLeft1.text, "Other spell")
        self.ns.data.spells[99999] = self.lua.table(en="Test", name="Prova", enDescription=self.ns.data.spells[1752].enDescription, description=self.ns.data.spells[1752].description)
        self.assertEqual(self.render(99999, source), source)

    def test_literal_description_still_works(self):
        source = "Instantly removes all Charm, Fear and Sleep effects."
        self.assertEqual(self.render(7744, source), "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")
        existing = self.ns.data.spells[7744]
        self.ns.data.spellDescriptionOverrides = self.lua.table()
        self.ns.data.spellDescriptionOverrides[7744] = self.lua.table(
            en=existing.enDescription, description=existing.description
        )
        self.ns.data.spells[7744] = None
        self.assertEqual(self.lua.globals().fireSpell(7744, "Unknown racial", source),
                         "Rimuove istantaneamente tutti gli effetti di Ammaliamento, Paura e Sonno.")

    def test_next_batch_simple_dynamic_and_unsupported_template(self):
        fireball = ("Hurls a fiery ball that causes 25 Fire damage and an additional "
                    "12 Fire damage over 6 sec.")
        rendered = self.render(133, fireball)
        self.assertIn("25 danni da fuoco", rendered)
        self.assertIn("12 danni da fuoco in 6 s.", rendered)
        strike = "A strong attack that increases melee damage by 9 and causes a high amount of threat."
        self.assertIn("9", self.render(284, strike))
        self.assertIn("genera molta minaccia", self.render(284, strike))
        roots = ("Roots the target in place and causes 5 Nature damage over 3 sec.  "
                 "Damage caused may interrupt the effect.  You may only have 1 target "
                 "Rooted at a time.")
        self.assertIn("5 danni da natura nell'arco di 3 s", self.render(339, roots))
        self.assertIn("un solo bersaglio", self.render(339, roots))
        changed = roots.replace("Roots the target", "Freezes the target")
        self.assertEqual(self.render(339, changed), changed)

    def test_conditional_tranquility_template(self):
        source = ("Regenerates all nearby party members within 40 yards for 55 "
                  "every 2 sec for 10 sec.  Druid must channel to maintain the spell.")
        result = self.render(740, source)
        self.assertIn("entro 40 m", result)
        self.assertIn("ripristinando 55 ogni 2 s per 10 s", result)
        changed = source.replace("Druid must channel", "Warlock must channel")
        self.assertEqual(self.render(740, changed), changed)

    def test_override_translates_body_without_name_entry(self):
        source = "The rogue's dodge chance will increase by 50% for 15 sec."
        existing = self.ns.data.spells[5277]
        self.ns.data.spellDescriptionOverrides = self.lua.table()
        self.ns.data.spellDescriptionOverrides[5277] = self.lua.table(
            en=existing.enDescription, description=existing.description
        )
        self.ns.data.spells[5277] = None
        rendered = self.lua.globals().fireSpell(5277, "Unmapped client name", source)
        self.assertEqual(rendered, "La probabilità di schivata del ladro aumenta del 50% per 15 s.")
        self.assertEqual(self.lua.globals().DynamicTooltipTextLeft1.text, "Unmapped client name")
        changed = source.replace("dodge chance", "hit chance")
        self.assertEqual(self.lua.globals().fireSpell(5277, "Unmapped client name", changed), changed)
        for english_duration, italian_duration in (
            ("1 hour", "1 ora"), ("2 hours", "2 ore"),
            ("1 day", "1 giorno"), ("2 days", "2 giorni"),
            ("5 minutes", "5 min"),
        ):
            body = source.replace("15 sec", english_duration)
            self.assertIn("per " + italian_duration + ".",
                          self.lua.globals().fireSpell(5277, "Unmapped client name", body))

    def test_bulk_dynamic_description_uses_exact_id_and_template(self):
        source = ("Turns the caster invisible for 15 sec, though this spell "
                  "is unstable and may end early.")
        result = self.lua.globals().fireSpell(66, "Unmapped client name", source)
        self.assertEqual(result, "Rende invisibile l'incantatore per 15 s. "
                         "Tuttavia, l'incantesimo è instabile e potrebbe "
                         "terminare prematuramente.")
        changed = source.replace("unstable", "permanent")
        self.assertEqual(self.lua.globals().fireSpell(66, "Unmapped client name", changed), changed)
        self.assertEqual(self.lua.globals().fireSpell(99999, "Unmapped client name", source), source)

        fear = ("Strikes fear in an enemy, causing it to flee in terror for up to "
                "8 sec. Only 1 target can be feared at a time.")
        result = self.lua.globals().fireSpell(30001, "Unmapped client name", fear)
        self.assertIn("Incute terrore", result)
        self.assertIn("fino a 8 s", result)

    def test_official_name_reuse_still_checks_source_and_id(self):
        self.lua.execute(
            (ADDON / "Data/SpellNameTranslationMemory.lua").read_text(encoding="utf-8"),
            "WOWForverItaliano", self.ns)
        source = ("Turns the caster invisible for 15 sec, though this spell "
                  "is unstable and may end early.")
        result = self.lua.globals().fireSpell(66, "Lesser Invisibility", source)
        self.assertIn("Rende invisibile", result)
        self.assertEqual(self.lua.globals().DynamicTooltipTextLeft1.text,
                         "Invisibilità Inferiore")
        self.assertEqual(self.lua.globals().fireSpell(66, "Unrelated spell", source), source)
        self.assertEqual(self.lua.globals().DynamicTooltipTextLeft1.text,
                         "Unrelated spell")

    def test_exact_english_alias_reuses_verified_dynamic_body(self):
        self.lua.execute(
            (ADDON / "Data/SpellTranslationAliases.lua").read_text(encoding="utf-8"),
            "WOWForverItaliano", self.ns)
        source = ("Bashes the target with your shield for 27 damage.  It also "
                  "interrupts spellcasting and prevents any spell in that "
                  "school from being cast for 6 sec.")
        self.assertIn("27 danni", self.render(72, source))
        self.assertIn("per 6 s.", self.render(72, source))
        changed = source.replace("your shield", "your weapon")
        self.assertEqual(self.render(72, changed), changed)

    def test_verified_aura_description_from_client(self):
        source = "17 Fire damage every 2 seconds."
        result = self.lua.globals().fireSpell(133, self.ns.data.spells[133].en, source)
        self.assertEqual(result, "17 danni da fuoco subiti ogni 2 s.")
        self.assertEqual(self.lua.globals().fireSpell(99999, "Unmapped", source), source)

    def test_plural_tokens_in_official_and_luna_text(self):
        plural = self.lua.globals().fireSpell(526, "Unmapped", "Cures 2 poison effects on the target.")
        singular = self.lua.globals().fireSpell(526, "Unmapped", "Cures 1 poison effect on the target.")
        self.assertEqual(plural, "Cura 2 effetti di Veleno sul bersaglio.")
        self.assertEqual(singular, "Cura 1 effetto di Veleno sul bersaglio.")
        stealth = ("Increases your Stealth detection as if you were 2 levels higher "
                   "and reduces your chance to be hit by spells and ranged attacks by 3%.")
        rendered = self.lua.globals().fireSpell(30894, "Unmapped", stealth)
        self.assertIn("2 livelli in più", rendered)
        self.assertIn("del 3%", rendered)

    def test_gender_token_maps_both_rendered_forms(self):
        self.ns.data.spellDescriptionOverrides[99998] = self.lua.table(
            en="Heals $ghimself:herself; for $s1.",
            description="Cura $gsé stesso:sé stessa; di $s1.",
        )
        self.assertEqual(
            self.lua.globals().fireSpell(99998, "Unmapped", "Heals himself for 37."),
            "Cura sé stesso di 37.",
        )
        self.assertEqual(
            self.lua.globals().fireSpell(99998, "Unmapped", "Heals herself for 37."),
            "Cura sé stessa di 37.",
        )
        self.assertEqual(
            self.lua.globals().fireSpell(99998, "Unmapped", "Heals someone for 37."),
            "Heals someone for 37.",
        )

    def test_uppercase_plural_selector_maps_both_forms(self):
        self.ns.data.spellDescriptionOverrides[99997] = self.lua.table(
            en="Gains $s1 Combo $LPoint:Points;.",
            description="Ottieni $s1 $Lpunto:punti; combo.",
        )
        self.assertEqual(
            self.lua.globals().fireSpell(99997, "Unmapped", "Gains 1 Combo Point."),
            "Ottieni 1 punto combo.",
        )
        self.assertEqual(
            self.lua.globals().fireSpell(99997, "Unmapped", "Gains 2 Combo Points."),
            "Ottieni 2 punti combo.",
        )

    def test_every_verified_dynamic_template(self):
        count = 0
        for spell_id in BATCH_IDS:
            english = self.ns.data.spells[spell_id].enDescription
            if "$" not in english:
                continue
            count += 1

            def sample_value(match):
                token = match.group()
                if token == "$lpoint:points;":
                    return "points"
                if token.startswith("$g") or token.startswith("$G"):
                    return token[2:].split(":", 1)[0]
                if re.fullmatch(r"\$\d*d", token):
                    return "10 sec"
                return "17"

            source = SPELL_TOKEN.sub(sample_value, english)
            rendered = self.render(spell_id, source)
            self.assertNotEqual(rendered, source, f"spell {spell_id} did not render")
            self.assertNotIn("$", rendered, f"spell {spell_id} left a token")
        self.assertEqual(count, 48)


if __name__ == "__main__":
    unittest.main()
