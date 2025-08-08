defmodule Mythweave.Quest.QuestEvents do
  @moduledoc """
  Subscribes to and processes game events to advance or resolve player quests.

  Hooks into:
    - Combat (`:on_kill`)
    - Movement (`:on_move`)
    - Future: dialogue, item pickup, interaction, environmental triggers

  This module is the entry point for event-based progression.
  """

  alias Mythweave.Quest.{QuestState, QuestService}

  @type player_id :: String.t()
  @type mob_id :: String.t()
  @type zone_id :: String.t()

  # -----------------------------
  # Event Hooks
  # -----------------------------

  @spec on_kill(player_id(), mob_id()) :: :ok
  def on_kill(player_id, mob_id) do
    IO.puts("[QuestEvents] #{player_id} killed #{mob_id} (quest hook)")

    # 🔧 TODO: Update QuestState kill count for player
    # 🔧 TODO: Check if any active quest completes via `QuestService.check_completion?/2`
    # 🔧 TODO: Trigger reward or state update if quest is complete

    :ok
  end

  @spec on_move(player_id(), zone_id()) :: :ok
  def on_move(player_id, zone_id) do
    IO.puts("[QuestEvents] #{player_id} moved to #{zone_id} (quest hook)")

    # 🔧 TODO: Update QuestState location for player
    # 🔧 TODO: Check for completion of delivery/location-based quests
    # 🔧 TODO: Broadcast quest update to client if state changes

    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Currently uses only `IO.puts` — no real updates to QuestState
  #    - ❗ Required: use `QuestState.update_kills/2` and `update_location/2`
  #
  # 2. Completion check not tied to active quest list
  #    - ❗ Future: fetch only active quests from player state
  #
  # 3. No broadcasting or event notifications on completion
  #    - 🔄 Optional: trigger WS push or EventBus event when player completes quest

end
