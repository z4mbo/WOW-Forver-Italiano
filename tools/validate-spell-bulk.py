"""Check bulk spell translations against the installed Forever beta DB2 extract."""

from __future__ import annotations

import json
import os
from pathlib import Path

from lupa import LuaRuntime
from generate_spell_reuse import TRUSTED_DONOR_MAX_ID, tokens_compatible


ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path(os.environ.get("TEMP", ".")) / "wfi-casc-audit" / "locale-verified" / "Spell.json"
PACKS = (
    "SpellTranslationMemory.lua",
    "BulkSpellDescriptionsA.lua",
    "BulkSpellDescriptionsB.lua",
    "BulkSpellDescriptionsC.lua",
    "BulkSpellDescriptionsSame.lua",
) + tuple(path.name for path in sorted((ROOT / "Addon" / "Data").glob("BulkSpellFrequent*.lua"))) + (
    "RetailSpellDescriptionMemory.lua",
    "RetailSpellTextMatchMemory.lua",
    "VerifiedTextQualityB.lua",
    "VerifiedTextQualityC.lua",
    "VerifiedTextQualityD.lua",
    "VerifiedGrammarSelectors.lua",
    "SpellCrossFieldTranslationMemory.lua",
    "SpellTranslationAliases.lua",
)
AURA_PACKS = (
    "SpellAuraTranslationMemory.lua",
    "BulkAuraFrequent.lua",
    "BulkAuraFrequentMore.lua",
    "BulkAuraFrequentNext.lua",
    "BulkAuraFrequentFinal.lua",
    "VerifiedRetailCorrections.lua",
    "VerifiedTextQualityD.lua",
    "VerifiedGrammarSelectors.lua",
    "RetailSpellAuraMemory.lua",
    "RetailSpellAuraTextMatchMemory.lua",
    "SpellAuraCrossFieldTranslationMemory.lua",
    "SpellAuraTranslationAliases.lua",
)
CORRECTION_PACKS = {
    "VerifiedTextQualityB.lua", "VerifiedTextQualityC.lua",
    "VerifiedTextQualityD.lua", "VerifiedGrammarSelectors.lua",
}


def load_pack(path: Path, registry: str = "spellDescriptionOverrides") -> dict[int, tuple[str, str]]:
    lua = LuaRuntime(unpack_returned_tuples=True)
    namespace = lua.table()
    lua.execute(path.read_text(encoding="utf-8"), "WOWForverItaliano", namespace)
    records = namespace.data[registry]
    return {int(spell_id): (record.en, record.description)
            for spell_id, record in records.items()}


def main() -> None:
    entries = json.loads(SOURCE.read_text(encoding="utf-8"))["entries"]
    source = {entry["id"]: entry["Description_lang"]
              for entry in entries if "Description_lang" in entry}
    known = {}
    aura_donors = {}
    for spell_id, field in source.items():
        if spell_id >= TRUSTED_DONOR_MAX_ID:
            continue
        english, italian = field.get("enUS"), field.get("itIT")
        if english and italian and english != italian:
            known.setdefault(english, set()).add(italian)
    for entry in entries:
        if entry["id"] >= TRUSTED_DONOR_MAX_ID:
            continue
        field = entry.get("AuraDescription_lang") or {}
        english, italian = field.get("enUS"), field.get("itIT")
        if english and italian and english != italian and "\ufffd" not in italian:
            aura_donors.setdefault(english, set()).add(italian)

    total_ids = set()
    errors = []
    for name in PACKS:
        path = ROOT / "Addon" / "Data" / name
        if not path.exists():
            continue
        records = load_pack(path)
        for spell_id, (english, italian) in records.items():
            field = source.get(spell_id)
            if field is None or english != field.get("enUS"):
                errors.append(f"{name}: {spell_id} English text differs from local Spell.db2")
            if not italian or italian == english:
                errors.append(f"{name}: {spell_id} has no Italian translation")
            if not tokens_compatible(english, italian):
                errors.append(f"{name}: {spell_id} spell placeholders changed")
            if "\n" in english and r"\r\n" in italian:
                errors.append(f"{name}: {spell_id} has literal escaped newlines")
            if name in CORRECTION_PACKS:
                pass  # Existing beta Italian text can itself be incomplete or wrong.
            elif name == "SpellTranslationMemory.lua":
                if field and field.get("itIT") not in ("", english):
                    errors.append(f"{name}: {spell_id} already has Italian")
                if italian not in known.get(english, ()) or len(known.get(english, ())) != 1:
                    errors.append(f"{name}: {spell_id} has no unique official text match")
            elif name == "SpellCrossFieldTranslationMemory.lua":
                if (known.get(english) or len(aura_donors.get(english, ())) != 1 or
                        italian not in aura_donors[english]):
                    errors.append(f"{name}: {spell_id} has no unique trusted aura donor")
            elif name in ("SpellTranslationAliases.lua",
                          "SpellCrossFieldTranslationMemory.lua") or name.startswith("BulkSpellFrequent") or name.startswith("RetailSpell"):
                if field and field.get("itIT") not in ("", english):
                    errors.append(f"{name}: {spell_id} already has Italian")
            elif "Same" in name:
                if field and field.get("itIT") != english:
                    errors.append(f"{name}: {spell_id} itIT was not identical English")
            elif field and field.get("itIT") != "":
                errors.append(f"{name}: {spell_id} itIT was not blank")
        total_ids.update(records)
        print(f"{name}: {len(records)} entries")
    aura_source = {entry["id"]: entry["AuraDescription_lang"]
                   for entry in entries if "AuraDescription_lang" in entry}
    aura_known = {}
    for spell_id, field in aura_source.items():
        if spell_id >= TRUSTED_DONOR_MAX_ID:
            continue
        english, italian = field.get("enUS"), field.get("itIT")
        if english and italian and english != italian:
            aura_known.setdefault(english, set()).add(italian)
    for name in AURA_PACKS:
        aura_path = ROOT / "Addon" / "Data" / name
        if not aura_path.exists():
            continue
        aura_records = load_pack(aura_path, "spellAuraDescriptionOverrides")
        for spell_id, (english, italian) in aura_records.items():
            field = aura_source.get(spell_id)
            if field is None or field.get("enUS") != english:
                errors.append(f"{name}: {spell_id} source mismatch")
            if not italian or italian == english:
                errors.append(f"{name}: {spell_id} untranslated")
            if name not in CORRECTION_PACKS and field and field.get("itIT") not in ("", english):
                errors.append(f"{name}: {spell_id} already localized")
            if name == "SpellAuraTranslationMemory.lua" and (
                    italian not in aura_known.get(english, ()) or
                    len(aura_known.get(english, ())) != 1):
                errors.append(f"{name}: {spell_id} no unique official source")
            if name == "SpellAuraCrossFieldTranslationMemory.lua" and (
                    aura_known.get(english) or len(known.get(english, ())) != 1 or
                    italian not in known[english]):
                errors.append(f"{name}: {spell_id} no unique trusted description donor")
            if not tokens_compatible(english, italian):
                errors.append(f"{name}: {spell_id} placeholders changed")
            if "\n" in english and r"\r\n" in italian:
                errors.append(f"{name}: {spell_id} has literal escaped newlines")
        print(f"{name}: {len(aura_records)} entries")
    print(f"total_unique_ids={len(total_ids)}")
    if errors:
        raise SystemExit("\n".join(errors[:30]) +
                         (f"\n... {len(errors) - 30} more" if len(errors) > 30 else ""))
    print("All source and translation checks passed.")


if __name__ == "__main__":
    main()
