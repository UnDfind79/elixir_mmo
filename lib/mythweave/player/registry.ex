defmodule Mythweave.Player.Registry do
  @moduledoc """
  Tracks and locates all active player processes.

  Responsibilities:
    - Register each player session under a unique ID
    - Allow global lookup by player ID or session PID
    - Enable supervision tree integration for live player processes
  """

  @table :player_registry

  @spec start() :: :ok
  def start do
    :ets.new(@table, [:named_table, :public, :set])
    :ok
  rescue
    _ -> :ok
  end

  @spec register(String.t(), pid()) :: true
  def register(player_id, pid), do: :ets.insert(@table, {player_id, pid})

  @spec lookup(String.t()) :: {:ok, pid()} | :error
  def lookup(player_id) do
    case :ets.lookup(@table, player_id) do
      [{^player_id, pid}] -> {:ok, pid}
      _ -> :error
    end
  end

  @spec unregister(String.t()) :: true
  def unregister(player_id), do: :ets.delete(@table, player_id)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Not linked to supervision tree
  #    - ✅ Register player GenServers on init
  #
  # 2. No bidirectional lookup (pid → id)
  #    - 🚧 Add reverse table if needed for tracing
  #
  # 3. Registry is not persistent across reboots
  #    - ❗ Only use for active sessions

end
