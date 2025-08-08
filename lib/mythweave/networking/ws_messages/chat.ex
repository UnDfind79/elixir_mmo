defmodule Mythweave.Networking.WSMessages.Chat do
  @moduledoc """
  Broadcasts a chat message to the current channel or zone.
  """

  defstruct [:text]

  alias Mythweave.Chat.ChatService

  def handle(%__MODULE__{text: msg}, player_id) do
    ChatService.send_message(player_id, msg)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Sends message globally without context (e.g., party, local)
  #    - 🚧 Extend to support multiple chat scopes
  #
  # 2. No message validation or profanity filtering
  #    - ❗ Add validation/sanitization to prevent abuse
  #
  # 3. No async handling or error catching
  #    - ✅ Consider async delivery or fail-safe handling
end
