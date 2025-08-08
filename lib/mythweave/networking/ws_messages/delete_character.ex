defmodule Mythweave.Networking.WSMessages.DeleteCharacter do
  @moduledoc """
  Deletes a character owned by the player.
  """

  defstruct [:character_id]

  alias Mythweave.Player.PlayerState

  def handle(%__MODULE__{character_id: cid}, player_id) do
    PlayerState.delete_character(player_id, cid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No confirmation step or undo support
  #    - ❗ Implement safety confirmation (e.g., 2-step delete)
  #
  # 2. No validation of character ownership
  #    - 🚧 Ensure character belongs to requesting player_id
  #
  # 3. Lacks audit logging for destructive action
  #    - ✅ Emit deletion event to logging/telemetry system
end
