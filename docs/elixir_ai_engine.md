
# 🤖 Mythweave AI Engine – Behavior Trees in Elixir

## 🔍 Purpose

Manages autonomous NPC behavior using modular behavior trees. AI logic runs in isolated GenServer processes scheduled via the `Thinker` module.

---

## 📁 Location

- `lib/mythweave/ai/ai_manager.ex`
- `lib/mythweave/ai/behavior_tree.ex`
- `lib/mythweave/ai/nodes/`

---

## 🧠 Components

- `AIManager`: Coordinates tick cycles for all zone NPCs.
- `BehaviorTree`: Evaluates nodes like `Aggro`, `Seek`, `Wander` using functional composition.
- `Thinker`: Periodically invokes decision logic via `:timer.send_interval` or `Process.send_after`.

---

## 🧩 Node Types

- `Aggro`: Detects hostiles within radius and sets target.
- `Seek`: Navigates toward target.
- `Wander`: Performs idle roaming.

---

## 🔁 Execution Loop

```elixir
def tick_all_npcs(zone_id) do
  Enum.each(npcs, &tick_npc/1)
end
```

---

## 🛠️ Roadmap Alignment

- Matches Phase 6: AI & Entity Behavior
- Supports FSM/BT hybrid behaviors
- Future expansion: async pathfinding, memory/context node
