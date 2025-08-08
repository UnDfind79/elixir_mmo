defmodule Mythweave.Networking.WSMessages.Xp do
  @moduledoc """
  Grants XP (debug/dev use).

  Responsible for:
    - Applying experience point increments
    - Delegating XP logic to PlayerState
  """

  defstruct [:amount]

  alias Mythweave.Player.PlayerState

  @type t :: %__MODULE__{
          amount: non_neg_integer()
        }

  @spec handle(t(), String.t()) :: {:ok | :error, any()}
  def handle(%__MODULE__{amount: amt}, pid) do
    PlayerState.grant_xp(pid, amt)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No permission check for XP injection
  #    - ❗ Restrict to admin/dev contexts only
  #
  # 2. Does not return post-XP state or level-up feedback
  #    - 🚧 Enhance `grant_xp/2` to emit structured events or results
  #
  # 3. No validation on XP bounds
  #    - ✅ Clamp or sanitize XP amounts if exposed to non-dev usage
end
