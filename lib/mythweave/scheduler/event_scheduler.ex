defmodule Mythweave.Scheduler.EventScheduler do
  @moduledoc """
  Global time-based event scheduler for delayed or recurring game logic.

  Responsibilities:
    - Queues one-off events (e.g., `{:respawn, npc_id}`)
    - Broadcasts timed world messages (e.g., system notices)
    - Powers delayed effects (e.g., buffs, AoE triggers, revive timers)

  Events are sent to this GenServer and dispatched at future times.
  """

  use GenServer
  require Logger

  @type event ::
          {:respawn, String.t()}
          | {:broadcast, map()}
          | {atom(), term()}

  @type state :: map()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(term()) :: GenServer.on_start()
  def start_link(_),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @spec schedule_event(event(), non_neg_integer()) :: :ok
  def schedule_event(event, delay_ms) when is_integer(delay_ms) and delay_ms >= 0 do
    Process.send_after(__MODULE__, {:trigger, event}, delay_ms)
    :ok
  end

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(state),
    do: {:ok, state}

  @impl true
  def handle_info({:trigger, event}, state) do
    dispatch(event)
    {:noreply, state}
  end

  # -----------------------------
  # Event Dispatcher
  # -----------------------------

  defp dispatch({:respawn, npc_id}) do
    Logger.debug("Triggering respawn for NPC #{npc_id}")
    Mythweave.World.WorldService.respawn_npc(npc_id)
  end

  defp dispatch({:broadcast, msg}) do
    Logger.info("Broadcasting system message: #{inspect(msg)}")
    Mythweave.Networking.WSRouter.broadcast_to_all(msg)
  end

  defp dispatch({type, data}) do
    Logger.warn("Unhandled scheduled event: #{inspect({type, data})}")
    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No support for recurring timers or cancelable events
  #    - ❗ Future: allow event IDs and cancellation via registry
  #
  # 2. Dispatch is hardcoded with simple pattern matching
  #    - 🔄 Optional: convert to dynamic handler dispatch via `EventRouter` module
  #
  # 3. No telemetry emitted for dispatch performance
  #    - ❗ Future: emit `:event_scheduled`, `:event_fired`, `:event_duration`
  #
  # 4. State is unused
  #    - ✅ Placeholder for tracking future scheduled/cancellable events

end
