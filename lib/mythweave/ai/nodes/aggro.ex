defmodule Mythweave.AI.Nodes.Aggro do
  @moduledoc """
  Behavior tree node that checks for nearby hostile entities and
  assigns the closest valid one as the target.

  Responsibilities:
    - Scan surrounding area within aggro radius
    - Filter by faction hostility rules
    - Set nearest target in AI context map
  """

  alias Mythweave.World.ZoneServer
  alias Mythweave.Utils.Vector

  @search_radius 5

  @type context :: map()
  @type result :: {:success, context()} | :failure

  @spec tick(context(), keyword()) :: result()
  def tick(%{position: pos, zone_id: zone_id} = context, _opts) do
    case find_nearest_hostile(pos, zone_id, context) do
      nil -> :failure
      %{id: target_id} = target ->
        {:success, Map.merge(context, %{target: target_id, target_entity: target})}
    end
  end

  defp find_nearest_hostile(pos, zone_id, %{faction: ai_faction}) do
    ZoneServer.entities_in_radius(zone_id, pos, @search_radius)
    |> Enum.filter(fn ent -> hostile?(ai_faction, ent) end)
    |> Enum.min_by(
      fn %{position: t_pos} -> Vector.distance(pos, t_pos) end,
      fn -> nil end
    )
  end

  defp hostile?(nil, _), do: false
  defp hostile?(_, %{faction: nil}), do: false
  defp hostile?(f1, %{faction: f2}), do: f1 != f2  # Expandable with faction matrix

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No faction system
  #    - ✅ Replace `!=` logic with faction rules from MythSystem
  #
  # 2. No visibility or obstruction checks
  #    - 🚧 Add LOS filtering (line-of-sight) if needed
  #
  # 3. No threat weighting
  #    - ❗ Consider priorities (e.g., lowest HP, nearest caster, etc.)
end
