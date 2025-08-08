defmodule Mythweave.ClassSchema.SchemaLoader do
  @moduledoc """
  Loads character schema layouts for ability and augment threading.

  Responsibilities:
    - Deserialize schema composition (essence, form, modifier slots)
    - Support schema switching for multi-style play
    - Serve data for HUD and glyph systems
  """

  @dir "priv/worlds/test_world/schemas/"

  @spec load(String.t()) :: {:ok, map()} | {:error, :not_found}
  def load(name) do
    path = Path.join(@dir, "#{name}.json")

    case File.read(path) do
      {:ok, json} -> Jason.decode(json)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes schemas are standalone, not tied to player
  #    - ✅ Normalize ownership ID or metadata for equipped slot
  #
  # 2. No schema slot validation (e.g. 3 max threads)
  #    - 🚧 Use macro rules or slot rules in Elixir struct
  #
  # 3. No versioning or migration logic
  #    - ❗ Prepare for breaking schema changes with upgrades

end
