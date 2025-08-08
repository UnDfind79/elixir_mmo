defmodule Mythweave.Networking.WSMessages.Resync do
  @moduledoc """
  Triggers a resync for part of the world state.

  Expects:
    - `scope`: area to resync (e.g., "zone", "inventory", "ui")

  Responsible for:
    - Routing resync requests to SyncService
    - Supporting scoped state refresh for clients
  """

  defstruct [:scope]

  alias Mythweave.State.SyncService

  @type t :: %__MODULE__{scope: String.t() | nil}

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{scope: scope}, player_id) do
    SyncService.request_resync(player_id, scope)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Accepts `nil` or invalid scopes silently
  #    - ❗ Add scope validation or defaults for missing/unknown values
  #
  # 2. No error propagation from SyncService
  #    - 🚧 Return {:error, reason} if request_resync fails
  #
  # 3. Lacks audit/logging of resync reasons
  #    - ✅ Optional: emit telemetry or debug log when resync is triggered
end
