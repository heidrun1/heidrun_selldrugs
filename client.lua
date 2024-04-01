-- Variables
ESX = exports["es_extended"]:getSharedObject()

-- Functions
function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

function PedIsBlacklisted(model)
    for l, v in pairs(Config.DisableNPCs) do
        if GetHashKey(l) == model then
            return true
        end
    end
    return false
end

function PlayerHasEnoughDrugs(itemName)
    local playerData = ESX.GetPlayerData()
    local item = exports['ox_inventory']:GetItemCount(itemName)

    return item >= Config.Drugs[itemName].quantity.min and item >= 1
end

-- Thread
CreateThread(function()
    for l, v in pairs(Config.Drugs) do
        exports.ox_target:addGlobalPed({
            {
                name = 'sprzedajdragi' .. l,
                icon = v.icon,
                label = v.label,
                items = l,
                canInteract = function(entity, distance, coords, name)
                    if PedIsBlacklisted(GetEntityModel(entity)) or IsEntityDead(entity) or IsEntityPositionFrozen(entity) or Config.BlacklistedJobs[ESX.GetPlayerData().job.name] then return false else return true end
                end,
                onSelect = function(data)
                    local Ped = data.entity

                    ESX.TriggerServerCallback("heidrun_selldrugs:checkPolice", function(polices)
                        if polices >= Config.MinPolice then
                            if PlayerHasEnoughDrugs(l) then
                                FreezeEntityPosition(Ped, true)
                                loadAnimDict("amb@world_human_prostitute@cokehead@base")
                                TaskPlayAnim(Ped, "amb@world_human_prostitute@cokehead@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
                                FreezeEntityPosition(PlayerPedId(), true)
                                loadAnimDict("gestures@m@standing@casual")
                                TaskPlayAnim(PlayerPedId(), "gestures@m@standing@casual", "gesture_easy_now", 8.0, -8.0, -1, 0, 0, false, false, false)
                                if lib.progressCircle({
                                        duration = 15000,
                                        position = 'bottom',
                                        useWhileDead = false,
                                        canCancel = true,
                                        disable = {
                                            car = true,
                                        },
                                    }) then
                                    local szansa = math.random(0, 100)
                                    if szansa >= 20 then
                                        loadAnimDict('mp_common')
                                        TaskPlayAnim(Ped, "mp_common", "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
                                        TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, 8.0, 2000, 50, 0, false, false, false)
                                        Citizen.Wait(1000)
                                        ESX.ShowNotification(Config.Locales['offer_accepted'])
                                        TriggerServerEvent("heidrun_selldrugs:SellDrug", l)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        ClearPedTasks(PlayerPedId())
                                        FreezeEntityPosition(Ped, false)
                                        ClearPedTasks(Ped)
                                    else
                                        Config.SendDispatch()
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        ClearPedTasks(PlayerPedId())
                                        FreezeEntityPosition(Ped, false)
                                        ClearPedTasks(Ped)
                                        ESX.ShowNotification(Config.Locales['offer_rejected'])
                                    end
                                else
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    ClearPedTasks(PlayerPedId())
                                    FreezeEntityPosition(Ped, false)
                                    ClearPedTasks(Ped)
                                    ESX.ShowNotification(Config.Locales['canceled'])
                                end
                            else
                                ESX.ShowNotification(Config.Locales['enough'] .. l)
                            end
                        else
                            ESX.ShowNotification(Config.Locales['nopolice'])
                        end
                    end)
                end
            },
        })
    end
end)
