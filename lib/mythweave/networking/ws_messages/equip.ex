defmodule Mythweave.Networking.WSMessages.Equip do
  @moduledoc """
  Equips an item from the player's inventory.

  Responsible for:
    - Validating item exists and is equippable
    - Moving item into correct slot
    - Updating player stats
  """

  defstruct [:item_id]

  alias Mythweave.Inventory.InventoryService

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{item_id: item_id}, player_id) do
    InventoryService.equip_item(player_id, item_id)
  end

  @type t :: %__MODULE__{
          item_id: String.t()
        }

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Does not validate ownership or inventory presence
  #    - ✅ Confirm InventoryService checks ownership
  #
  # 2. No stat delta or feedback sent to client
  #    - 🚧 Extend return payload to include new stats/equipment state
  #
  # 3. Ignores possible conflicts (e.g., already equipped item)
  #    - ❗ Add pre-checks for slot conflicts or unequipping flow
end
