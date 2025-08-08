defmodule Mythweave.Trade.TradeSession do
  @moduledoc """
  Represents a trade session between two players.

  Responsibilities:
    - Track offered items and currency per participant
    - Handle acceptance and confirmation steps
    - Validate item availability and finalize transfers
  """

  use GenServer

  @type player_id :: String.t()
  @type state :: %{
          a: player_id(),
          b: player_id(),
          offers: %{player_id() => %{items: list(), gold: non_neg_integer()}},
          accepted: MapSet.t(player_id())
        }

  @spec start_link({player_id(), player_id()}) :: GenServer.on_start()
  def start_link({a, b}) do
    GenServer.start_link(__MODULE__, {a, b}, name: via(a, b))
  end

  defp via(a, b), do: {:via, Registry, {Mythweave.Registry.TradeRegistry, "#{a}_#{b}"}}

  @impl true
  def init({a, b}) do
    {:ok,
     %{
       a: a,
       b: b,
       offers: %{
         a => %{items: [], gold: 0},
         b => %{items: [], gold: 0}
       },
       accepted: MapSet.new()
     }}
  end

  @spec offer_item(pid(), player_id(), any()) :: :ok
  def offer_item(pid, player, item),
    do: GenServer.cast(pid, {:offer_item, player, item})

  @spec offer_gold(pid(), player_id(), integer()) :: :ok
  def offer_gold(pid, player, amount),
    do: GenServer.cast(pid, {:offer_gold, player, amount})

  @spec accept(pid(), player_id()) :: :ok
  def accept(pid, player),
    do: GenServer.cast(pid, {:accept, player})

  @impl true
  def handle_cast({:offer_item, player, item}, state) do
    update = update_in(state.offers[player].items, &[item | &1])
    {:noreply, %{state | offers: update, accepted: MapSet.new()}}
  end

  def handle_cast({:offer_gold, player, amount}, state) do
    update = put_in(state.offers[player].gold, amount)
    {:noreply, %{state | offers: update, accepted: MapSet.new()}}
  end

  def handle_cast({:accept, player}, %{accepted: accepted} = state) do
    accepted = MapSet.put(accepted, player)

    if MapSet.size(accepted) == 2 do
      complete_trade(state)
      {:stop, :normal, state}
    else
      {:noreply, %{state | accepted: accepted}}
    end
  end

  defp complete_trade(state) do
    %{a: a, b: b, offers: offers} = state

    Mythweave.Player.Server.cast(a, {:trade_receive, offers[b]})
    Mythweave.Player.Server.cast(b, {:trade_receive, offers[a]})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No item validation or inventory limit check
  #    - ✅ Validate inventory space before completion
  #
  # 2. No timeout or cancel logic
  #    - 🚧 Add expiration or abort commands
  #
  # 3. Does not lock items during trade
  #    - ❗ Add soft lock or hold system to prevent dupes

end
