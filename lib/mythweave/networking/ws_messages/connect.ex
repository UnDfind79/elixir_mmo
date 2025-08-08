defmodule Mythweave.Networking.WSMessages.Connect do
  @moduledoc """
  Initializes a new client connection and authenticates the token.
  """

  defstruct [:token]

  alias Mythweave.Auth.AuthService
  alias Mythweave.Auth.AuthSocketHandler

  def handle(%__MODULE__{token: token}, _pid) do
    with {:ok, player_id} <- AuthService.verify_token(token),
         :ok <- AuthSocketHandler.register(player_id) do
      {:ok, %{player_id: player_id}}
    else
      _ -> {:error, :unauthorized}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes token verification returns only {:ok, player_id}
  #    - 🚧 Confirm support for token refresh or context restoration
  #
  # 2. Registers session without transport context
  #    - ❗ Add socket or connection metadata to session
  #
  # 3. No handling for already-connected clients
  #    - ✅ Add deduplication or reconnect logic
end
