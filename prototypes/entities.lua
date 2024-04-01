data:extend({
    {
        type = "furnace",
        name = "stacker-entity",
        icon = "__stacked-items__/graphics/1x1DevGraphics.png",
        icon_size = 32,
        flags = {"placeable-neutral", "placeable-player", "player-creation", "hide-alt-info"},
        collision_box = {{-0.5, -1}, {0.5, 1}},
        collision_mask = {"item-layer", "object-layer", "water-tile", "colliding-with-tiles-only"},
        crafting_categories = {"stack-item"},
        result_inventory_size = 1,
        energy_usage = "90kW",
        crafting_speed = 240,
        source_inventory_size = 1,
        energy_source = {type = "void"},
    },
})