defmodule Mythweave.Zone.ZoneMutator do
  @moduledoc """
  Provides mutation helpers for adding/removing entities in a zone.

  Responsibilities:
    - Insert or remove entities from zone state
    - Notify players of spawn or despawn
    - Update dynamic layers of the world map
  """

  alias Mythweave.Zone.ZoneServer

  @spec spawn_entity(pid(), map()) :: :ok
  def spawn_entity(zone_pid, entity) do
    GenServer.cast(zone_pid, {:spawn, entity})
  end

  @spec despawn_entity(pid(), String.t()) :: :ok
  def despawn_entity(zone_pid, entity_id) do
    GenServer.cast(zone_pid, {:despawn, entity_id})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Entity metadata not validated
  #    - ✅ Ensure position and type are set
  #
  # 2. No collision check on spawn
  #    - 🚧 Validate spawn location is free
  #
  # 3. No broadcast logic here
  #    - ❗ Integrate with ZoneServer outbound sync

end
