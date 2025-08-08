defmodule Mythweave.Monitoring.Metrics do
  @moduledoc """
  Emits telemetry events for performance, usage, and health metrics.

  Responsibilities:
    - Hook into core systems like combat, zone, and player actions
    - Track gauges, counters, and timers for Prometheus or StatsD
    - Enable alerting and dashboards in production
  """

  require Logger
  import Telemetry.Metrics

  @metric_prefix [:mythweave]

  @spec definitions() :: [Telemetry.Metrics.metric()]
  def definitions do
    [
      # Player lifecycle
      counter(@metric_prefix ++ [:player, :connected]),
      counter(@metric_prefix ++ [:player, :disconnected]),

      # Combat
      summary(@metric_prefix ++ [:combat, :cast_duration], unit: {:native, :millisecond}),
      counter(@metric_prefix ++ [:combat, :kills]),
      counter(@metric_prefix ++ [:combat, :damage_instances]),

      # Crafting
      counter(@metric_prefix ++ [:crafting, :success]),
      counter(@metric_prefix ++ [:crafting, :failure]),

      # Zone management
      last_value(@metric_prefix ++ [:zone, :active_count]),
      summary(@metric_prefix ++ [:zone, :tick_duration], unit: {:native, :millisecond}),

      # Inventory
      counter(@metric_prefix ++ [:inventory, :item_used]),
      counter(@metric_prefix ++ [:inventory, :item_equipped]),
      counter(@metric_prefix ++ [:inventory, :item_dropped])
    ]
  end

  @spec emit(atom() | [atom()], map()) :: :ok
  def emit(event, metadata) do
    :telemetry.execute([:mythweave | List.wrap(event)], %{}, metadata)
    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Metrics definitions are not auto-attached to reporters
  #    - ✅ Register via `TelemetrySupervisor` in app start
  #
  # 2. Not all systems emit metrics yet
  #    - 🚧 Add hooks to player state, schema usage, vendor systems
  #
  # 3. No exporter wiring
  #    - ❗ Connect via `TelemetryMetricsPrometheus` or `TelemetryMetricsStatsd` for ops integration

end
