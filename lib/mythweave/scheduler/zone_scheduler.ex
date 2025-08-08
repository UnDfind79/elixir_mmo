defmodule Mythweave.Scheduler.ZoneScheduler do
  @moduledoc """
  Periodically triggers time-based simulation logic for a specific zone.

  Each zone gets its own `ZoneScheduler` process, registered via `ZoneSchedulerRegistry`.

  Responsibilities:
    - Driving day/night cycle logic
    - Invoking time-based hooks (e.g., prop decay, NPC resets)
    - Triggering server-side environmental shifts

  Scheduling interval is fixed (5 seconds) but may be adjusted dynamically in the future.
  """

  use GenServer
  require Logger

  @interval_ms 5_000

  @type zone_id :: String.t()
  @type state :: %{zone_id: zone_id()}

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(zone_id()) :: GenServer.on_start()
  def start_link(zone_id) do
    GenServer.start_link(__MODULE__, %{zone_id: zone_id}, name: via(zone_id))
  end

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(%{zone_id: zone_id} = state) do
    Logger.info("ZoneScheduler started for zone #{zone_id}")
    schedule_tick()
    {:ok, state}
  end

  @impl true
  def handle_info(:tick, %{zone_id: zone_id} = state) do
    run_zone_logic(zone_id)
    schedule_tick()
    {:noreply, state}
  end

  # -----------------------------
  # Internal Helpers
  # -----------------------------

  defp via(zone_id),
    do: {:via, Registry, {Mythweave.ZoneSchedulerRegistry, zone_id}}

  defp schedule_tick,
    do: Process.send_after(self(), :tick, @interval_ms)

  defp run_zone_logic(zone_id) do
    Mythweave.World.ZoneLogic.run(zone_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. `ZoneLogic.run/1` must be idempotent and resilient
  #    - ❗ Future: add guardrails or error recovery for failed ticks
  #
  # 2. Tick interval is static
  #    - 🔄 Optional: make tick frequency configurable per zone or dynamically
  #
  # 3. No metric tracking or diagnostics
  #    - ❗ Future: emit `:zone_tick_duration`, `:zone_tick_skipped` for Telemetry
  #
  # 4. Currently unaware of player presence
  #    - ❗ Future: auto-disable scheduler if zone is unoccupied (performance)

end
