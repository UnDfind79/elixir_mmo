defmodule Mythweave.Networking.WSMessages.Reconnect do
  @moduledoc """
  Reconnects a previously connected player and reloads their state.

  Responsible for:
    - Restoring player session
    - Rehydrating player state into memory
  """

  defstruct []

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{}

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(_, pid) do
    PlayerState.reconnect(pid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of reconnect eligibility
  #    - ✅ Ensure session is valid and not banned/disconnected
  #
  # 2. No zone or world state re-binding
  #    - 🚧 Re-assign player to zone context if needed
  #
  # 3. No client sync/acknowledgement message
  #    - ❗ Trigger client-side rehydration with full state payload
end
