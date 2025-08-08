defmodule Mythweave.Auth.SessionRegistry do
  @moduledoc """
  Tracks online players and their session processes.

  Responsibilities:
    - Register players with process monitoring
    - Lookup player sessions
    - Auto-clean on crash or disconnect
  """

  use GenServer
  require Logger

  @type player_id :: String.t()
  @type player_pid :: pid()
  @type state :: %{player_id() => player_pid()}

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(_opts), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  # Public API

  @spec register(player_id(), player_pid()) :: :ok
  def register(player_id, pid), do: GenServer.cast(__MODULE__, {:register, player_id, pid})

  @spec unregister(player_id()) :: :ok
  def unregister(player_id), do: GenServer.cast(__MODULE__, {:unregister, player_id})

  @spec list_online() :: [player_id()]
  def list_online, do: GenServer.call(__MODULE__, :list)

  @spec whereis(player_id()) :: {:ok, pid()} | :error
  def whereis(player_id), do: GenServer.call(__MODULE__, {:whereis, player_id})

  # GenServer callbacks

  @impl true
  def handle_cast({:register, player_id, pid}, state) do
    Logger.info("Session registered", player_id: player_id, pid: inspect(pid))
    Process.monitor(pid)
    {:noreply, Map.put(state, player_id, pid)}
  end

  @impl true
  def handle_cast({:unregister, player_id}, state) do
    Logger.info("Session unregistered", player_id: player_id)
    {:noreply, Map.delete(state, player_id)}
  end

  @impl true
  def handle_call(:list, _from, state), do: {:reply, Map.keys(state), state}

  @impl true
  def handle_call({:whereis, player_id}, _from, state) do
    case Map.fetch(state, player_id) do
      {:ok, pid} when is_pid(pid) ->
        if Process.alive?(pid) do
          {:reply, {:ok, pid}, state}
        else
          {:reply, :error, Map.delete(state, player_id)}
        end

      _ ->
        {:reply, :error, Map.delete(state, player_id)}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    new_state = Enum.reject(state, fn {_id, p} -> p == pid end) |> Map.new()
    Logger.info("Session removed due to process exit", pid: inspect(pid))
    {:noreply, new_state}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only one session per player_id is allowed
  #    - 🚧 Switch to `MapSet` per player for multi-device support
  #
  # 2. Sessions never expire
  #    - ❗ Implement TTL with periodic GC for zombie entries
  #
  # 3. No connection metadata (IP, device)
  #    - ✅ Add optional metadata struct if needed
end
