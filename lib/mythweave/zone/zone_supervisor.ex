defmodule Mythweave.Zone.ZoneSupervisor do
  @moduledoc """
  Dynamic supervisor responsible for managing all live zone servers.

  Each zone is started dynamically using its `zone_id`. The zone will:
    - Load its `.server.json` from disk
    - Initialize simulation state
    - Begin ticking and publishing events

  This supervisor ensures fault isolation across zones using `:one_for_one` strategy.
  """

  use DynamicSupervisor

  alias Mythweave.World.ZoneServer

  @type zone_id :: String.t()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(_init_arg),
    do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @spec start_zone(zone_id()) :: DynamicSupervisor.on_start_child()
  def start_zone(zone_id) do
    child_spec = {ZoneServer, zone_id}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @spec stop_zone(pid()) :: :ok | {:error, term()}
  def stop_zone(pid),
    do: DynamicSupervisor.terminate_child(__MODULE__, pid)

  # -----------------------------
  # Callbacks
  # -----------------------------

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Zone IDs are assumed to be globally unique
  #    - ✅ Ensure name registration via Registry to prevent duplicates
  #
  # 2. No lifecycle hooks for graceful shutdowns or transfers
  #    - ❗ Future: emit events on zone start/stop for metrics/logging
  #
  # 3. No support for preloading zones at boot or delayed spawning
  #    - 🔄 Optional: implement preload list or dynamic load-on-demand logic
  #
  # 4. Does not track which zones are currently active
  #    - ❗ Future: introduce Registry or ETS-based live zone tracker

end
