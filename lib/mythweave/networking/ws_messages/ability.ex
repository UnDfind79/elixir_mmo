defmodule Mythweave.WS.Ability do
  @moduledoc """
  Handles WebSocket message: ability.ex
  """

  alias Mythweave.Networking.SocketUtils
  alias Mythweave.Engine.EventBus

  def handle(_payload, socket) do
    # TODO: Implement logic for `ability.ex` message
    EventBus.broadcast(:debug, {:unhandled_message, "ability.ex"})
    SocketUtils.reply(socket, :unhandled, %{message: "ability.ex not implemented"})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Message handler is a stub with no payload parsing
  #    - ❗ Define schema/format for `ability.ex` WebSocket payload
  #
  # 2. No routing to combat/ability systems
  #    - 🚧 Integrate with AbilityService or CombatService (if exists)
  #
  # 3. Debug broadcast is generic
  #    - ✅ Sufficient for dev visibility, but consider structured logging
end
