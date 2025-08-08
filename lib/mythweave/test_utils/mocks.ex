defmodule Mythweave.TestUtils.Mocks do
  @moduledoc """
  Provides mock data and test helpers for integration and unit tests.

  Responsibilities:
    - Generate fake player, NPC, or item state
    - Simulate event input and zone state
    - Reduce setup boilerplate in test cases
  """

  alias Mythweave.Player.Server
  alias Mythweave.Item.Item

  @spec fake_player(String.t()) :: pid()
  def fake_player(id) do
    {:ok, pid} = Server.start_link(id)
    pid
  end

  @spec sample_item(String.t()) :: Item.t()
  def sample_item(name) do
    %Item{
      id: name,
      type: :consumable,
      meta: %{heal: 10}
    }
  end

  @spec fake_zone_state() :: map()
  def fake_zone_state do
    %{
      id: "zone-test",
      entities: [],
      events: []
    }
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Items and NPCs use minimal test shape
  #    - ✅ Add support for full inventory mock
  #
  # 2. No randomization or fixtures
  #    - 🚧 Seedable random for property tests
  #
  # 3. Mocks don't track process lifecycle
  #    - ❗ Add teardown helpers for test cleanup

end
