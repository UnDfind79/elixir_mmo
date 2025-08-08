
# 🧳 Elixir MMORPG Server – ItemEngine Module

## 🔍 Purpose

`ItemEngine` manages all player-item interactions in the game, including inventory addition, removal, and usage (potions, buffs, etc.). It is event-driven and interacts with entity processes for application of item effects.

---

## 📁 Location

- `lib/mmorpg/services/item_engine.ex`

---

## ⚙️ Dependencies

| Module             | Purpose                                              |
|--------------------|------------------------------------------------------|
| `Mmorpg.EventBus`  | Emits `:item_used` and `:inventory_changed` events   |
| `EntityServer`     | Updates entity stats and inventory                   |
| `ItemDefs`         | Static item metadata store                           |

---

## 📦 Inventory Functions

### `add_item_to_inventory/2`

```elixir
@spec add_item_to_inventory(pid(), String.t()) :: :ok | {:error, :full}
```

- Adds item to player's inventory if there is space
- Emits `:inventory_changed`

---

### `remove_item_from_inventory/2`

```elixir
@spec remove_item_from_inventory(pid(), String.t()) :: :ok | {:error, :not_found}
```

- Removes one instance of item from inventory
- Emits `:inventory_changed`

---

## 🍷 Item Usage

### `use_item/2`

```elixir
@spec use_item(pid(), String.t()) :: :ok | {:error, :invalid}
```

- Checks item effect from `ItemDefs`
- Applies effect to target (via `EntityServer`)
- If `consumable`, removes item
- Emits `:item_used` and `:inventory_changed`

---

## 📊 Item Definition (from `ItemDefs`)

```elixir
%{
  id: "potion_health_small",
  name: "Small Health Potion",
  type: :consumable,
  effect: %{restore_hp: 25},
  consumable: true
}
```

---

## 🧠 Logic Flow

1. Call `ItemEngine.use_item(player_pid, item_id)`
2. Get effect data from `ItemDefs`
3. Apply effect (e.g., restore HP)
4. Remove item if marked `consumable: true`
5. Emit events

---

## 🔄 Events Emitted

| Event Name         | Trigger                                   |
|--------------------|--------------------------------------------|
| `:item_used`       | Successful use of item                    |
| `:inventory_changed` | Addition or removal of items             |

---

## 🧪 Testing

- Found in `item_engine_test.exs`
- Covers:
  - Item use flow
  - Missing items
  - Full inventory

---

## ➕ Additional Functions

### `define_item/1`
Registers custom items into `ItemDefs` dynamically

### `give_item/2`
Convenience helper to add an item and notify player

---

## ✅ Summary

`ItemEngine` is the server’s authoritative handler for all in-game items. It validates usage rules, resolves effects, and emits state change events for inventory syncing.

