defmodule Mythweave.Combat.CombatLog do
  @moduledoc """
  Stores structured combat events in ETS for:

    - Debugging and replay
    - Telemetry inspection
    - Live dashboards or monitoring

  Uses `:bag` ETS table to support multiple events per timestamp.
  """

  use GenServer

  @log_table :combat_log

  @type event :: %{
          type: :hit | :miss,
          attacker: String.t(),
          defender: String.t(),
          damage: integer(),
          critical: boolean(),
          timestamp: DateTime.t()
        }

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    unless ets_exists?() do
      :ets.new(@log_table, [:named_table, :public, :bag, {:read_concurrency, true}])
    end

    {:ok, %{}}
  end

  @spec record(map()) :: :ok
  def record(%{timestamp: %DateTime{} = ts} = event) do
    :ets.insert(@log_table, {ts, event})
    emit_telemetry(event)
    :ok
  end

  @spec get_all() :: [{DateTime.t(), event()}]
  def get_all do
    :ets.tab2list(@log_table)
  end

  @spec get_recent(non_neg_integer()) :: [{DateTime.t(), event()}]
  def get_recent(limit) do
    get_all()
    |> Enum.sort_by(fn {ts, _} -> ts end, :desc)
    |> Enum.take(limit)
  end

  @spec get_by_attacker(String.t()) :: [{DateTime.t(), event()}]
  def get_by_attacker(attacker_id) do
    get_all()
    |> Enum.filter(fn {_ts, %{attacker: id}} -> id == attacker_id end)
  end

  # -------------------------
  # 🔧 PRIVATE HELPERS
  # -------------------------

  defp ets_exists?, do: :ets.whereis(@log_table) != :undefined

  defp emit_telemetry(%{type: :hit, damage: dmg}) do
    :telemetry.execute([:mythweave, :combat, :hit], %{damage: dmg}, %{})
  end

  defp emit_telemetry(%{type: :miss}) do
    :telemetry.execute([:mythweave, :combat, :miss], %{}, %{})
  end

  defp emit_telemetry(_), do: :ok

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No TTL or garbage collection
  #    - 🚧 Add periodic pruning or max-size limit
  #
  # 2. No zone metadata on records
  #    - ❗ Add zone ID for scoped analytics or war tracking
  #
  # 3. Flat structure limits event querying flexibility
  #    - ✅ Add compound ETS keys or secondary indexes
end
