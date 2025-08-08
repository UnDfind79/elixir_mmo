
# 💠 Elixir MMORPG Server – Developer / Designer Guide  
*Projected v1.0 – OTP-Integrated Production Architecture*

---

## 1 · Core Attribute System

### 1.1 Tier 1: Primary Attributes
```elixir
@primary_attrs [:body, :mind, :grace, :personality]
```
- `Body`: Strength, durability  
- `Mind`: Intellect, calculation  
- `Grace`: Agility, precision  
- `Personality`: Creativity, aura

### 1.2 Tier 2: Hybrid Attributes  
Defined via combinations of Tier 1. Computed lazily by `AttributeEngine`.

```elixir
%{
  power: [:body, :grace],
  focus: [:mind, :body],
  clarity: [:mind, :grace],
  will: [:mind, :personality],
  dominance: [:body, :personality],
  creativity: [:mind, :personality],
  charisma: [:grace, :personality],
  composure: [:personality, :mind],
  speed: [:grace, :mind]
}
```

### 1.3 Tier 3: Derived Attributes  
Used by combat, crafting, and simulation systems. Defined as stat pipelines.

```elixir
%{
  melee_dmg: [:power, :dominance],
  melee_acc: [:focus, :dominance],
  ranged_dmg: [:power, :speed],
  magic_atk: [:power, :clarity],
  magic_def: [:clarity, :will],
  mana_regen: [:clarity, :will],
  fortitude: [:power, :focus],
  physical_def: [:fortitude, :will],
  evasion: [:speed, :composure],
  ...
}
```

**Propagation Flow**:  
`AttributeEngine.compute/1` aggregates raw modifiers, computes Tier 1, cascades to Tier 2/3.

---

## 2 · Combat Math

```elixir
defmodule CombatMath do
  def hit_chance(acc, eva) do
    chance = :math.pow(acc, 0.6) / (:math.pow(acc, 0.6) + :math.pow(eva, 0.6))
    Float.clamp(chance, 0.05, 0.95)
  end

  def damage_scaling(atk, def) do
    ratio = :math.pow(atk, 0.65) / (:math.pow(def, 0.65) + 0.001)
    ratio / (ratio + 1.5)
  end
end
```

---

## 3 · Damage Types & Status Effects

```elixir
@types %{
  fire: :burn,
  ice: :slow,
  blunt: :stun,
  piercing: :bleed,
  poison: :poison,
  lightning: :shock,
  dark: :curse,
  holy: :cleanse,
  arcane: nil
}
```

Status infliction calculated via `StatusEngine.attempt/3`.

---

## 4 · Schema System

- Max 3 adventurer schemas, 2 crafting schemas per player.  
- Grids are shaped and validated by `SchemaGrid`.  
- Only modifiable at zone-registered `:schema_nodes`.  
- XP accrual managed by `SchemaEngine.level_up/2`.  
- Bonuses unlocked via `SchemaEngine.line_bonus/1`.

```elixir
# Example:
SchemaEngine.line_bonus(grid) → [:horizontal_0] → +5% Magic Atk
```

---

## 5 · Ability System

- Each ability struct includes: `:cost`, `:cooldown_group`, `:scaling_stat`, `:status_override`.
- Activated via `AbilityEngine.use/3` → validates → emits combat event.
- Passive/toggled abilities treated as timed states.
- Leveled via `AbilityProgressionService`.

---

## 6 · Combat Flow

```elixir
PlayerCommand
  → CommandRouter
    → CombatEngine.attack(attacker, defender, ability)
        ├ Attributes = AttributeEngine.compute/1
        ├ if hit? do
        │   damage = CombatMath.damage_scaling(...)
        │   StatusEngine.attempt(...)
        └ Emit CombatLogEvent via PubSub
```

---

## 7 · Inventory & Equipment

- `InventoryService` validates capacity and stack logic.
- `EquipmentService` injects bonuses into `Entity.AttributeSources`.
- Supports sockets, rarity metadata, custom modifiers.

---

## 8 · Crafting System (Phase 2+)

```elixir
# Workflow
CraftingSession.start(player, recipe) → stream channelled steps
→ Check failure/success → Quality output calculated
```

- Modular recipes: discoverable, branchable  
- Steps may be interactive or stat-resolved  
- Result quality = `CraftQuality + RNG + recipe bonuses`

---

## 9 · Economy

- `VendorService`: direct transactions  
- `AuctionService`: GenServer-per-listing, resolves on timeout  
- Phase 3: multi-currency & dynamic market system

---

## 10 · NPC & Quest

- `NPCService.interact/2` → dialog + quest attach  
- `QuestService`: tracks, validates, distributes rewards  
- Behaviors modularized under `NPCBehaviorTree`

---

## 11 · Zone & Session Management

| Module | Function |
|--------|----------|
| `ZoneServer` | Manages live zone state (per zone via DynamicSupervisor) |
| `SessionTracker` | Cleans up data and player presence |
| `DeathService` | Respawn scheduling |
| `CombatLogService` | Player-specific GenServers with TTL |

---

## 12 · Admin & Debug Tools

```elixir
AdminService.dispatch(:give_gold, %{player: ..., amount: 500})
```

- All commands gated behind `player.admin?`
- Registered in `AdminCommandRegistry`

---

## 13 · Roadmap (Phase 3+)

- Crafting engine GUI + prompts  
- Enhanced schema upgrade system  
- Pet AI (obedience = Dominance + Personality)  
- Currency tiering & dynamic economy  
- World-map safe zones with schema edit access  
- Full NPC AI: pathfinding + behavior trees  
- Social systems: parties, guilds, emotes  

---

## Zone Services (via `ZoneRegistry`)

Each Zone is a supervised process. All services are zone-scoped:

```elixir
ZoneRegistry.dispatch(:zone_id, {:zone_music, :set, "MysticTrack"})
```

| Service | Description |
|---------|-------------|
| `ZoneDiscovery` | Visibility, fast-travel unlocks |
| `ZoneVisitTracker` | Analytics + unlock history |
| `ZoneMusic` | Ambient track per zone |
| `ZoneLight` | Float 0.0–1.0 |
| `ZoneEffect` | FX events (particles/sound) |
| `ZoneLoot` | Local drop tables |
| `ZoneWeather` | Dynamic or scripted |
| `ZoneNPCSpawn` | Active NPCs per zone |
| `ZoneQuest` | Zone-wide quest pool |
| `ZoneTrap` | Trap defs + state |
| `ZonePortal` | Inter-zone gateways |

---

## WebSocket & HTTP API (Phoenix)

**New Routes**  
```http
POST   /auth/register
POST   /auth/token
WS     /subscribe
WS     /unsubscribe
GET    /entities/{id}
GET    /zones/{zone_id}/subscribe
GET    /zones/{zone_id}/unsubscribe
GET    /entities
```

Backed by Phoenix Channels and PubSub broadcasts. Auth tokens signed via `Guardian`.
