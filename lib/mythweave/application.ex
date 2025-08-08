defmodule Mythweave.Application do
  @moduledoc """
  OTP Application module. Boots the supervision tree and starts core services.
  """

  use Application

  def start(_type, _args) do
    children = [
      # Phoenix endpoint for WebSocket and HTTP
      MythweaveWeb.Endpoint,

      # Core supervisors
      {Registry, keys: :unique, name: Mythweave.PlayerRegistry},
      {Registry, keys: :unique, name: Mythweave.ZoneRegistry},

      Mythweave.Player.Supervisor,
      Mythweave.World.ZoneSupervisor,
      Mythweave.NPC.Supervisor,
      Mythweave.Persistence.Supervisor,

      # Supporting systems
      Mythweave.Engine.TickLoop,
      Mythweave.World.WorldLoader,
      Mythweave.State.WorldState,
      Mythweave.Engine.EventBus,

      # Metrics and telemetry
      Mythweave.Engine.Metrics
    ]

    opts = [strategy: :one_for_one, name: Mythweave.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MythweaveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
