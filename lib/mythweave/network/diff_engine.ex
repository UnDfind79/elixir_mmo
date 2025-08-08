defmodule Mythweave.Network.DiffEngine do
  @moduledoc """
  Generates minimal state diffs for efficient client sync.

  Responsibilities:
    - Compare old vs new entity states
    - Output only the changed fields
    - Reduce outbound bandwidth and sync lag
  """

  @type state :: map()
  @type diff :: map()

  @spec compute_diff(state(), state()) :: diff()
  def compute_diff(prev, next) do
    Map.drop(next, fn {k, v} -> Map.get(prev, k) == v end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Diffs are shallow — no nested tracking
  #    - ✅ Add recursive diff for equipment/stats/inventory
  #
  # 2. No diff compression or checksum
  #    - 🚧 Add hash to detect client desync
  #
  # 3. No support for rebase or rollback
  #    - ❗ Integrate with state timeline history

end
