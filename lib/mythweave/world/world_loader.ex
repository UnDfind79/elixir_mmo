defmodule Mythweave.World.WorldLoader do
  @moduledoc """
  Loads static world data (zones, terrain, spawn points, metadata) from disk or database.

  This module is responsible for retrieving zone definitions in JSON format. These are used to initialize
  zone layers, collision maps, prop placements, and other zone metadata used during server startup or hotloading.

  Supported zone file types:
    - `.server.json`: authoritative server zone definition
    - `.client.json`: visual-only data for validation
    - `.meta.json`: metadata for zone generation, hooks, etc.

  Future versions may support live hot-reloading and persistent DB-backed world definitions.
  """

  require Logger

  @app :mythweave
  @priv_worlds Path.join(:code.priv_dir(@app), "worlds")

  @type zone_data :: map()
  @type error_reason :: :not_found | :invalid_format | :read_error | :decode_error

  @doc """
  Returns the full path to the active world directory.
  Defaults to `test_world` if not configured.
  """
  @spec world_dir() :: String.t()
  def world_dir do
    world_key = Application.get_env(@app, :world_dir, "test_world")
    Path.join(@priv_worlds, world_key)
  end

  @doc """
  Loads the `.server.json` file for the given zone ID within the selected world.
  """
  @spec load_zone(String.t()) :: {:ok, zone_data()} | {:error, error_reason()}
  def load_zone(zone_id) do
    path = Path.join(world_dir(), "#{zone_id}.server.json")

    case File.read(path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, data} ->
            {:ok, data}

          {:error, reason} ->
            Logger.error("Zone #{zone_id} failed to decode: #{inspect(reason)}")
            {:error, :decode_error}
        end

      {:error, :enoent} ->
        Logger.warn("Zone file not found for ID: #{zone_id}")
        {:error, :not_found}

      {:error, reason} ->
        Logger.error("Zone file read error for ID #{zone_id}: #{inspect(reason)}")
        {:error, :read_error}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only `.server.json` is loaded. Client/meta loading not yet implemented
  #    - ❗ Future: implement `load_client_zone/1` and `load_meta/1` variants
  #
  # 2. Assumes all JSON files are fully schema-validated before use
  #    - ❗ Future: add schema validation (e.g., via JsonXema or custom validation pass)
  #
  # 3. Does not support world loading from a DB or remote system
  #    - ❗ Future: implement database-backed zone retrieval for dynamic servers
  #
  # 4. No hot-reload or inotify-like file watching
  #    - 🔄 Optional: add file system watch to auto-reload on edit

end
