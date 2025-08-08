defmodule Mythweave.Utils.Logger do
  @moduledoc """
  Structured game logging with contextual metadata and severity filtering.

  Wraps `Logger` with standardized formatting for:
    - In-game events
    - Player actions
    - World/system events
    - Debug and diagnostic output

  All log entries include a structured metadata context for tracing.
  """

  require Logger

  @type context :: keyword()

  # -----------------------------
  # Public Logging Functions
  # -----------------------------

  @spec info(String.t(), context()) :: :ok
  def info(message, context \\ []),
    do: log(:info, message, context)

  @spec warn(String.t(), context()) :: :ok
  def warn(message, context \\ []),
    do: log(:warn, message, context)

  @spec error(String.t(), context()) :: :ok
  def error(message, context \\ []),
    do: log(:error, message, context)

  @spec debug(String.t(), context()) :: :ok
  def debug(message, context \\ []),
    do: log(:debug, message, context)

  # -----------------------------
  # Internal Dispatcher
  # -----------------------------

  defp log(level, message, context) do
    Logger.log(level, fn ->
      "[#{String.upcase(to_string(level))}] #{message} | #{format_context(context)}"
    end)
  end

  defp format_context([]), do: "-"
  defp format_context(context), do: inspect(context, pretty: true, limit: :infinity)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Currently outputs formatted string only — no metadata tagging
  #    - ❗ Future: pass structured metadata to Logger via `Logger.metadata/1`
  #
  # 2. No support for per-module tagging or trace IDs
  #    - 🔄 Optional: inject `:module`, `:trace_id`, `:player_id`, etc.
  #
  # 3. Not wired into telemetry or external sink (Logflare, Loki, etc.)
  #    - ❗ Future: integrate with external observability tools

end
