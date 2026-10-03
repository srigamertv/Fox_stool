local stoolObject = nil
local creatingStool = false
local useEvent = 'Fox_stool:client:use'

local function debugPrint(message)
    if Config.Debug then
        print(('[%s] %s'):format(GetCurrentResourceName(), message))
    end
end

local function loadModel(modelHash)
    if HasModelLoaded(modelHash) then
        return true
    end

    if not IsModelValid(modelHash) then
        debugPrint(('Invalid stool model: %s'):format(Config.Stool.model))
        return false
    end

    RequestModel(modelHash)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() > timeout then
            debugPrint(('Timed out loading stool model: %s'):format(Config.Stool.model))
            return false
        end
        Wait(50)
    end

    return true
end

local function removeStool()
    local playerPed = PlayerPedId()

    creatingStool = false
    ClearPedTasksImmediately(playerPed)
    Citizen.InvokeNative(0xE1EF3C1216AFF2CD, playerPed, 0, 0)
    Wait(100)

    if stoolObject and DoesEntityExist(stoolObject) then
        DetachEntity(stoolObject, false, false)
        SetEntityAsMissionEntity(stoolObject, true, true)
        DeleteObject(stoolObject)

        if DoesEntityExist(stoolObject) then
            DeleteEntity(stoolObject)
        end
    end

    stoolObject = nil
end

local function createStool()
    if creatingStool then
        return
    end

    if stoolObject and DoesEntityExist(stoolObject) then
        return
    end

    creatingStool = true

    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then
        creatingStool = false
        return
    end

    local coords = GetEntityCoords(playerPed)
    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)

    if not foundGround then
        groundZ = coords.z
    end

    local stoolZ = groundZ + Config.Stool.groundOffset
    local heading = GetEntityHeading(playerPed)
    local modelHash = GetHashKey(Config.Stool.model)
    local scenarioHash = GetHashKey(Config.Stool.scenario)

    if not loadModel(modelHash) then
        creatingStool = false
        return
    end

    TaskStartScenarioAtPosition(
        playerPed,
        scenarioHash,
        coords.x,
        coords.y,
        stoolZ,
        heading,
        -1,
        true,
        true
    )

    Wait(Config.Stool.spawnDelay)

    if not creatingStool then
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    stoolObject = CreateObject(modelHash, coords.x, coords.y, stoolZ, true, true, true)

    if stoolObject and stoolObject ~= 0 and DoesEntityExist(stoolObject) then
        SetEntityAsMissionEntity(stoolObject, true, true)
        SetEntityCollision(stoolObject, false, true)
        SetEntityVisible(stoolObject, true, false)

        local pelvisBone = GetPedBoneIndex(playerPed, Config.Stool.pelvisBone)

        AttachEntityToEntity(
            stoolObject,
            playerPed,
            pelvisBone,
            Config.Stool.attachOffset.x,
            Config.Stool.attachOffset.y,
            Config.Stool.attachOffset.z,
            Config.Stool.attachRotation.x,
            Config.Stool.attachRotation.y,
            Config.Stool.attachRotation.z,
            true,
            true,
            false,
            true,
            1,
            true
        )
    else
        stoolObject = nil
        ClearPedTasksImmediately(playerPed)
    end

    SetModelAsNoLongerNeeded(modelHash)
    creatingStool = false
end

local function toggleStool()
    if creatingStool then
        return
    end

    if stoolObject and DoesEntityExist(stoolObject) then
        removeStool()
        return
    end

    createStool()
end

RegisterNetEvent(useEvent, toggleStool)

if Config.Command.enabled and Config.Command.name ~= '' then
    RegisterCommand(Config.Command.name, toggleStool, false)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    removeStool()
end)
