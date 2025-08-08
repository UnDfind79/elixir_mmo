defmodule Mythweave.Networking.SocketChannel do
  @moduledoc """
  WebSocket handler for player communication using Phoenix Channels.

  Responsibilities:
    - Joins player-specific topics (e.g., `"player:\#{id}"`)
    - Registers active connections with `ConnectionManager`
    - Forwards messages to `MessageRouter`
    - Handles cleanup on disconnect

  Message routing is centralized and domain-agnostic.
  """

  use Phoenix.Channel

  alias Mythweave.Networking.{MessageRouter, ConnectionManager}

  @type socket :: Phoenix.Socket.t()
  @type player_id :: String.t()
  @type payload :: map()

  # -----------------------------
  # Player Join Lifecycle
  # -----------------------------

  @impl true
  def join("player:" <> player_id, _params, socket) do
    ConnectionManager.register(player_id, self())
    {:ok, Phoenix.Socket.assign(socket, :player_id, player_id)}
  end

  @impl true
  def terminate(_reason, socket) do
    ConnectionManager.disconnect_pid(self())
    :ok
  end

  # -----------------------------
  # Incoming Message Handler
  # -----------------------------

  @impl true
  def handle_in(event, payload, socket) do
    case MessageRouter.route(event, payload, socket) do
      {:reply, response, new_socket} ->
        {:reply, {:ok, response}, new_socket}

      :noreply ->
        log_unhandled(event, payload, socket)
        {:noreply, socket}
    end
  end

  # -----------------------------
  # Debug & Logging
  # -----------------------------

  defp log_unhandled(event, payload, socket) do
    require Logger

    Logger.warning("""
    [⚠️ Unrouted Message]
    ▸ Event: #{inspect(event)}
    ▸ Payload: #{inspect(payload)}
    ▸ Player: #{inspect(socket.assigns[:player_id])}
    """)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No heartbeat or timeout logic
  #    - ❗ Needed: push `ping`/`pong` or client liveness tracking
  #
  # 2. No auth or session validation on join
  #    - ❗ Future: verify session token before allowing socket join
  #
  # 3. No support for non-player topics
  #    - 🔄 Optional: extend to `zone:*`, `global:*`, etc. channels

end
