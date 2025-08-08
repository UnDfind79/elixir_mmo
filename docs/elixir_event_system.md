# 📣 Elixir MMORPG – Event System

## 📌 Purpose
The Event System serves as the backbone for decoupled communication in the Elixir MMORPG server. It allows services to emit and handle game events without tight coupling using Elixir’s native PubSub and message passing patterns.

---

## 📁 Module Overview

| Component           | Type       | Responsibility                                      |
|---------------------|------------|------------------------------------------------------|
| `Game.EventBus`     | PubSub     | PubSub dispatcher module                            |
| `Game.EventHandler` | Behaviour  | Standard interface for event listeners              |
| `Game.Events.*`     | Structs    | Typed data for known events (`CombatEvent`, etc.)   |

---

## ⚙️ Implementation

### 1. `Game.EventBus`

```elixir
defmodule Game.EventBus do
  use GenServer

  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def emit(event_type, payload) do
    Phoenix.PubSub.broadcast(Game.PubSub, "event:#{event_type}", {event_type, payload})
  end

  def subscribe(event_type) do
    Phoenix.PubSub.subscribe(Game.PubSub, "event:#{event_type}")
  end
end
```

---

### 2. Registering a Listener

```elixir
Game.EventBus.subscribe("CombatEvent")
```

- The caller process will now receive matching `{event_type, payload}` tuples.

---

### 3. Emitting Events

```elixir
Game.EventBus.emit("CombatEvent", %{attacker: "player1", target: "npc1"})
```

- This sends the payload to all subscribed services.

---

## 📦 Example Flow

```plaintext
[CombatService] -- emit --> CombatEvent
   |
   +--> [QuestService] -- receives and updates quest
   |
   +--> [SyncService] -- pushes damage state to client
```

---

## 🧠 Typed Events (Structs)

Each major event has a typed wrapper:

```elixir
defmodule Game.Events.CombatEvent do
  defstruct [:attacker, :target, :damage]
end
```

- Stronger than stringly-typed JSON
- Enforced by pattern matching in handlers

---

## 🧪 Testing

- Validated in `test/event_bus_test.exs`
- Services simulate messages and confirm reaction via pattern-matched handles

---

## ✅ Summary

The Elixir Event System is an asynchronous pub/sub framework built on Phoenix PubSub. It supports scalable inter-service signaling using clean topics and typed messages. Its decoupled architecture simplifies orchestration across AI, quests, combat, chat, and inventory systems.
