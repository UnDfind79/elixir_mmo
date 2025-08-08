defmodule Mythweave.Quest.QuestService do
  @moduledoc """
  Handles static and procedural quest definitions, condition checks, and metadata access.

  Responsibilities:
    - Load quest definitions (currently static, future: JSON, DB, or generated)
    - Resolve condition logic: kills, locations, events, and compound conditions
    - Retrieve structured quest data for NPCs, UI, and player state

  A quest consists of:
    - `id` :: string
    - `name` :: string
    - `conditions` :: map of goals (e.g., kills, delivery, zone visit)
  """

  alias Mythweave.Quest.QuestState

  @type quest_id :: String.t()
  @type quest :: %{
          id: quest_id(),
          name: String.t(),
          conditions: map()
        }

  @type player_state :: %{
          kills: map(),
          location: String.t(),
          quest_flags: map()
        }

  # -----------------------------
  # Public API
  # -----------------------------

  @spec list_all_quests() :: [quest()]
  def list_all_quests do
    # 🗃 TODO: Load from file (`priv/static/quests/*.json`) or database
    [
      %{id: "quest_1", name: "Slay 10 Rats", conditions: %{kills: %{"rat" => 10}}},
      %{id: "quest_2", name: "Deliver Package", conditions: %{location: "zone_2"}}
    ]
  end

  @spec get_quest(quest_id()) :: quest() | nil
  def get_quest(id),
    do: Enum.find(list_all_quests(), &(&1.id == id))

  @spec check_completion?(quest(), player_state()) :: boolean()
  def check_completion?(%{conditions: conditions}, state) do
    Enum.all?(conditions, fn
      {:kills, reqs} ->
        Enum.all?(reqs, fn {mob, count} ->
          Map.get(state.kills, mob, 0) >= count
        end)

      {:location, expected} ->
        state.location == expected

      {:flag, {key, expected}} ->
        Map.get(state.quest_flags, key) == expected

      _ ->
        false
    end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Quest definitions are hardcoded
  #    - ❗ Future: load from JSON/YAML files or DB schema
  #
  # 2. `QuestState` not yet used to persist player progress
  #    - ✅ Integrate `QuestState` when implementing per-player tracking
  #
  # 3. Only supports basic `kills`, `location`, `flag` conditions
  #    - 🔄 Optional: extend to `item`, `dialogue`, `time`, `custom_condition/1` callbacks
  #
  # 4. No quest tiers, branches, or rewards implemented
  #    - ❗ Required: define reward schemas and completion hooks

end
