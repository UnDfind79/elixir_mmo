defmodule Mythweave.Zone.LayeredMap do
  @moduledoc """
  Represents a zone with multiple vertical terrain layers.

  Responsibilities:
    - Store terrain and prop data per layer
    - Provide access to walkability and movement cost
    - Support vertical traversal and cross-layer checks
  """

  @type coord :: {integer(), integer()}
  @type layer :: non_neg_integer()
  @type tile :: %{walkable: boolean(), cost: integer(), props: list()}
  @type t :: %{layer => %{coord => tile()}}

  @doc """
  Creates a new layered map from raw layer data.
  """
  @spec build_from_layers([{layer(), map()}]) :: t()
  def build_from_layers(layer_data) do
    Enum.into(layer_data, %{}, fn {layer_num, tiles} ->
      {layer_num, normalize_layer(tiles)}
    end)
  end

  @doc """
  Checks whether a tile at the given position and layer is walkable.
  """
  @spec walkable?(t(), coord(), layer()) :: boolean()
  def walkable?(map, {x, y}, layer) do
    get_in(map, [layer, {x, y}, :walkable]) == true
  end

  @doc """
  Gets the movement cost of a tile, or returns a default.
  """
  @spec movement_cost(t(), coord(), layer()) :: integer()
  def movement_cost(map, {x, y}, layer) do
    get_in(map, [layer, {x, y}, :cost]) || 1
  end

  @doc """
  Retrieves all props on a given tile.
  """
  @spec props_at(t(), coord(), layer()) :: list()
  def props_at(map, {x, y}, layer) do
    get_in(map, [layer, {x, y}, :props]) || []
  end

  defp normalize_layer(raw) do
    Enum.into(raw, %{}, fn {coord, attrs} ->
      {coord, Map.merge(%{walkable: true, cost: 1, props: []}, attrs)}
    end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No prop tag filtering
  #    - ✅ Add support for filtering by tag (e.g., :cover, :spawnable)
  #
  # 2. No vertical traversal logic
  #    - 🚧 Allow climbing/descending between layers with rules
  #
  # 3. No caching of frequently accessed tiles
  #    - ❗ Consider ETS or memoization for AI pathing
end
