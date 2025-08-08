defmodule Mythweave.Networking.WSMessages.PartyLeave do
  @moduledoc """
  Allows a player to leave their current party.

  Responsible for:
    - Routing leave request to the party service
    - Cleaning up party state if needed
  """

  defstruct []

  alias Mythweave.Social.PartyService

  @type t :: %__MODULE__{}

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(_, player_id) do
    PartyService.leave(player_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No feedback to the player on result
  #    - ✅ Respond with confirmation or reason for failure
  #
  # 2. No party broadcast of member departure
  #    - 🚧 Notify remaining party members of the change
  #
  # 3. Assumes player is currently in a party
  #    - ❗ Validate party membership before proceeding
end
