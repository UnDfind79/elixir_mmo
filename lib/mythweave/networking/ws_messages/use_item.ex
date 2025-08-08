defmodule Mythweave.Networking.WSMessages.UseItem do
  @moduledoc """
  Uses an item in the player’s inventory.

  Responsible for:
    - Dispatching item use request to inventory logic
    - Verifying presence and usability of item
  """

  defstruct [:item_id]

  alias Mythweave.Inventory.InventoryService

  @type t :: %__MODULE__{
          item_id: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok | :error, any()}
  def handle(%__MODULE__{item_id: iid}, pid) do
    InventoryService.use_item(pid, iid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes item exists and is usable
  #    - ❗ Validate item availability and use requirements
  #
  # 2. No feedback if item fails silently
  #    - 🚧 Extend `InventoryService.use_item/2` to return informative error states
  #
  # 3. No usage cooldown, restrictions, or animations
  #    - ✅ Introduce later with combat/zone pacing systems
end
