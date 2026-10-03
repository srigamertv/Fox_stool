Config = {}

-- auto = detecta VORP/RSG automaticamente.
-- Tambem aceita: 'vorp', 'rsg' ou 'standalone'.
Config.Framework = 'auto'

Config.Command = {
    enabled = true,
    name = 'banquinho'
}

Config.Item = {
    enabled = true,
    name = 'banquinho',
    consume = false,
    closeInventory = true,

    -- No RSG o item pode ser adicionado ao Shared.Items automaticamente.
    rsg = {
        label = 'Banquinho',
        weight = 500,
        image = 'banquinho.png',
        unique = false,
        shouldClose = true,
        description = 'Um banquinho portátil para sentar em qualquer lugar.'
    }
}

Config.Stool = {
    model = 's_stoolfoldingstatic01x',
    scenario = 'PROP_HUMAN_SEAT_CHAIR_SMOKE_ROLL',
    groundOffset = 0.48,
    spawnDelay = 2500,
    pelvisBone = 11816,
    attachOffset = { x = 0.0, y = 0.0, z = -0.5 },
    attachRotation = { x = 0.0, y = 0.0, z = 0.0 }
}

Config.Debug = false
