defmodule Mythweave.Auth.Token do
  @moduledoc """
  JWT token generation and verification for authenticated players.

  Responsibilities:
    - Encode and sign claims for player sessions
    - Verify token validity and expiration
    - Extract `player_id` (subject) on valid sessions
  """

  @algorithm "HS256"
  @default_expiry 86_400  # 24 hours

  @type token :: String.t()
  @type player_id :: String.t()

  @spec generate(player_id()) :: token()
  def generate(player_id) do
    claims = %{
      "sub" => player_id,
      "exp" => current_unix() + @default_expiry
    }

    {_jws, token} =
      JOSE.JWT.sign(signing_key(), %{"alg" => @algorithm}, claims)
      |> JOSE.JWS.compact()

    token
  end

  @spec verify(token()) :: {:ok, %{player_id: player_id()}} | :error
  def verify(token) do
    with {true, %JOSE.JWT{fields: %{"exp" => exp, "sub" => player_id}}, _} <-
           JOSE.JWT.verify_strict(signing_key(), [@algorithm], token),
         true <- exp > current_unix() do
      {:ok, %{player_id: player_id}}
    else
      _ -> :error
    end
  end

  defp current_unix, do: DateTime.utc_now() |> DateTime.to_unix(:second)

  defp signing_key do
    case Application.get_env(:mythweave, :auth_secret) do
      nil ->
        IO.warn("Using fallback dev secret for JWT. Set :auth_secret in config/prod.exs!")
        :crypto.hash(:sha256, "fallback_dev_secret")

      secret when is_binary(secret) ->
        :crypto.hash(:sha256, secret)
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Only basic "sub" and "exp" claims supported
  #    - ✅ Add `scope`, `zone`, or session ID if needed
  #
  # 2. No blacklist or revocation support
  #    - 🚧 Consider Redis or DB-based denylist
  #
  # 3. Fallback secret used in dev
  #    - ❗ Validate config envs are set for prod
end
