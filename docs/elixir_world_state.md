# 🌍 Module 7: World State & Zones

## 🔍 Overview

The `WorldStateService` tracks entity locations, manages spatial zones, and facilitates spatial queries across the game world. It supports collision detection, prop interactions, and zone-specific logic.

---

## 📁 File Location

- **Path**: `app/services/world_state_service.py`
- **Main Class**: `WorldStateService`

---

## ⚙️ Initialization

```python
class WorldStateService:
    def __init__(self, width, height, zone_size):
        ...
```

- Sets up a 2D spatial grid using the given dimensions.
- `zone_size` defines the chunk unit, typically 16×16.

---

## 🗂️ Internal Data Structures

```python
self.entities = {}  # entity_id → entity
self.grid = defaultdict(set)  # (zone_x, zone_y) → entity_ids
```

Zones only track entity IDs; full data resides in `self.entities`.

---

## 🚀 Core Methods

| Method | Description |
|--------|-------------|
| `add_entity(entity, position)` | Adds the entity to tracking grid. |
| `move_entity(entity, new_position)` | Updates an entity's grid location. |
| `remove_entity(entity_id)` | Deregisters an entity completely. |
| `get_entities_in_zone(zone)` | Returns all entity IDs in a specific zone. |
| `get_entities_near(position, radius)` | Returns nearby entities based on radius. |

---

## 🧠 Spatial Example

```python
world.add_entity(goblin, (10, 5))
world.move_entity(player, (11, 5))
entities = world.get_entities_near((11, 5), radius=1)
```

Used for AI detection, combat triggers, or visibility checks.

---

## 🔄 Component Interactions

| Component | Purpose |
|----------|---------|
| `AIService` | Checks for nearby threats or allies. |
| `SyncService` | Retrieves player locations for updates. |
| `ContainerService` | Registers/despawns loot containers. |
| `SchedulerService` | Coordinates respawn or timed events. |

---

## 🧪 Testing

- Location: `tests/test_world_state_service.py`
- Confirms movement, zone tracking, and spatial radius queries.

---

## ✅ Summary

`WorldStateService` is the backbone of spatial logic in the game server. It powers proximity checks, efficient updates, and smooth gameplay interactions.

---

# 🌳 Prop System

## 🎯 Purpose

Handles world props—interactive or decorative objects placed in zones.

### Features

- Loads from JSON templates.
- Optional interactivity and state transitions.
- Supports collision detection and event hooks.

### JSON Format Example

```json
{
  "id": "tree_01",
  "name": "Oak Tree",
  "type": "scenery",
  "collision": { "type": "box", "width": 2.0, "height": 4.5, "depth": 2.0 },
  "position": { "x": 100, "y": 0, "z": 75 },
  "rotation": { "x": 0, "y": 90, "z": 0 },
  "interactable": false
}
```

Props load on zone initialization and optionally respond to events.

---

# 🚧 Collision System

## 🎯 Purpose

Manages physical boundaries and spatial blocking using AABB logic.

### Features

- AABB collision detection
- Collision profile per entity type
- Optimized with grid or quadtree partitioning
- Integrated with movement validation

### Example Shape

```json
{
  "collision": {
    "type": "box",
    "width": 1.0,
    "height": 2.0,
    "depth": 1.0
  }
}
```

Used in runtime to register entity or prop boundaries for movement checks.

---

# 🌐 WebSocket & API

### 🧠 WebSocket Commands
- `use_ability`

### 🔌 API Routes
- `/zones/{zone_id}/subscribe`
- `/zones/{zone_id}/unsubscribe`
- `/auth/register`
- `/auth/token`
- `/subscribe`
- `/unsubscribe`
- `/ws/dummy`
- `/entities/{eid}`
- `/entities`