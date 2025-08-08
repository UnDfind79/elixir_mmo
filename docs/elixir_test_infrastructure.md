
# 🧪 Module 8: Testing Infrastructure

## 🔍 Purpose

The testing infrastructure ensures server functionality through structured, service-focused unit tests. Each major module is covered with isolated mocks and expected behaviors.

---

## 🧩 Location

## 🔧 Test Environment Stubs

To support testing without external dependencies, the server employs:

- **Fake SQLAlchemy Stubs**: A mocked `sqlalchemy` package providing in-memory registry, `Column`, `Session`, and query functionality. Allows database tests without installing real SQLAlchemy.
- **Passlib CryptContext Stub**: A stubbed `passlib.context.CryptContext` that performs identity hashing and verification, facilitating auth tests without requiring the real Passlib library.
- **Async Backend Fallback**: For AnyIO-backed tests importing the `trio` backend, the infrastructure falls back to the `asyncio` backend by forcing `sniffio.current_async_library` to `asyncio` and stubbing out `anyio._backends._trio.TestRunner`. Ensures compatibility without installing Trio.


- **Root Folder**: `/tests/`
- **File Naming**: `test_<service_name>.py`
- **Framework**: `pytest` (inferred from test structure and naming)

---

## 📁 Organization

```
tests/
├── test_ai_service.py
├── test_auth_service.py
├── test_combat_service.py
├── test_container_service.py
├── test_dispatcher.py
├── test_equipment_service.py
├── test_item_service.py
├── test_loot_service.py
├── test_quest_service.py
├── test_scheduler_service.py
├── test_sync_service.py
├── test_world_state_service.py
```

Each service in `app/services/` has a matching test file.

---

## 🧪 Unit Testing Approach

| Practice                | Description                                      |
|-------------------------|--------------------------------------------------|
| **Isolated Tests**      | Each service is tested independently            |
| **Mocks & Fixtures**    | Used to simulate dispatcher, world, etc.        |
| **Stateless Verification** | Tests do not depend on shared state          |
| **Service-focused**     | Each method’s output and side effects are validated |

Example (in `test_loot_service.py`):

```python
def test_generate_loot_returns_valid_items():
    loot = loot_service.generate_loot(monster="goblin")
    assert all(item in item_db for item in loot)
```

---

## 🧱 Mocking Patterns

Common mocks include:

| Mocked Object         | Purpose                         |
|------------------------|----------------------------------|
| `dispatcher`           | Validates events are emitted     |
| `world_state_service`  | Supplies entity/zonal context    |
| `item_service`         | Provides item metadata           |

Mocks are either manually defined or injected as lightweight stubs.

---

## 🔁 Examples of Tested Behaviors

| Service               | Key Tests Performed                                 |
|------------------------|-----------------------------------------------------|
| `CombatService`        | Damage calculation, death events                    |
| `AIService`            | Action ticks, pathfinding triggers                  |
| `SchedulerService`     | Task delay/rescheduling                             |
| `EquipmentService`     | Stat changes on equip/unequip                       |
| `QuestService`         | Event-triggered progress and completion             |
| `SyncService`          | Event-to-client payload generation                  |
| `WorldStateService`    | Entity zoning and radius detection                  |

---

## 📏 Quality Standards

- **Descriptive Test Names**: `test_<function>_<condition>`
- **Minimal Shared Setup**: Reduces test bleed
- **Clear Assertions**: Simple `assert` statements dominate
- **Repeatable & Stateless**: Supports parallel runs

---

## ✅ Summary

The testing infrastructure adheres to unit-first, event-aware principles. It ensures each service behaves correctly in isolation and validates integration paths indirectly through event mocks and simulations.


## Newly Added WebSocket Commands
- use_ability


## Newly Added API Routes
- /zones/{zone_id}/subscribe
- /auth/register
- /subscribe
- /auth/token
- /unsubscribe
- /ws/dummy
- /entities/{eid}
- /zones/{zone_id}/unsubscribe
- /entities
