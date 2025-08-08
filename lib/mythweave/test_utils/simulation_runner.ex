defmodule Mythweave.TestUtils.SimulationRunner do
  @moduledoc """
  Developer utility to spawn test players and NPCs for load simulation.

  Responsibilities:
    - Register simulated players or mobs into the world
    - Execute scripted behaviors (movement, combat, casting)
    - Log or trace performance metrics during simulation
  """

  alias Mythweave.Player.PlayerServer
  alias Mythweave.World.ZoneServer
  alias Mythweave.ClassSchema.ThreadHash
  alias Mythweave.Constants

  @default_zone Constants.starting_zone()
  @default_layer 0

  @doc """
  Spawns a simulated player with optional overrides.
  """
  @spec spawn_player(String.t(), map()) :: :ok
  def spawn_player(player_id, opts \\ %{}) do
    {:ok, pid} = PlayerServer.start_link(player_id)
    coords = Map.get(opts, :coord, {0, 0})
    zone = Map.get(opts, :zone, @default_zone)
    layer = Map.get(opts, :layer, @default_layer)

    ZoneServer.add_player(zone, player_id, coords, layer)
    PlayerServer.set_zone(pid, zone, coords, layer)
    simulate_behavior(pid, Map.get(opts, :behavior, :idle))
  end

  @doc """
  Simulates simple behavior for a given player PID.
  """
  @spec simulate_behavior(pid(), atom()) :: :ok
  def simulate_behavior(_pid, :idle), do: :ok

  def simulate_behavior(pid, :wander) do
    Task.start(fn -> loop_wander(pid) end)
    :ok
  end

  defp loop_wander(pid) do
    for _ <- 1..10 do
      PlayerServer.move_randomly(pid)
      Process.sleep(:rand.uniform(500))
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of player count
  #    - ✅ Cap spawn count to prevent crashing
  #
  # 2. No scripted combat interactions
  #    - 🚧 Add optional ability rotation scripts
  #
  # 3. No stats collection
  #    - ❗ Track average tick time, desyncs, memory use
end
