defmodule Mythweave.Quest.QuestState do
  @moduledoc """
  Tracks and mutates the quest progress for an individual player.

  Each player's quest state is stored in a GenServer that manages:
    - Quest enrollment
    - Completion tracking
    - Quest metadata (e.g., timestamps, progress fields)

  Accessed via `QuestRegistry` and manipulated through cast/call interfaces.
  """

  use GenServer

  @type quest_id :: String.t()
  @type player_id :: String.t()
  @type status :: :in_progress | :completed

  @type quest_entry :: %{
          status: status(),
          inserted_at: DateTime.t(),
          progress: map()
        }

  @type state :: %{
          player_id: player_id(),
          quests: %{quest_id() => quest_entry()}
        }

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(player_id()) :: GenServer.on_start()
  def start_link(player_id) do
    GenServer.start_link(__MODULE__, %{player_id: player_id, quests: %{}}, name: via(player_id))
  end

  @spec add(player_id(), quest_id()) :: :ok
  def add(player_id, quest_id),
    do: GenServer.cast(via(player_id), {:add, quest_id})

  @spec complete(player_id(), quest_id()) :: :ok
  def complete(player_id, quest_id),
    do: GenServer.cast(via(player_id), {:complete, quest_id})

  @spec get_all(player_id()) :: map()
  def get_all(player_id),
    do: GenServer.call(via(player_id), :get)

  # -----------------------------
  # Internal Registry and Setup
  # -----------------------------

  defp via(pid),
    do: {:via, Registry, {Mythweave.QuestRegistry, pid}}

  @impl true
  def init(state), do: {:ok, state}

  # -----------------------------
  # Callbacks
  # -----------------------------

  @impl true
  def handle_call(:get, _from, state),
    do: {:reply, state.quests, state}

  @impl true
  def handle_cast({:add, quest_id}, state) do
    entry = %{
      status: :in_progress,
      inserted_at: DateTime.utc_now(),
      progress: %{}
    }

    updated = Map.put(state.quests, quest_id, entry)
    {:noreply, %{state | quests: updated}}
  end

  @impl true
  def handle_cast({:complete, quest_id}, state) do
    updated =
      Map.update(state.quests, quest_id, nil, fn quest ->
        %{quest | status: :completed}
      end)

    {:noreply, %{state | quests: updated}}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No persistence layer — state lost on disconnect
  #    - ❗ Required: persist to DB on exit or via snapshot
  #
  # 2. Progress tracking is a stub (`progress: %{}`)
  #    - 🔄 Optional: implement progress mutation (e.g., kill count updates)
  #
  # 3. No hooks for broadcasting quest updates to UI or logs
  #    - ❗ Future: emit `:quest_added`, `:quest_completed` events to EventBus

end
