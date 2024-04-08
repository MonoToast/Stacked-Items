data:extend({
    {
        type = "recipe-category",
        name = "stack-item"
    }
})

StackedItemsAPI = { }

local function IsStacked(name)
    return  #"-stacked" < #name and string.sub(name, -#"-stacked") == "-stacked"
end

---@param item data.ItemPrototype
function StackedItemsAPI.MakeItemStackable(item)
    if IsStacked(item.name) then return end
    if item.stack_size < 4 then return end
    data:extend({
        {
            type = "item",
            name = item.name .. "-stacked",
            icon_size = item.icon_size,
            icon_mipmaps = item.icon_mipmaps,
            stack_size = 1,
            order = item.order,
            subgroup = item.subgroup,
            icons = {
                {icon = item.icon, shift = {0,  6}},
                {icon = item.icon, shift = {0,  3}},
                {icon = item.icon, shift = {0,  0}},
                {icon = item.icon, shift = {0, -3}},
            },
            localised_name = {"", {"item-name." .. item.name}},
            dark_background_icon = item.dark_background_icon
        },
        {
            type = "recipe",
            name = item.name .. "-stack",
            category = "stack-item",
            energy_required = 8,
            hidden = true,
            hide_from_stats = true,
            hide_from_player_crafting = true,
            allow_decomposition = false,
            ingredients = {{item.name, 8}},
            result = item.name .. "-stacked",
            result_count = 2
        },
        {
            type = "recipe",
            name = item.name .. "-unstack",
            category = "stack-item",
            energy_required = 8,
            hidden = true,
            hide_from_player_crafting = true,
            allow_decomposition = false,
            ingredients = {{item.name .. "-stacked", 2}},
            result = item.name,
            result_count = 8
        }
    })
end

---@param subgroup data.ItemSubGroupID
function StackedItemsAPI.MakeItemSubroupStackable(subgroup)
    local items = data.raw["item"]
    for key, value in pairs(items) do
        if value.subgroup == subgroup then
            StackedItemsAPI.MakeItemStackable(value)
        end
    end
end


---@param group data.ItemGroupID
function StackedItemsAPI.MakeItemGroupStackable(group)
    for key, value in pairs(data.raw["item-subgroup"]) do
        if value.group == group then
            StackedItemsAPI.MakeItemSubroupStackable(value.name)
        end
    end
end

StackedItemsAPI.MakeItemSubroupStackable("intermediate-product")
StackedItemsAPI.MakeItemSubroupStackable("raw-material")
StackedItemsAPI.MakeItemSubroupStackable("raw-resource")
StackedItemsAPI.MakeItemSubroupStackable("terrain")