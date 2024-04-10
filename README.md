# Stacked-Items
Stacking Mod for Factorio

The Stacked-Items mod allows you to stack items efficiently by setting two loaders facing each other, optimizing space on belts by 4x. It is initially compatible with AAI Loaders, with plans for integration with other loader mods.

## Compatibility Mod(s)
- Space Exploration: [se-stacked-items](https://mods.factorio.com/mod/se-stacked-items)

## Testing and Feedback
This mod is currently in the testing phase, and your feedback is invaluable. Please report any bugs or suggest improvements via our GitHub repository or Factorio's Mod Portal page. Your input will help enhance the mod for everyone.

- GitHub Repository: [MonoToast/Stacked-Items](https://github.com/MonoToast/Stacked-Items)
- Mod Portal: [Stacked-Items](https://mods.factorio.com/mod/stacked-items)

## Contribute to Compatibility
To extend the stacking functionality to other mods, follow these steps:

1. Add this mod and the target mod as dependencies.
2. Use the provided API functions to enable stacking for the desired items or groups.

API Functions:
- `StackedItemsAPI.MakeItemGroupStackable(data.ItemPrototype item)`: Activate stacking for item groups, corresponding to crafting menu tabs.
- `StackedItemsAPI.MakeItemSubgroupStackable(data.ItemSubGroupID subgroup)`: Enable stacking for subgroups rows within the tabs.
- `StackedItemsAPI.MakeItemStackable(data.ItemGroupID group)`: Apply stacking to individual items.
