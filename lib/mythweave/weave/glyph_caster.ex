defmodule Mythweave.Weave.GlyphCaster do
  @moduledoc """
  Evaluates player-submitted glyphs and casts corresponding abilities.

  Responsibilities:
    - Validate and normalize glyph patterns
    - Map glyphs to registered spell schemas
    - Dispatch successful casts to the WeaveEngine
  """

  alias Mythweave.Weave.Schema
  alias Mythweave.Weave.WeaveEngine
  alias Mythweave.Security.Validator

  @type player_id :: String.t()
  @type glyph_data :: %{pattern: String.t(), power: integer(), focus: String.t()}

  @spec cast_glyph(player_id(), glyph_data()) :: :ok | {:error, atom()}
  def cast_glyph(player_id, %{pattern: pattern} = glyph) do
    if Validator.valid_payload?(glyph, [:pattern, :power, :focus]) do
      case Schema.resolve(pattern) do
        {:ok, spell_id} ->
          WeaveEngine.cast(player_id, spell_id, glyph)
          :ok

        _ ->
          {:error, :unknown_glyph}
      end
    else
      {:error, :invalid_glyph_input}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only supports static string patterns
  #    - ✅ Expand to support gesture or sequence matching
  #
  # 2. No feedback or partial matches
  #    - 🚧 Suggest corrections or closest valid glyphs
  #
  # 3. No glyph unlock gating
  #    - ❗ Tie availability to lore progression or XP

end
