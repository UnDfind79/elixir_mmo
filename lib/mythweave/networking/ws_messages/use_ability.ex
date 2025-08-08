defmodule Mythweave.Networking.WSMessages.UseAbility do
  @moduledoc """
  Uses a special ability (alias of Ability message).

  Responsible for:
    - Wrapping and routing ability activation
    - Ensuring compatibility with client-side message schema
  """

  defstruct [:ability_id, :target_id]

  alias Mythweave.Networking.WSMessages.Ability

  @type t :: %__MODULE__{
          ability_id: String.t(),
          target_id: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok | :error, any()}
  def handle(msg, pid), do: Ability.handle(msg, pid)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Delegates blindly to Ability.handle/2
  #    - 🚧 Confirm structure of `msg` matches `ability.ex` expectations
  #
  # 2. No validation of ability_id or target
  #    - ❗ Add error handling for malformed or unsupported ability inputs
  #
  # 3. Doesn't differentiate usage source (e.g. passive trigger vs direct)
  #    - ✅ Consider extending support for triggered abilities later
end
