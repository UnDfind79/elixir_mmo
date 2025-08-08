defmodule Mythweave.NPC.NPCServer do
  @moduledoc """
  Manages the runtime state and behavior of a single NPC entity.

  This GenServer holds:
    - NPC position, stats, AI type
    - Dialogue hooks or shop interfaces
    - Future: combat logic, faction alignment, awareness radius

  All NPCs are registered in `Mythweave.NPCRegistry` and supervised individually.
  """

  use GenServer

  alias Mythweave.NPC

  @type npc_id :: String.t()
  @type state :: %NPC{
          id: npc_id(),
          name: String.t(),
          zone_id: String.t(),
          position: {number(), number()},
          type: atom(),
          stats: map(),
          ai: map(),
          dialogue: map()
        }

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(NPC.t()) :: GenServer.on_start()
  def start_link(%NPC{id: id} = npc),
    do: GenServer.start_link(__MODULE__, npc, name: via(id))

  @spec get(npc_id()) :: state()
  def get(id),
    do: GenServer.call(via(id), :get)

  # -----------------------------
  # GenServer Callbacks
  # -----------------------------

  @impl true
  def init(npc), do: {:ok, npc}

  @impl true
  def handle_call(:get, _from, state),
    do: {:reply, state, state}

  # -----------------------------
  # Registry
  # -----------------------------

  defp via(id),
    do: {:via, Registry, {Mythweave.NPCRegistry, id}}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No AI tick or behavior dispatch
  #    - ❗ Future: implement `handle_info(:tick, state)` for AI loop
  #
  # 2. Dialogue is raw map — no interaction helpers yet
  #    - 🔄 Optional: define `DialogueService` for trees, options, flags
  #
  # 3. No live zone broadcast or awareness system
  #    - ❗ Future: add publish to zone or socket layer when NPC state changes

end
