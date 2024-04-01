-- Variables
ESX = exports["es_extended"]:getSharedObject()

--  Callbacks
ESX.RegisterServerCallback("heidrun_selldrugs:checkPolice", function(source, cb)
    local xPlayers = ESX.GetExtendedPlayers("job", "police")
    local Polices = 0
    for _, xPlayer in pairs(xPlayers) do
        Polices = Polices + 1
    end
    cb(Polices)
end)

-- Event
RegisterServerEvent("heidrun_selldrugs:SellDrug", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)
    local cena = math.random(Config.Drugs[item].price.min, Config.Drugs[item].price.max)
    local ilosc = math.random(Config.Drugs[item].quantity.min, Config.Drugs[item].quantity.max)

    if xItem.count > ilosc then
        xPlayer.removeInventoryItem(item, ilosc)
        xPlayer.addAccountMoney("money", cena * ilosc)
        xPlayer.showNotification(Config.Locales['yousold'] .. " " .. ilosc .. "x " .. item)
    else
        xPlayer.removeInventoryItem(item, xItem.count)
        xPlayer.addAccountMoney("money", cena * xItem.count)
        xPlayer.showNotification(Config.Locales['yousold'] .. " " .. xItem.count .. "x " .. item)
    end
end)
