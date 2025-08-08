defmodule Mythweave.AI.Nodes.Wander do
  @moduledoc """
  AI node that causes an NPC to move randomly within its zone.

  Responsibilities:
    - Attempt movement to a random adjacent tile
    - Avoid impassable terrain via walkability check
    - Return `:success` on move, or `:failure` after retries
  """

  alias Mythweave.World.ZoneServer
  alias Mythweave.NPC.NPCServer
  alias Mythweave.Utils.Vector

  @max_attempts 5

  @type context :: %{
          npc_id: String.t(),
          zone_id: String.t()
        }

  @spec tick(context(), keyword()) :: :success | :failure | :running
  def tick(%{npc_id: npc_id, zone_id: zone_id}, _opts) do
    case NPCServer.position(npc_id) do
      {:ok, pos} -> try_random_moves(pos, zone_id, npc_id, @max_attempts)
      _ -> :failure
    end
  end

  defp try_random_moves(_pos, _zone_id, _npc_id, 0), do: :failure

  defp try_random_moves(pos, zone_id, npc_id, attempts_left) do
    new_pos = Vector.add(pos, random_adjacent())

    if ZoneServer.walkable?(zone_id, new_pos) do
      case NPCServer.move(npc_id, new_pos, zone_id) do
        :ok -> :success
        _ -> retry(pos, zone_id, npc_id, attempts_left)
      end
    else
      retry(pos, zone_id, npc_id, attempts_left)
    end
  end

  defp retry(pos, zone_id, npc_id, attempts_left),
    do: try_random_moves(pos, zone_id, npc_id, attempts_left - 1)

  defp random_adjacent do
    dx = Enum.random(-1..1)
    dy = Enum.random(-1..1)
    {dx, dy}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No wandering boundary constraints
  #    - ✅ Add leash radius or patrol bounds in future
  #
  # 2. Walkability only considers tiles
  #    - 🚧 Detect props or other entities blocking motion
  #
  # 3. Random movement could loop frequently
  #    - ❗ Consider backtracking avoidance memory in context
end
