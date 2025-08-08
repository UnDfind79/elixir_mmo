defmodule Mythweave.World.WorldLoaderTest do
  use ExUnit.Case, async: true
  alias Mythweave.World.WorldLoader

  test "world_dir defaults to test_world under priv/worlds" do
    expected_suffix = Path.join(["priv", "worlds", "test_world"])
    assert String.ends_with?(WorldLoader.world_dir(), expected_suffix)
  end

  test "loads a known zone .server.json" do
    # Zones are nested; pass a relative id that matches the file layout.
    # test_world/zones/zone_root/zone_root.server.json
    assert {:ok, zone} = WorldLoader.load_zone("zones/zone_root/zone_root")
    assert is_map(zone)
    assert zone["id"] == "zone_root"
  end
end
