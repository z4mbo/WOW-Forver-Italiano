-- Manual corrections where an otherwise exact Retail donor reverses the
-- meaning of the beta's English source. Keep before generated Retail packs.
local _, ns = ...
ns.data = ns.data or {}
ns.data.spellAuraDescriptionOverrides = ns.data.spellAuraDescriptionOverrides or {}
ns.data.spellAuraDescriptionOverrides[1294431] = {
    en = "$s1 Shadow damage inflicted after $d.",
    description = "$s1 danni da ombra inflitti dopo $d.",
}
