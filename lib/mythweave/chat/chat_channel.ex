defmodule Mythweave.Chat.ChatChannel do
  @moduledoc """
  Phoenix Channel for real-time player chat.

  Responsibilities:
    - Join scoped chat topics (global, local, party)
    - Handle incoming chat messages
    - Route commands to `ChatCommands`
    - Deliver regular messages via `ChatService`
  """

  use Phoenix.Channel

  alias Mythweave.Chat.{ChatService, ChatCommands}
  alias Mythweave.Utils.Logger

  @impl true
  @spec join(String.t(), map(), Phoenix.Socket.t()) :: {:ok, Phoenix.Socket.t()}
  def join("chat:" <> _subtopic, _params, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_in(String.t(), map(), Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("chat", %{"text" => text} = _payload, socket) when is_binary(text) do
    case socket.assigns do
      %{player_id: player_id} ->
        case ChatCommands.parse(text, player_id) do
          :handled ->
            :ok

          :unhandled ->
            ChatService.send_message(player_id, text)
        end

      _ ->
        Logger.warn("Chat received without player_id", raw: text)
    end

    {:noreply, socket}
  end

  def handle_in("chat", _bad_payload, socket) do
    Logger.debug("Dropping malformed chat payload")
    {:noreply, socket}
  end

  def handle_in(event, _payload, socket) do
    Logger.debug("Unhandled chat event", event: event)
    {:noreply, socket}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Chat is unsanitized — no profanity filtering or length checks
  #    - ❗ Add `ChatFilter` and/or profanity screening module
  #
  # 2. Commands are synchronous
  #    - ✅ Acceptable for slash commands, but monitor latency
  #
  # 3. Scope detection (zone, guild, party) is absent
  #    - 🚧 Tag `text` with context or detect from socket/topic
end
