Config = {}

Config.Drugs = { 

    ["marihuana"] = {
        label = "Sell a Example drug",
        icon = "fa-solid fa-cannabis",
        price = { min = 20, max = 70}, -- Sale price
        quantity  = { min = 3, max = 8}, -- possible number of sales at once
    },

}

Config.Locales = {
    ["offer_accepted"] = "The local accepted your offer",
    ["offer_rejected"] = "The local rejected your offer",
    ["canceled"] = "You canceled the sale",
    ["yousold"] = "You sold",
    ["nopolice"] = "There aren't enough officers for you to sell drugs",
    ["enough"] = "You don't have enough "
}

Config.MinPolice = 0

Config.BlacklistedJobs = { -- Blacklisted Jobs To Sell Drugs
    ["police"] = true,
    ["sheriff"] = true,
}

Config.SendDispatch = function() 
    local coords = GetEntityCoords(PlayerPedId())
    
end

Config.DisableNPCs = { -- peds on which there is no option to sell 
    ["example"] = true,
}