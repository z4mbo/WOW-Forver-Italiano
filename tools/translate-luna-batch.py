"""Translate an exact-source DB2 queue with GPT Luna (low), resumably.

This tool only writes JSON translation memory in the temporary directory. It
never changes the addon, the game installation, or the Git checkout. Lua packs
are generated separately after source and placeholder validation.
"""

from __future__ import annotations

import argparse
from collections import Counter
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path


SCHEMA = {
    "type": "object",
    "properties": {"translations": {"type": "array", "items": {"type": "string"}}},
    "required": ["translations"],
    "additionalProperties": False,
}
SOURCE_KEYS = ("en", "english", "enDescription")
REFERENCE = re.compile(
    r"\$\?[A-Za-z0-9_]+|\$@[A-Za-z]+\d*|\$<[A-Za-z0-9_]+>|"
    r"\$[*/]\d+;[A-Za-z]\d+|\$\d*[A-Za-z]+\d*"
)
MARKUP = re.compile(r"\|[cC][0-9a-fA-F]{8}|\|[rR]|\|[HhTtAa][^|]*\|")
FORMAT = re.compile(r"(?<!\d)%(?:\d+\$)?[+\-#0]*(?:\d+|\*)?(?:\.(?:\d+|\*))?[hlL]?[diuoxXfFeEgGaAcspq%]")
SELECTOR = re.compile(r"\$([lLgG])([^:;]+):([^;]+);")


def formulas(value: str) -> list[str] | None:
    found: list[str] = []
    start = 0
    while True:
        start = value.find("${", start)
        if start < 0:
            return found
        depth = 0
        index = start + 1
        while index < len(value):
            if value[index] == "{":
                depth += 1
            elif value[index] == "}":
                depth -= 1
                if depth == 0:
                    found.append(value[start:index + 1])
                    start = index + 1
                    break
            index += 1
        else:
            return None


def source_of(row: dict) -> str:
    for key in SOURCE_KEYS:
        if isinstance(row.get(key), str):
            return row[key]
    raise ValueError(f"No English source in queue row: {row!r}")


def load_queue(path: Path) -> list[str]:
    raw = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(raw, list):
        raise ValueError("Queue must be a JSON array of grouped source rows")
    seen: set[str] = set()
    sources: list[str] = []
    for row in raw:
        if not isinstance(row, dict):
            raise ValueError("Each queue row must be an object")
        source = source_of(row)
        if not source or source in seen:
            continue
        seen.add(source)
        sources.append(source)
    return sources


def verify(source: str, italian: str, category: str) -> str | None:
    if source.isspace() and italian == source:
        return None
    if not italian or italian.isspace():
        return "blank result"
    if "\ufffd" in italian or "\x00" in italian:
        return "replacement or NUL character"
    if source.count("\n") != italian.count("\n") or source.count("\r") != italian.count("\r"):
        return "line ending count changed"
    if MARKUP.findall(source) != MARKUP.findall(italian):
        return "WoW markup changed"
    if category in ("ui-global", "client-db2"):
        if FORMAT.findall(source) != FORMAT.findall(italian) or source.count("%") != italian.count("%"):
            return "UI printf placeholders changed"
        if REFERENCE.findall(source) != REFERENCE.findall(italian):
            return "UI WoW variable references changed"
    if category.endswith("description"):
        source_refs = SELECTOR.sub(lambda m: "$" + m.group(1).lower() + ";", source)
        italian_refs = SELECTOR.sub(lambda m: "$" + m.group(1).lower() + ";", italian)
        if Counter(REFERENCE.findall(source_refs)) != Counter(REFERENCE.findall(italian_refs)):
            return "WoW variable references changed"
        for char in "${}[]":
            if source.count(char) != italian.count(char):
                return f"WoW syntax count changed: {char}"
        if formulas(source) != formulas(italian):
            return "WoW formula changed"
        if ([match.group(1).lower() for match in SELECTOR.finditer(source)] !=
                [match.group(1).lower() for match in SELECTOR.finditer(italian)]):
            return "WoW plural or gender selector changed"
        if FORMAT.findall(source) != FORMAT.findall(italian):
            return "description printf placeholders changed"
    return None


def prompt_for(category: str, sources: list[str], drafts: list[str] | None = None,
               reconsider: bool = False) -> str:
    noun = ("nomi o sottotitoli" if category.endswith("name") or category == "spell-subtext"
            else "nomi, etichette e descrizioni del client" if category == "client-db2"
            else "etichette e messaggi di interfaccia" if category == "ui-global" else "descrizioni")
    if drafts is not None:
        return (
            "Correggi queste bozze italiane per World of Warcraft. L'inglese è "
            "la fonte esatta. Ogni variabile, formula, controllo condizionale, "
            "segnaposto printf, colore, link e struttura a capo deve restare "
            "funzionante e nello stesso ordine della fonte. Mantieni la "
            "traduzione italiana già presente; correggi soltanto errori e "
            "sintassi. Rispondi solo con {\"translations\":[...]} in ordine.\n\n"
            + json.dumps([{"en": en, "draft": draft}
                          for en, draft in zip(sources, drafts)], ensure_ascii=False)
        )
    if reconsider:
        return (
            "Riesamina queste stringhe del client World of Warcraft: Forever "
            "che una prima passata ha lasciato identiche all'inglese. Se "
            "contengono parole inglesi comuni, traducile in italiano naturale. "
            "Conserva invece nomi propri, codici, comandi slash, URL, formule, "
            "segnaposto e parole che sono già italiano. Non spacciare una "
            "parola inglese comune per nome proprio. Mantieni identici "
            "tutti i token WoW e printf. Rispondi solo con "
            "{\"translations\":[...]} nello stesso ordine.\n\n"
            + json.dumps(sources, ensure_ascii=False)
        )
    return (
        "Sei un traduttore italiano di testi di World of Warcraft: Forever beta. "
        f"Traduci esattamente i seguenti {noun} inglesi. Rispondi soltanto con "
        "un oggetto JSON {\"translations\":[...]} con una stringa italiana per "
        "ogni stringa in input, nello stesso ordine. Mantieni i nomi propri "
        "senza inventare equivalenti; traduci termini comuni e frasi. "
        "Mantieni esattamente ogni variabile e sintassi WoW che inizia con $, "
        "inclusi identificatori numerici, parentesi, selettori e ordine. "
        "Traduci le parole all'interno dei selettori $l e $g quando possibile "
        "senza alterarne la sintassi. Mantieni tag di colore, link, codici di "
        "formattazione, a capo e sequenze CRLF. Non aggiungere spiegazioni "
        "o inventare testo. Se una stringa è solo un nome proprio, sigla, "
        "codice o numero, puoi conservarla invariata. Non eliminare i marker "
        "tecnici come [DNT], [PH], UNUSED, DEPRECATED. Conserva esattamente "
        "tutti i segnaposto printf come %s, %d, %.2f e %1$s, i codici |c/|r "
        "e i link WoW. Lascia invariata una stringa composta solo da codice "
        "di formattazione, comando slash o nome proprio.\n\n"
        + json.dumps(sources, ensure_ascii=False)
    )


def call_luna(sources: list[str], category: str, work: Path, timeout: int,
              drafts: list[str] | None = None, reconsider: bool = False) -> list[str]:
    binary = shutil.which("codex")
    if binary is None:
        raise RuntimeError("codex CLI is not installed")
    schema = work / "output-schema.json"
    response = work / "last-response.json"
    schema.write_text(json.dumps(SCHEMA), encoding="utf-8")
    command = [
        binary, "exec", "--ignore-user-config", "-m", "gpt-6-luna", "-c",
        'model_reasoning_effort="low"', "-s", "read-only", "--ephemeral",
        "--skip-git-repo-check", "-C", str(work), "--output-schema",
        str(schema), "-o", str(response), "-",
    ]
    result = subprocess.run(command, input=prompt_for(category, sources, drafts, reconsider), text=True,
                            encoding="utf-8", stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE, timeout=timeout, check=False)
    if result.returncode != 0 or not response.exists():
        raise RuntimeError(f"Luna exit={result.returncode}: {result.stderr[-1200:]}")
    payload = json.loads(response.read_text(encoding="utf-8"))
    translated = payload.get("translations")
    if not isinstance(translated, list) or len(translated) != len(sources) or not all(
            isinstance(value, str) for value in translated):
        raise ValueError("Luna returned missing, non-string, or miscounted translations")
    return translated


def call_adaptive(sources: list[str], category: str, work: Path, timeout: int,
                  drafts: list[str] | None = None, reconsider: bool = False) -> list[str]:
    """Split a long structured response if Luna cannot keep its item count."""
    for attempt in range(2):
        try:
            return call_luna(sources, category, work, timeout, drafts, reconsider)
        except (RuntimeError, ValueError, subprocess.TimeoutExpired) as exc:
            print(f"Retrying {len(sources)}-source batch: {exc}", file=sys.stderr, flush=True)
            if attempt == 0:
                time.sleep(2)
    if len(sources) == 1:
        raise RuntimeError(f"Luna failed for one source: {sources[0][:200]!r}")
    middle = len(sources) // 2
    return (call_adaptive(sources[:middle], category, work, timeout,
                          drafts[:middle] if drafts is not None else None, reconsider) +
            call_adaptive(sources[middle:], category, work, timeout,
                          drafts[middle:] if drafts is not None else None, reconsider))


def save_memory(path: Path, memory: dict[str, dict]) -> None:
    temp = path.with_suffix(".tmp")
    temp.write_text(json.dumps(memory, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    temp.replace(path)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--category", required=True, choices=("spell-name", "item-name", "spell-subtext", "ui-global", "client-db2",
                        "spell-description", "aura-description", "item-description"))
    parser.add_argument("--queue", required=True, type=Path)
    parser.add_argument("--memory", type=Path)
    parser.add_argument("--batch-size", type=int, default=50)
    parser.add_argument("--max-chars", type=int, default=10000)
    parser.add_argument("--max-batches", type=int)
    parser.add_argument("--timeout", type=int, default=360)
    rerun = parser.add_mutually_exclusive_group()
    rerun.add_argument("--repair-review", action="store_true",
                       help="retry only memory entries flagged for review")
    rerun.add_argument("--reconsider-identical", action="store_true",
                       help="ask Luna to revisit unchanged English results")
    arguments = parser.parse_args()
    if arguments.batch_size < 1 or arguments.max_chars < 1:
        parser.error("batch-size and max-chars must be positive")
    work = Path(tempfile.gettempdir()) / "wfi-luna-batch" / arguments.category
    work.mkdir(parents=True, exist_ok=True)
    memory_path = arguments.memory or work / "memory.json"
    sources = load_queue(arguments.queue)
    memory = json.loads(memory_path.read_text(encoding="utf-8")) if memory_path.exists() else {}
    pending = ([source for source in sources if memory.get(source, {}).get("status") == "review"]
               if arguments.repair_review else
               [source for source in sources if memory.get(source, {}).get("it") == source]
               if arguments.reconsider_identical else
               [source for source in sources if source not in memory])
    print(f"{arguments.category}: unique={len(sources)} completed={len(memory)} pending={len(pending)}", flush=True)
    batches = 0
    while pending and (arguments.max_batches is None or batches < arguments.max_batches):
        batch: list[str] = []
        chars = 0
        while pending and len(batch) < arguments.batch_size:
            source = pending[0]
            if batch and chars + len(source) > arguments.max_chars:
                break
            batch.append(pending.pop(0))
            chars += len(source)
        drafts = [memory[source]["it"] for source in batch] if arguments.repair_review else None
        translations = call_adaptive(batch, arguments.category, work, arguments.timeout,
                                     drafts, arguments.reconsider_identical)
        for source, translated in zip(batch, translations):
            problem = verify(source, translated, arguments.category)
            memory[source] = {"it": translated, "status": "verified" if problem is None else "review",
                              "reason": problem or ""}
        save_memory(memory_path, memory)
        batches += 1
        accepted = sum(row["status"] == "verified" for row in memory.values())
        print(f"batch={batches} done={len(memory)}/{len(sources)} accepted={accepted} review={len(memory)-accepted}",
              flush=True)
    print(f"memory={memory_path}", flush=True)


if __name__ == "__main__":
    main()
