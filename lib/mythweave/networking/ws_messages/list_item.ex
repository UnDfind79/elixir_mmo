defmodule Mythweave.Networking.WSMessages.ListItem do
  @moduledoc """
  Lists all items in a player's inventory.

  Responsible for:
    - Fetching current inventory contents
    - Returning raw or structured item list
  """

  defstruct []

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{}

  @spec handle(t(), String.t()) :: {:ok, list()} | {:error, term()}
  def handle(_msg, player_id) do
    PlayerState.get_inventory(player_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes inventory always returns {:ok, items}
  #    - ❗ Handle missing players or corrupted state
  #
  # 2. No metadata included (e.g., item location, slot, state)
  #    - 🚧 Enrich item data with slot/stack/equip context
  #
  # 3. No paging or limits for large inventories
  #    - ✅ Add support for pagination if inventories grow
end
