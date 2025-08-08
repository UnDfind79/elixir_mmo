defmodule Telemetry.Metrics do
  @moduledoc """
  Minimal no-op stubs for `Telemetry.Metrics` so the project can compile
  without bringing in external dependencies yet.

  Provides the common metric macros (`counter/2`, `summary/2`, etc.)
  that simply expand to atoms, allowing modules that `import Telemetry.Metrics`
  to compile.

  ⚠️ This is *not* production telemetry. Replace with the real `:telemetry_metrics`
  dependency when wiring proper monitoring.
  """

  defmacro counter(_name, _opts \\ []), do: quote(do: :telemetry_counter)
  defmacro summary(_name, _opts \\ []), do: quote(do: :telemetry_summary)
  defmacro last_value(_name, _opts \\ []), do: quote(do: :telemetry_last_value)
  defmacro distribution(_name, _opts \\ []), do: quote(do: :telemetry_distribution)
end
