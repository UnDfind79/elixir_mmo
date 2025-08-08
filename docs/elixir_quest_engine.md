# 🧾 Elixir MMORPG – QuestEngine Module

## 🔍 Purpose

The `QuestEngine` manages dynamic quest state, tracking player progress based on dispatched world events. It enables reactive gameplay and supports scalable content-driven quests.

---

## 📁 Location

- `lib/mmorpg/services/quest_engine.ex`

---

## ⚙️ Dependencies

| Module            | Role                                        |
|-------------------|---------------------------------------------|
| `EventBus`        | Subscribes to combat/item/gameplay events   |
| `QuestData`       | Provides static definitions for all quests  |
| `InventoryEngine` | Delivers item rewards on completion         |
| `Player` Module   | Tracks individual quest state               |

---

## 📘 Quest Format

```elixir
%{
  id: "defeat_goblins",
  objectives: [
    %{type: :kill, target: "goblin", count: 5}
  ],
  reward: %{
    xp: 50,
    items: ["coin"]
  }
}
```

---

## 🔁 Core Functions

### `track_quest/2`

```elixir
@spec track_quest(Player.t(), String.t()) :: :ok | {:error, :already_tracked}
```

- Attaches a quest to the player
- Initializes objective state for progress tracking

---

### `update_progress/2`

```elixir
@spec update_progress(Player.t(), map()) :: :ok
```

- Triggered by event listeners (e.g. `:combat_event`)
- Updates progress on relevant objectives
- Auto-checks for quest completion

---

### `check_completion/2`

```elixir
@spec check_completion(Player.t(), String.t()) :: :ok | :incomplete
```

- Verifies if all objectives are met
- Triggers reward delivery and event broadcast if complete

---

## 🧠 Example Flow

1. Player accepts quest `defeat_goblins`
2. On each goblin kill, `:combat_event` fires
3. `update_progress/2` updates kill count
4. `check_completion/2` awards XP + items when done
5. `:quest_completed` broadcast sent for UI sync

---

## 🧪 Tests

- All core logic covered in `test/quest_engine_test.exs`
- Focus on event-to-objective pipelines, reward application

---

## ✅ Summary

The `QuestEngine` is an extensible, event-aware system supporting deep quest scripting through configuration. Its decoupled architecture and data-first design make it easy to expand content and maintain narrative systems.