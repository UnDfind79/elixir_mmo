defmodule Ecto.Query do
  @moduledoc """
  Minimal no-op stub for `Ecto.Query` so imports like `import Ecto.Query`
  and macros like `from/2` will compile.

  ⚠️ This is not a real query DSL. Replace with the real `:ecto` dependency
  (and an adapter like `:postgrex`) when persistence is implemented.
  """

  defmacro from(expr, _kw \\ []), do: expr
end

defmodule Ecto.Repo do
  @moduledoc """
  Minimal no-op stub for `Ecto.Repo` that provides common functions used
  in code paths, returning harmless defaults.

  ⚠️ Not production-ready. Swap to a real Repo module with a proper adapter
  and configuration before any real persistence.
  """

  defmacro __using__(_opts) do
    quote do
      # Common Repo functions as no-ops / safe defaults
      def config, do: []

      def all(_query), do: []
      def one(_query), do: nil
      def get(_schema, _id), do: nil
      def get!(_schema, _id), do: raise "Ecto.Repo.get!/2 not available in stub"
      def get_by(_schema, _clauses), do: nil

      def insert(changeset), do: {:ok, changeset}
      def insert!(_changeset), do: raise "Ecto.Repo.insert!/1 not available in stub"
      def update(changeset), do: {:ok, changeset}
      def update!(_changeset), do: raise "Ecto.Repo.update!/1 not available in stub"
      def delete(struct), do: {:ok, struct}
      def delete!(_struct), do: raise "Ecto.Repo.delete!/1 not available in stub"

      def transaction(fun) when is_function(fun, 0), do: {:ok, fun.()}
      def preload(struct_or_structs, _preloads), do: struct_or_structs
    end
  end
end
