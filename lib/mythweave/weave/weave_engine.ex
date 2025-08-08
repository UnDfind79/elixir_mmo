defmodule Mythweave.Weave.WeaveEngine do
  @moduledoc """
  Executes spell logic after successful glyph matching.

  Responsibilities:
    - Perform casting animation, effect dispatch, and resource drain
    - Route effect logic to appropriate pipeline
    - Trigger cooldowns and UI feedback
  """

  alias Mythweave.Combat.EffectPipeline
  alias Mythweave.Currency.Mana
  alias Mythweave.UI.MessageDispatcher
  alias Mythweave.Item.Effects

  @type player_id :: String.t()
  @type spell_id :: String.t()
  @type glyph_data :: map()

  @spec cast(player_id(), spell_id(), glyph_data()) :: :ok
  def cast(player_id, spell_id, glyph) do
    if Mana.spend(player_id, 10) do
      Effects.cast(player_id, spell_id, glyph)
      MessageDispatcher.send(player_id, %{text: "🔮 Cast #{spell_id}", category: :combat})
      :ok
    else
      MessageDispatcher.notify_error(player_id, "Not enough mana!")
      {:error, :insufficient_mana}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Mana cost is hardcoded
  #    - ✅ Use schema-based cost in future
  #
  # 2. No cooldown system yet
  #    - 🚧 Add cooldowns to prevent spam
  #
  # 3. No spell failure conditions
  #    - ❗ Add accuracy, resist, or focus checks

end
