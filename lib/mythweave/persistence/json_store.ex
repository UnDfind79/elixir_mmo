defmodule Mythweave.Persistence.JsonStore do
  @moduledoc """
  File-based persistence system using JSON files.

  Responsibilities:
    - Persist structured player, world, or item data
    - Serialize game state for backups or offline editing
    - Provide disk-based fallback when ETS is not viable
  """

  @base_dir "priv/save_data/"

  @spec save(String.t(), map()) :: :ok | {:error, any()}
  def save(name, data) do
    path = Path.join(@base_dir, "#{name}.json")
    with {:ok, encoded} <- Jason.encode(data),
         :ok <- File.write(path, encoded) do
      :ok
    end
  end

  @spec load(String.t()) :: {:ok, map()} | {:error, atom()}
  def load(name) do
    path = Path.join(@base_dir, "#{name}.json")
    case File.read(path) do
      {:ok, contents} -> Jason.decode(contents)
      _ -> {:error, :not_found}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No atomic save or snapshot rotation
  #    - ✅ Add backup naming or versioning support
  #
  # 2. No access logging or audit trail
  #    - 🚧 Log write/read activity for review
  #
  # 3. No schema validation before save
  #    - ❗ Use struct types or ExJsonSchema

end
