
# 🔐 Mythweave AuthService – Elixir Implementation

## 🔍 Purpose

Handles player authentication using secure token validation, player registration, and session lifecycle management. Backed by Elixir’s concurrency model and designed with GenServer patterns.

---

## 📁 Location

- `lib/mythweave/auth/auth_service.ex`
- `lib/mythweave/auth/session_registry.ex`
- `lib/mythweave/auth/token.ex`

---

## 🧱 Architecture

- `AuthService`: Validates credentials, issues tokens, and verifies sessions.
- `SessionRegistry`: Registry-based GenServer tracking active players by session ID.
- `Token`: JWT signing/verification module used by the login flow.

---

## ✅ Best Practices

- Uses `Registry` to uniquely track sessions.
- All player session state stored in supervised GenServer.
- JWTs signed using Phoenix.Token or Joken with configurable salt/secret.

---

## 🔐 Example Flow

```elixir
{:ok, session_pid} = AuthService.login(username, password)
{:ok, token} = Token.sign(session_pid)
SessionRegistry.whereis(token)
```

---

## 🔒 Roadmap Integration

- Rate-limiting and anti-cheat measures enforced via `SessionRegistry`
- Hooked into audit logs during Phase 8 (Validation)
- Event bus integration planned for session lifecycle (connect/disconnect)
