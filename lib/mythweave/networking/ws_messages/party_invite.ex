defmodule Mythweave.Networking.WSMessages.PartyInvite do
  @moduledoc """
  Sends a party invite to another player.

  Responsible for:
    - Handling client-side invite initiation
    - Passing target ID to the party coordination service
  """

  defstruct [:target_id]

  alias Mythweave.Social.PartyService

  @type t :: %__MODULE__{
          target_id: String.t()
        }

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{target_id: tid}, pid) do
    PartyService.invite(pid, tid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of party size, cooldowns, or existing invites
  #    - ❗ Enforce party constraints and prevent spam
  #
  # 2. Assumes `target_id` is online and reachable
  #    - 🚧 Add session presence check or fallback handling
  #
  # 3. No feedback or invite acknowledgment system
  #    - ✅ Define client-side confirmation flow for invites
end
