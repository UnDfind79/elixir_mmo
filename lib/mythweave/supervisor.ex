defmodule Mythweave.Supervisor do
  @moduledoc """
  Root-level supervisor for game systems and registries.

  Responsibilities:
    - Start and monitor all global services
    - Structure domain-level supervisors
    - Ensure fault isolation across components
  """

  use Supervisor

  @impl true
  def start_link(_args), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl true
  def init(:ok) do
    children = [
      Mythweave.Registry.ZoneRegistry,
      Mythweave.Telemetry,
      Mythweave.Monitoring.ServerMonitor
      # Add more here: PlayerSupervisor, WorldManager, etc.
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Flat supervision tree
  #    - ✅ Refactor into domain-specific trees (e.g. EngineSupervisor)
  #
  # 2. No dynamic supervision
  #    - 🚧 Add DynamicSupervisor for zones, instances
  #
  # 3. No start/stop hooks
  #    - ❗ Add boot diagnostics or telemetry emitters

end
