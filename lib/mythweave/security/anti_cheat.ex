defmodule Mythweave.Security.AntiCheat do
  @moduledoc """
  Detects and mitigates common forms of cheating or input abuse.

  Responsibilities:
    - Track move and action rate limits per player
    - Detect invalid inputs (e.g. out-of-bounds, unauthorized casts)
    - Integrate with audit logging and disconnect logic
  """

  use GenServer
  alias Mythweave.Logging.AuditLog

  @tick_interval 1_000
  @move_limit 15
  @cast_limit 5

  @type player_id :: String.t()
  @type action_count :: %{move: integer(), cast: integer()}
  @type state :: %{optional(player_id()) => action_count()}

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  @spec report_move(player_id()) :: :ok
  def report_move(id), do: GenServer.cast(__MODULE__, {:move, id})

  @spec report_cast(player_id()) :: :ok
  def report_cast(id), do: GenServer.cast(__MODULE__, {:cast, id})

  @impl true
  def handle_cast({type, id}, state) do
    updated =
      Map.update(state, id, %{move: 0, cast: 0}, fn counts ->
        Map.update!(counts, type, &(&1 + 1))
      end)

    {:noreply, updated}
  end

  @impl true
  def handle_info(:tick, state) do
    Enum.each(state, fn {id, %{move: m, cast: c}} ->
      cond do
        m > @move_limit ->
          AuditLog.record(:security, "Speedhack detected for #{id}", %{moves: m})

        c > @cast_limit ->
          AuditLog.record(:security, "Cast spam detected for #{id}", %{casts: c})

        true -> :ok
      end
    end)

    schedule_tick()
    {:noreply, %{}}
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, @tick_interval)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No player blocking or punishment yet
  #    - ✅ Add kick or mute via AdminHandler
  #
  # 2. Hardcoded thresholds and actions
  #    - 🚧 Move to config or per-zone settings
  #
  # 3. Only counts move and cast actions
  #    - ❗ Expand to item use, crafting, login rate

end
