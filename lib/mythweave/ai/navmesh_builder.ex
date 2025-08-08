defmodule Mythweave.AI.NavmeshBuilder do
  @moduledoc """
  Generates navigation meshes and movement cost maps for terrain-aware AI pathing.

  Responsibilities:
    - Identify walkable tiles per zone layer
    - Tag navigable areas with movement costs
    - Provide runtime queries for AI decision making
  """

  alias Mythweave.World.LayeredMap

  @type coord :: {integer(), integer()}
  @type layer :: non_neg_integer()
  @type tile_cost :: non_neg_integer()
  @type navmesh :: %{layer() => %{coord() => tile_cost()}}

  @doc """
  Builds a navmesh with movement cost per walkable tile.
  """
  @spec build_navmesh(LayeredMap.t()) :: navmesh()
  def build_navmesh(layered_map) do
    Enum.reduce(layered_map, %{}, fn {layer, tiles}, acc ->
      costs =
        tiles
        |> Enum.filter(fn {_coord, tile} -> tile.walkable end)
        |> Enum.map(fn {coord, tile} -> {coord, tile.cost || 1} end)
        |> Map.new()

      Map.put(acc, layer, costs)
    end)
  end

  @doc """
  Checks whether a tile is traversable and returns its cost.
  Returns `{:ok, cost}` or `:blocked`.
  """
  @spec movement_cost(navmesh(), coord(), layer()) :: {:ok, tile_cost()} | :blocked
  def movement_cost(mesh, coord, layer) do
    case get_in(mesh, [layer, coord]) do
      nil -> :blocked
      cost -> {:ok, cost}
    end
  end

  @doc """
  Returns a list of all walkable coordinates on the given layer.
  """
  @spec coords_on_layer(navmesh(), layer()) :: [coord()]
  def coords_on_layer(mesh, layer) do
    mesh
    |> Map.get(layer, %{})
    |> Map.keys()
  end

  @doc """
  Returns whether a given tile is navigable by AI.
  """
  @spec navigable?(navmesh(), coord(), layer()) :: boolean()
  def navigable?(mesh, coord, layer) do
    get_in(mesh, [layer, coord]) != nil
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No elevation constraints or slopes
  #    - ✅ Add height deltas to tile metadata in LayeredMap
  #
  # 2. No entity size rules (e.g., large creatures can't fit in 1x1)
  #    - 🚧 Introduce clearance metadata or tile tags
  #
  # 3. No support for blocked props (e.g., furniture)
  #    - ❗ Use prop tags to dynamically update mesh on spawn/despawn
end
