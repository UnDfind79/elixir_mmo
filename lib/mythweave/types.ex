defmodule Mythweave.Types do
  @moduledoc """
  Declares shared types used across multiple domains.

  Responsibilities:
    - Define reusable typespecs for players, entities, zones
    - Avoid duplication and type mismatches
    - Facilitate dialyzer and documentation tooling
  """

  @type coord :: {integer(), integer()}
  @type player_id :: String.t()
  @type zone_id :: String.t()
  @type entity_id :: String.t()
  @type spell_id :: String.t()
  @type tag :: atom()

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only basic types included
  #    - ✅ Add structs for PlayerState, ZoneState, Effect
  #
  # 2. No validation layer
  #    - 🚧 Link to schema or validator module
  #
  # 3. Not namespaced per domain
  #    - ❗ Consider `Types.Combat`, `Types.World`, etc. if needed

end
