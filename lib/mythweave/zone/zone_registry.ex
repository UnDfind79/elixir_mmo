defmodule Mythweave.Zone.ZoneRegistry do
  @moduledoc """
  Tracks all live zone server processes by zone ID.

  Responsibilities:
    - Allow lookup, registration, and monitoring of active zones
    - Enable broadcasting or zone-specific commands
    - Facilitate distributed supervision in multi-node mode
    - Store zone metadata for filtering and introspection
  """

  use GenServer

  @type zone_id :: String.t()
  @type zone_metadata :: %{pid: pid(), tags: [atom()]}
  @type state :: %{optional(zone_id()) => zone_metadata()}

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(state), do: {:ok, state}

  @spec register(zone_id(), pid(), [atom()]) :: :ok
  def register(zone_id, pid, tags \\ []),
    do: GenServer.cast(__MODULE__, {:register, zone_id, pid, tags})

  @spec get(zone_id()) :: {:ok, pid()} | :error
  def get(zone_id), do: GenServer.call(__MODULE__, {:get, zone_id})

  @spec list() :: [zone_id()]
  def list, do: GenServer.call(__MODULE__, :list)

  @spec tagged([atom()]) :: [zone_id()]
  def tagged(tags), do: GenServer.call(__MODULE__, {:tagged, tags})

  @impl true
  def handle_cast({:register, zone_id, pid, tags}, state) do
    Process.monitor(pid)

    update = Map.put(state, zone_id, %{pid: pid, tags: tags})
    {:noreply, update}
  end

  @impl true
  def handle_call({:get, zone_id}, _from, state) do
    case Map.get(state, zone_id) do
      %{pid: pid} -> {:reply, {:ok, pid}, state}
      _ -> {:reply, :error, state}
    end
  end

  def handle_call(:list, _from, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_call({:tagged, required_tags}, _from, state) do
    filtered =
      state
      |> Enum.filter(fn {_id, %{tags: tags}} ->
        Enum.all?(required_tags, &Enum.member?(tags, &1))
      end)
      |> Enum.map(fn {id, _} -> id end)

    {:reply, filtered, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    updated =
      state
      |> Enum.reject(fn {_id, meta} -> meta.pid == pid end)
      |> Enum.into(%{})

    {:noreply, updated}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Zone metadata is lightweight
  #    - ✅ Extend with instance, level range, zone_type
  #
  # 2. No distributed registry
  #    - 🚧 Replace with Horde or :global for cross-node use
  #
  # 3. Tags are static
  #    - ❗ Allow updates or rebinding of zone tags at runtime

end
