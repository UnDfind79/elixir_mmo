defmodule Mythweave.Utils.Timer do
  @moduledoc """
  Tracks named timers per process for cooldowns, durations, and delays.

  Responsibilities:
    - Store one or more timers for a given context (combat, status, event)
    - Provide checks for expired or active timers
    - Allow time-based filtering logic
  """

  @type timers :: %{optional(atom()) => non_neg_integer()}

  @spec now() :: integer()
  def now, do: System.system_time(:second)

  @spec expired?(timers(), atom()) :: boolean()
  def expired?(map, key) do
    case Map.get(map, key) do
      nil -> true
      ts -> now() > ts
    end
  end

  @spec start(timers(), atom(), integer()) :: timers()
  def start(map, key, duration) do
    Map.put(map, key, now() + duration)
  end

  @spec clear(timers(), atom()) :: timers()
  def clear(map, key), do: Map.delete(map, key)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only second precision
  #    - ✅ Consider adding millisecond support
  #
  # 2. No periodic timer callbacks
  #    - 🚧 Add tick-based expiration handler for GenServers
  #
  # 3. No grouping of timers by subsystem
  #    - ❗ Consider structured timer sets by combat, status, etc.

end
