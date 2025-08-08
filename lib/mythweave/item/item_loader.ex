defmodule Mythweave.Item.ItemLoader do
  @moduledoc """
  Loads general item definitions from JSON for dynamic content or debugging.

  Responsibilities:
    - Support full-world item simulation, not just templates
    - Provide loading API for admin or procedural generation
  """

  @dir "priv/worlds/test_world/items/"

  @spec load(String.t()) :: {:ok, map()} | {:error, :not_found}
  def load(id) do
    path = Path.join(@dir, "#{id}.json")

    case File.read(path) do
      {:ok, json} -> Jason.decode(json)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Mirrors functionality with `ItemTemplateLoader`
  #    - ✅ Consolidate loaders for shared cache and schema
  #
  # 2. No error metadata on load failure
  #    - 🚧 Improve error surface for client/UI diagnostics

end
