defmodule Mythweave.Engine.Metrics do
  @moduledoc """
  Centralized Telemetry interface for Mythweave subsystems.

  Supports:
    - Custom metric emission per event
    - Dynamic handler registration
    - Namespaced event conventions

  Use cases:
    - Combat logs
    - Zone tick durations
    - Socket connection metrics
    - Player state transitions
  """

  @default_prefix [:mythweave]

  @type event_name :: atom() | [atom()]
  @type measurements :: map()
  @type metadata :: map()
  @type handler_opts :: keyword()

  @doc """
  Emits a telemetry event under the Mythweave namespace.

  Example:
    emit_event(:zone_tick, %{duration: 32}, %{zone_id: "zone_1"})
  """
  @spec emit_event(event_name(), measurements(), metadata()) :: :ok
  def emit_event(event, measurements \\ %{}, metadata \\ %{}) do
    :telemetry.execute(normalize_event(event), measurements, metadata)
  end

  @doc """
  Attaches a handler module to a telemetry event.

  The handler module must implement:
    `handle_event(event_name, measurements, metadata, config)`
  """
  @spec attach_handler(event_name(), module(), handler_opts()) :: :ok | {:error, term()}
  def attach_handler(event, handler_mod, opts \\ []) do
    event_name = normalize_event(event)
    id = handler_id(event_name)

    :telemetry.attach(id, event_name, &handler_mod.handle_event/4, opts)
  end

  @doc """
  Detaches a telemetry handler from an event.
  """
  @spec detach_handler(event_name()) :: :ok
  def detach_handler(event) do
    :telemetry.detach(handler_id(normalize_event(event)))
  end

  @doc false
  defp normalize_event(event) when is_list(event), do: @default_prefix ++ event
  defp normalize_event(event) when is_atom(event), do: @default_prefix ++ [event]

  @doc false
  defp handler_id(event), do: Enum.join(event, ".") <> "_handler"

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No error logging on failed handler attach/detach
  #    - ❗ Consider adding log warnings for handler errors
  #
  # 2. No built-in common event definitions or docs
  #    - 🧩 Could define known metric schemas (e.g., :combat, :network, :db)
  #
  # 3. No buffer/retry for async processing
  #    - ✅ Acceptable for current needs; use robust external handlers for async
end
