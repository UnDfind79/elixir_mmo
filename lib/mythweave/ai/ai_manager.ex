defmodule Mythweave.AI.AIManager do
  @moduledoc """
  Central coordinator for NPC AI logic across all zones.

  Responsibilities:
    - Tick NPC processes globally or by zone
    - Filter NPCs by tag for targeted behavior
    - Emit tick completion signals via EventBus
  """

  alias Mythweave.NPC.NPCSupervisor
  alias Mythweave.Engine.EventBus
  alias Mythweave.Utils.Logger

  @timeout 50

  @type pid_ref :: pid()
  @type tag :: atom()
  @type zone_id :: String.t()

  @spec tick_all_npcs() :: :ok
  def tick_all_npcs do
    NPCSupervisor.list_all_npcs()
    |> Enum.each(&safe_tick/1)

    EventBus.publish(:npc_tick_completed, %{})
    :ok
  end

  @spec tick_npcs_in_zone(zone_id()) :: :ok
  def tick_npcs_in_zone(zone_id) do
    NPCSupervisor.list_npcs_in_zone(zone_id)
    |> Enum.each(&safe_tick/1)

    EventBus.publish(:npc_tick_zone_completed, %{zone: zone_id})
    :ok
  end

  @spec tick_npcs_by_tag(tag()) :: :ok
  def tick_npcs_by_tag(tag) do
    NPCSupervisor.list_all_npcs()
    |> Task.async_stream(
      fn pid -> maybe_tick_if_tagged(pid, tag) end,
      timeout: @timeout,
      on_timeout: :kill_task
    )
    |> Stream.run()

    :ok
  end

  # -------------------------
  # 🔧 Internal Helpers
  # -------------------------

  defp maybe_tick_if_tagged(pid, tag) do
    case GenServer.call(pid, {:has_tag?, tag}, @timeout) do
      true -> safe_tick(pid)
      _ -> :skip
    end
  catch
    _, _ -> :error
  end

  defp safe_tick(pid) do
    send(pid, :tick)
  rescue
    error -> Logger.warn("NPC tick failed", pid: inspect(pid), error: Exception.message(error))
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Tag lookup assumes each NPC answers `{:has_tag?, tag}`
  #    - ✅ Ensure tag support in `handle_call`
  #
  # 2. Uses `send` for ticking (no response expected)
  #    - 🚧 Consider callback-based model for smarter AI branching
  #
  # 3. No tick throttling
  #    - ❗ Introduce per-NPC cooldown metadata or distributed timer
end
