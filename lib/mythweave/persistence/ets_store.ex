defmodule Mythweave.Persistence.EtsStore do
  @moduledoc """
  Lightweight in-memory persistence using ETS.

  Responsibilities:
    - Store short-lived or frequently accessed session data
    - Provide fast key/value access for systems like inventory, cooldowns
    - Optionally back persistent snapshot files
  """

  @table :mythweave_store

  @spec start() :: :ok
  def start do
    :ets.new(@table, [:named_table, :public, :set, read_concurrency: true])
    :ok
  rescue
    _ -> :ok  # Table already exists
  end

  @spec put(any(), any()) :: true
  def put(key, value), do: :ets.insert(@table, {key, value})

  @spec get(any()) :: {:ok, any()} | :error
  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, val}] -> {:ok, val}
      _ -> :error
    end
  end

  @spec delete(any()) :: true
  def delete(key), do: :ets.delete(@table, key)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No automatic TTL/expiration logic
  #    - ✅ Add timer-based sweeps for ephemeral entries
  #
  # 2. No support for schema or type enforcement
  #    - 🚧 Validate keys/values against expected types
  #
  # 3. Not tied to supervision tree
  #    - ❗ Register with App Supervisor for restart

end
