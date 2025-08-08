defmodule Mythweave.Ability.Ability do
  @moduledoc """
  Executes ability logic, transforming raw thread or template input into effect events.

  Responsibilities:
    - Load ability metadata from schema
    - Resolve cost, cooldown, modifiers, and augments
    - Apply targeting, area, and status effects
    - Output normalized effect events for the game engine
  """

  alias Mythweave.Loader.AbilityLoader
  alias Mythweave.Combat.{Formulas}

  @type entity_id :: String.t()
  @type ability_id :: String.t()
  @type context :: map()
  @type event :: map()
  @type ability :: map()

  @spec resolve(entity_id(), ability_id(), context()) :: {:ok, [event()]} | {:error, any()}
  def resolve(caster_id, ability_id, context) do
    with {:ok, ability} <- AbilityLoader.load(ability_id),
         :ok <- validate(caster_id, ability, context),
         {:ok, events} <- apply_ability(caster_id, ability, context) do
      {:ok, events}
    else
      {:error, reason} -> {:error, reason}
      error -> {:error, inspect(error)}
    end
  end

  @spec validate(entity_id(), ability(), context()) :: :ok | {:error, String.t()}
  defp validate(_caster_id, _ability, _context) do
    # TODO: Add real checks (cooldowns, energy, range, etc.)
    :ok
  end

  @spec apply_ability(entity_id(), ability(), context()) :: {:ok, [event()]}
  defp apply_ability(caster_id, ability, context) do
    # Simplified example: fixed damage event
    damage = Formulas.calculate_damage(caster_id, context.target_id, ability)

    event = %{
      type: :damage,
      source: caster_id,
      target: context.target_id,
      amount: damage,
      kind: ability["kind"] || "generic",
      ability_id: ability["id"]
    }

    {:ok, [event]}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Validation is stubbed — doesn't check resistances, energy, or range
  #    - ✅ Implement full validator pipeline in `validate/3`
  #
  # 2. Damage formula is oversimplified
  #    - 🚧 Replace with type-scaled damage (Formulas module handles scaling)
  #
  # 3. Status effects and AOE handling are unimplemented
  #    - ❗ Add augment pipelines and effect propagation model
end
