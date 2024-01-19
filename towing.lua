local towingService = false
local towedVehicle = nil

RegisterCommand("tow", function()
    if not towingService then 
        StartTowingService()
    else
        StopTowingService()
    end
end, false)

function StartTowingService()
    towingService = true
    TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Towing has started, get in the tow truck and approach the vehicle you want to tow")
end

function StopTowingService()
    towingService = false
    towedVehicle = nil
    TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Towing has stopped")
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        if towingService then
            local playerPed = PlayerPedId(-1)
            local vehicle = GetVehicleInfront()

            if IsPedInAnyVehicle(plauerPed, false) and IsVehicleTowTruch(vehicle) and not IsVehicleBeingTowed(vehicle) then
                if towedVehicle == nil then
                    if IsControlJustPressed(0, 38) then 
                        DetachVehicleFromTowTruck(towedVehicle)
                        TriggerEvent("chatMessage", "Towing Service", {255, 0, 0}, "Vehicle released!")
                        towedVehicle = nil 
                    end
                end
            end
        end
    end
end)

function GetVehicleInFront()
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)
    local entityHit, _, coords, _, vehicle = RayCastVehicle(pos.x, pos.y, pos.z, pos.x + 10.0, pos.y + 10.0, pos.z + 10.0)

    return vehicle
end

function IsVehicleTowTruck(vehicle)
    local model = GetEntityModel(vehicle)
    return model == GetHashKey("flatbed")
end

function RayCastVehicle(x1, y1, z1, x2, y2, z2)
    local rayHandle = StartShapeTestRay(x1, y1, z1, x2, y2, z2, 10, 0, 0)
    local _, _, _, _, entity = GetShapeTestResult(rayHandle)

    return entity
end