defmodule Mythweave.State.WorldState do
  @moduledoc """
  Global, server-wide cache for world-level state.

  This GenServer holds and manages high-level world metadata, such as:
    - Time of day (`:day`, `:night`, etc)
    - Weather conditions
    - Global flags and world events

  The data is read-through from persistent store (StateStore) on boot
  and updated asynchronously when changed.

  Consumers should call `get/0` for full snapshot or
  use `update/2` for partial state mutation.
  """

  use GenServer

  alias Mythweave.State.StateStore

  @name __MODULE__

  @type world_state :: %{
          time_of_day: String.t(),
          weather: String.t(),
          global_flags: map()
        }

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, %{}, name: @name)

  @spec get() :: world_state()
  def get,
    do: GenServer.call(@name, :get)

  @spec update(atom(), term()) :: :ok
  def update(key, value),
    do: GenServer.cast(@name, {:update, key, value})

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(_) do
    initial_state = StateStore.load_world_state() || default_state()
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get, _from, state),
    do: {:reply, state, state}

  @impl true
  def handle_cast({:update, key, value}, state) do
    new_state = Map.put(state, key, value)
    :ok = StateStore.save_world_state(new_state)
    {:noreply, new_state}
  end

  # -----------------------------
  # Helpers
  # -----------------------------

  defp default_state do
    %{
      time_of_day: "day",
      weather: "clear",
      global_flags: %{}
    }
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation or type enforcement on updates
  #    - ❗ Future: define schema for allowed keys and value types
  #
  # 2. No event broadcasting on world change (e.g., weather shift)
  #    - ❗ Future: emit `:world_updated` or `:weather_changed` via EventBus
  #
  # 3. No delta patching or subscriptions for partial observers
  #    - 🔄 Optional: allow players/NPCs to subscribe to world state changes
  #
  # 4. Assumes single-node deployment for world state
  #    - ❗ Future: cluster-safe version for distributed nodes (ETS/Mnesia/DeltaCRDT)

end
