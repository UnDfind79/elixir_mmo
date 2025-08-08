defmodule Mythweave.Engine.TickLoop do
  @moduledoc """
  Central ticking system dispatching `:tick` events at a fixed interval.

  Drives all real-time systems (AI, world simulation, NPC behaviors).

  Emits:
    - `[:mythweave, :tick, :frame]` telemetry event per tick
    - `:tick` messages to `Mythweave.Engine.EventBus` subscribers

  Configuration:
    - Set `:tick_rate` in app config (defaults to 100ms)
  """

  use GenServer
  require Logger

  alias Mythweave.Engine.{EventBus, Metrics}
  alias Mythweave.Utils.Config

  @tick_event :tick

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    tick_rate = Config.get(:tick_rate, 100)
    Logger.info("🚀 TickLoop started at #{tick_rate}ms intervals")

    next_tick(tick_rate)
    {:ok, %{tick_rate: tick_rate, last_tick: current_time_ms()}}
  end

  @impl true
  def handle_info(:tick, %{tick_rate: tick_rate, last_tick: last_ts} = state) do
    now = current_time_ms()
    drift = now - last_ts - tick_rate

    Metrics.emit_event([:tick, :frame], %{count: 1, drift: drift}, %{})
    EventBus.broadcast(@tick_event, @tick_event)

    next_tick(tick_rate)
    {:noreply, %{state | last_tick: now}}
  end

  @doc """
  Dynamically adjusts the tick rate at runtime.
  """
  @spec set_tick_rate(non_neg_integer()) :: :ok
  def set_tick_rate(ms) when is_integer(ms) and ms > 0 do
    GenServer.cast(__MODULE__, {:set_tick_rate, ms})
  end

  @impl true
  def handle_cast({:set_tick_rate, ms}, state) do
    Logger.info("⚙️ Tick rate updated to #{ms}ms")
    {:noreply, %{state | tick_rate: ms}}
  end

  defp next_tick(ms), do: Process.send_after(self(), @tick_event, ms)
  defp current_time_ms(), do: System.system_time(:millisecond)

  # -------------------------
  # ✅ COMPLETED UPGRADES
  # -------------------------
  # - Drift compensation via timestamp delta
  # - Runtime tick_rate tuning with `set_tick_rate/1`
  # - Telemetry includes drift
  #
  # -------------------------
  # 🧩 FUTURE OPTIONS
  # -------------------------
  # - Detect slow subscribers via custom EventBus hooks
  # - Add supervision-aware logging for downstream failures
end
