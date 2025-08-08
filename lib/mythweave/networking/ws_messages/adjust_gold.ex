defmodule Mythweave.WS.AdjustGold do
  @moduledoc """
  Handles WebSocket message: adjust_gold.ex
  """

  alias Mythweave.Networking.SocketUtils
  alias Mythweave.Engine.EventBus

  def handle(_payload, socket) do
    # TODO: Implement logic for `adjust_gold.ex` message
    EventBus.broadcast(:debug, {:unhandled_message, "adjust_gold.ex"})
    SocketUtils.reply(socket, :unhandled, %{message: "adjust_gold.ex not implemented"})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation or structure for gold adjustment
  #    - ❗ Define expected fields (e.g., amount, reason) in payload
  #
  # 2. No side effect or player update logic
  #    - 🚧 Implement integration with economy or player state modules
  #
  # 3. No permission or source validation
  #    - ⚠️ Consider restricting access to system/GM sources only
end
