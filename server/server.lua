ESX = exports["es_extended"]:getSharedObject()

local function getPlayer(source)
    return ESX.GetPlayerFromId(source)
end

-- Event na odstránenie položky
RegisterServerEvent("gast_atmhack:server:removeitem")
AddEventHandler("gast_atmhack:server:removeitem", function(item)
    local xPlayer = getPlayer(source)
    xPlayer.removeInventoryItem(item, 1)
end)

-- Event na pridanie peňazí
RegisterNetEvent('gast_atmhack:server:givecash')
AddEventHandler('gast_atmhack:server:givecash', function()
    local xPlayer = getPlayer(source)
    local randomMoney = math.random(Config.MinWithdrawl, Config.MaxWithdrawal)
    xPlayer.addAccountMoney(Config.Account, randomMoney)
end)

-- Server callback na kontrolu položiek
ESX.RegisterServerCallback('gast_atmhack:server:hasitem', function(source, cb, item1, item2)
    local xPlayer = getPlayer(source)

    -- Zjednodušená kontrola existencie položiek
    local hasItems = (xPlayer.getInventoryItem(item1).count > 0) and (xPlayer.getInventoryItem(item2).count > 0)
    
    cb(hasItems)
end)
