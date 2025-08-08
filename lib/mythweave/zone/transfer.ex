defmodule Mythweave.Zone.Transfer do
  @moduledoc """
  Handles moving a player between zones, including layer handoff and state sync.

  Responsibilities:
    - Validate destination zone and coordinates
    - Notify both old and new ZoneServer of transfer
    - Preserve player state and visibility
  """

  alias Mythweave.Zone.{ZoneServer, ZoneRegistry}
  alias Mythweave.Player.PlayerServer

  @type player_id :: String.t()
  @type zone_id :: String.t()
  @type coord :: {integer(), integer()}
  @type layer :: non_neg_integer()

  @spec transfer(player_id(), zone_id(), coord(), layer()) :: :ok | {:error, term()}
  def transfer(player_id, to_zone, {x, y} = coord, layer) do
    with {:ok, player_pid} <- PlayerServer.lookup(player_id),
         {:ok, from_zone} <- PlayerServer.get_zone(player_pid),
         true <- ZoneRegistry.exists?(to_zone),
         {:ok, _} <- ZoneServer.add_player(to_zone, player_id, coord, layer),
         :ok <- ZoneServer.remove_player(from_zone, player_id),
         :ok <- PlayerServer.set_zone(player_pid, to_zone, coord, layer) do
      :ok
    else
      _ -> {:error, :invalid_transfer}
    end
  end

  @doc """
  Attempts to move a player across adjacent zones based on edge crossing.
  """
  @spec maybe_cross_edge(player_id(), coord(), layer()) :: :ok | :noop
  def maybe_cross_edge(player_id, {x, y} = pos, layer) do
    case ZoneServer.adjacent_zone_at?(pos) do
      {:ok, new_zone, entry_pos} ->
        transfer(player_id, new_zone, entry_pos, layer)

      :none ->
        :noop
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No spawn safety check on destination tile
  #    - ✅ Ensure walkability before placement
  #
  # 2. No notification to nearby players
  #    - 🚧 Broadcast leave/enter events on both sides
  #
  # 3. No interrupt checks during movement
  #    - ❗ Prevent transfers mid-cast or stunned
end
