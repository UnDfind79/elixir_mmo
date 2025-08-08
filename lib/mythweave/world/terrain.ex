defmodule Mythweave.World.Terrain do
  @moduledoc """
  Stores and provides access to static map terrain data.

  Responsibilities:
    - Load terrain metadata for collision and pathing
    - Expose tile queries for NPC AI and player movement
    - Support multiple zone maps with layered data
  """

  @type tile :: %{type: atom(), walkable: boolean()}
  @type map_grid :: %{integer() => %{integer() => tile()}}

  @spec walkable?(map_grid(), {integer(), integer()}) :: boolean()
  def walkable?(map, {x, y}) do
    get_in(map, [x, y, :walkable]) == true
  end

  @spec tile_type(map_grid(), {integer(), integer()}) :: atom()
  def tile_type(map, {x, y}) do
    get_in(map, [x, y, :type]) || :unknown
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes 2D map grid is loaded
  #    - ✅ Add file loader for TMX/CSV maps
  #
  # 2. No support for Z-layers
  #    - 🚧 Add elevation and multi-layer support
  #
  # 3. No terrain-based movement modifiers
  #    - ❗ Add movement cost and slowdown rules

end
