local resourceName = GetCurrentResourceName()
local useEvent = 'Fox_stool:client:use'
local registeredFramework = nil

local function debugPrint(message)
    if Config.Debug then
        print(('[%s] %s'):format(resourceName, message))
    end
end

local function detectFramework()
    local configured = string.lower(Config.Framework or 'auto')

    if configured ~= 'auto' then
        return configured
    end

    if GetResourceState('rsg-core') == 'started' then
        return 'rsg'
    end

    if GetResourceState('vorp_inventory') == 'started' or GetResourceState('vorp_core') == 'started' then
        return 'vorp'
    end

    return 'standalone'
end

local function registerVorpItem()
    if GetResourceState('vorp_inventory') ~= 'started' then
        debugPrint('VORP detectado, aguardando vorp_inventory iniciar.')
        return false
    end

    exports.vorp_inventory:registerUsableItem(Config.Item.name, function(data)
        local src = data and data.source
        if not src then
            return
        end

        if Config.Item.consume then
            local itemId = data.item and (data.item.id or data.item.mainid)
            if itemId then
                exports.vorp_inventory:subItemById(src, itemId, nil, false, 1)
            else
                exports.vorp_inventory:subItem(src, Config.Item.name, 1)
            end
        end

        if Config.Item.closeInventory then
            exports.vorp_inventory:closeInventory(src)
        end

        TriggerClientEvent(useEvent, src)
    end, resourceName)

    registeredFramework = 'vorp'
    debugPrint(('Item VORP registrado: %s'):format(Config.Item.name))
    return true
end

local function ensureRsgItem(RSGCore)
    if RSGCore.Shared and RSGCore.Shared.Items and RSGCore.Shared.Items[Config.Item.name] then
        return true
    end

    local itemData = Config.Item.rsg
    if type(itemData) ~= 'table' then
        print(('[%s] Config.Item.rsg nao foi configurado para o item "%s".'):format(resourceName, Config.Item.name))
        return false
    end

    local definition = {
        name = Config.Item.name,
        label = itemData.label or Config.Item.name,
        weight = itemData.weight or 0,
        type = 'item',
        image = itemData.image or '',
        unique = itemData.unique == true,
        useable = true,
        shouldClose = itemData.shouldClose ~= false,
        description = itemData.description or ''
    }

    local ok, result, message = pcall(function()
        return RSGCore.Functions.AddItem(Config.Item.name, definition)
    end)

    if not ok then
        print(('[%s] Falha ao adicionar item RSG "%s": %s'):format(resourceName, Config.Item.name, tostring(result)))
        return false
    end

    if result == false then
        print(('[%s] RSG nao adicionou o item "%s": %s'):format(resourceName, Config.Item.name, tostring(message)))
        return false
    end

    debugPrint(('Item RSG adicionado ao Shared.Items: %s'):format(Config.Item.name))
    return true
end

local function registerRsgItem()
    if GetResourceState('rsg-core') ~= 'started' then
        debugPrint('RSG configurado, aguardando rsg-core iniciar.')
        return false
    end

    local RSGCore = exports['rsg-core']:GetCoreObject()
    if not RSGCore then
        return false
    end

    if not ensureRsgItem(RSGCore) then
        return false
    end

    RSGCore.Functions.CreateUseableItem(Config.Item.name, function(source, item)
        local Player = RSGCore.Functions.GetPlayer(source)
        if not Player then
            return
        end

        if Config.Item.consume then
            if GetResourceState('rsg-inventory') ~= 'started' then
                return
            end

            local removed = exports['rsg-inventory']:RemoveItem(
                source,
                Config.Item.name,
                1,
                item and item.slot or nil,
                resourceName .. '-used'
            )

            if not removed then
                return
            end
        end

        if Config.Item.closeInventory and GetResourceState('rsg-inventory') == 'started' then
            TriggerClientEvent('rsg-inventory:client:closeinv', source)
        end

        TriggerClientEvent(useEvent, source)
    end)

    registeredFramework = 'rsg'
    debugPrint(('Item RSG utilizavel registrado: %s'):format(Config.Item.name))
    return true
end

local function tryRegisterItem()
    if registeredFramework then
        return true
    end

    if not Config.Item.enabled or not Config.Item.name or Config.Item.name == '' then
        debugPrint('Item desativado no config.')
        return false
    end

    local framework = detectFramework()

    if framework == 'vorp' then
        return registerVorpItem()
    elseif framework == 'rsg' then
        return registerRsgItem()
    elseif framework == 'standalone' then
        debugPrint('Nenhum framework detectado. O comando continua disponivel.')
        return false
    end

    print(('[%s] Framework invalido em Config.Framework: %s'):format(resourceName, tostring(framework)))
    return false
end

CreateThread(function()
    for _ = 1, 20 do
        Wait(500)
        if tryRegisterItem() then
            return
        end
    end

    if Config.Item.enabled and not registeredFramework and detectFramework() ~= 'standalone' then
        print(('[%s] Nao foi possivel registrar o item "%s". Confira a ordem de ensure do framework/inventario.'):format(resourceName, Config.Item.name))
    end
end)

AddEventHandler('onResourceStart', function(startedResource)
    if registeredFramework or not Config.Item.enabled then
        return
    end

    if startedResource == 'rsg-core' or startedResource == 'vorp_core' or startedResource == 'vorp_inventory' then
        SetTimeout(500, tryRegisterItem)
    end
end)

AddEventHandler('onResourceStop', function(stoppedResource)
    if stoppedResource ~= resourceName then
        return
    end

    if registeredFramework == 'vorp' and GetResourceState('vorp_inventory') == 'started' then
        exports.vorp_inventory:unRegisterUsableItem(Config.Item.name)
    end
end)
