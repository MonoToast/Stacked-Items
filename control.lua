local function IsStacked(name)
    return  #"-stacked" < #name and string.sub(name, -#"-stacked") == "-stacked"
end

local function BatchInsertInventory(player, items)
    for _, item in ipairs(items) do
        player.get_main_inventory().insert(item)
    end
end

local function BatchRemoveInventory(player, items)
    for _, item in ipairs(items) do
        player.get_main_inventory().remove(item)
    end
end

local function on_player_main_inventory_changed(event)

    local player = game.players[event.player_index]
    local inv = player.get_main_inventory().get_contents()

    local itemsToRemove = {}
    local itemsToInsert = {}

    for name, count in pairs(inv) do
        if IsStacked(name) then
            table.insert(itemsToRemove, {name = name, count = count})
            table.insert(itemsToInsert, {name = string.sub(name, 1, #name - #"-stacked"), count = count * 4})
        end
    end

    BatchRemoveInventory(player, itemsToRemove)
    BatchInsertInventory(player, itemsToInsert)

end

script.on_event(defines.events.on_player_main_inventory_changed, on_player_main_inventory_changed)

local DirectionTable = {
    ["input0"] =  { ConnectedPos = function (p) return {x = p.x + 0, y = p.y - 1} end, IsConnected = function (d) return d == "output0" or d == "input4" end }, --north
    ["input2"] =  { ConnectedPos = function (p) return {x = p.x + 1, y = p.y + 0} end, IsConnected = function (d) return d == "output2" or d == "input6" end }, --east
    ["input4"] =  { ConnectedPos = function (p) return {x = p.x + 0, y = p.y + 1} end, IsConnected = function (d) return d == "output4" or d == "input0" end }, --south
    ["input6"] =  { ConnectedPos = function (p) return {x = p.x - 1, y = p.y + 0} end, IsConnected = function (d) return d == "output6" or d == "input2" end }, --west
    ["output0"] = { ConnectedPos = function (p) return {x = p.x + 0, y = p.y + 1} end, IsConnected = function (d) return d == "output4" or d == "input0" end }, --south
    ["output2"] = { ConnectedPos = function (p) return {x = p.x - 1, y = p.y + 0} end, IsConnected = function (d) return d == "output6" or d == "input2" end }, --west
    ["output4"] = { ConnectedPos = function (p) return {x = p.x + 0, y = p.y - 1} end, IsConnected = function (d) return d == "output0" or d == "input4" end }, --north
    ["output6"] = { ConnectedPos = function (p) return {x = p.x + 1, y = p.y + 0} end, IsConnected = function (d) return d == "output2" or d == "input6" end }, --east
}

local SpawnPointTable = {
    ["input0"] =  {SpawnPoint = function (p) return {x = p.x + 0, y = p.y - 1} end},
    ["input2"] =  {SpawnPoint = function (p) return {x = p.x + 0, y = p.y + 0} end},
    ["input4"] =  {SpawnPoint = function (p) return {x = p.x + 0, y = p.y + 0} end},
    ["input6"] =  {SpawnPoint = function (p) return {x = p.x - 1, y = p.y + 0} end},
    ["output0"] = {SpawnPoint = function (p) return {x = p.x + 0, y = p.y + 0} end},
    ["output2"] = {SpawnPoint = function (p) return {x = p.x - 1, y = p.y + 0} end},
    ["output4"] = {SpawnPoint = function (p) return {x = p.x + 0, y = p.y - 1} end},
    ["output6"] = {SpawnPoint = function (p) return {x = p.x + 0, y = p.y + 0} end},
}

--- func desc
---@param entity LuaEntity
local function TryToConnectLoaders(entity)
    local directionData = DirectionTable[entity.loader_type .. entity.direction]
    if not directionData then return end

    local connected = entity.surface.find_entity(entity.name, directionData.ConnectedPos(entity.position))
    if not connected then return end

    if not directionData.IsConnected(connected.loader_type .. connected.direction) then return end

    local stacker = entity.surface.create_entity{name = "stacker-entity", position = SpawnPointTable[entity.loader_type .. entity.direction].SpawnPoint(entity.position), direction = entity.direction, force = entity.force}
end

local function TryToDisconnectLoaders(entity)
    local directionData = DirectionTable[entity.loader_type .. entity.direction]
    if not directionData then return end

    local connected = entity.surface.find_entity(entity.name, directionData.ConnectedPos(entity.position))
    if not connected then return end

    if not directionData.IsConnected(connected.loader_type .. connected.direction) then return end

    local stacker = entity.surface.find_entity("stacker-entity", SpawnPointTable[entity.loader_type .. entity.direction].SpawnPoint(entity.position))
    stacker.destroy()
end

local function on_built_entity(event) TryToConnectLoaders(event.created_entity) end
local function on_robot_built_entity(event) TryToConnectLoaders(event.created_entity) end

local function on_player_mined_entity(event) TryToDisconnectLoaders(event.entity) end
local function on_robot_mined_entity(event) TryToDisconnectLoaders(event.entity) end


script.on_event(defines.events.on_built_entity, on_built_entity, {{filter = "type", type = "loader-1x1"}})
script.on_event(defines.events.on_player_mined_entity, on_player_mined_entity, {{filter = "type", type = "loader-1x1"}})
script.on_event(defines.events.on_robot_built_entity, on_robot_built_entity, {{filter = "type", type = "loader-1x1"}})
script.on_event(defines.events.on_robot_mined_entity, on_robot_mined_entity, {{filter = "type", type = "loader-1x1"}})