defmodule Mythweave.Player.PlayerRegistry do
  @moduledoc """
  Provides consistent access to player processes via named registry lookup.

  Registered by:
    - Player ID (`String.t()`)

  Used in:
    - `PlayerServer`, `PlayerSupervisor`, `CombatEngine`, etc.

  The registry must be declared in your supervision tree as:

      {Registry, keys: :unique, name: Mythweave.PlayerRegistry}
  """

  @type player_id :: String.t()

  @spec via(player_id()) :: {:via, Registry, {Mythweave.PlayerRegistry, player_id()}}
  def via(id),
    do: {:via, Registry, {Mythweave.PlayerRegistry, id}}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No query or introspection helpers
  #    - 🔄 Optional: add `list_online_players/0`, `whereis/1`, etc
  #
  # 2. Assumes registry is supervised elsewhere
  #    - ✅ Ensure `Mythweave.PlayerRegistry` is present in supervision tree

end
