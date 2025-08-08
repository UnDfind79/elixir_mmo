defmodule Mythweave.Combat.Formulas do
  @moduledoc """
  Mathematical formulas for combat calculations.

  Responsibilities:
    - Calculate damage, healing, resistances, and energy use
    - Support stat-based scaling and diminishing returns
    - Provide reusable helpers for other combat modules
  """

  @type stat_map :: map()

  @spec calculate_damage(stat_map(), stat_map()) :: non_neg_integer()
  def calculate_damage(attacker_stats, defender_stats) do
    attack = Map.get(attacker_stats, :power, 10)
    defense = Map.get(defender_stats, :armor, 5)
    max(attack - defense, 1)
  end

  @spec calculate_resist(stat_map()) :: float()
  def calculate_resist(stats) do
    resist = Map.get(stats, :resistance, 0)
    1.0 - (resist / 100)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Simple linear formulas
  #    - ✅ Replace with balance-tuned exponential or table-driven logic
  #
  # 2. No critical hit, evasion, or modifier scaling
  #    - 🚧 Add support for random proc and RNG elements
  #
  # 3. Hardcoded fallback stats
  #    - ❗ Fallback logic should defer to Player/Entity modules

end
