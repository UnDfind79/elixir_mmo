defmodule Mythweave.Currency.XP do
  @moduledoc """
  Manages experience (XP) accumulation and consumption.

  Responsibilities:
    - Add XP to player and trigger level/talent checks
    - Allow XP spending on ability upgrades or schema growth
    - Track XP milestones and notify relevant systems
  """

  alias Mythweave.Player.Registry
  alias Mythweave.EventBus

  @type player_id :: String.t()
  @type amount :: non_neg_integer()

  @spec grant(player_id(), amount()) :: :ok | {:error, atom()}
  def grant(player_id, xp) when xp > 0 do
    case Registry.lookup(player_id) do
      {:ok, pid} ->
        GenServer.cast(pid, {:grant_xp, xp})
        EventBus.publish(:xp_gained, %{player: player_id, amount: xp})
        :ok

      _ -> {:error, :not_found}
    end
  end

  @spec spend(player_id(), amount()) :: :ok | {:error, atom()}
  def spend(player_id, xp) when xp > 0 do
    case Registry.lookup(player_id) do
      {:ok, pid} -> GenServer.call(pid, {:spend_xp, xp})
      _ -> {:error, :not_found}
    end
  end

  @spec get_total(player_id()) :: {:ok, amount()} | {:error, atom()}
  def get_total(player_id) do
    case Registry.lookup(player_id) do
      {:ok, pid} -> GenServer.call(pid, :get_xp)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Player module must implement XP message handling
  #    - ✅ Ensure GenServer supports `:grant_xp`, `:spend_xp`, `:get_xp`
  #
  # 2. No tiered milestone or reward triggering yet
  #    - 🚧 Add progression-based triggers for schema unlocking
  #
  # 3. XP is assumed to be global, not schema-specific
  #    - ❗ Distinguish between character-level XP and ability XP

end
