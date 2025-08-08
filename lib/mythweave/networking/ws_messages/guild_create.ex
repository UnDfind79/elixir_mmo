defmodule Mythweave.Networking.WSMessages.GuildCreate do
  @moduledoc """
  Creates a new guild with the player as leader.

  Responsible for:
    - Validating guild name
    - Creating guild record and leadership
    - Registering player as guild master
  """

  defstruct [:guild_name]

  alias Mythweave.Social.GuildService

  @type t :: %__MODULE__{
          guild_name: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{guild_name: name}, player_id) do
    GuildService.create_guild(player_id, name)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No guild name validation for profanity/length
  #    - ❗ Add validation before passing to GuildService
  #
  # 2. Does not check if player is already in a guild
  #    - 🚧 Prevent duplicate guild membership
  #
  # 3. No broadcast or notification to player
  #    - ✅ Ensure GuildService returns a response suitable for feedback
end
