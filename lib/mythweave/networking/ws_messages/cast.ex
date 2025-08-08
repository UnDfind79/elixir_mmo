defmodule Mythweave.Networking.WSMessages.Cast do
  @moduledoc """
  Casts a targeted spell or skill.
  """

  defstruct [:spell_id, :target_id]

  alias Mythweave.Combat.CombatEngine
  alias Mythweave.Player.PlayerState

  def handle(%__MODULE__{spell_id: sid, target_id: tid}, player_id) do
    with {:ok, caster} <- PlayerState.get(player_id),
         {:ok, target} <- PlayerState.get(tid) do
      CombatEngine.cast_spell(caster, target, sid)
    else
      _ -> {:error, :cast_failed}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes both caster and target are valid players
  #    - 🚧 Needs support for NPC or environmental targets
  #
  # 2. No validation of spell ownership, cost, or cooldown
  #    - ❗ Add checks to ensure the player can cast the spell
  #
  # 3. Fails silently on errors with a generic :cast_failed
  #    - ✅ Return detailed error reasons for feedback and logging
end
