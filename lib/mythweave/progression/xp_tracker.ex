defmodule Mythweave.Progression.XPTracker do
  @moduledoc """
  Monitors total XP earned per player and triggers level milestones.

  Responsibilities:
    - Track accumulated XP over time (not current spendable balance)
    - Emit events when level thresholds are crossed
    - Support analytics, achievements, and stats
  """

  alias Mythweave.EventBus

  @type tracker :: %{total: non_neg_integer(), level: non_neg_integer()}

  @level_thresholds [0, 100, 250, 500, 1000, 2000]

  @spec add_xp(tracker(), non_neg_integer()) :: tracker()
  def add_xp(%{total: total, level: level} = tracker, gain) do
    new_total = total + gain
    new_level = determine_level(new_total)

    if new_level > level do
      EventBus.publish(:level_up, %{level: new_level})
    end

    %{tracker | total: new_total, level: new_level}
  end

  @spec determine_level(non_neg_integer()) :: non_neg_integer()
  defp determine_level(total) do
    Enum.count(@level_thresholds, fn threshold -> total >= threshold end) - 1
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Levels are hardcoded
  #    - ✅ Load from config or external progression table
  #
  # 2. No per-level rewards or announcements
  #    - 🚧 Add hooks for gear unlocks, title, schema unlock
  #
  # 3. Does not sync with Currency.XP spendable balance
  #    - ❗ Keep separation of "earned vs available"

end
