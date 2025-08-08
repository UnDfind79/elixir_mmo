defmodule Mythweave.Networking.WSMessages.Move do
  @moduledoc """
  Updates a player's position in the world.

  Responsible for:
    - Receiving client movement requests
    - Updating world state with new coordinates
  """

  defstruct [:x, :y]

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{
          x: integer(),
          y: integer()
        }

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{x: x, y: y}, player_id) do
    PlayerState.set_position(player_id, {x, y})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Accepts raw position without validation or rate limiting
  #    - ❗ Implement movement validation (distance, cooldown, path)
  #
  # 2. No collision, zone, or map logic tied to movement
  #    - 🚧 Integrate spatial systems for collision checks
  #
  # 3. Broadcast or notify others of movement missing
  #    - ✅ Add EventBus hooks to inform nearby players
end
