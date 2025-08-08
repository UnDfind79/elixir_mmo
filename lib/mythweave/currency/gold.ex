defmodule Mythweave.Currency.Gold do
  @moduledoc """
  Handles gold transactions, balances, and validation per player.

  Responsibilities:
    - Read, update, and transfer gold amounts
    - Enforce sufficient balance checks
    - Provide utility for shop, trade, and vendor interactions
  """

  alias Mythweave.Player.Registry
  alias Mythweave.EventBus

  @type player_id :: String.t()
  @type amount :: non_neg_integer()

  @spec get_balance(player_id()) :: {:ok, amount()} | {:error, atom()}
  def get_balance(player_id) do
    case Registry.lookup(player_id) do
      {:ok, pid} -> GenServer.call(pid, :get_gold)
      _ -> {:error, :not_found}
    end
  end

  @spec add_gold(player_id(), amount()) :: :ok | {:error, atom()}
  def add_gold(player_id, amount) when amount > 0 do
    case Registry.lookup(player_id) do
      {:ok, pid} ->
        GenServer.cast(pid, {:add_gold, amount})
        EventBus.publish(:gold_added, %{player: player_id, amount: amount})
        :ok

      _ -> {:error, :not_found}
    end
  end

  @spec spend_gold(player_id(), amount()) :: :ok | {:error, atom()}
  def spend_gold(player_id, amount) when amount > 0 do
    case Registry.lookup(player_id) do
      {:ok, pid} -> GenServer.call(pid, {:spend_gold, amount})
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Player module must support `:get_gold`, `:add_gold`, and `:spend_gold` calls
  #    - ✅ Ensure message handling is defined on player GenServer
  #
  # 2. No concurrency-safe transfer between two players
  #    - 🚧 Add `transfer/3` with locking or atomic pattern
  #
  # 3. No audit trail for large or unusual transactions
  #    - ❗ Log transactions above threshold using AuditLog

end
