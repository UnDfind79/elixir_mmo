defmodule Mythweave.Networking.ConnectionManager do
  @moduledoc """
  Tracks live WebSocket connections per player using a GenServer.

  Features:
    - Multi-session support (multiple PIDs per player ID)
    - Reverse PID-to-player lookup
    - Safe disconnect and cleanup logic
    - Handles session termination gracefully
  """

  use GenServer
  require Logger

  @type player_id :: String.t()
  @type connection_state :: %{player_id() => MapSet.t(pid())}

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @spec register(player_id(), pid()) :: :ok
  def register(player_id, pid),
    do: GenServer.cast(__MODULE__, {:register, player_id, pid})

  @spec unregister(player_id()) :: :ok
  def unregister(player_id),
    do: GenServer.cast(__MODULE__, {:unregister, player_id})

  @spec disconnect_pid(pid()) :: :ok
  def disconnect_pid(pid),
    do: GenServer.cast(__MODULE__, {:disconnect_pid, pid})

  @spec get_pids(player_id()) :: [pid()]
  def get_pids(player_id),
    do: GenServer.call(__MODULE__, {:get_pids, player_id})

  @spec find_player_by_pid(pid()) :: player_id() | nil
  def find_player_by_pid(pid),
    do: GenServer.call(__MODULE__, {:reverse_lookup, pid})

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(_),
    do: {:ok, %{}}

  @impl true
  def handle_cast({:register, id, pid}, state) do
    updated = Map.update(state, id, MapSet.new([pid]), &MapSet.put(&1, pid))
    {:noreply, updated}
  end

  @impl true
  def handle_cast({:unregister, id}, state),
    do: {:noreply, Map.delete(state, id)}

  @impl true
  def handle_cast({:disconnect_pid, pid}, state) do
    new_state =
      Enum.reduce(state, %{}, fn {id, pids}, acc ->
        updated = MapSet.delete(pids, pid)
        if MapSet.size(updated) > 0, do: Map.put(acc, id, updated), else: acc
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get_pids, id}, _from, state),
    do: {:reply, Map.get(state, id, MapSet.new()) |> MapSet.to_list(), state}

  @impl true
  def handle_call({:reverse_lookup, pid}, _from, state) do
    player_id =
      Enum.find_value(state, fn {id, pids} ->
        if MapSet.member?(pids, pid), do: id, else: nil
      end)

    {:reply, player_id, state}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Connection events are silent
  #    - ❗ Future: emit `:player_connected`, `:player_disconnected` via EventBus
  #
  # 2. State is not clustered — local to node
  #    - ❗ Needed: ETS + Horde or DeltaCRDT for cross-node session awareness
  #
  # 3. No timeout or idle kick logic
  #    - 🔄 Optional: implement disconnect timeout for zombie PIDs

end
