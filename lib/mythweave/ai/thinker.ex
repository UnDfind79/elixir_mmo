defmodule Mythweave.AI.Thinker do
  @moduledoc """
  Asynchronous scheduler for updating AI-controlled entities.

  Responsibilities:
    - Periodically trigger AI `:think` messages
    - Dispatch updates to registered AI entities
    - Support decoupled, fault-tolerant ticking with backoff and jitter
  """

  use GenServer

  alias Mythweave.AI.Registry
  alias Mythweave.Utils.Logger

  @tick_interval 200  # ms base interval
  @jitter_range 40    # +/- jitter in ms

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(_) do
    schedule_tick()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:tick_ai, state) do
    Registry.all_ai_entities()
    |> Enum.each(&tick_entity/1)

    schedule_tick()
    {:noreply, state}
  end

  defp tick_entity(pid) do
    send(pid, :think)
  rescue
    e -> Logger.warn("AI tick failed", pid: inspect(pid), reason: Exception.message(e))
  end

  defp schedule_tick do
    jitter = :rand.uniform(@jitter_range * 2) - @jitter_range
    delay = max(@tick_interval + jitter, 50)
    Process.send_after(self(), :tick_ai, delay)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No per-zone or per-tag prioritization
  #    - ✅ Add hooks for zone-local thinkers or regional load balancing
  #
  # 2. Jitter is fixed range
  #    - 🚧 Replace with adaptive backpressure model if zone congestion detected
  #
  # 3. Entity failure not tracked
  #    - ❗ Collect metrics on failed ticks for observability
end
