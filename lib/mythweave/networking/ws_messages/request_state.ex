defmodule Mythweave.Networking.WSMessages.RequestState do
  @moduledoc """
  Requests full world + player state sync.

  Triggers:
    - A full state push via `SyncService`

  Typically used:
    - On login, reconnect, or client-side desync
  """

  defstruct []

  alias Mythweave.State.SyncService

  @type t :: %__MODULE__{}

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(_, player_id) do
    SyncService.request_full_state(player_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of player_id ownership
  #    - ✅ Confirm upstream socket is verified
  #
  # 2. No fallback on failed state push
  #    - 🚧 Add retry or failure log if SyncService fails
  #
  # 3. Assumes SyncService always succeeds
  #    - ❗ Handle {:error, reason} cases in SyncService
end
