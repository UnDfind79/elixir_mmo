defmodule Mythweave.Auth.AuthSocketHandler do
  @moduledoc """
  Handles WebSocket authentication lifecycle:
    - Login and token issuance
    - Session refresh
    - Logout and cleanup
  """

  alias Mythweave.Auth.AuthService
  alias Mythweave.Utils.Logger

  @type socket :: Phoenix.Socket.t()
  @type event :: String.t()
  @type payload :: map()

  @spec handle(event(), payload(), socket()) ::
          {:reply, {:ok | :error, any()}, socket()}
  def handle("connect", %{"username" => username, "password" => password}, socket) do
    case AuthService.login(username, password) do
      {:ok, %{player_id: player_id, token: token}} ->
        Logger.info("Login successful", username: username, player_id: player_id)
        {:reply, {:ok, %{player_id: player_id, token: token}}, assign(socket, :player_id, player_id)}

      {:error, reason} ->
        Logger.warn("Login failed", username: username, reason: reason)
        {:reply, {:error, reason}, socket}
    end
  end

  def handle("refresh_token", %{"token" => token}, socket) do
    case AuthService.refresh(token) do
      {:ok, %{player_id: player_id}} ->
        Logger.info("Token refreshed", player_id: player_id)
        {:reply, {:ok, %{player_id: player_id}}, assign(socket, :player_id, player_id)}

      {:error, reason} ->
        Logger.warn("Token refresh failed", reason: reason)
        {:reply, {:error, "Session expired"}, clear_auth(socket)}
    end
  end

  def handle("logout", _payload, socket) do
    case socket.assigns[:player_id] do
      nil ->
        {:reply, :ok, socket}

      player_id ->
        AuthService.logout(player_id)
        Logger.info("Logout successful", player_id: player_id)
        {:reply, :ok, clear_auth(socket)}
    end
  end

  def handle(event, _payload, socket) do
    Logger.warn("Unhandled auth event", event: event)
    {:reply, {:error, "Unrecognized auth event: #{event}"}, socket}
  end

  @spec clear_auth(socket()) :: socket()
  defp clear_auth(socket) do
    socket
    |> Phoenix.Socket.assign(:player_id, nil)
    |> Phoenix.Socket.assign(:token, nil)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No brute-force or abuse protection
  #    - ❗ Add IP-aware throttling (e.g., Hammer or RateLimiter)
  #
  # 2. Socket lifecycle not verified post-refresh
  #    - ✅ Confirm `player_id` assignment triggers player init downstream
  #
  # 3. Auth assumes all events originate from a trusted channel
  #    - 🚧 Audit for channel hijacking or event spoofing risks
end
