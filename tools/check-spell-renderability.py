"""Exercise catalogue spell templates through the tooltip hook with sample values.

This is a synthetic check of supported placeholder shapes, not a claim about
which tooltip text the Forever beta actually renders during play.
"""

from pathlib import Path

from lupa import LuaRuntime

from generate_spell_reuse import tokens


ADDON = Path(__file__).resolve().parents[1] / "Addon"


def sample_token(token: str) -> str:
    if token.startswith(("$l", "$L", "$g", "$G")):
        return token[2:].split(":", 1)[0]
    if token.endswith("d") and not token.startswith("${"):
        return "10 sec"
    return "17"


def render_source(identifier: int, template: str) -> str | None:
    if identifier == 339:
        return ("Roots the target in place and causes 17 Nature damage over 10 sec.  "
                "Damage caused may interrupt the effect.  You may only have 1 "
                "target Rooted at a time.")
    if identifier == 740:
        return ("Regenerates all nearby party members within 17 yards for 17 "
                "every 17 sec for 10 sec.  Druid must channel to maintain the spell.")
    parts = tokens(template)
    if parts is None:
        return None
    output = template
    for token in parts:
        output = output.replace(token, sample_token(token), 1)
    return output


def main() -> None:
    lua = LuaRuntime(unpack_returned_tuples=True)
    namespace = lua.table()
    lua.execute("""
        WFI_DB = {}
        issecretvalue = function() return false end
        InCombatLockdown = function() return false end
        CreateFrame = function()
            local frame = { RegisterEvent=function() end, UnregisterEvent=function() end,
                SetScript=function(self, event, callback) self[event]=callback end }
            lastFrame=frame
            return frame
        end
        TooltipDataProcessor = {
            AddTooltipPostCall=function(_, callback) spellCallback=callback end,
        }
        Enum = { TooltipDataType = { Spell=2 } }
        makeText = function(value)
            return { text=value, GetText=function(self) return self.text end,
                SetText=function(self, value) self.text=value end,
                IsProtected=function() return false end }
        end
        fireSpell = function(id, name, body)
            ProbeTooltipTextLeft1=makeText(name)
            ProbeTooltipTextLeft2=makeText(body)
            spellCallback({GetName=function() return "ProbeTooltip" end}, {id=id})
            return ProbeTooltipTextLeft2.text
        end
    """)
    for row in (ADDON / "WOWForverItaliano.toc").read_text(encoding="utf-8-sig").splitlines():
        name = row.strip()
        if name == "Core.lua" or (name.startswith("Data\\") and name.endswith(".lua")):
            lua.execute((ADDON / name.replace("\\", "/")).read_text(encoding="utf-8"),
                        "WOWForverItaliano", namespace)
    lua.execute((ADDON / "Modules/Spells.lua").read_text(encoding="utf-8"),
                "WOWForverItaliano", namespace)
    lua.execute('lastFrame:OnEvent("ADDON_LOADED", "WOWForverItaliano")')
    data = namespace.data
    for label, registry in (
        ("spell_descriptions", data.spellDescriptionOverrides),
        ("spell_auras", data.spellAuraDescriptionOverrides),
    ):
        checked = succeeded = 0
        unsupported: list[tuple[int, str]] = []
        failures: list[tuple[int, str]] = []
        for spell_id, entry in registry.items():
            source = render_source(int(spell_id), entry.en)
            if source is None or len(source) > 2400:
                unsupported.append((spell_id, entry.en[:110].replace("\n", " ")))
                continue
            name = data.spells[spell_id]
            name = name.en if name is not None else "Unmapped spell"
            result = lua.globals().fireSpell(spell_id, name, source)
            checked += 1
            if result != source:
                succeeded += 1
            else:
                failures.append((spell_id, entry.en[:110].replace("\n", " ")))
        print(f"synthetic_{label}_checked={checked} translated={succeeded} "
              f"unrendered={len(failures)} unsupported_source_templates={len(unsupported)}")
        for spell_id, english in failures[:40]:
            print(f"  {spell_id}: {english}")
        for spell_id, english in unsupported[:10]:
            print(f"  unsupported {spell_id}: {english}")
        if failures:
            raise SystemExit(f"{label} contains tooltip templates that did not render")


if __name__ == "__main__":
    main()
