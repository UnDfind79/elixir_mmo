# 🗃️ Elixir MMORPG – ContainerEngine Module

## 🔍 Purpose

The `ContainerEngine` module manages interactive containers in the world, such as ground loot piles or treasure chests. It integrates tightly with loot generation, scheduling, and zone entity tracking.

---

## 📁 Location

- `lib/mmorpg/services/container_engine.ex`

---

## ⚙️ Core Responsibilities

- Spawn new containers with loot
- Track container state within a zone layer
- Handle timed despawn and respawn
- Broadcast events for container changes

---

## 🔧 Module Interface

```elixir
@spec create_container(Zone.id(), {float(), float()}, [String.t()], keyword()) :: String.t()
```
Creates a new container with items at the given position. Optional `:respawn_in` (in seconds) schedules a future respawn.

```elixir
@spec remove_container(Zone.id(), String.t()) :: :ok
```
Removes the container from the world and emits a `:container_removed` event.

```elixir
@spec open_container(Player.t(), Zone.id(), String.t()) :: {:ok, [String.t()]} | {:error, :not_found}
```
Opens a container, grants the player the contents, removes the container, and optionally schedules a respawn.

```elixir
@spec schedule_respawn(Zone.id(), map(), integer()) :: :ok
```
Schedules re-creation of a container based on its previous state after a delay.

---

## 🔁 Lifecycle Flow

1. A mob dies and drops loot.
2. `ContainerEngine.create_container/4` places the items on the map.
3. Player interacts using `open_container/3`.
4. The container disappears.
5. If applicable, it is re-created later via `schedule_respawn/3`.

---

## 🔄 Interactions

| Module             | Description                                 |
|--------------------|---------------------------------------------|
| `LootEngine`       | Supplies item list on mob death             |
| `ZoneServer`       | Stores and manages container entity state   |
| `EventBus`         | Emits `:container_created` and `:container_removed` |
| `Scheduler`        | Handles timed respawn with reference        |
| `PlayerInventory`  | Receives items when opened                  |

---

## 🧪 Testing Focus

- Container visibility across connected clients
- Item delivery on `open_container/3`
- Accurate re-creation from `schedule_respawn/3`

---

## ✅ Summary

`ContainerEngine` is a critical system for real-time interaction with world loot. It decouples lifecycle, spatial logic, and player impact while ensuring server consistency and UI update hooks.