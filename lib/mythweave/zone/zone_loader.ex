defmodule Mythweave.Zone.ZoneLoader do
  @moduledoc """
  Loads static and dynamic content for a given zone.

  Responsibilities:
    - Load terrain, entities, props, and triggers
    - Initialize default player spawns
    - Prepare zone for startup in memory
  """

  alias Mythweave.Loader.{EntityLoader, TerrainLoader}

  @spec load(String.t()) :: map()
  def load(zone_id) do
    %{
      terrain: TerrainLoader.load(zone_id),
      entities: EntityLoader.load(zone_id),
      spawn: {5, 5}
    }
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Hardcoded spawn position
  #    - ✅ Move to spawn metadata or per-faction config
  #
  # 2. Does not validate file existence
  #    - 🚧 Add error handling for invalid zone IDs
  #
  # 3. No support for prop scripts or hazards
  #    - ❗ Add event triggers and interactive tile support

end
