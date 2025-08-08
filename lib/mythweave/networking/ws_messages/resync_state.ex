defmodule Mythweave.Networking.WSMessages.ResyncState do
  @moduledoc """
  Alias of `resync` for client compatibility.

  Used when:
    - Client sends `resync_state` instead of `resync`
    - Maintains compatibility across protocol versions
  """

  defstruct [:scope]

  alias Mythweave.Networking.WSMessages.Resync

  @type t :: %__MODULE__{scope: String.t() | nil}

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(msg, pid), do: Resync.handle(msg, pid)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Fully delegated to `Resync` — any changes must stay in sync
  #    - ✅ Ensure Resync.handle/2 remains backward-compatible
  #
  # 2. No internal validation of `scope`
  #    - 🚧 Validate known scopes (zone, inventory, etc.) in Resync
  #
  # 3. No structured error bubbling
  #    - ❗ Return informative errors if Resync fails
end
