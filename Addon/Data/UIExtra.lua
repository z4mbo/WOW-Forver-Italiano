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
    ["Toy Box"] = "Raccolta giocattoli",
    ["Heirlooms"] = "Cimeli",
    ["Appearances"] = "Aspetti",
    ["Collected"] = "Raccolto",
    ["Not Collected"] = "Non raccolto",
    ["Favorites"] = "Preferiti",
    ["Favorite"] = "Preferito",
    ["Summon"] = "Evoca",
    ["Achievements"] = "Imprese",
    ["Achievement Points"] = "Punti impresa",
    ["Earned"] = "Ottenuta",

    -- Mail
    ["Inbox"] = "Posta in arrivo",
    ["Send Mail"] = "Invia posta",
    ["Return"] = "Restituisci",
    ["Open"] = "Apri",
    ["Money"] = "Denaro",
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
    ["Time Left"] = "Tempo rimanente",
    ["Seller"] = "Venditore",
    ["Cancel Auction"] = "Annulla asta",

    -- Group finder and dungeon panels
    ["Dungeons & Raids"] = "Spedizioni e incursioni",
    ["Premade Groups"] = "Gruppi precostituiti",
    ["Custom"] = "Personalizzato",
    ["Find a Group"] = "Trova un gruppo",
    ["Start a Group"] = "Crea un gruppo",
    ["Sign Up"] = "Iscriviti",
    ["Applicants"] = "Candidati",
    ["Dungeon Difficulty"] = "Difficoltà spedizione",
    ["Raid Difficulty"] = "Difficoltà incursione",

    -- Minimap and travel
    ["Calendar"] = "Calendario",
    ["Tracking"] = "Tracciamento",
    ["Innkeeper"] = "Locandiere",
}
for english, italian in pairs(translations) do
    ns.data.ui[english] = italian
end
