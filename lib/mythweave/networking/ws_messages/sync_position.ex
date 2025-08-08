defmodule Mythweave.Networking.WSMessages.SyncPosition do
  @moduledoc """
  Forces a position resync from client to server.

  Responsible for:
    - Accepting coordinate input from client
    - Updating authoritative player position state
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

  # 1. No movement validation performed
  #    - ❗ Sanitize or verify client-reported coordinates against server state
  #
  # 2. Assumes all position updates are legit
  #    - 🚧 Add anti-teleportation or cheat-detection filters
  #
  # 3. No acknowledgment or state echo to client
  #    - ✅ Consider emitting position sync confirmation via socket
end
