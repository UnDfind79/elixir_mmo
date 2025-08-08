defmodule Mythweave.Persistence.DB do
  @moduledoc """
  Central access point for executing database queries via Ecto.

  Wraps common Repo operations with clear namespacing and consistency.
  Intended for use by `PersistenceService` and related high-level modules.
  """

  import Ecto.Query, warn: false
  alias Mythweave.Persistence.Repo

  @type schema :: module()
  @type changeset :: Ecto.Changeset.t()
  @type clauses :: keyword()
  @type db_struct :: Ecto.Schema.t()
  @type queryable :: Ecto.Queryable.t()

  # -----------------------------
  # Basic Query Execution
  # -----------------------------

  @spec get_by(schema(), clauses()) :: db_struct() | nil
  def get_by(schema, clauses),
    do: Repo.get_by(schema, clauses)

  @spec insert(changeset()) :: {:ok, db_struct()} | {:error, Ecto.Changeset.t()}
  def insert(changeset),
    do: Repo.insert(changeset)

  @spec update(changeset()) :: {:ok, db_struct()} | {:error, Ecto.Changeset.t()}
  def update(changeset),
    do: Repo.update(changeset)

  @spec delete(db_struct()) :: {:ok, db_struct()} | {:error, term()}
  def delete(struct),
    do: Repo.delete(struct)

  # -----------------------------
  # Query Builders
  # -----------------------------

  @spec all(queryable()) :: [term()]
  def all(queryable),
    do: Repo.all(queryable)

  @spec one(queryable()) :: term() | nil
  def one(queryable),
    do: Repo.one(queryable)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No telemetry or instrumentation wrappers
  #    - ❗ Future: track query latency with `:telemetry` or `EctoTracer`
  #
  # 2. No soft-delete or archival helpers
  #    - 🔄 Optional: add `soft_delete/2`, `restore/1` for audit-safe mutations
  #
  # 3. No transaction helpers
  #    - ❗ Future: implement `transaction/1` for grouped writes

end
