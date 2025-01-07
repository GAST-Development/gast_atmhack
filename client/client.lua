local playerPed, playerCoords, Tablet
local PlayerJob = {}
local Hacked = {}

ESX = exports["es_extended"]:getSharedObject()

-- Pomocné funkcie na notifikácie
local function notifySuccess()
    lib.notify({
        title = 'Decryptomatic',
        description = 'Podarilo sa ti hacknuť bankomat.',
        type = 'success'
    })
end

local function notifyFailure()
    lib.notify({
        title = 'Decryptomatic',
        description = 'Nepodarilo sa ti hacknuť bankomat, utekaj!!!',
        type = 'error'
    })
end

-- Funkcia na detekciu, či je hráč pri ATM
local function isPlayerNearATM(playerCoords)
    for _, atmModel in ipairs(Config.ATMModelsString) do
        local hash = GetHashKey(atmModel)
        if IsObjectNearPoint(hash, playerCoords.x, playerCoords.y, playerCoords.z, 1.5) then
            return true, hash
        end
    end
    return false, nil
end

-- MiniGame pre otvorenie
local function openMiniGame()
    exports['gast_lib']:Scrambler(function(success)
        if success then
            notifySuccess()
            TriggerServerEvent("gast_atmhack:server:givecash")
            local chance = math.random()
            if chance < Config.Chance then
                TriggerEvent("gast_atmhack:policenotify")
            end
            TriggerServerEvent("gast_atmhack:server:removeitem", "hackcard")
            ClearPedTasks(playerPed)
            DeleteObject(Tablet)
        else
            notifyFailure()
            TriggerEvent("gast_atmhack:policenotify")
            TriggerServerEvent("gast_atmhack:server:removeitem", "hackcard")
            ClearPedTasks(playerPed)
            DeleteObject(Tablet)
        end
    end, "runes", 20, 1) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
end

-- Event pre začatie hackovania
CreateThread(function()
    exports.ox_target:addModel(Config.ATMModels, {
        {
            name = 'hack_atm',
            event = 'gast_atmhack:client:starthack',
            icon = 'fa-solid fa-tablet-screen-button',
            label = 'Hacknuť ATM',
            num = 1
        }
    })
end)

RegisterNetEvent('gast_atmhack:client:starthack')
AddEventHandler('gast_atmhack:client:starthack', function()
    ATMHack()
end)

RegisterNetEvent("gast_atmhack:policenotify")
AddEventHandler("gast_atmhack:policenotify", function()
    exports.tk_dispatch:addCall({
        title = 'Ozbrojená lúpež',
        code = '10-68',
        priority = 'Priority 3',
        coords = GetEntityCoords(PlayerPedId()),
        showLocation = true,
        showGender = true,
        playSound = true,
        blip = {
            color = 3,
            sprite = 357,
            scale = 1.0,
        },
        jobs = {'police', 'sheriff'}
    })
end)

-- Funkcia na hackovanie ATM
function ATMHack()
    playerPed = PlayerPedId()
    playerCoords = GetEntityCoords(playerPed, true)
    local nearATM = false
    local hackStarted = false
    local beenHacked = false

    local policeCount = (GlobalState.police or 0) + (GlobalState.sheriff or 0)
    
    -- Overenie počtu policajtov
    if policeCount >= Config.mincops then
        ESX.TriggerServerCallback("gast_atmhack:server:hasitem", function(hasItem)
            if hasItem then
                nearATM, atmHash = isPlayerNearATM(playerCoords)
                
                if nearATM then
                    local ATM = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 1.5, atmHash, false, false, false)

                    -- Skontroluj, či už ATM nebol hacknutý
                    for i = 1, #Hacked do
                        if Hacked[i] == ATM then
                            beenHacked = true
                        end
                    end

                    if not beenHacked then
                        -- Načítanie animácie a začatie hackovania
                        RequestAnimDict('amb@prop_human_atm@male@enter')
                        while not HasAnimDictLoaded('amb@prop_human_atm@male@enter') do
                            Citizen.Wait(5)
                        end

                        if HasAnimDictLoaded('amb@prop_human_atm@male@enter') then
                            TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@enter', "enter", 1.0,-1.0, 3000, 1, 1, true, true, true)
                            Citizen.Wait(1000)
                            Tablet = CreateObject(GetHashKey("hei_prop_dlc_tablet"), 0, 0, 0, true, true, true)
                            AttachEntityToEntity(Tablet, playerPed, GetPedBoneIndex(playerPed, 18905), 0.20, 0.12, 0.05, 58.0, 122.0, 180.0, true, true, false, true, 1, true)
                            RequestAnimDict('missfam4')

                            while not HasAnimDictLoaded('missfam4') do
                                Citizen.Wait(5)
                            end

                            if HasAnimDictLoaded('missfam4') then
                                TaskPlayAnim(playerPed, "missfam4", "base", 1.0, 4.0, -1, 33, 0.0, false, false, false)
                                Citizen.Wait(2000)
                            end
                        end

                        -- Pridanie ATM do zoznamu hacknutých
                        table.insert(Hacked, ATM)
                        openMiniGame()
                    else
                        lib.notify({
                            title = 'Decryptomatic',
                            description = 'Niekto už hackol tento bankomat pred tebou.',
                            type = 'error'
                        })
                    end
                else
                    lib.notify({
                        title = 'Decryptomatic',
                        description = 'Nie si pri ATM.',
                        type = 'error'
                    })
                end
            else
                lib.notify({
                    title = 'Decryptomatic',
                    description = 'Niečo ti chýba.',
                    type = 'error'
                })
            end
        end, 'decryptomatic', 'hackcard')
    else
        lib.notify({
            title = 'Decryptomatic',
            description = 'Práve nieje vhodný čas na vykradanie.',
            type = 'error'
        })
    end
end
