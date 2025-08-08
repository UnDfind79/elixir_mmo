defmodule Mythweave.Crafting.CraftingEngine do
  @moduledoc """
  Executes crafting attempts based on player inputs and loaded recipes.

  Responsibilities:
    - Match player ingredients to known recipes
    - Validate skill level, station requirements, and patterns
    - Determine crafting outcome: success, fail, or critical
  """

  alias Mythweave.Crafting.RecipeLoader
  alias Mythweave.Player.Inventory
  alias Mythweave.EventBus

  @type player_id :: String.t()
  @type recipe_id :: String.t()
  @type result :: :success | :fail | :critical

  @spec craft(player_id(), recipe_id(), [String.t()]) :: {:ok, result()} | {:error, atom()}
  def craft(player_id, recipe_id, ingredients) do
    with {:ok, recipe} <- RecipeLoader.load(recipe_id),
         true <- validate_ingredients(ingredients, recipe),
         result <- roll_outcome(recipe),
         :ok <- Inventory.consume_items(player_id, ingredients) do
      EventBus.publish(:craft, %{player: player_id, result: result, recipe: recipe_id})
      {:ok, result}
    else
      false -> {:error, :invalid_ingredients}
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_ingredients(player_items, %{inputs: required}) do
    Enum.sort(player_items) == Enum.sort(required)
  end

  defp roll_outcome(_recipe) do
    # Stub: always succeed
    :success
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Outcome always succeeds
  #    - ✅ Add RNG + skill checks (e.g., crit chance)
  #
  # 2. No support for stations, tools, or special augment rolls
  #    - 🚧 Integrate station metadata and quality tiers
  #
  # 3. Inventory check assumes consume will succeed
  #    - ❗ Add dry-run preview + error recovery

end
