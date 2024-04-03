local StackedSuffix = "-stacked"

local function IsStacked(name)
    return #StackedSuffix < #name and name:sub(-#StackedSuffix) == StackedSuffix
end

local function BatchConvertStackedItems(player, items)
    for _, item in ipairs(items) do
        player.get_main_inventory().remove(item)
        player.get_main_inventory().insert({name = item.name:sub(0, #item.name - #StackedSuffix), count = item.count * 4})
    end
end

local function on_player_main_inventory_changed(event)

    local player = game.players[event.player_index]
    local inv = player.get_main_inventory().get_contents()

    local itemsToConvert = {}

    for name, count in pairs(inv) do
        if IsStacked(name) then
            table.insert(itemsToConvert, {name = name, count = count})
        end
    end

    BatchConvertStackedItems(player, itemsToConvert)

end

script.on_event(defines.events.on_player_main_inventory_changed, on_player_main_inventory_changed)

local vectorTable = {
    [0] = {x = 0, y = -1},
    [2] = {x = 1, y = 0},
    [4] = {x = 0, y = 1},
    [6] = {x = -1, y = 0}
}

local function CreateLoaderTable(loaderEntity)
    local direction = (loaderEntity.direction + (loaderEntity.loader_type == "output" and 4 or 0)) % 8
    return {
        direction = direction,
        normal = vectorTable[direction],
        connectionPoint = {x = loaderEntity.position.x + vectorTable[direction].x, y = loaderEntity.position.y + vectorTable[direction].y},
        reference = loaderEntity
    }
end

local function ConnectLoader(entity)

    if not entity then return end
    local loader = CreateLoaderTable(entity)
    local findEntityResult = entity.surface.find_entity(entity.name, loader.connectionPoint)

    if not findEntityResult then return end
    local loaderToConnect = CreateLoaderTable(findEntityResult)

    if not (loader.normal.x + loaderToConnect.normal.x == 0 and loader.normal.y + loaderToConnect.normal.y == 0) then return end

    local pos = (loader.direction == 0 or loader.direction == 6) and loaderToConnect.reference.position or loader.reference.position
    entity.surface.create_entity{name = "stacker-entity", position = pos, direction = loader.direction, force = entity.force}
end

local function DisconnectLoaders(entity)
    
    if not entity then return end
    local loader = CreateLoaderTable(entity)

    local findEntityResult = entity.surface.find_entity("stacker-entity", loader.connectionPoint) or entity.surface.find_entity("stacker-entity", loader.reference.position)

    if not findEntityResult then return end
    findEntityResult.destroy()
end

local filter = {{filter = "type", type = "loader-1x1"}}

script.on_event(defines.events.on_built_entity,         function (event) ConnectLoader(event.created_entity) end, filter)
script.on_event(defines.events.on_robot_built_entity,   function (event) ConnectLoader(event.created_entity) end, filter)
script.on_event(defines.events.script_raised_built,     function (event) ConnectLoader(event.entity)         end, filter)
script.on_event(defines.events.script_raised_revive,    function (event) ConnectLoader(event.entity)         end, filter)

script.on_event(defines.events.script_raised_destroy,   function (event) DisconnectLoaders(event.entity) end, filter)
script.on_event(defines.events.on_player_mined_entity,  function (event) DisconnectLoaders(event.entity) end, filter)
script.on_event(defines.events.on_robot_mined_entity,   function (event) DisconnectLoaders(event.entity) end, filter)
script.on_event(defines.events.on_entity_died,          function (event) DisconnectLoaders(event.entity) end, filter)