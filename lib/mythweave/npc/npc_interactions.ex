defmodule Mythweave.NPC.NPCInteractions do
  @moduledoc """
  Handles interactions between players and NPCs.

  Supports:
    - Dialogue
    - Quest triggers
    - Trading and shops
    - Conditional branching (future)

  This is the entry point for any player-initiated interaction with NPCs.
  """

  alias Mythweave.NPC

  @type player_id :: String.t()
  @type interaction_result :: {:ok, map()} | {:error, term()}

  @spec interact(player_id(), NPC.t()) :: interaction_result()
  def interact(player_id, %NPC{dialogue: lines}) when is_list(lines) do
    {:ok,
     %{
       player_id: player_id,
       messages: lines,
       interaction: :dialogue
     }}
  end

  def interact(_player_id, _npc),
    do: {:error, :invalid_npc}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Dialogue is static and linear
  #    - ❗ Future: support branching dialogue tree via `DialogueService`
  #
  # 2. No quest or shop integration
  #    - 🔄 Optional: `case npc.type do :quest_giver -> QuestService.trigger(...)`
  #
  # 3. No interaction routing or NPC context switching
  #    - ❗ Needed: detect player proximity and NPC state to authorize interaction

end
