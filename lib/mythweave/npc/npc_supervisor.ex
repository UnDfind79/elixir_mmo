defmodule Mythweave.NPC.NPCSupervisor do
  @moduledoc """
  Supervises all NPC processes and manages their lifecycle.

  Spawns:
    - Registry (`Mythweave.NPCRegistry`) for process lookups
    - DynamicSupervisor (`Mythweave.NPCDynamicSupervisor`) for NPCServer instances

  Responsibilities:
    - Starts/stops NPCs on demand
    - Ensures fault isolation per NPC
    - Supports dynamic reloading or scripted NPCs
  """

  use Supervisor

  alias Mythweave.NPC.NPCServer

  @registry Mythweave.NPCRegistry
  @dynamic_sup Mythweave.NPCDynamicSupervisor

  @type npc :: struct()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(_),
    do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @spec spawn_npc(npc()) :: DynamicSupervisor.on_start_child()
  def spawn_npc(npc),
    do: DynamicSupervisor.start_child(@dynamic_sup, {NPCServer, npc})

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

  # 1. NPCRegistry is node-local
  #    - ❗ Future: support multi-node Registry or cluster-wide NPC presence
  #
  # 2. No despawn or restart throttle for flapping
  #    - 🔄 Optional: debounce or backoff strategies for unstable NPC scripts
  #
  # 3. No awareness of zone-to-NPC mapping
  #    - ❗ Add `ZoneLoader.spawn_npcs(zone_id)` to preload relevant NPCs

end
