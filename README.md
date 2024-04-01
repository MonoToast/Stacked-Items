# Stacked-Items
Stacking Mod for Factorio

This mod allows you to set two loaders facing each other to stack items efficiently, optimizing space on belts by 4x. Initially compatible with AAI Loaders, with plans for integration with other loader mods.

# Compatibility Mod(s):
Space Exploration: [Insert URL]

# Testing and Feedback:
This mod is in the testing phase, and your feedback is invaluable. Please report any bugs or suggest improvements via our GitHub page. Your input will help enhance the mod for everyone.
Github: 

# Contribute to Compatibility:
To extend stacking functionality to other mods, add this mod and the target mod as dependencies. Then, use the provided API functions to enable stacking for the desired items or groups.

StackedItemsAPI.MakeItemGroupStackable(data.ItemPrototype item)         Activate stacking for item groups, corresponding to crafting menu tabs.

StackedItemsAPI.MakeItemSubgroupStackable(data.ItemSubGroupID subgroup) Enable stacking for subgroups rows within the tabs.

StackedItemsAPI.MakeItemStackable(data.ItemGroupID group)               Apply stacking to individual items.
