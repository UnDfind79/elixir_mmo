defmodule Mythweave.Networking.WSMessages.SchemaLoad do
  @moduledoc """
  Developer tool: loads a dynamic schema at runtime.

  Expects:
    - `schema_id`: string identifier of the schema to load

  Responsible for:
    - Invoking `SchemaLoader` to reload data/schemas dynamically
  """

  defstruct [:schema_id]

  alias Mythweave.Dev.SchemaLoader

  @type t :: %__MODULE__{schema_id: String.t()}

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{schema_id: id}, _pid) do
    SchemaLoader.load(id)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No authentication or permission checks
  #    - ❗ Restrict access to dev/admin sessions only
  #
  # 2. Silent failure if schema ID is invalid or not found
  #    - 🚧 Improve error reporting to caller on failure
  #
  # 3. No audit or telemetry emitted
  #    - ✅ Optional: emit debug/telemetry event for loaded schema
end
