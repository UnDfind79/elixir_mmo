defmodule Mythweave.Security.Validator do
  @moduledoc """
  Validates incoming player actions before routing.

  Responsibilities:
    - Check that coordinates are in bounds
    - Ensure ability IDs exist and players are authorized
    - Prevent malformed payloads or client tampering
  """

  alias Mythweave.Loader.AbilityLoader
  alias Mythweave.World.Terrain

  @spec valid_move?({integer(), integer()}) :: boolean()
  def valid_move?({x, y}) do
    x in 0..1024 and y in 0..1024  # TODO: Delegate to zone map bounds
  end

  @spec valid_cast?(String.t()) :: boolean()
  def valid_cast?(ability_id) do
    case AbilityLoader.load(ability_id) do
      {:ok, _} -> true
      _ -> false
    end
  end

  @spec valid_payload?(map(), [atom()]) :: boolean()
  def valid_payload?(payload, required_keys) do
    Enum.all?(required_keys, &Map.has_key?(payload, Atom.to_string(&1)))
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Move check is hardcoded to square world
  #    - ✅ Use zone-specific bounds from Terrain
  #
  # 2. No schema-based validation
  #    - 🚧 Add declarative validator DSL or JSON schema
  #
  # 3. Does not validate inter-player commands (e.g. trade targets)
  #    - ❗ Add entity existence and proximity checks

end
