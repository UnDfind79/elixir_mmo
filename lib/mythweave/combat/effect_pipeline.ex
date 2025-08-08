defmodule Mythweave.Combat.EffectPipeline do
  @moduledoc """
  Composable logic for applying sequences of combat effects.

  Responsibilities:
    - Process stacked effects like damage, debuffs, healing, etc.
    - Maintain ordering guarantees for conditional chains
    - Allow future augment/plugin hooks per phase
  """

  alias Mythweave.Combat.StatusEffects

  @type effect :: map()
  @type result :: {:ok, [effect()]} | {:error, any()}

  @spec run(entity_id :: String.t(), [effect()]) :: result()
  def run(target_id, effects) do
    Enum.reduce_while(effects, {:ok, []}, fn effect, {:ok, acc} ->
      case apply_effect(target_id, effect) do
        :ok -> {:cont, {:ok, [effect | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp apply_effect(target_id, %{type: :status, status: status}) do
    StatusEffects.apply(target_id, status)
  end

  defp apply_effect(_target_id, _effect), do: :ok

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Effect types are hardcoded
  #    - 🚧 Add dynamic dispatch or DSL-driven handlers
  #
  # 2. No rollback if partial failure in chain
  #    - ❗ Consider transactional model or undo stack
  #
  # 3. No stacking logic or duration merge rules
  #    - ✅ Implement stacking rules via StatusEffects module

end
