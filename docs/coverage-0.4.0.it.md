# Copertura del catalogo 0.4.0-beta

I conteggi seguenti provengono dai DB2 estratti dal client Forever beta **1.60.1.70009** installato localmente. Un ID è coperto soltanto se il catalogo dell'addon contiene lo stesso ID e il testo inglese identico al campo `enUS` della beta. Non sono misure di ciò che è apparso nel gioco, né includono testi inviati dal server.

| Campo DB2 con italiano vuoto o uguale all'inglese | ID coperti | ID rilevati | ID ancora scoperti |
| --- | ---: | ---: | ---: |
| `SpellName.Name_lang` | 5.541 | 16.773 | 11.232 |
| `Spell.Description_lang` | 7.637 | 11.292 | 3.655 |
| `Spell.AuraDescription_lang` | 2.821 | 4.616 | 1.795 |
| `ItemSparse.Display_lang` | 565 | 7.351 | 6.786 |
| `ItemSparse.Description_lang` | 2.555 | 3.984 | 1.429 |

Il catalogo contiene inoltre **146 correzioni di nomi oggetto** per ID il cui campo `itIT` è presente ma contiene il nome italiano di un altro oggetto. Non rientrano nel conteggio dei campi vuoti/identici della tabella. Comprende 2.418 chiavi di interfaccia, 141 ID di missione e 178 ID di PNG. Delle missioni, 63 hanno una descrizione e 13 hanno entrambi i testi di avanzamento e completamento nel catalogo.

Questi numeri si possono rigenerare con `tools/catalog-stats.py` e `tools/report-local-db2-coverage.py` usando la stessa estrazione locale. Le descrizioni con valori dinamici superano un test sintetico di sostituzione, ma non una verifica visiva nel client. Missioni e dialoghi non presenti nei DB2 richiedono il loro ID e testo inglese esatto dal server o da una cattura nel gioco. L'interfaccia della selezione del personaggio si carica prima degli addon e resta fuori dalla portata di questo pacchetto.
