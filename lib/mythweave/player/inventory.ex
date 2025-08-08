defmodule Mythweave.Player.Inventory do
  @moduledoc """
  Handles player's inventory operations.

  Responsibilities:
    - Add, remove, and list item instances
    - Support stackable items and unique item rules
    - Integrate with crafting and loot systems
  """

  alias Mythweave.Item.Item

  @type inventory :: [Item.t()]
  @type item_id :: String.t()

  @spec add_item(inventory(), Item.t()) :: inventory()
  def add_item(inv, item), do: [item | inv]

  @spec remove_item(inventory(), item_id()) :: {Item.t() | nil, inventory()}
  def remove_item(inv, id) do
    {found, rest} = Enum.split_with(inv, &(&1.id == id))
    {List.first(found), rest}
  end

  @spec has_item?(inventory(), item_id()) :: boolean()
  def has_item?(inv, id), do: Enum.any?(inv, &(&1.id == id))

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No support for stacking or max slot limits
  #    - ✅ Add quantity and weight system
  #
  # 2. No sorting or categorization
  #    - 🚧 Tag items for quick filtering
  #
  # 3. Inventory is not persistent
  #    - ❗ Hook into JsonStore save/load

end
