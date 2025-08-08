defmodule Mythweave.Zone.MSIDManager do
  @moduledoc """
  Manages instanced dungeons and mission-triggered zone spawns.

  Responsibilities:
    - Spawn private zone instances for players or groups
    - Register and supervise dynamic ZoneServer processes
    - Tear down instances after timeout or completion
  """

  use GenServer

  alias Mythweave.Zone.{ZoneServer, ZoneRegistry}
  alias Mythweave.Constants

  @type instance_id :: String.t()
  @type zone_template :: String.t()
  @type player_id :: String.t()
  @type coord :: {integer(), integer()}
  @type layer :: non_neg_integer()

  @timeout_ms 1000 * 60 * 30  # 30 minutes

  # -------------------------
  # ✅ Public API
  # -------------------------

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  @spec spawn_instance(zone_template(), player_id()) :: {:ok, instance_id()}
  def spawn_instance(template, owner_id) do
    GenServer.call(__MODULE__, {:spawn_instance, template, owner_id})
  end

  # -------------------------
  # 🚀 GenServer Callbacks
  # -------------------------

  @impl true
  def init(_), do: {:ok, %{}}

  @impl true
  def handle_call({:spawn_instance, template, owner_id}, _from, state) do
    instance_id = generate_instance_id(template, owner_id)

    ZoneRegistry.register(instance_id)

    {:ok, _pid} = ZoneServer.start_link(%{
      id: instance_id,
      template: template,
      instanced: true,
      owner_id: owner_id
    })

    # Schedule cleanup
    Process.send_after(self(), {:cleanup, instance_id}, @timeout_ms)

    {:reply, {:ok, instance_id}, Map.put(state, instance_id, :active)}
  end

  @impl true
  def handle_info({:cleanup, instance_id}, state) do
    ZoneServer.stop(instance_id)
    ZoneRegistry.unregister(instance_id)
    {:noreply, Map.delete(state, instance_id)}
  end

  # -------------------------
  # 🔧 Internal Helpers
  # -------------------------

  defp generate_instance_id(template, owner_id) do
    "inst_#{template}_#{owner_id}_#{:erlang.unique_integer([:positive])}"
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No persistence or reuse of instances
  #    - ✅ Add tracking for group-specific runs
  #
  # 2. Cleanup is silent
  #    - 🚧 Notify players if instance expires
  #
  # 3. No validation of template
  #    - ❗ Check if template is valid zone
end
