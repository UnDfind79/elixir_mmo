
# 🧍 Mythweave Entity Model – Unified Player/NPC Representation

## 🔍 Purpose

Represents all dynamic in-world entities (players, NPCs, items) with standardized data structures and a clean process-based lifecycle. Central to visibility, combat, persistence, and stat computation.

---

## 📁 Location

- `lib/mythweave/entity/entity.ex`
- `lib/mythweave/entity/templates/`
- `lib/mythweave/stats/stat_calculator.ex`

---

## 🧬 Structure

Each entity is a data map with keys:

```elixir
%Entity{
  id: "player_123",
  kind: :player | :npc,
  position: {x, y},
  stats: %{hp: 100, atk: 20, def: 10},
  status_effects: [],
  tags: [:hostile, :undead],
  equipment: %{},
  inventory: [],
  abilities: [...]
}
```

---

## ♻️ Process Lifecycle

- Tracked by ZoneServer
- Updated by Tickers, AI, and Players
- Diffed for sync over network

---

## 🗺️ Roadmap Integration

- Phase 1: Entity split from player code
- Phase 2/3: Combat, stats, inventory modeled here
- Phase 5: Scoped visibility via position and zone
