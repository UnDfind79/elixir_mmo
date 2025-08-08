defmodule Mythweave.TestUtils.CLICommands do
  @moduledoc """
  Developer-facing CLI interface for debugging and simulation.

  Responsibilities:
    - Expose manual commands via IEx or dev console
    - Trigger player actions, spawns, schema switches
    - Inspect world state and performance stats
  """

  alias Mythweave.TestUtils.SimulationRunner
  alias Mythweave.Player.PlayerServer
  alias Mythweave.World.ZoneServer

  @doc """
  Spawns a dummy player with the given ID.
  """
  @spec spawn(String.t()) :: :ok
  def spawn(player_id) do
    SimulationRunner.spawn_player(player_id, %{behavior: :wander})
  end

  @doc """
  Teleports a player to specific coordinates.
  """
  @spec teleport(String.t(), {integer(), integer()}, integer()) :: :ok
  def teleport(player_id, {x, y}, layer \\ 0) do
    case PlayerServer.lookup(player_id) do
      {:ok, pid} -> PlayerServer.set_position(pid, {x, y}, layer)
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Broadcasts an artificial message to all players in a zone.
  """
  @spec broadcast(String.t(), any()) :: :ok
  def broadcast(zone_id, message) do
    ZoneServer.broadcast(zone_id, {:test_msg, message})
  end

  @doc """
  Prints the current zone state to console.
  """
  @spec debug_zone(String.t()) :: :ok
  def debug_zone(zone_id) do
    IO.inspect(ZoneServer.get_state(zone_id), label: "Zone #{zone_id}")
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No auth or permission gates
  #    - ✅ Restrict CLI to dev/test env only
  #
  # 2. No error logging or formatting
  #    - 🚧 Improve error messages for common misuse
  #
  # 3. No support for schema injection
  #    - ❗ Add `/give_schema` or augment injection tool
end
