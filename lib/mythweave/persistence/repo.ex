defmodule Mythweave.Persistence.Repo do
  @moduledoc """
  Primary Ecto repository for Mythweave persistence.

  Configured for PostgreSQL via `:mythweave` OTP app config.

  Used by:
    - `Mythweave.Persistence.DB`
    - `Ecto.Repo.insert/update/get` operations
  """

  use Ecto.Repo,
    otp_app: :mythweave,
    adapter: Ecto.Adapters.Postgres

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Connection pooling via `:pool_size` in `config/*.exs`
  #    - ✅ Tune for production scale
  #
  # 2. No read-replica or replica routing
  #    - ❗ Future: support multi-region read replicas
  #
  # 3. No query instrumentation
  #    - 🔄 Optional: integrate with Telemetry, PromEx, AppSignal, etc.

end
