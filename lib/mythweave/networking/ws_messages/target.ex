defmodule Mythweave.Networking.WSMessages.Target do
  @moduledoc """
  Sets a target for the player (for combat, inspect, etc).

  Responsible for:
    - Storing a target reference in player state
    - Supporting context-sensitive targeting (combat, interaction, etc)
  """

  defstruct [:target_id]

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{
          target_id: String.t()
        }

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{target_id: tid}, player_id) do
    PlayerState.set_target(player_id, tid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of target existence or visibility
  #    - ❗ Check if target is valid and visible in player's zone
  #
  # 2. Does not differentiate between types of targets
  #    - 🚧 Tag targets by type (enemy, ally, object) to refine behavior
  #
  # 3. Silent failure if player state is unavailable
  #    - ✅ Consider returning descriptive errors or logging fallback
end
