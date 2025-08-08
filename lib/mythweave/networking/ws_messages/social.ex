defmodule Mythweave.Networking.WSMessages.Social do
  @moduledoc """
  Generic handler for friend requests, blocks, and messages.

  Responsible for:
    - Routing social actions like friend add/remove, block, etc.
    - Delegating to SocialService for state changes
  """

  defstruct [:action, :target_id]

  alias Mythweave.Social.SocialService

  @type t :: %__MODULE__{
          action: String.t(),
          target_id: String.t()
        }

  @spec handle(t(), String.t()) :: :ok | {:error, term()}
  def handle(%__MODULE__{action: a, target_id: t}, p),
    do: SocialService.handle_action(p, a, t)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of action keywords
  #    - ❗ Add strict validation for supported action types
  #
  # 2. Does not prevent self-targeting for invalid actions
  #    - 🚧 Add guard against self-targeted blocks/messages
  #
  # 3. No result feedback routed to caller
  #    - ✅ Enhance SocialService to return and propagate structured responses
end
