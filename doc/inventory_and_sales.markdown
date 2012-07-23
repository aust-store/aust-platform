## Inventory and Sales

A **InventoryItem** (current Good model) represents items in the store
inventory. It doesn't know
about __quantities__, __price__ or __cost__, but a concept about a good.

When items are added or subtracted, a register is made in the
**InventoryEntry** model. An Entry type can be either __In__ (when it got
into the inventory, inward) or __Out__ (when it left the inventory
due to a sale, for example, called outward).

For each Entry of type In, a new register is made in the
**InventoryEntryBalance** model. This register keeps cached the current
quantity of a given item in the inventory, or in other words, the difference
between the amount inward and outward movements in the inventory.

Each time an Entry of type Out is created, the InventoryEntryBalance is
updated, subtracting the current amount of a certain item in the inventory.

### Sales

Each **Order** contains many items, called **OrderItem** model.

Each order item is linked to a particular entry of type Out in the
InventoryEntry.
