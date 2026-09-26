local ADDON_NAME, ns = ...
ns.data = ns.data or {}
ns.data.ui = ns.data.ui or {}

-- Additional labels used by the collections, mail, auction, and group panels.
-- Keep this list to concise interface labels; names of mounts, pets, and items
-- belong in their own data tables.
local translations = {
    -- Collections
    ["Mounts"] = "Cavalcature",
    ["Pets"] = "Mascotte",
    ["Pet Journal"] = "Diario delle mascotte",
    ["Mount Journal"] = "Diario delle cavalcature",
    ["Toys"] = "Giocattoli",
    ["Toy Box"] = "Raccolta giocattoli",
    ["Heirlooms"] = "Cimeli",
    ["Appearances"] = "Aspetti",
    ["Collected"] = "Raccolto",
    ["Not Collected"] = "Non raccolto",
    ["Favorites"] = "Preferiti",
    ["Favorite"] = "Preferito",
    ["Summon"] = "Evoca",
    ["Summon Random Favorite"] = "Evoca un preferito casuale",
    ["Mount Special"] = "Abilità speciale della cavalcatura",
    ["Achievements"] = "Imprese",
    ["Achievement Points"] = "Punti impresa",
    ["Earned"] = "Ottenuta",
    ["Earned by"] = "Ottenuta da",
    ["Not Earned"] = "Non ottenuta",

    -- Mail
    ["Inbox"] = "Posta in arrivo",
    ["Send Mail"] = "Invia posta",
    ["Subject"] = "Oggetto",
    ["Take All"] = "Ritira tutto",
    ["Return"] = "Restituisci",
    ["Return to Sender"] = "Restituisci al mittente",
    ["Open"] = "Apri",
    ["COD"] = "Contrassegno",
    ["Money"] = "Denaro",
    ["Attach Money"] = "Allega denaro",
    ["Attachment"] = "Allegato",
    ["Attachments"] = "Allegati",
    ["Send"] = "Invia",
    ["Expires in"] = "Scade tra",

    -- Auction house
    ["Browse"] = "Sfoglia",
    ["Auctions"] = "Aste",
    ["Bids"] = "Offerte",
    ["Create Auction"] = "Crea asta",
    ["Duration"] = "Durata",
    ["Bid"] = "Offerta",
    ["Buyout"] = "Riscatto",
    ["Buyout Price"] = "Prezzo di riscatto",
    ["Starting Bid"] = "Offerta iniziale",
    ["Time Left"] = "Tempo rimanente",
    ["Seller"] = "Venditore",
    ["Post"] = "Metti all'asta",
    ["Cancel Auction"] = "Annulla asta",

    -- Group finder and dungeon panels
    ["Dungeons & Raids"] = "Spedizioni e incursioni",
    ["Premade Groups"] = "Gruppi precostituiti",
    ["Custom"] = "Personalizzato",
    ["Find a Group"] = "Trova un gruppo",
    ["Start a Group"] = "Crea un gruppo",
    ["Sign Up"] = "Iscriviti",
    ["Listing"] = "Annuncio",
    ["Applicants"] = "Candidati",
    ["Delisted"] = "Rimosso dall'elenco",
    ["Dungeon Difficulty"] = "Difficoltà spedizione",
    ["Raid Difficulty"] = "Difficoltà incursione",

    -- Minimap and travel
    ["Calendar"] = "Calendario",
    ["Tracking"] = "Tracciamento",
    ["Track Resources"] = "Traccia risorse",
    ["Innkeeper"] = "Locandiere",
}

for english, italian in pairs(translations) do
    ns.data.ui[english] = italian
end
