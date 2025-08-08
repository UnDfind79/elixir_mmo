defmodule Mythweave.Progression.StatPipeline do
  @moduledoc """
  Calculates final player stats from base attributes, gear, and buffs.

  Responsibilities:
    - Merge base stats with equipment bonuses and active modifiers
    - Provide final stats to combat and UI systems
    - Allow extension via schema, perks, or status effects
  """

  alias Mythweave.Player.Equipment

  @type base_stats :: map()
  @type final_stats :: map()
  @type gear :: Equipment.gear()

  @spec calculate(base_stats(), gear(), list()) :: final_stats()
  def calculate(base, gear, buffs \\ []) do
    gear_bonus = %{
      power: Equipment.get_bonus(gear, :power),
      armor: Equipment.get_bonus(gear, :armor)
    }

    Enum.reduce([base, gear_bonus | buffs], %{}, fn src, acc ->
      Map.merge(acc, src, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Buffs must be maps with stat keys
  #    - ✅ Validate input in future
  #
  # 2. No dynamic modifiers (multiplicative scaling, time decay)
  #    - 🚧 Extend to support multipliers or active durations
  #
  # 3. No caching of computed values
  #    - ❗ Recalc on every combat tick may be inefficient

end
