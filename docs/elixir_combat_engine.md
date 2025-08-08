
# ⚔️ Mythweave Combat Engine – Real-time Battle System in Elixir

## 🔍 Purpose

Implements the core battle mechanics of the MMORPG using OTP GenServers. Manages ability use, stat resolution, and outcome broadcasting via PubSub.

---

## 📁 Location

- `lib/mythweave/combat/`
- Ability definitions: `priv/data/abilities.json`

---

## 🧱 Components

- `CombatEngine`: Central GenServer routing battle actions and resolving turns.
- `EffectPipeline`: Handles modular damage, healing, and status effects.
- `Ability`: Loaded dynamically from JSON, defines input, cost, and resolution rules.

---

## 🧠 Example

```elixir
CombatEngine.cast({:use_ability, player, "fireball", target})
```

---

## 📦 Features

- Cooldown, energy, and stat-based formulas
- Status effects (e.g. silence, fear) applied via pipeline
- Event emission for UI and system logs

---

## 🗺️ Roadmap Integration

- Phase 2: Combat & Abilities Core
- Abilities extensible via JSON config (hot-reload planned)
- Damage/resist tied into entity stats and gear bonuses
