defmodule Mythweave.Player.PlayerServer do
  @moduledoc """
  Owns and manages the runtime state of an individual player using a GenServer.

  Responsibilities:
    - Tracks live `PlayerState` (location, stats, inventory, combat, etc.)
    - Exposes safe APIs for inspection and state manipulation
    - Registered by `player_id` in `Mythweave.PlayerRegistry`

  This is the authoritative process for a player's server-side state.
  """

  use GenServer

  alias Mythweave.Player.PlayerState

  @type player_id :: String.t()
  @type state :: PlayerState.t()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(map()) :: GenServer.on_start()
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: via(initial_state.id))
  end

  @spec get_state(player_id()) :: state()
  def get_state(player_id),
    do: GenServer.call(via(player_id), :get_state)

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(attrs) do
    state = PlayerState.new(attrs)
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state),
    do: {:reply, state, state}

  # -----------------------------
  # Internal Registry Helpers
  # -----------------------------

  defp via(player_id),
    do: {:via, Registry, {Mythweave.PlayerRegistry, player_id}}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No setters or mutation logic (e.g., move, attack, inventory ops)
  #    - ❗ Future: add `move/2`, `update_hp/2`, `add_item/2`, etc.
  #
  # 2. No persistence integration
  #    - 🔄 Optional: persist `PlayerState` snapshot on disconnect or interval
  #
  # 3. No EventBus or zone broadcast on updates
  #    - ❗ Future: emit messages when player state changes

end
