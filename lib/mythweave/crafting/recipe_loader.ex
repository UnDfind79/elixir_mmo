defmodule Mythweave.Crafting.RecipeLoader do
  @moduledoc """
  Loads crafting recipe definitions from external JSON files.

  Responsibilities:
    - Fetch recipes by ID
    - Parse input/output and metadata
    - Support cached or lazy-load pattern
  """

  @recipes_path "priv/worlds/test_world/recipes/"

  @type recipe_id :: String.t()
  @type recipe :: %{inputs: [String.t()], output: String.t(), metadata: map()}

  @spec load(recipe_id()) :: {:ok, recipe()} | {:error, :not_found}
  def load(id) do
    path = Path.join(@recipes_path, "#{id}.json")

    case File.read(path) do
      {:ok, json} -> Jason.decode(json)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No in-memory cache of recipes
  #    - ✅ Add caching via ETS or GenServer if load cost rises
  #
  # 2. Missing schema validation for JSON content
  #    - 🚧 Validate shape before passing to CraftingEngine
  #
  # 3. No support for recipe categories or tags
  #    - ❗ Add structure for profession-type segregation

end
