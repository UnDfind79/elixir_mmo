# ⏲️ Module 6: Scheduler System

## 🔍 Overview

The `SchedulerService` orchestrates the timing and repeated execution of server-side tasks. It powers timed mechanics like NPC decision-making, loot container respawning, and quest timeouts.

---

## 📍 File Location

- **Path:** `app/services/scheduler_service.py`
- **Class:** `SchedulerService`

---

## ⚙️ Class Initialization

```python
class SchedulerService:
    def __init__(self):
        self.tasks = []
```

- Initializes with a queue for scheduled tasks.
- Manages time-to-execution for each callback.

---

## 🔁 Core Functionality

### 1. `schedule(callback, delay, repeat=False)`
```python
def schedule(self, callback: Callable, delay: float, repeat: bool = False):
```

- Schedules `callback` to run after `delay` seconds.
- If `repeat` is `True`, re-schedules the task after each run.
- Commonly used for AI ticks or time-based triggers.

---

### 2. `cancel(callback)`
```python
def cancel(self, callback: Callable):
```

- Removes a pending task from the queue, if found.
- Safe to call regardless of whether the task ran.

---

### 3. `tick(delta_time)`
```python
def tick(self, delta_time: float):
```

- Invoked regularly by the main game loop.
- Reduces time remaining on each task.
- Executes tasks whose timers have elapsed.
- Re-queues repeating tasks.

---

## 🧠 Usage Example

```python
# Delay loot respawn by 2 minutes
scheduler.schedule(
    lambda: container_service.respawn_container(data),
    delay=120
)
```

---

## 🔄 Integration Points

| Used By            | Example Task                        |
|--------------------|-------------------------------------|
| `AIService`        | Regular behavior ticks              |
| `ContainerService` | Delayed respawn after looting       |
| `QuestService`     | Timeout or delay-based mechanics    |

---

## ⏲️ How It Works

- Each task has a countdown timer.
- `tick()` reduces timers based on frame time (`delta_time`).
- Executed tasks are removed (or recycled if `repeat=True`).

---

## 🧪 Test Coverage

- Located in `tests/test_scheduler_service.py`
- Verifies delay accuracy, cancellation logic, and repeat handling

---

## ✅ Summary

`SchedulerService` enables robust time-based execution for asynchronous game logic. It simplifies repeated or delayed callbacks without manually tracking state.

---

## 📌 Undocumented Internal Functions

### `_loop`
- Internal timing loop likely run on a background thread or tick system.
- Executes pending tasks and schedules the next run.

### `start`
- Boots the scheduler, possibly linking to game engine tick.

### `stop`
- Stops task execution loop gracefully.

### `test_scheduler_delayed_and_repeating`
- Ensures that scheduled tasks trigger at correct intervals, both once and repeatedly.

### `one_shot`
- Used in tests to verify one-time execution behavior.

---

## 📡 Newly Introduced WebSocket Commands

- `use_ability`

---

## 🌐 Recently Added API Endpoints

- `POST /auth/register`
- `POST /auth/token`
- `POST /subscribe`
- `POST /unsubscribe`
- `GET /entities/{eid}`
- `POST /zones/{zone_id}/subscribe`
- `POST /zones/{zone_id}/unsubscribe`
- `GET /ws/dummy`