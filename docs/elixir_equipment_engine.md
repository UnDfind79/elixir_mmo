# 🛡️ Elixir MMORPG – EquipmentEngine Module

## 🔍 Purpose

The `EquipmentEngine` handles player and entity equipment logic, managing stat updates, inventory swaps, and interaction with combat and item systems. It ensures equipped items modify stats consistently and emit real-time updates.

---

## 📁 Location

- `lib/mmorpg/services/equipment_engine.ex`

---

## ⚙️ Dependencies

| Module              | Role                                             |
|---------------------|--------------------------------------------------|
| `EventBus`          | Emits `:equipment_changed` and sync signals     |
| `PlayerInventory`   | To validate and transfer inventory items        |
| `ItemDefs`          | Source of equipment definitions and modifiers   |
| `CombatEngine`      | Reads current stats from modified entities      |

---

## 📊 Item Format

Each item must define:

```elixir
%{
  id: "leather_armor",
  slot: :chest,
  modifiers: %{defense: 5, max_hp: 10}
}
```

- `slot`: Atom like `:head`, `:chest`, `:weapon`, etc.
- `modifiers`: Map of stat deltas applied on equip

---

## 🔁 Core Functions

### `equip_item/2`

```elixir
@spec equip_item(Entity.t(), Item.t()) :: :ok | {:error, term()}
```

- Validates the item has a slot
- If a conflicting item exists, unequips it first
- Applies stat deltas to the entity
- Emits `:equipment_changed` for sync

---

### `unequip_item/2`

```elixir
@spec unequip_item(Entity.t(), atom()) :: :ok | {:error, :not_found}
```

- Removes item in a given slot
- Reverts all associated stat modifiers
- Emits event and restores item to inventory

---

## 🔄 Usage Flow

### On Equip:

1. `PlayerInventory` triggers `equip_item/2`
2. Modifiers are added to entity stats
3. Previous item (if any) is returned to inventory
4. `EventBus` emits `:equipment_changed`

### On Unequip:

1. Player calls `unequip_item/2`
2. Modifiers are subtracted from stats
3. Item is returned to inventory
4. Event is emitted for UI update

---

## 🧪 Testing Focus

- Modifier addition/subtraction edge cases
- Equip-over-slot handling
- Inventory overflow rejection

---

## ✅ Summary

`EquipmentEngine` controls stat-impacting gear mechanics with high determinism and server-authoritative logic. Its clean structure allows future additions like durability, enchantments, or class restrictions without impacting core systems.