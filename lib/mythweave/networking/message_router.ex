defmodule Mythweave.Networking.MessageRouter do
  @moduledoc """
  Central dispatcher for all incoming WebSocket messages.

  Routes messages by type to the appropriate domain handler, such as:
    - Auth (login, logout)
    - Chat (commands, messages)
    - Gameplay (movement, combat, inventory, schema, etc.)

  This is the entry point from `SocketChannel` to the server's service layers.
  """

  require Logger

  alias Mythweave.Auth.AuthSocketHandler
  alias Mythweave.Chat.ChatChannel

  @type payload :: map()
  @type socket :: Phoenix.Socket.t()

  # -----------------------------
  # Core Message Routing
  # -----------------------------

  @spec route(String.t(), payload(), socket()) :: :noreply | any()
  def route("connect", payload, socket),
    do: AuthSocketHandler.handle("connect", payload, socket)

  def route("logout", _payload, socket),
    do: AuthSocketHandler.handle("logout", %{}, socket)

  # -----------------------------
  # Chat Messages
  # -----------------------------

  def route("chat", %{"text" => _text} = payload, socket) do
    # 🧠 Future: route slash commands differently from chat messages
    ChatChannel.handle_in("chat", payload, socket)
  end

  # -----------------------------
  # Fallback Catch-All
  # -----------------------------

  def route(msg_type, _payload, socket) do
    Logger.warning("Unhandled WebSocket message: #{msg_type}")
    send(socket.transport_pid, {:warning, "Unknown message: #{msg_type}"})
    :noreply
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No gameplay handlers yet (e.g., move, attack, use_ability)
  #    - ❗ Future: add routing for CombatEngine, InventoryService, SchemaService, etc.
  #
  # 2. No event dispatch or audit trail
  #    - 🔄 Optional: emit `:ws_message_received` to EventBus for observability
  #
  # 3. No message validation schema
  #    - ❗ Add JSON schema validation or guards for malformed input

end
