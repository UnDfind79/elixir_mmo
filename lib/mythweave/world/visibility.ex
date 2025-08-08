defmodule Mythweave.World.Visibility do
  @moduledoc """
  Manages line-of-sight and fog-of-war visibility per player.

  Responsibilities:
    - Track visible tiles and entities
    - Compare visibility across ticks for delta updates
    - Enforce stealth and obstruction mechanics
  """

  @type coord :: {integer(), integer()}
  @type vis_set :: MapSet.t(coord())

  @radius 8

  @spec visible_coords(coord()) :: vis_set()
  def visible_coords({x, y}) do
    for dx <- -@radius..@radius, dy <- -@radius..@radius,
        :math.sqrt(dx * dx + dy * dy) <= @radius,
        into: MapSet.new(),
        do: {x + dx, y + dy}
  end

  @spec changed?(vis_set(), vis_set()) :: boolean()
  def changed?(old, new), do: MapSet.difference(new, old) != MapSet.new()

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Uses circular radius approximation
  #    - ✅ Add tile-based LOS line blocking later
  #
  # 2. No terrain consideration
  #    - 🚧 Check Terrain module for walls/blocks
  #
  # 3. No stealth check for hidden NPCs
  #    - ❗ Add reveal based on perception checks

end
