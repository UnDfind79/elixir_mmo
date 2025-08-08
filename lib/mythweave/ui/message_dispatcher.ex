defmodule Mythweave.UI.MessageDispatcher do
  @moduledoc """
  Sends formatted messages to player sessions via socket or proxy.

  Responsibilities:
    - Deliver chat, system, and combat messages
    - Abstract away socket transport details
    - Support future multi-channel output (whisper, zone, group)
  """

  import Kernel, except: [send: 2]

  alias Mythweave.UI.SystemMessage
  alias Mythweave.Player.Registry

  @type player_id :: String.t()

  @spec send(player_id(), SystemMessage.t()) :: :ok | :error
  def send(player_id, msg) do
    case Registry.lookup(player_id) do
      {:ok, pid} -> GenServer.cast(pid, {:system_message, msg})
      _ -> :error
    end
  end

  @spec broadcast([player_id()], SystemMessage.t()) :: :ok
  def broadcast(ids, msg) do
    Enum.each(ids, &send(&1, msg))
    :ok
  end

  @spec notify_error(player_id(), String.t()) :: :ok
  def notify_error(id, text) do
    send(id, SystemMessage.error(text))
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Sends only via player GenServer
  #    - ✅ Add transport-level fallback if needed
  #
  # 2. No channel-based routing (guild, team, local)
  #    - 🚧 Add chat context tags and router module
  #
  # 3. No message persistence/log
  #    - ❗ Add historical storage if needed for audit/logs

end
