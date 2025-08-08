defmodule Mythweave.Zone.ZoneServer do
  @moduledoc """
  Handles live simulation for a single zone.

  Responsibilities:
    - Maintains real-time entity and environment state via `ZoneState`
    - Executes tick loop for AI, physics, event processing
    - Publishes events to the internal PubSub/EventBus system
    - Initializes zone state from `WorldLoader`

  This GenServer is uniquely registered via the `ZoneRegistry`.
  """

  use GenServer

  alias Mythweave.State.ZoneState
  alias Mythweave.Engine.EventBus
  alias Mythweave.World.WorldLoader
  alias Mythweave.Zone.ZoneSchema

  @tick_rate_ms 100

  @type zone_id :: String.t()
  @type state :: ZoneState.t()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(zone_id()) :: GenServer.on_start()
  def start_link(zone_id) do
    GenServer.start_link(__MODULE__, zone_id, name: via(zone_id))
  end

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(zone_id) do
    with {:ok, raw_data} <- WorldLoader.load_zone(zone_id),
         :ok <- ZoneSchema.validate(raw_data),
         %ZoneState{} = zone_state <- ZoneState.build(zone_id, raw_data) do
      {:ok, zone_state, {:continue, :start_tick_loop}}
    else
      {:error, reason} ->
        Logger.error("Failed to initialize zone #{zone_id}: #{inspect(reason)}")
        {:stop, reason}
    end
  end

  @impl true
  def handle_continue(:start_tick_loop, state) do
    :timer.send_interval(@tick_rate_ms, :tick)
    {:noreply, state}
  end

  @impl true
  def handle_info(:tick, state) do
    # 🔄 TODO: Implement ECS tick update for entities and world state
    # 🔄 TODO: Publish fine-grained updates to players in this zone
    EventBus.publish(:zone_tick, %{zone: state.zone_id})
    {:noreply, state}
  end

  # -----------------------------
  # Helpers
  # -----------------------------

  defp via(zone_id),
    do: {:via, Registry, {Mythweave.ZoneRegistry, zone_id}}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. ZoneState.build/2 must synthesize initial live state from raw zone data
  #    - ✅ Ensure ZoneState supports this operation and is fault tolerant
  #
  # 2. Tick loop has no entity/world update logic yet
  #    - ❗ Future: invoke entity system, AI behavior trees, collision/movement, etc
  #
  # 3. No routing logic for player joins, exits, or interactions
  #    - ❗ Future: implement dynamic player attachment and socket messaging
  #
  # 4. No support for dynamic prop changes, weather, or time
  #    - 🔄 Optional: introduce zone events and simulation triggers

end
