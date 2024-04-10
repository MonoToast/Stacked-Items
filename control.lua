local function updateStackedItems(playerIndex)
    local playerInventory = game.players[playerIndex].get_main_inventory()

    if not playerInventory then return end

    for i = 1, #playerInventory do
        local item = playerInventory[i]
        if item and item.valid_for_read and string.match(item.name, "-stacked$") then
            local baseItemName = item.name:sub(1, -#"-stacked" - 1)
            item.set_stack({name = baseItemName, count = item.count * 4})
        end
    end
end

local vectorTable = {
    [0] = {x = 0, y = -1},
    [2] = {x = 1, y = 0},
    [4] = {x = 0, y = 1},
    [6] = {x = -1, y = 0}
}

local function handleStackerEntity(placedLoader, isCreate)
    if not placedLoader or not placedLoader.valid then return end

    local placedDirection = (placedLoader.direction + (placedLoader.loader_type == "output" and 4 or 0)) % 8
    local connectionLoader = placedLoader.surface.find_entity(placedLoader.name, {x = placedLoader.position.x + vectorTable[placedDirection].x, y = placedLoader.position.y + vectorTable[placedDirection].y})

    if not connectionLoader then return end
    local connectionDirection = (connectionLoader.direction + (connectionLoader.loader_type == "output" and 4 or 0)) % 8

    if (((placedDirection + 4) % 8) - connectionDirection) ~= 0 then return end

    local middlePosition = {
        x = (placedLoader.position.x + vectorTable[placedDirection].x + connectionLoader.position.x + vectorTable[connectionDirection].x) / 2,
        y = (placedLoader.position.y + vectorTable[placedDirection].y + connectionLoader.position.y + vectorTable[connectionDirection].y) / 2
    }

    if isCreate then
        placedLoader.surface.create_entity{
            name = "stacker-entity",
            position = middlePosition,
            direction = placedDirection,
            force = placedLoader.force
        }
    else
        local stackerEntity = placedLoader.surface.find_entity("stacker-entity", middlePosition)
        if stackerEntity then stackerEntity() end
    end
end

local filter = {{filter = "type", type = "loader-1x1"}}

script.on_event(defines.events.on_player_main_inventory_changed, updateStackedItems)

script.on_event(defines.events.on_built_entity, function(event) handleStackerEntity(event.created_entity, true) end, filter)
script.on_event(defines.events.on_robot_built_entity, function(event) handleStackerEntity(event.created_entity, true) end, filter)
script.on_event(defines.events.script_raised_built, function(event) handleStackerEntity(event.entity, true) end, filter)
script.on_event(defines.events.script_raised_revive, function(event) handleStackerEntity(event.entity, true) end, filter)

script.on_event(defines.events.script_raised_destroy, function(event) handleStackerEntity(event.entity, false) end, filter)
script.on_event(defines.events.on_player_mined_entity, function(event) handleStackerEntity(event.entity, false) end, filter)
script.on_event(defines.events.on_robot_mined_entity, function(event) handleStackerEntity(event.entity, false) end, filter)
script.on_event(defines.events.on_entity_died, function(event) handleStackerEntity(event.entity, false) end, filter)