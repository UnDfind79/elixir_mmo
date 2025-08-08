defmodule Mythweave.Player.Session do
  @moduledoc """
  Interface layer between player socket and server-side logic.

  Responsibilities:
    - Route player-specific network messages (move, cast, chat)
    - Track session lifecycle and cleanup on disconnect
    - Validate incoming input payloads
  """

  alias Mythweave.Player.Registry
  alias Mythweave.World.ZoneServer
  alias Mythweave.Combat.Engine

  @type payload :: map()

  @spec handle_auth(pid(), payload()) :: :ok
  def handle_auth(_socket_pid, %{"player_id" => id}) do
    Mythweave.Player.Server.start_link(id)
    Registry.register(id, self())
    :ok
  end

  @spec handle_move(pid(), payload()) :: :ok
  def handle_move(socket_pid, %{"player_id" => id, "pos" => pos}) do
    with {:ok, pid} <- Registry.lookup(id) do
      send(pid, {:move, pos})
      :ok
    else
      _ -> {:error, :not_found}
    end
  end

  @spec handle_cast(pid(), payload()) :: :ok
  def handle_cast(_socket_pid, %{"player_id" => id, "ability" => ability, "target" => target}) do
    Engine.cast_ability(id, ability, %{target_id: target})
    :ok
  end

  @spec handle_chat(pid(), payload()) :: :ok
  def handle_chat(_socket_pid, %{"msg" => msg}) do
    Mythweave.EventBus.publish(:chat, %{text: msg})
    :ok
  end

  @spec handle_inspect(pid(), payload()) :: :ok
  def handle_inspect(_socket_pid, %{"player_id" => id}) do
    {:ok, pid} = Registry.lookup(id)
    state = :sys.get_state(pid)
    IO.inspect(state, label: "Player Inspect")
    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No error handling for invalid or missing keys
  #    - ✅ Add pattern checks and default fallbacks
  #
  # 2. Assumes player_id is trusted from client
  #    - 🚧 Verify identity via token system
  #
  # 3. No disconnect or timeout handling
  #    - ❗ Add lifecycle hooks and registry cleanup

end
