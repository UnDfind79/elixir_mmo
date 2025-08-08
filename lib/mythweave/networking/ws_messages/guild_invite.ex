defmodule Mythweave.Networking.WSMessages.GuildInvite do
  @moduledoc """
  Invites another player to the sender’s guild.

  Responsible for:
    - Permission check (inviter must be officer or leader)
    - Target player validation
    - Emitting invite and/or notifying target
  """

  defstruct [:target_id]

  alias Mythweave.Social.GuildService

  @type t :: %__MODULE__{
          target_id: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{target_id: tid}, pid) do
    GuildService.invite(pid, tid)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation if `pid` is in a guild or has invite privileges
  #    - ❗ Enforce role-based access (officer/leader only)
  #
  # 2. Does not confirm target is online or exists
  #    - 🚧 Add lookup/failover for offline/inexistent players
  #
  # 3. No real-time notification sent to target
  #    - ✅ Ensure GuildService handles broadcast or event
end
