defmodule Mythweave.Item.ItemTest do
  use ExUnit.Case, async: true
  alias Mythweave.Item.Item

  test "new/1 builds an item struct-like map with id" do
    itm = Item.new(%{"id" => "potion", "name" => "Potion"})
    assert itm.id == "potion"
  end
end

defmodule Mythweave.Item.InventoryServiceTest do
  use ExUnit.Case, async: true
  alias Mythweave.Item.{InventoryService, Item}

  test "add and remove items from inventory" do
    inv = []
    itm = Item.new(%{"id" => "sword", "name" => "Sword"})
    inv = InventoryService.add_item(inv, itm)
    assert length(inv) == 1

    {found, inv2} = InventoryService.remove_item(inv, "sword")
    assert found.id == "sword"
    assert inv2 == []
  end
end
