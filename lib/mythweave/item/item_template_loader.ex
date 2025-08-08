defmodule Mythweave.Item.ItemTemplateLoader do
  @moduledoc """
  Loads static item template definitions from JSON files.

  Responsibilities:
    - Provide base item data like name, rarity, tags, effects
    - Support caching and structured deserialization
    - Enable flexible extensions via `meta` fields
  """

  @template_dir "priv/worlds/test_world/items/"

  @type item_id :: String.t()
  @type template :: map()

  @spec load(item_id()) :: {:ok, template()} | {:error, :not_found}
  def load(id) do
    path = Path.join(@template_dir, "#{id}.json")

    case File.read(path) do
      {:ok, json} -> Jason.decode(json)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No in-memory caching for frequently accessed templates
  #    - ✅ Add ETS or Agent cache for faster repeated loads
  #
  # 2. No schema validation on loaded fields
  #    - 🚧 Introduce `ExJsonSchema` or manual field verification
  #
  # 3. No fallback or default templates
  #    - ❗ Handle missing or broken templates gracefully in prod

end
