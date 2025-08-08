defmodule Mythweave.Combat.CombatEngine do
  @moduledoc """
  Core engine for resolving combat interactions.

  Features:
    - Hit/miss resolution
    - Critical hit checks
    - Damage computation and state mutation
    - Logging via `CombatLog`
    - Hooks for future combat effects and broadcasting

  Returns:
    - `{:ok, updated_defender}` on hit
    - `{:missed, defender}` on evasion
  """

  alias Mythweave.Combat.{CombatMath, CombatLog}
  alias Mythweave.Player.PlayerState
  alias Mythweave.Engine.EventBus
  alias Mythweave.Entity

  @type result :: {:ok, Entity.t()} | {:missed, Entity.t()}

  @spec attack(Entity.t(), Entity.t()) :: result()
  def attack(attacker, defender) do
    if CombatMath.hit?(attacker, defender) do
      resolve_hit(attacker, defender)
    else
      CombatLog.record(%{
        type: :miss,
        attacker: attacker.id,
        defender: defender.id,
        timestamp: DateTime.utc_now()
      })

      EventBus.broadcast(:combat, {:miss, %{attacker: attacker.id, defender: defender.id}})
      {:missed, defender}
    end
  end

  defp resolve_hit(attacker, defender) do
    base_damage = CombatMath.calculate_damage(attacker, defender)
    critical_hit = CombatMath.crit?(attacker)
    damage = if critical_hit, do: round(base_damage * 1.5), else: base_damage

    updated_defender = PlayerState.apply_damage(defender, damage)

    CombatLog.record(%{
      type: :hit,
      attacker: attacker.id,
      defender: defender.id,
      damage: damage,
      critical: critical_hit,
      timestamp: DateTime.utc_now()
    })

    EventBus.broadcast(:combat, {:hit, %{
      attacker: attacker.id,
      defender: defender.id,
      damage: damage,
      critical: critical_hit
    }})

    # Future hook points:
    # - ✅ Procs, buffs, interrupts
    # - 🚧 Ability chaining and status effect queues
    # - ❗ Damage overlays and visual indicators

    {:ok, updated_defender}
  end
end
