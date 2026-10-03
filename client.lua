local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isInTowVehicle = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 then
            local vehicleModel = GetEntityModel(vehicle)
            
            for _, towVehicle in ipairs(Config.TowableVehicles) do
                if GetHashKey(towVehicle) == vehicleModel then
                    isInTowVehicle = true
                    break
                else
                    isInTowVehicle = false
                end
            end
        else
            isInTowVehicle = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        if isInTowVehicle then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            
            if vehicle ~= 0 and not IsPedInAnyVehicle(playerPed, false) then
                TriggerServerEvent('towMoneyScript:checkTow')
            end
        end
    end
end)