# 🎁 Elixir MMORPG Server – LootEngine Module

## 🔍 Purpose

`LootEngine` handles all randomized item generation when NPCs, containers, or other sources are interacted with. It operates on structured loot tables and applies weighted selection logic.

---

## 📁 Location

- `lib/mmorpg/services/loot_engine.ex`

---

## ⚙️ Dependencies

| Module               | Purpose                                      |
|----------------------|----------------------------------------------|
| `Mmorpg.ItemDefs`    | Item definition metadata                     |
| `Mmorpg.Container`   | For loot container population (optional)     |
| `EnumUtils`          | Utility for weighted random selection        |

---

## 📊 Loot Table Format

Tables are defined statically or loaded from data files:

```elixir
%{
  "goblin" => [
    %{item_id: "potion_health_small", weight: 0.5},
    %{item_id: "coin", weight: 0.3},
    %{item_id: "dagger_rusty", weight: 0.2}
  ]
}
```

---

## 🔁 Core Functions

### `generate_loot/1`

```elixir
@spec generate_loot(String.t()) :: [String.t()]
```

- Pulls entries from loot table by source ID (e.g. "goblin")
- Applies weighted selection to determine drop set
- Returns list of item IDs

---

### `drop_loot/2`

```elixir
@spec drop_loot(String.t(), pid()) :: :ok
```

- Uses `generate_loot/1` to create a loot list
- Sends items to `ContainerServer` (if container exists) or into inventory
- Emits event `:loot_generated`

---

### `define_loot_table/2`

```elixir
@spec define_loot_table(String.t(), [map()]) :: :ok
```

- Dynamically defines/overrides a loot table during runtime

---

## 🧪 Testing

- `loot_engine_test.exs` ensures:
  - Proper weight-based selection
  - Container or direct drop logic
  - Runtime-defined loot tables

---

## ➕ Related Functions

- `test_loot_drop/0`: Simulates goblin death and verifies loot is correct
- `define_loot_table/2`: Registers new loot source
- `drop_loot/2`: Handles actual in-world placement or reward

---

## ✅ Summary

`LootEngine` encapsulates all loot generation using deterministic and randomized rules. It supports monsters, static containers, and scripted encounters with flexible probability models.