local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.quests = ns.data.quests or {}

-- English source text and Forever quest IDs verified against 60.tools.
-- https://www.60.tools/quests/98389-a-light-in-the-darkness
-- https://www.60.tools/quests/6395-marlas-last-wish
ns.data.quests[98389] = {
    enTitle = "A Light in the Darkness",
    title = "Una luce nell'oscurità",
    objectives = "Libera 6 vittime intrappolate nelle ragnatele nella tana di Telanotte per Aramis Hammerhand ad Albamorta.",
    description = "Saluti, <Class>. Sì, sono un paladino. Nemmeno la morte può fermare la Luce. Questo è ciò che accomuna i miei simili a tutti i Reietti: abbiamo superato ciò che i vivi considerano la propria fine. Eppure, persino tra i nostri, c'è chi ci teme; sospettano che li colpiremo come mostri. In realtà, il nostro rapporto con la non morte è complesso, ma non sono qui per fare del male ai nostri. Aiutami a dimostrarlo agli altri. Dirigiti a nord-ovest, alla tana di Telanotte, e libera gli stolti appena risorti intrappolati dai ragni.",
}

ns.data.quests[6395] = {
    enTitle = "Marla's Last Wish",
    title = "L'ultimo desiderio di Marla",
    objectives = "Porta i resti di Samuel Fipps alla tomba di Marla, poi torna da Novice Elreth.",
    description = "Prima della peste, la mia amica Marla Fipps viveva con suo marito Samuel. Quando la peste arrivò, Samuel ne fu sopraffatto e si unì alle schiere del Flagello. Marla fu risparmiata dalla non morte, ma morì per mano del marito ormai privo di senno. Il suo amore era così forte, però, che il suo ultimo desiderio fu essere sepolta accanto al suo amato Samuel. Samuel Fipps vaga in un accampamento in rovina lungo la strada a nord-est di Albamorta. Sconfiggilo e realizza il desiderio di Marla: seppelliscilo accanto a lei, nella prima fila del nostro cimitero.",
    progress = "Dobbiamo rispettare i nostri morti, <name>. È uno dei modi in cui ci distinguiamo dal Flagello...",
    completion = "Oggi hai compiuto una buona azione, <name>. La nostra lotta contro il Flagello continua, ma speriamo che Marla e Samuel trovino pace insieme nella loro ultima dimora.",
}
