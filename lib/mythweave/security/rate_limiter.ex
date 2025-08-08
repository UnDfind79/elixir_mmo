defmodule Mythweave.Security.RateLimiter do
  @moduledoc """
  Enforces per-player rate limits for various actions.

  Responsibilities:
    - Track and restrict message frequency per player/action
    - Prevent abuse via rapid move/cast/chat spamming
    - Block or delay messages that exceed allowed rate
  """

  use GenServer

  @tick_ms 1_000
  @limits %{
    move: 20,
    cast: 5,
    chat: 10
  }

  @type action :: atom()
  @type player_id :: String.t()
  @type state :: %{optional(player_id()) => %{optional(action()) => non_neg_integer()}}

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @impl true
  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  @spec check(player_id(), action()) :: :ok | {:error, :rate_limited}
  def check(player_id, action) do
    GenServer.call(__MODULE__, {:check, player_id, action})
  end

  @impl true
  def handle_call({:check, id, action}, _from, state) do
    allowed = Map.get(@limits, action, 10)
    current = get_in(state, [id, action]) || 0

    if current < allowed do
      state = update_in(state[id][action], fn val -> (val || 0) + 1 end)
      {:reply, :ok, state}
    else
      {:reply, {:error, :rate_limited}, state}
    end
  end

  @impl true
  def handle_info(:tick, _state) do
    schedule_tick()
    {:noreply, %{}}
  end

  defp schedule_tick, do: Process.send_after(self(), :tick, @tick_ms)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Rate windows are 1-second resets
  #    - ✅ Add sliding window or token bucket if needed
  #
  # 2. No per-zone customization
  #    - 🚧 Allow zone config to override limits
  #
  # 3. State is fully reset per tick (not smoothed)
  #    - ❗ Consider weighted decay for smoother limits

end
