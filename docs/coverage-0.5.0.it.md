# Copertura del catalogo 0.5.0-beta

La fonte è l'estrazione in sola lettura dei testi `enUS` e `itIT` dei 14 DB2 con campi localizzati individuati nel client Forever beta **1.60.1.70009** installato. Un campo è una lacuna se l'inglese è presente e l'italiano è vuoto o identico all'inglese. La corrispondenza del catalogo richiede lo stesso ID e il testo inglese esatto. Un nome proprio lasciato invariato è stato riesaminato separatamente.

| Fonte | Lacune rilevate | ID/campi nel catalogo | Scoperti |
| --- | ---: | ---: | ---: |
| `SpellName.Name_lang` | 16.773 | 16.773 | 0 |
| `Spell.Description_lang` | 11.292 | 11.292 | 0 |
| `Spell.AuraDescription_lang` | 4.616 | 4.616 | 0 |
| `Spell.NameSubtext_lang` | 3.753 | 3.753 | 0 |
| `ItemSparse.Display_lang` | 7.351 | 7.351 | 0 |
| `ItemSparse.Description_lang` | 3.984 | 3.984 | 0 |
| `GlobalStrings.TagText_lang` | 4.371 | 4.371 | 0 |
| `Creature`, `AreaTable`, `Faction`, `Achievement`, `ChrRaces`, `Map` | 1.625 | 1.625 | 0 |
| `ChrClasses.Name_lang`, `Name_male_lang` | 18 | 18 | 0 |
| `QuestLine`, `QuestInfo`, `SkillLine` | 62 | 62 | 0 |
| **Totale** | **53.845** | **53.845** | **0** |

Un controllo separato di collisioni evidenti nei campi `itIT` non vuoti ha individuato **1.765** valori italiani associati al testo inglese sbagliato. Le correzioni nel catalogo corrispondono a tutti e 1.765 gli ID e alle rispettive fonti inglesi. Le collisioni ambigue sono escluse da questo conteggio.

Il controllo aggregato riproducibile è `tools/report-all-local-db2-coverage.py`: verifica i 14 archivi estratti, i campi esaminati e tutti i controlli di copertura, comprese le collisioni. Richiede le estrazioni locali descritte in `tools/extract-db2-locales.md` e `docs/extra-db2-locstring-inventory.md`; i file del client non sono redistribuiti nel repository.

**Zero lacune nel catalogo non significa gioco interamente tradotto.** Alcuni tooltip usano formule del client che l'addon non può ricostruire in modo sicuro. Missioni non incontrate, dialoghi dei PNG e altri testi possono arrivare dal server e mancare dai DB2 locali. Il catalogo comprende 141 ID di missione già verificati, non tutte le missioni disponibili. Il client beta non ha i nomi italiani delle nove classi nella selezione del personaggio: quella schermata appare prima che un addon possa caricarsi. Doppiaggio, filmati, chat e addon di terzi restano fuori dal pacchetto.
