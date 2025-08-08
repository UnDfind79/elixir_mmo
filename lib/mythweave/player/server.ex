defmodule Mythweave.Player.Server do
  @moduledoc """
  GenServer managing the full state of a single player.

  Responsibilities:
    - Maintain inventory, stats, progression, and location
    - Respond to events and commands (e.g., move, cast, spend XP)
    - Support direct message dispatch from session handler
  """

  use GenServer

  @type state :: %{
          id: String.t(),
          pos: {integer(), integer()},
          xp: non_neg_integer(),
          gold: non_neg_integer(),
          inventory: list(),
          equipped: map()
        }

  @initial %{
    xp: 0,
    gold: 0,
    pos: {0, 0},
    inventory: [],
    equipped: %{}
  }

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(player_id), do: GenServer.start_link(__MODULE__, player_id, name: via(player_id))

  defp via(player_id), do: {:via, Registry, {Mythweave.Player.Registry, player_id}}

  @impl true
  def init(player_id) do
    {:ok, Map.put(@initial, :id, player_id)}
  end

  @impl true
  def handle_call(:get_gold, _from, state), do: {:reply, state.gold, state}
  def handle_call(:get_xp, _from, state), do: {:reply, state.xp, state}
  def handle_call({:spend_gold, amt}, _from, state) when amt <= state.gold,
    do: {:reply, :ok, %{state | gold: state.gold - amt}}

  def handle_call({:spend_gold, _}, _from, state), do: {:reply, {:error, :insufficient_funds}, state}

  def handle_call({:spend_xp, amt}, _from, state) when amt <= state.xp,
    do: {:reply, :ok, %{state | xp: state.xp - amt}}

  def handle_call({:spend_xp, _}, _from, state), do: {:reply, {:error, :not_enough_xp}, state}

  @impl true
  def handle_cast({:add_gold, amt}, state), do: {:noreply, %{state | gold: state.gold + amt}}
  def handle_cast({:grant_xp, amt}, state), do: {:noreply, %{state | xp: state.xp + amt}}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Does not persist player state
  #    - ✅ Add save/load integration via JsonStore
  #
  # 2. No module handling inventory/equipment separation
  #    - 🚧 Delegate to Inventory and Equipment contexts
  #
  # 3. No event broadcast for XP/Gold updates
  #    - ❗ Add EventBus hooks for UI sync

end
