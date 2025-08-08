defmodule Mythweave.Auth.AuthService do
  @moduledoc """
  Handles authentication, token issuance, and session lifecycle.

  Responsibilities:
    - Verify player credentials via secure hashing
    - Register and track active sessions
    - Issue and validate auth tokens
  """

  alias Mythweave.Auth.{Token, SessionRegistry}
  alias Mythweave.Persistence.Schemas.PlayerRecord
  alias Mythweave.Persistence.Repo
  alias Mythweave.Utils.Logger

  import Ecto.Query

  @type player_id :: String.t()
  @type token :: String.t()

  @spec login(String.t(), String.t()) :: {:ok, map()} | {:error, String.t()}
  def login(username, password) do
    with {:ok, player} <- validate_credentials(username, password),
         token <- Token.generate(player.id) do
      SessionRegistry.register(player.id, self())
      Logger.info("Login success", username: username, player_id: player.id)

      {:ok, %{player_id: player.id, token: token}}
    else
      {:error, reason} ->
        Logger.warn("Login failed", username: username, reason: reason)
        {:error, reason}
    end
  end

  @spec logout(player_id()) :: :ok
  def logout(player_id) do
    SessionRegistry.unregister(player_id)
    Logger.info("Logout success", player_id: player_id)
    :ok
  end

  @spec refresh(token()) :: {:ok, map()} | {:error, String.t()}
  def refresh(token) do
    case Token.verify(token) do
      {:ok, %{player_id: player_id}} -> {:ok, %{player_id: player_id}}
      _ -> {:error, "Invalid or expired token"}
    end
  end

  defp validate_credentials(username, password) do
    case Repo.get_by(PlayerRecord, username: username) do
      nil ->
        {:error, "Unknown username"}

      %PlayerRecord{password_hash: hash} = player ->
        if Bcrypt.verify_pass(password, hash) do
          {:ok, player}
        else
          {:error, "Incorrect password"}
        end
    end
  rescue
    e -> {:error, "Login error: #{Exception.message(e)}"}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Token lifetime/claims not yet scoped
  #    - ✅ Add claims for zone, perms, etc. if needed
  #
  # 2. No throttling or lockout after failed logins
  #    - ❗ Add brute-force mitigation in public deployment
  #
  # 3. SessionRegistry assumes unique player ownership
  #    - 🚧 Expand to allow multi-device or shadowing logic if needed
end
