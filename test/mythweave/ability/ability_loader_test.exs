defmodule Mythweave.Ability.AbilityLoaderTest do
  use ExUnit.Case, async: true
  alias Mythweave.Ability.AbilityLoader

  test "loads an ability JSON by id" do
    assert {:ok, data} = AbilityLoader.load("fireball")
    assert is_map(data)
    assert data["id"] == "fireball"
  end

  test "returns error for missing ability" do
    assert {:error, :not_found} = AbilityLoader.load("no_such_ability_123")
  end
end
