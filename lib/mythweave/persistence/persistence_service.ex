defmodule Mythweave.Persistence.PersistenceService do
  @moduledoc """
  Provides high-level logic for saving and loading game state, including:
    - Player data
    - Inventory
    - Character records

  This module acts as the gateway between live game logic and the database.
  """

  require Logger

  alias Mythweave.Persistence.DB
  alias Mythweave.Schemas.{Player, Inventory, Character}

  @type player_id :: String.t()
  @type result_ok :: {:ok, term()}
  @type result_err :: {:error, term()}
  @type db_result :: result_ok() | result_err()

  # -----------------------------
  # Player State
  # -----------------------------

  @spec load_player(player_id()) :: db_result()
  def load_player(player_id) do
    case DB.get_by(Player, id: player_id) do
      %Player{} = player -> {:ok, player}
      nil ->
        Logger.warn("Player not found: #{player_id}")
        {:error, :not_found}
    end
  end

  @spec save_player(Player.t()) :: db_result()
  def save_player(%Player{} = player_changeset),
    do: DB.update(player_changeset)

  # -----------------------------
  # Inventory
  # -----------------------------

  @spec load_inventory(player_id()) :: Inventory.t() | nil
  def load_inventory(player_id),
    do: DB.get_by(Inventory, player_id: player_id)

  # -----------------------------
  # Character Sheet
  # -----------------------------

  @spec save_character(Character.t()) :: db_result()
  def save_character(%Character{} = character_changeset),
    do: DB.update(character_changeset)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No preloading or joins on load
  #    - ❗ Future: support `load_player_with_inventory/1`, preload all nested data
  #
  # 2. No caching layer or ETS acceleration
  #    - 🔄 Optional: add ETS caching for hot characters to reduce DB load
  #
  # 3. No handling for creation or deletion
  #    - ❗ Future: implement `create_player/1`, `delete_player/1`, etc.

end
