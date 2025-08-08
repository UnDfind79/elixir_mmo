defmodule Mythweave.Utils.UUID do
  @moduledoc """
  Generates unique identifiers for items, entities, and sessions.

  Responsibilities:
    - Provide ID generation without collision
    - Abstract UUID library choice
    - Support tagging or categorization of IDs
  """

  @spec generate() :: String.t()
  def generate, do: Ecto.UUID.generate()

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Uses Ecto.UUID for generation
  #    - ✅ Replace with nanoid or ULID if needed
  #
  # 2. No namespacing or ID prefixing
  #    - 🚧 Add support for "player_", "item_" prefixes
  #
  # 3. No uniqueness validation across nodes
  #    - ❗ Ensure consistency in multi-node deployment

end
