# Mythweave Server Modernization Roadmap (Client-Ready)

This roadmap merges server hardening with **client-first** practices so a future client (TS/Kotlin/Swift/C#) can connect, validate, and render smoothly from day one.

---

## Phase 0 — Baseline + Guardrails (Day 0–1)

**Server Goals:** Compile reliably, surface problems early, codify style.  
**Client Impact:** Stable, predictable builds and coding standards; fewer surprises for SDKs.

- **Lock toolchain:** Elixir `~> 1.15`–`1.18`, OTP 26/27. Add `.tool-versions` or docs.
- **Format & lint:**
  - Add `credo` (strict) and `mix format` in CI.
  - Credo checks for: unqualified `assign/3`, deprecated `Logger.warn`, unused aliases, illegal guards.
- **Static types:** Add **Dialyzer** with `dialyxir`; enforce typespecs on public APIs.
- **Project hygiene:** `mix alias ci`: `format --check-formatted`, `credo --strict`, `dialyzer`, `test --cover`.
- **Docs skeleton:** `/docs` folder with architecture overview + contribution guide.

**Deliverables:** CI passes, compiles without warnings, style gates in place.

---

## Phase 1 — Kill the “red” errors, make it boot (Day 1–3)

**Server Goals:** Zero compile errors; minimal run loop starts; basic auth/token works.  
**Client Impact:** Client can connect, auth, and see a snapshot immediately.

1. **Resolve missing structs/modules** — add minimal `defstruct` + `@enforce_keys` + typespecs for:
   - `Mythweave.Persistence.Schemas.PlayerRecord`
   - `Mythweave.Persistence.Schemas.WorldSnapshot`
   - `Mythweave.Schemas.Player`
   - `Mythweave.State.ZoneState`
   - `Mythweave.Item.Item` (canonicalize namespace)
   - `Mythweave.NPC`
2. **Auth tokens (real lib):** Add `{:jose, "~> 1.11"}`; HS256 tokens with `exp`, `sub`; secret via `runtime.exs` env var.
3. **Networking choice:**
   - **A (recommended):** Minimal Phoenix stack (`phoenix_pubsub`, `plug`, `cowboy`, optional `phoenix`). Real `MythweaveWeb.Endpoint` + Channels.
   - **B:** Temporary stubs if we must defer web (not client-friendly).
4. **Persistence (interim):** ETS-backed `Repo` facade, or wire `ecto_sql + postgrex` with a tiny schema (players + snapshots).
5. **Correctness cleanups:** `Logger.warning/…`, remove illegal guards, qualify `Phoenix.Socket.assign/3`, fix `Kernel.send/2` conflicts, fix heredocs.

**Client-Ready Output:**
- **Protocol skeleton**: define initial **message schemas** (JSON Schema) for: `login`, `resume`, `join_zone`, `state_snapshot`, `delta_entity`, `chat`, `move`, `cast_ability`, `attack`, `error`.
- **Sample transcript** of connect/auth/snapshot in `/docs/protocol/README.md`.

**Deliverables:** `mix run --no-halt` boots; `mix test` subset passes; protocol draft exists.

---

## Phase 2 — OTP Architecture & Boundaries (Day 3–6)

**Server Goals:** Resilient supervision; explicit boundaries/behaviours.  
**Client Impact:** Predictable ownership of state; fewer race conditions and clearer APIs.

- **Supervision tree:** Root → Networking, Engine (TickLoop/EventBus/Telemetry), World, Players, Persistence.
- **Registries:** Player/session/zone registries with `via` tuples.
- **Contexts/Behaviours:** `Auth`, `Networking`, `Engine`, `World`, `Combat`, `Item`, `Quest`, `Persistence`. Behaviour for `Persistence.Adapter` (ETS|Repo).

**Client-Ready Output:**
- **State discovery endpoints** (HTTP or RPC): `GET /state/me`, `GET /state/zone/:id` returning the same shapes as WS snapshots.
- **Capability flags**: server advertises features in `hello`/`welcome` message.

**Deliverables:** Boundary doc + supervision diagram in `/docs/architecture/`.

---

## Phase 3 — Observability, Diagnostics & Config (Day 5–8)

**Server Goals:** First-class telemetry/metrics/logs and robust runtime config.  
**Client Impact:** Client devs can self-diagnose via diagnostics stream; stable env toggles.

- **Telemetry events:** Emit from TickLoop (frame/drift), Combat (hit/crit/damage), Zone (load/save), Auth (login/logout), Networking (msg_received/invalid).
- **Metrics:** Add `:telemetry_metrics`; counters, distributions, last-values.
- **Structured logs:** Consistent `Logger.metadata(player_id, session_id, zone_id)`.
- **Runtime config:** `runtime.exs` for tick rate, token secret, persistence adapter; validate env on boot.

**Client-Ready Output:**
- **Diagnostics channel/event** (WS): exposes server time, tick drift, ratelimit status.
- **/health** endpoint and simple **web inspector** to subscribe to a player’s frames.

**Deliverables:** Health endpoint OK, metrics exported, observable sessions.

---

## Phase 4 — Persistence Strategy (Day 7–12)

**Server Goals:** Durable, queryable state store with a clean façade.  
**Client Impact:** Fast login, reliable resume, consistent inventory/quest state.

- **Option 1 (Interim):** ETS/Dets with periodic **snapshots** (`WorldSnapshot`, `Player`).
- **Option 2 (Recommended):** Postgres via `ecto_sql`:
  - Schemas: `players`, `player_items`, `world_snapshots`, `zones`.
  - **Changesets** with validations; all writes in transactions.
  - Keep `Persistence.DB` as façade to keep gameplay DB-agnostic.

**Client-Ready Output:**
- **Idempotent operations**: client actions accept `client_op_id` to safely retry.
- **Pagination & partial fetch**: large collections (`inventory`, `quests`) return paginated slices.

**Deliverables:** Either stable ETS or initial Postgres schema + migrations + green tests.

---

## Phase 5 — Networking & Protocol Hardening (Day 10–15)

**Server Goals:** Secure, validated, and efficient WS protocol.  
**Client Impact:** Turn-key SDKs; reconnection that just works.

- **Auth & session resume:** token refresh, sequence numbers, **replay missed events** on reconnect.
- **Heartbeats:** server publishes heartbeat interval; client can detect stalls.
- **Validation layer:** server validates payloads against the **JSON Schemas**; returns structured errors (`code`, `retryable`, `hint_id`). 
- **Priorities & batching:** permit bundling low-priority events; throttle chatty streams server-side.
- **Compression:** enable permessage-deflate; consider binary framing (MessagePack/Protobuf) for hot paths.

**Client-Ready Output:**
- **SDKs**: ship a **TypeScript SDK** (auth, reconnect, typed events, validation). Plan Kotlin/Swift next.
- **Codegen**: generate client models/types from the same message schemas.
- **Golden transcripts** for core flows (connect → join → snapshot → delta → logout) in `/docs/protocol/transcripts/`.

**Deliverables:** Protocol doc + codegen pipeline + sample apps.

---

## Phase 6 — Gameplay Core Hardening (Day 12–20)

**Server Goals:** Stable combat/zones/inventory/quest loops.  
**Client Impact:** Low-latency UX and deterministic visuals.

- **Combat:** finalize `CombatMath` invariants; property tests (bounds, nonnegative damage, crit odds).
- **Zones:** ZoneServer lifecycle; hot reload for zone JSON with versioning; safe fallbacks.
- **Inventory/Items:** canonical `Item` struct; stack rules; property + integration tests.
- **Quests:** minimal lifecycle; persistence hooks; state transitions.

**Client-Ready Output:**
- **Delta updates + snapshots:** zone/join provide **full snapshot**, then **diffs** with `seq` + `ts`.
- **Stable IDs & ordering:** every event carries `id`, `seq`, `ts` for deterministic UIs.

**Deliverables:** Subsystem tests pass; tick loop stable under simulated load.

---

## Testing Strategy (Protects Clients)

- **Unit tests:** math, parsing, loaders.
- **Property tests:** combat/inventory invariants; path constraints.
- **Integration tests:** boot tree → login → join → move → attack → logout (WS round-trip).
- **Golden-file tests:** expected message sequences for client flows.
- **Contract tests in CI:** validate server handlers against **shared schemas**; fail build on drift.
- **Concurrency tests:** bot swarms; assert no mailbox bloat/deadlocks.
- **Coverage gate:** 70% → 85% target.

---

## Code Quality Patterns

- Prefer **pattern matching** at API edges; avoid broad rescues.
- No global mutable state; use `Registry` + small GenServers; wrap ETS behind modules.
- `@enforce_keys` + **typespecs** on all structs; avoid illegal guards.
- Small, **owning** processes (Zone owns NPCs; PlayerServer owns inventory).
- Backpressure: design for batching/pull when necessary.

---

## Suggested Dependencies

- **Core:** `jason`, `phoenix_pubsub`, `plug`, `cowboy`, `telemetry`, `telemetry_metrics`
- **Recommended next:** `phoenix` (channels), `ecto_sql`, `postgrex`, `oban` (jobs), `nimble_options` (config validation)
- **Dev/Test:** `ex_doc`, `credo`, `dialyxir`, `stream_data`, `mix_test_watch`

---

## Concrete Fix Queue (Initial Batches)

1. Replace placeholder structs with real minimal ones (Player, NPC, Item, ZoneState, WorldSnapshot, PlayerRecord).
2. Implement JOSE-backed `Auth.Token`; `runtime.exs` secret.
3. Choose Networking path (prefer Phoenix); implement `Endpoint` + Channel.
4. Remove illegal guards, deprecated logging, unqualified `assign`, and `Kernel.send/2` conflicts.
5. Add Telemetry events + Metrics; expose diagnostics channel + `/health`.
6. Tighten context boundaries and supervision order.
7. Draft **message schemas**, set up **codegen** for TS SDK, and add **golden transcripts**.
8. Run & extend tests (unit/property/integration/contract).

---

## Acceptance Criteria

- `mix test` **green**, **no warnings**.
- Server boots with WS handling and **protocol negotiation**; client can **connect, resume, and receive snapshot+delta**.
- `credo --strict` clean; no new Dialyzer issues.
- Health endpoint OK; metrics exposed; diagnostics channel available.
- **TypeScript SDK** published from repo; **JSON Schemas** are the single source of truth.
- Docs include quick start for server + client, protocol reference, error catalog, compat matrix.
