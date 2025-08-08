defmodule Mythweave.Zone.ZoneSync do
  @moduledoc """
  Handles syncing updated zone state to visible players.

  Responsibilities:
    - Broadcast NPC, object, or terrain updates
    - Compare visibility sets to minimize payload
    - Send deltas to clients as needed
  """

  alias Mythweave.UI.MessageDispatcher
  alias Mythweave.World.Visibility

  @type player_state :: %{id: String.t(), pos: {integer(), integer()}, visible: MapSet.t()}

  @spec sync_state([player_state()], map()) :: :ok
  def sync_state(players, zone_state) do
    Enum.each(players, fn %{id: id, pos: pos, visible: prev_vis} ->
      new_vis = Visibility.visible_coords(pos)

      if Visibility.changed?(prev_vis, new_vis) do
        MessageDispatcher.send(id, %{
          type: :zone_update,
          entities: list_entities(zone_state, new_vis)
        })
      end
    end)

    :ok
  end

  defp list_entities(zone_state, vis_set) do
    zone_state.entities
    |> Enum.filter(fn %{pos: pos} -> MapSet.member?(vis_set, pos) end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes all players are in same zone
  #    - ✅ Generalize for cross-zone sync
  #
  # 2. No change compression
  #    - 🚧 Add diffing between ticks to reduce bandwidth
  #
  # 3. No support for player-NPC visibility mismatch
  #    - ❗ Enforce stealth + perception checks

end
