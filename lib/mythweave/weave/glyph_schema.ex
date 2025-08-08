defmodule Mythweave.Weave.GlyphSchema do
  @moduledoc """
  Manages the registry of known glyph patterns and their spell mappings.

  Responsibilities:
    - Map glyph patterns to ability IDs
    - Provide metadata for tooltips, loading, and UI preview
    - Allow custom glyph registration by admin or lore events
  """

  @type glyph :: String.t()
  @type spell_id :: String.t()

  @glyph_map %{
    "△○□" => "fire_burst",
    "○□○" => "heal_wave",
    "□□□" => "shield_wall"
  }

  @spec resolve(glyph()) :: {:ok, spell_id()} | :error
  def resolve(pattern), do: Map.fetch(@glyph_map, pattern)

  @spec list_all() :: [{glyph(), spell_id()}]
  def list_all, do: Enum.to_list(@glyph_map)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Patterns are hardcoded
  #    - ✅ Move to external JSON or DB source
  #
  # 2. No metadata (mana, tags, unlock reqs)
  #    - 🚧 Add spell metadata in schema
  #
  # 3. No dynamic registration at runtime
  #    - ❗ Enable admin/gamemaster glyph additions

end
