defmodule Mythweave.Logging.AuditLog do
  @moduledoc """
  Records critical game events, admin actions, and suspicious activity.

  Responsibilities:
    - Persist high-impact actions like bans, zone crashes, or gold changes
    - Support structured logs with metadata
    - Enable inspection or export for moderation or forensic tools
  """

  require Logger

  @type category :: :admin_action | :economy | :security | :system
  @type entry :: %{
          time: DateTime.t(),
          category: category(),
          message: String.t(),
          meta: map()
        }

  @spec record(category(), String.t(), map()) :: :ok
  def record(category, message, meta \\ %{}) do
    entry = %{
      time: DateTime.utc_now(),
      category: category,
      message: message,
      meta: meta
    }

    log(entry)
    persist(entry)
    :ok
  end

  defp log(%{category: :security} = entry) do
    Logger.warning("[SECURITY] #{entry.message}", entry.meta)
  end

  defp log(%{category: :admin_action} = entry) do
    Logger.info("[ADMIN] #{entry.message}", entry.meta)
  end

  defp log(%{category: :economy} = entry) do
    Logger.info("[ECONOMY] #{entry.message}", entry.meta)
  end

  defp log(%{category: :system} = entry) do
    Logger.debug("[SYSTEM] #{entry.message}", entry.meta)
  end

  defp persist(_entry) do
    # Placeholder: Integrate with database, ETS, or file-based storage
    # File.append or :ets.insert(:audit_log, entry) could be future hooks
    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only logs to stdout/logger
  #    - ✅ Add `persist/1` for file or DB storage
  #
  # 2. No deduplication or spam protection
  #    - 🚧 Consider event hash, rate limit by category or source
  #
  # 3. Not queryable or reportable
  #    - ❗ ETS table or Telemetry pipeline for real-time admin tools

end
