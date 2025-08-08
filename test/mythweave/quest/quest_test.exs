defmodule Mythweave.Quest.QuestStateTest do
  use ExUnit.Case, async: true
  alias Mythweave.Quest.QuestState

  test "starting and completing a quest" do
    state = %{} |> QuestState.start("player-1", "starter_quest")
    assert state["starter_quest"].status == :in_progress

    state2 = QuestState.complete(state, "player-1", "starter_quest")
    assert state2["starter_quest"].status == :completed
  end
end

defmodule Mythweave.Quest.QuestServiceTest do
  use ExUnit.Case, async: false
  alias Mythweave.Quest.QuestService

  test "GenServer lifecycle" do
    {:ok, pid} = start_supervised(QuestService)
    assert Process.alive?(pid)
  end
end
