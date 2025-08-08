defmodule Mythweave.Player.PlayerSupervisor do
  @moduledoc """
  Supervises all active player processes dynamically.

  This module starts:
    - A `Registry` for player process lookups by ID
    - A `DynamicSupervisor` to manage the lifecycle of `PlayerServer` instances

  Player processes are fault-isolated and restarted independently.
  """

  use Supervisor

  alias Mythweave.Player.{PlayerRegistry, PlayerServer}

  @registry PlayerRegistry
  @dynamic_sup Mythweave.PlayerDynamicSupervisor

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(_),
    do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @spec start_player(map()) :: DynamicSupervisor.on_start_child()
  def start_player(state),
    do: DynamicSupervisor.start_child(@dynamic_sup, {PlayerServer, state})

  # -----------------------------
  # Supervision Tree
  # -----------------------------

  @impl true
  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: @registry},
      {DynamicSupervisor, strategy: :one_for_one, name: @dynamic_sup}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. PlayerRegistry is local-only
  #    - ❗ Future: use `Registry.Distributed` for clustering across nodes
  #
  # 2. No load-shedding for high connection bursts
  #    - 🔄 Optional: add player admission throttling or queueing
  #
  # 3. No player termination hook for cleanup
  #    - ❗ Add callback on `PlayerServer` exit to persist state

end
