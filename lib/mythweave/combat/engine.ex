defmodule Mythweave.Combat.Engine do
  @moduledoc """
  Central coordinator for executing real-time combat logic.

  Responsibilities:
    - Resolve ability activations and dispatch effects
    - Manage turnless interactions across all entities
    - Broadcast combat outcomes to visible players
  """

  alias Mythweave.Combat.Ability
  alias Mythweave.EventBus

  @type entity_id :: String.t()
  @type ability_id :: String.t()
  @type context :: map()

  @spec cast_ability(entity_id(), ability_id(), context()) :: :ok | {:error, any()}
  def cast_ability(caster_id, ability_id, context \\ %{}) do
    case Ability.resolve(caster_id, ability_id, context) do
      {:ok, events} ->
        Enum.each(events, &dispatch_event/1)
        :ok

      {:error, reason} -> {:error, reason}
    end
  end

  defp dispatch_event(event) do
    EventBus.broadcast(:combat, event)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No interrupt/cancel logic for in-flight abilities
  #    - 🚧 Track ability casting state in entity FSM
  #
  # 2. Visibility scope not enforced for event broadcasting
  #    - ❗ Integrate with `Visibility.visible_entities/1` to filter messages
  #
  # 3. No combat log or audit trail
  #    - ✅ Add EventBus subscription for persistent logging

end
