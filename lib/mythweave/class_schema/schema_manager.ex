defmodule Mythweave.ClassSchema.SchemaManager do
  @moduledoc """
  Manages player schema sets, enabling slot switching and augment control.

  Responsibilities:
    - Track active schema per player
    - Allow switching between stored schema profiles
    - Provide lookup for thread sets by active schema
  """

  alias Mythweave.ClassSchema.SchemaLoader
  alias Mythweave.UI.MessageDispatcher

  @type player_id :: String.t()
  @type schema_id :: String.t()
  @type schema :: map()

  use GenServer

  # -------------------------
  # 🎮 Public API
  # -------------------------

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec load_schema(player_id(), schema_id()) :: :ok | {:error, any()}
  def load_schema(player_id, schema_id) do
    GenServer.call(__MODULE__, {:load, player_id, schema_id})
  end

  @spec get_schema(player_id()) :: {:ok, schema()} | {:error, :not_loaded}
  def get_schema(player_id) do
    GenServer.call(__MODULE__, {:get, player_id})
  end

  @spec get_threads(player_id()) :: {:ok, map()} | {:error, :not_loaded}
  def get_threads(player_id) do
    with {:ok, schema} <- get_schema(player_id) do
      {:ok, Map.take(schema, ["essence", "form", "modifier"])}
    end
  end

  # -------------------------
  # 🧠 GenServer Callbacks
  # -------------------------

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:load, player_id, schema_id}, _from, state) do
    case SchemaLoader.load(schema_id) do
      {:ok, schema} ->
        MessageDispatcher.send(player_id, %{
          text: "Schema equipped: #{schema_id}",
          category: :system
        })

        {:reply, :ok, Map.put(state, player_id, schema)}

      {:error, reason} ->
        MessageDispatcher.notify_error(player_id, "Schema load failed: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:get, player_id}, _from, state) do
    case Map.get(state, player_id) do
      nil -> {:reply, {:error, :not_loaded}, state}
      schema -> {:reply, {:ok, schema}, state}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No per-player slot memory (e.g., primary/secondary/tertiary)
  #    - ✅ Add named slot map with active pointer
  #
  # 2. Schemas are transient — no persistence on reboot
  #    - 🚧 Add save/load to ETS or disk cache
  #
  # 3. No augment update or socket editing tools
  #    - ❗ Add mutate/replace logic for runtime editing

end
