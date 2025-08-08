defmodule Mythweave.State.StateStore do
  @moduledoc """
  Handles persistence of server-wide game state using PostgreSQL via Ecto.

  This module manages the read/write cycle of:
    - Global world metadata (time, weather, flags)
    - Future snapshot types (e.g., economy, event timelines, zone archives)

  Uses `WorldSnapshot` schema keyed by `"global"` for current implementation.
  """

  require Logger

  alias Mythweave.Persistence.Repo
  alias Mythweave.Persistence.Schemas.WorldSnapshot

  @global_snapshot_id "global"

  @type world_state :: map()
  @type db_result :: {:ok, term()} | {:error, Ecto.Changeset.t()}

  # -----------------------------
  # Public API
  # -----------------------------

  @spec load_world_state() :: world_state() | nil
  def load_world_state do
    case Repo.get(WorldSnapshot, @global_snapshot_id) do
      nil ->
        Logger.warn("WorldState not found in DB (id=#{@global_snapshot_id})")
        nil

      %WorldSnapshot{data: data} ->
        data
    end
  end

  @spec save_world_state(world_state()) :: db_result()
  def save_world_state(data) when is_map(data) do
    changeset =
      %WorldSnapshot{id: @global_snapshot_id}
      |> WorldSnapshot.changeset(%{data: data})

    case Repo.insert_or_update(changeset) do
      {:ok, _record} = result ->
        result

      {:error, changeset} = error ->
        Logger.error("Failed to persist world state: #{inspect(changeset.errors)}")
        error
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only supports the `"global"` snapshot right now
  #    - ❗ Future: expand to support multiple snapshot types and IDs
  #
  # 2. No timestamp comparison or merge strategy for stale data
  #    - 🔄 Optional: validate timestamp on load and reject outdated writes
  #
  # 3. No caching or ETS-layer between DB and WorldState
  #    - ❗ Add read-through/write-back cache later for performance

end
