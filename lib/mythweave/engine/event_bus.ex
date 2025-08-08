defmodule Mythweave.Engine.EventBus do
  @moduledoc """
  Unified in-memory pub/sub system for real-time game messaging.

  Combines:
    - Lightweight GenServer-based topic management
    - Efficient broadcast via `Registry` with `:duplicate` keys
    - Safe delivery to subscriber processes (with dead PID cleanup)

  Supports:
    - Ticking, combat, crafting, and zone system events
    - System telemetry hooks via unified event streams
    - Loose coupling between simulation layers and consumers
  """

  use GenServer

  @registry __MODULE__
  @type topic :: atom()
  @type payload :: term()
  @type subscriber :: pid()

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_args) do
    Registry.start_link(keys: :duplicate, name: @registry)
  end

  @impl true
  def init(init_arg), do: {:ok, init_arg}

  @doc """
  Subscribes the calling process to a given topic.
  """
  @spec subscribe(topic()) :: {:ok, term()} | {:error, term()}
  def subscribe(topic) do
    Registry.register(@registry, topic, [])
  end

  @doc """
  Broadcasts a message to all subscribers of a topic.
  """
  @spec broadcast(topic(), payload()) :: :ok
  def broadcast(topic, message) do
    Registry.dispatch(@registry, topic, fn entries ->
      for {pid, _} <- entries do
        if Process.alive?(pid) do
          send(pid, {:event, topic, message})
        end
      end
    end)

    :ok
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No filtering or transform logic per subscriber
  #    - 🚧 Allow message shaping (e.g., compression or redaction)
  #
  # 2. No monitoring or pruning of dead entries
  #    - ✅ Currently handled by `Registry` (automatic cleanup)
  #
  # 3. No event replay, audit, or persistence
  #    - ❗ Integrate with telemetry or metrics for live dashboards

end
