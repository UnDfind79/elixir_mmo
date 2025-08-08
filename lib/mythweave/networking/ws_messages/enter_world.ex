defmodule Mythweave.WS.EnterWorld do
  @moduledoc """
  Handles WebSocket message: enter_world.ex

  Responsible for:
    - Loading player state into memory
    - Spawning the player into the game world
    - Binding them to a zone and sending initial state
  """

  alias Mythweave.Player.PlayerState
  alias Mythweave.Zone.ZoneManager
  alias Mythweave.Engine.EventBus
  alias Mythweave.Networking.SocketUtils

  @spec handle(map(), Phoenix.Socket.t()) :: :ok | {:error, term()}
  def handle(%{"character_id" => char_id}, socket) do
    player_id = socket.assigns.player_id

    with {:ok, state} <- PlayerState.load(player_id, char_id),
         :ok <- ZoneManager.spawn_player(state),
         :ok <- EventBus.subscribe(:tick) do
      # Optionally send a welcome or initial world state message
      SocketUtils.reply(socket, :entered_world, %{zone: state.zone_id, stats: state.stats})
    else
      {:error, reason} ->
        SocketUtils.reply(socket, :error, %{reason: reason})
    end
  end

  def handle(_invalid, socket) do
    SocketUtils.reply(socket, :error, %{reason: "Malformed enter_world payload"})
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Assumes player_id is correctly assigned to the socket
  #    - ✅ Ensure authentication flow covers this binding
  #
  # 2. ZoneManager.spawn_player is stubbed
  #    - 🚧 Implement zone-aware player instancing and position tracking
  #
  # 3. No schema, inventory, or abilities loaded yet
  #    - ❗ Integrate deeper state bootstrap pipeline
end
