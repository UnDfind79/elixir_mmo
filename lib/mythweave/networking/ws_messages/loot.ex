defmodule Mythweave.Networking.WSMessages.Loot do
  @moduledoc """
  Attempts to loot an item from the world.

  Responsible for:
    - Verifying loot eligibility
    - Transferring item to player inventory
  """

  defstruct [:item_id]

  alias Mythweave.World.LootService

  @type t :: %__MODULE__{
          item_id: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{item_id: item_id}, player_id) do
    LootService.attempt_loot(player_id, item_id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes item is lootable without context (e.g., ownership, cooldown)
  #    - ❗ Validate eligibility: distance, tags, ownership
  #
  # 2. Ignores zone/position awareness during loot
  #    - 🚧 Add position validation (within range)
  #
  # 3. No feedback on failure reasons (e.g., inventory full)
  #    - ✅ Standardize structured error messages
end
