defmodule Mythweave.Networking.WSMessages.AdminSetGold do
  @moduledoc """
  Admin command: Sets a player’s gold to a specific value.

  Expects a payload like:
    %{target_id: "player_abc123", gold: 10000}

  Returns:
    {:ok, %{gold: new_amount}} | {:error, reason}
  """

  defstruct [:target_id, :gold]

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{
          target_id: String.t(),
          gold: non_neg_integer()
        }

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{target_id: pid, gold: amt}, _admin_id) do
    # TODO: Add admin permission validation
    case PlayerState.set_gold(pid, amt) do
      {:ok, updated_state} ->
        {:ok, %{gold: updated_state.gold}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of admin permissions or role context
  #    - ❗ Ensure only authorized users can invoke this action
  #
  # 2. Assumes PlayerState.set_gold/2 handles all validation
  #    - 🚧 Confirm PlayerState enforces caps, bounds, and state sync
  #
  # 3. Target player process may not exist or be inactive
  #    - ⚠️ Handle :error from lookup and return user-friendly feedback
end
