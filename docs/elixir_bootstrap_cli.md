
# 🚀 Elixir Server Bootstrapping & CLI

## 📍 Entrypoint: `ElixirMMO.Application`
The Elixir server bootstraps through the OTP supervision tree, orchestrating system-wide service startup and resilient process supervision.

### Boot Process Overview
1. Loads world data from zone/prop/entity config files.
2. Starts core systems via supervised children.
3. Binds websocket handlers using Phoenix Channels or a custom socket layer.
4. Begins ticking systems like AI and Scheduler via GenServers.

---

## ⚙️ Zone Production CLI (Mix Task)

A CLI for pre-generating and validating zone definitions, optimized for use in deployment pipelines or developer tooling.

```bash
mix zone.produce config/zone_config.yaml --out-dir ./worlds
```

### Usage
- Validates YAML config
- Generates deterministic zone binary or JSON files
- Injects into `:ets`, file system, or bootloader

---

## 🧰 Service Initialization Map

| Service           | Description |
|------------------|-------------|
| `ZoneLoader`     | Parses static zone data into structs, loads via ETS or persistent GenServers |
| `PropLoader`     | Registers interactive/non-interactive world props |
| `EntityLoader`   | Loads entity archetypes and NPC templates |
| `WorldState`     | Starts zone grid maps, entity tracking |
| `Scheduler`      | Ticks time-based tasks via a GenServer loop |
| `EventDispatcher`| Enables event-driven pub/sub architecture |
| `SocketHandler`  | Manages websocket subscriptions, per-zone routing |
| `SyncService`    | Broadcasts state changes to players |
| `AIService`      | Runs periodic logic for mob entities |
| `QuestService`   | Listens to events, tracks player quest state |
| `ItemService`    | Manages inventory and item effects |
| `LootService`    | Generates loot drops for kills |
| `AuthService`    | Verifies login credentials and issues tokens |

---

## 🧪 Boot-Time Test Modes

- **In-Memory Engine Stub**: Simulates database, fast startup.
- **Fake Auth Backend**: Mocks hashing/tokening.
- **Stub Event I/O**: Intercepts or silences pub/sub in CI mode.

---

## ✅ Summary

Elixir bootstrapping leverages the OTP lifecycle to create a modular, recoverable server runtime. Systems are broken into supervised workers with clear startup dependencies. CLI tools enable safe content generation and repeatable deployments.

