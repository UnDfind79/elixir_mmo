defmodule Mythweave.Networking.WSMessages.Trade do
  @moduledoc """
  Sends a trade request to another player.

  Responsible for:
    - Initiating or accepting trade interactions
    - Routing actions like "invite", "accept", "decline" to TradeService
  """

  defstruct [:target_id, :action]

  alias Mythweave.Economy.TradeService

  @type t :: %__MODULE__{
          target_id: String.t(),
          action: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok | :error, any()}
  def handle(%__MODULE__{action: action, target_id: tid}, pid) do
    TradeService.handle(pid, action, tid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of trade action type
  #    - ❗ Ensure action is one of: "invite", "accept", "decline", etc.
  #
  # 2. Assumes player can always initiate trade
  #    - 🚧 Add checks for zone rules, distance, or cooldowns
  #
  # 3. Lacks confirmation or response feedback
  #    - ✅ Extend to return structured trade result or error context
end
