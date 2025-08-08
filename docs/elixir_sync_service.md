
# 🌐 Module 5: Sync Layer (Elixir Version)

## 🔍 Purpose

The Sync Layer keeps all connected clients in sync with the authoritative server state. It listens to game events and distributes changes to relevant player processes.

---

## 📦 Module

- **File**: `lib/mmorpg/sync/sync_service.ex`
- **Module**: `MMORPG.Sync.SyncService`

---

## ⚙️ Initialization

```elixir
defmodule MMORPG.Sync.SyncService do
  use GenServer
  alias MMORPG.{Events.Dispatcher, World.WorldState, Session.SessionManager}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(%{world: world, dispatcher: dispatcher, session_manager: session_manager}) do
    Dispatcher.register("EntityMovedEvent", &handle_entity_moved/1)
    Dispatcher.register("ItemUsedEvent", &handle_item_used/1)
    {:ok, %{world: world, dispatcher: dispatcher, session_manager: session_manager}}
  end
end
```

---

## 🧠 Core Responsibilities

| Function              | Description                                           |
|-----------------------|-------------------------------------------------------|
| `handle_entity_moved/1` | Broadcasts position changes to nearby players         |
| `handle_item_used/1`    | Sends effect info to affected player                 |
| `send_to_player/2`      | Sends targeted update to a specific session          |
| `broadcast_to_zone/2`   | Broadcasts update to all sessions in a zone          |

---

## 🔁 Event Listeners

These are callback functions registered via `EventDispatcher`.

### Entity Movement
```elixir
def handle_entity_moved(%{"entity_id" => id, "position" => pos}) do
  payload = %{
    "type" => "EntityMoved",
    "entity_id" => id,
    "position" => pos
  }

  MMORPG.Session.SessionManager.broadcast_to_zone(pos["zone_id"], payload)
end
```

### Item Used
```elixir
def handle_item_used(%{"player_id" => id, "item" => item}) do
  payload = %{
    "type" => "ItemUsed",
    "item" => item
  }

  MMORPG.Session.SessionManager.send_to_player(id, payload)
end
```

---

## 🔌 Integration

| Service         | Usage                                                   |
|------------------|----------------------------------------------------------|
| `Dispatcher`     | Subscribes to gameplay events                            |
| `SessionManager` | Handles WebSocket connections and zone broadcasts        |
| `WorldState`     | Provides zone/entity context for filtering broadcasts    |

---

## 🧪 Testing

Suggested test module: `test/mmorpg/sync/sync_service_test.exs`

- Simulate dispatcher events
- Assert expected session message dispatches
- Test zone-wide vs targeted communication logic

---

## ✅ Summary

`SyncService` listens for world and entity changes and communicates them over player sockets. It is essential for real-time multiplayer synchronization.
