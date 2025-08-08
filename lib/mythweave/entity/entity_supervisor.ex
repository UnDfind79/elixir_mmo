defmodule Mythweave.EntitySupervisor do
  @moduledoc """
  Dynamic supervisor responsible for all runtime game entity processes.

  Manages:
    - NPC servers
    - Player servers
    - Props, portals, triggers (if modeled as processes)

  Strategy:
    - Uses `:one_for_one` to isolate faults to single entities
  """

  use DynamicSupervisor

  require Logger

  @type entity_module :: module()
  @type entity_args :: term()
  @type entity_ref :: {:ok, pid()} | {:error, term()}

  @spec start_link(any()) :: Supervisor.on_start()
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Logger.info("[EntitySupervisor] Initialized with :one_for_one strategy")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a runtime entity process under supervision.

  Arguments:
    - `mod`: A module implementing `start_link/1`
    - `args`: The args passed to `start_link/1`
  """
  @spec start_entity(entity_module(), entity_args()) :: entity_ref()
  def start_entity(mod, args) when is_atom(mod) do
    spec = %{
      id: {mod, make_ref()},
      start: {mod, :start_link, [args]},
      restart: :transient,
      shutdown: 5_000,
      type: :worker
    }

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} ->
        Logger.debug("[EntitySupervisor] Started entity #{inspect mod} at #{inspect pid}")
        {:ok, pid}

      error ->
        Logger.error("[EntitySupervisor] Failed to start entity #{inspect mod}: #{inspect error}")
        error
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No registry or PID tagging for lookup
  #    - ✅ Add named via Registry or ETS to support shutdown, messaging
  #
  # 2. No telemetry hooks
  #    - 📊 Consider `:telemetry.execute` on entity start/stop
  #
  # 3. Cleanup logic for persisting final entity state on crash
  #    - ❗ Requires integration with entity termination callbacks

end
