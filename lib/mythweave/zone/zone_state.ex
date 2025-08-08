defmodule Mythweave.Zone.ZoneState do
  @moduledoc """
  Represents the live simulation state of a single zone.

  Held by `ZoneServer`, this struct tracks:
    - All active entities (players, NPCs, props)
    - Active projectiles (arrows, spells, thrown objects)
    - Per-tile environmental flags (slow zones, fire, traps)
    - Current weather conditions affecting simulation

  Built from zone `.server.json` files at load time.
  """

  @enforce_keys [:zone_id]
  defstruct [
    :zone_id,
    entities: %{},
    projectiles: [],
    tile_flags: %{},
    weather: nil
  ]

  @type entity_id :: String.t()
  @type tile_flags :: map()
  @type projectile :: map()
  @type weather_type :: String.t() | nil

  @type t :: %__MODULE__{
          zone_id: String.t(),
          entities: %{optional(entity_id()) => map()},
          projectiles: [projectile()],
          tile_flags: tile_flags(),
          weather: weather_type()
        }

  # -----------------------------
  # Constructor
  # -----------------------------

  @spec new(String.t()) :: t()
  def new(zone_id), do: %__MODULE__{zone_id: zone_id}

  @spec build(String.t(), map()) :: t()
  def build(zone_id, raw_zone_data) do
    %__MODULE__{
      zone_id: zone_id,
      entities: %{},                    # Initially empty — populated at runtime
      projectiles: [],
      tile_flags: extract_tile_flags(raw_zone_data),
      weather: Map.get(raw_zone_data, "weather", nil)
    }
  end

  # -----------------------------
  # Internal Builders
  # -----------------------------

  defp extract_tile_flags(%{"collisions" => collisions}) when is_list(collisions) do
    Enum.reduce(collisions, %{}, fn %{"x" => x, "y" => y, "flags" => flags}, acc ->
      Map.put(acc, {x, y}, flags)
    end)
  end

  defp extract_tile_flags(_), do: %{}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. `entities` and `projectiles` are managed by ZoneServer tick logic
  #    - ❗ Future: add functions to safely update these via functional mutation
  #
  # 2. No hooks for prop or structure state
  #    - 🔄 Optional: add `props`, `interactables`, etc for environmental simulation
  #
  # 3. Tile flags use raw {x, y} tuple keys
  #    - ❗ Future: optimize for zone size and resolution (ETS or spatial map?)

end
