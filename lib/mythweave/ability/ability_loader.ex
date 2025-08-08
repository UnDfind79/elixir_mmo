defmodule Mythweave.Ability.AbilityLoader do
  @moduledoc """
  Loads ability definitions from external JSON files.

  Responsibilities:
    - Fetch ability config by ID
    - Deserialize structured properties (cost, tags, effects)
    - Handle caching for repeated access
  """

  @dir "priv/worlds/test_world/abilities/"

  @spec load(String.t()) :: {:ok, map()} | {:error, :not_found}
  def load(id) do
    path = Path.join(@dir, "#{id}.json")

    case File.read(path) do
      {:ok, raw} -> Jason.decode(raw)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Abilities are raw JSON maps
  #    - ✅ Add schema or struct enforcement
  #
  # 2. No cache or hot reload mechanism
  #    - 🚧 Introduce Agent or ETS store for performance
  #
  # 3. No fallback/default ability behavior
  #    - ❗ Ensure critical abilities can’t fail to load

end
