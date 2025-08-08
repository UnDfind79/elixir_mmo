defmodule Mythweave.EntityFactory do
  @moduledoc """
  Builds in-world game entities (NPCs, mobs, objects) from raw data or defined prototypes.

  Responsibilities:
    - Load and validate entity blueprints from disk or DB
    - Normalize stat maps and atomize keys
    - Allow runtime overrides for spawned variants
    - Prepare clean `Mythweave.Entity` structs
  """

  alias Mythweave.Entity

  @type raw_entity :: map()
  @type overrides :: map()

  @spec build_from_map(raw_entity()) :: Entity.t()
  def build_from_map(%{
        "id" => id,
        "type" => type,
        "name" => name,
        "position" => %{"x" => x, "y" => y},
        "zone" => zone_id,
        "stats" => stats
      }) do
    Entity.new(
      id,
      String.to_atom(type),
      name,
      {x, y},
      zone_id,
      normalize_stats(stats),
      %{}
    )
  end

  @spec build_from_prototype(raw_entity(), overrides()) :: Entity.t()
  def build_from_prototype(prototype, overrides \\ %{}) do
    prototype
    |> Map.merge(overrides)
    |> build_from_map()
  end

  @spec normalize_stats(map() | nil) :: map()
  defp normalize_stats(stats) when is_map(stats) do
    for {k, v} <- stats, into: %{}, do: {String.to_atom(k), v}
  end

  defp normalize_stats(_), do: %{}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of required fields (id, type, zone, etc)
  #    - ❗ Replace with {:ok, Entity.t()} | {:error, reason} pattern
  #
  # 2. No support for gear-augmented stat injection
  #    - 🚧 Inject equipment from prototype metadata or runtime context
  #
  # 3. Metadata remains empty
  #    - ✅ Use prototype fields for behavior, faction, AI hints

end
