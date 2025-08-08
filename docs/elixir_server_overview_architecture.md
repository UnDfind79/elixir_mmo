
# 🏗️ Mythweave Server Architecture – OTP-first Design

## 🧭 Design Philosophy

Built on BEAM/OTP principles: lightweight concurrency, fault isolation, and hot code reload. Game world decomposed into supervised, registry-tracked processes.

---

## 📂 Core Layers

- **Application & Supervision Tree**
  - `Mythweave.Application` boots all core services.
- **GenServers** for:
  - Zones
  - Players
  - CombatEngine
  - AI Thinkers
- **PubSub Bus**: `Mythweave.Events`
- **Registry**: `ZoneRegistry`, `PlayerRegistry`, `SessionRegistry`

---

## 🕸️ Message Flow

```
Client -> SocketHandler -> MessageRouter -> ZoneServer -> Entity/AI
                                         -> CombatEngine
                                         -> Inventory
```

---

## 🗺️ Roadmap Alignment

- Phase 1: World decomposition into GenServers
- Phase 4: MessageRouter and client sync
- Phase 8: Telemetry, logging, and fault recovery
