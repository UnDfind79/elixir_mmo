defmodule Mythweave.AI.Nodes.Seek do
  @moduledoc """
  AI node that moves an NPC one step toward a known target position.

  Responsibilities:
    - Calculate directional step toward target
    - Avoid unwalkable terrain or invalid moves
    - Return `:running` while in motion, `:success` on arrival
  """

  alias Mythweave.NPC.NPCServer
  alias Mythweave.World.ZoneServer
  alias Mythweave.Utils.Vector

  @type context :: %{
          npc_id: String.t(),
          zone_id: String.t(),
          position: {integer(), integer()},
          target: {integer(), integer()}
        }

  @spec tick(context(), keyword()) :: :success | :running | :failure
  def tick(%{npc_id: npc_id, target: target, position: pos, zone_id: zone_id}, _opts)
      when is_tuple(target) and is_tuple(pos) do
    if pos == target do
      :success
    else
      case next_step_toward(pos, target) do
        {:ok, new_pos} ->
          if ZoneServer.walkable?(zone_id, new_pos) do
            case NPCServer.move(npc_id, new_pos, zone_id) do
              :ok -> :running
              _ -> :failure
            end
          else
            :failure
          end

        :invalid ->
          :failure
      end
    end
  end

  def tick(_, _), do: :failure

  @spec next_step_toward({integer(), integer()}, {integer(), integer()}) ::
          {:ok, {integer(), integer()}} | :invalid
  defp next_step_toward({x1, y1}, {x2, y2}) do
    dx = Integer.sign(x2 - x1)
    dy = Integer.sign(y2 - y1)

    if dx == 0 and dy == 0 do
      :invalid
    else
      {:ok, {x1 + dx, y1 + dy}}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Movement is naïve cardinal only
  #    - ✅ Add diagonal logic or weighted scoring in future
  #
  # 2. No obstacle memory
  #    - 🚧 Use path memory or navmesh to avoid failed paths
  #
  # 3. No threat re-evaluation
  #    - ❗ Consider abandoning target if unreachable after retries
end
