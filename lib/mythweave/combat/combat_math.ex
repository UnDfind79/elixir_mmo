defmodule Mythweave.Combat.CombatMath do
  @moduledoc """
  Core combat math utilities for Mythweave.

  Includes:
    - Hit/miss resolution
    - Critical hit logic
    - Base damage with variance
    - Extendable hooks for future schema effects
  """

  @default_crit_chance 0.1
  @variance 0.15

  @type stats :: %{optional(atom) => number()}
  @type damage :: non_neg_integer()

  @doc """
  Returns true if the attacker successfully hits the defender.
  Accuracy is compared against evasion, resulting in a hit chance ratio.
  """
  @spec hit?(stats(), stats()) :: boolean()
  def hit?(%{accuracy: atk_acc}, %{evasion: def_ev}) do
    chance = atk_acc / max(1, atk_acc + def_ev)
    :rand.uniform() < clamp(chance, 0.05, 0.95)
  end

  @doc """
  Returns true if the attack is a critical hit.
  Falls back to a default crit chance if unspecified.
  """
  @spec crit?(stats()) :: boolean()
  def crit?(%{crit_chance: chance}) when is_number(chance) do
    :rand.uniform() < clamp(chance, 0.0, 1.0)
  end

  def crit?(_), do: :rand.uniform() < @default_crit_chance

  @doc """
  Calculates base damage using attack, defense, and damage variance.
  Applies no buffs or schema-level effects.
  """
  @spec calculate_damage(stats(), stats()) :: damage()
  def calculate_damage(%{attack: atk}, %{defense: defn}) do
    base = max(atk - defn, 0)
    modifier = random_variance()
    max(round(base * modifier), 0)
  end

  # -------------------------
  # 🔧 PRIVATE HELPERS
  # -------------------------

  defp random_variance do
    1.0 + (:rand.uniform() * @variance - @variance / 2)
  end

  defp clamp(val, min, max) when val < min, do: min
  defp clamp(val, min, max) when val > max, do: max
  defp clamp(val, _, _), do: val

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No buffs/debuffs or schema multipliers
  #    - ✅ Inject upstream or preprocess stat maps
  #
  # 2. Assumes fixed damage model
  #    - ❗ Refactor for damage type tags (physical, fire, shadow, etc.)
  #
  # 3. No damage scaling by level, gear, or temporary effects
  #    - 🚧 Add optional plugin system or modifier callback layer
end
