defmodule Mythweave.Networking.WSMessages.ListCharacters do
  @moduledoc """
  Lists all characters available to a player.

  Responsible for:
    - Querying player state storage
    - Returning structured list of characters
  """

  defstruct []

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{}

  @spec handle(t(), String.t()) :: {:ok, list()} | {:error, term()}
  def handle(_msg, player_id) do
    PlayerState.list_characters(player_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes character data is always present or {:ok, []}
  #    - ❗ Handle storage failure or retrieval issues gracefully
  #
  # 2. Does not include metadata (e.g., last played, zone)
  #    - 🚧 Extend PlayerState.list_characters/1 to return richer detail
  #
  # 3. No pagination or limit on large character lists
  #    - ✅ Add support for paging if needed later
end
