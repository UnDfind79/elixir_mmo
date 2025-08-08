defmodule Mythweave.Zone.ZoneSchema do
  @moduledoc """
  Validates server zone JSON structure and ensures required fields are present
  and well-formed.

  Zone data is expected to be parsed from `.server.json` and passed here
  before being loaded into runtime processes.

  Basic validation only checks for presence of required keys.
  Future enhancements will validate key formats, value types, and geometric correctness.
  """

  @required_keys ~w(id name layers collisions props spawn_points)a

  @type validation_result :: :ok | {:error, String.t()}

  @spec validate(map()) :: validation_result()
  def validate(zone) when is_map(zone) do
    missing_keys =
      Enum.filter(@required_keys, fn key ->
        not Map.has_key?(zone, key)
      end)

    if missing_keys == [] do
      :ok
    else
      {:error, "Zone validation failed: missing fields [#{Enum.join(missing_keys, ", ")}]"}
    end
  end

  def validate(_),
    do: {:error, "Zone data must be a map"}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Currently checks only for presence of top-level keys
  #    - ✅ Validate zone keys: id, name, layers, collisions, props, spawn_points
  #
  # 2. No type or structure checks on keys
  #    - ❗ Future: enforce schema (e.g., ensure `layers` is list of maps)
  #
  # 3. No geometry validation for collisions/props
  #    - ❗ Future: validate collision geometry correctness (e.g., non-negative width/height)
  #
  # 4. No hook for dev tools or schema evolution tracking
  #    - 🔄 Optional: integrate version tracking or schema diffing for migration support

end
