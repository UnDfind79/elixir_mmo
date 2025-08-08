defmodule Mythweave.Combat.StatusEffects do
  @moduledoc """
  System for applying and tracking temporary or permanent status effects.

  Responsibilities:
    - Apply, update, and remove statuses on entities
    - Support common effects like stun, silence, burn, fear
    - Integrate with timers and event hooks for expiration
  """

  @type effect_name :: atom()
  @type duration_ms :: non_neg_integer()

  @spec apply(String.t(), %{name: effect_name(), duration: duration_ms()}) :: :ok | {:error, any()}
  def apply(entity_id, %{name: name, duration: duration}) do
    send(entity_id, {:apply_status, name, duration})
    :ok
  catch
    _, _ -> {:error, :invalid_target}
  end

  @spec remove(String.t(), effect_name()) :: :ok
  def remove(entity_id, name) do
    send(entity_id, {:remove_status, name})
    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Send-only API, no confirmation or state introspection
  #    - ✅ Add StatusRegistry or per-entity state tracking
  #
  # 2. No stacking logic or priority enforcement
  #    - 🚧 Add status classes (e.g., hard vs soft CC) with overwrite rules
  #
  # 3. Duration is not enforced centrally
  #    - ❗ Add timer or tick-based cleanup task

end
