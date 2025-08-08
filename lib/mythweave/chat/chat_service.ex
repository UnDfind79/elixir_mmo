defmodule Mythweave.Chat.ChatService do
  @moduledoc """
  Core chat message handling.

  Responsibilities:
    - Broadcast player messages (global, local)
    - Send system or private messages
    - Provide contextual responses to commands
  """

  alias Mythweave.Engine.EventBus
  alias Mythweave.Auth.SessionRegistry

  @type player_id :: String.t()
  @type message_text :: String.t()

  # === Chat API ===

  @spec send_message(player_id(), message_text()) :: :ok
  def send_message(player_id, message) do
    EventBus.broadcast(:chat, %{
      type: :global,
      from: player_id,
      text: message
    })
  end

  @spec send_local(player_id(), message_text()) :: :ok
  def send_local(player_id, text) do
    EventBus.broadcast(:chat, %{
      type: :local,
      from: player_id,
      text: text
    })
  end

  @spec send_system(player_id(), message_text()) :: :ok
  def send_system(player_id, text) do
    EventBus.broadcast(:chat, %{
      type: :system,
      to: player_id,
      text: text
    })
  end

  # === Legacy Command Bridge (deprecated) ===
  # Redirects slash-style commands issued through old handlers.
  # Should be replaced by `ChatCommands.parse/2`.

  @spec handle_command(String.t(), player_id()) :: :ok
  def handle_command("/who", player_id) do
    players = SessionRegistry.list_online()
    summary = "👥 Online players (#{length(players)}): #{Enum.join(players, ", ")}"
    send_system(player_id, summary)
  end

  def handle_command("/zone", player_id) do
    # TODO: Replace with dynamic zone lookup via PlayerServer
    send_system(player_id, "📍 You are currently in zone: [unknown]")
  end

  def handle_command("/help", player_id) do
    send_system(player_id, """
    🧠 Available chat commands:
/who           - List online players
/zone          - Show current zone
/roll          - Roll a 1–100
/emote [text]  - Perform an emote
    """)
  end

  def handle_command(_unknown, player_id) do
    send_system(player_id, "❓ Unknown command. Try /help.")
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. `handle_command/2` is redundant with ChatCommands
  #    - ✅ Deprecate and route all slash commands through a unified module
  #
  # 2. Zone info is hardcoded
  #    - 🚧 Integrate with live player metadata (via PlayerServer or Registry)
  #
  # 3. `EventBus.broadcast/2` assumes all consumers respect payload shape
  #    - ❗ Add schema spec or test to avoid breakage
end
