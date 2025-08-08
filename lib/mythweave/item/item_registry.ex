defmodule Mythweave.Item.ItemRegistry do
  @moduledoc """
  Central registry for static item prototypes.

  Provides fast in-memory access to all static item definitions, including:
    - Equipment templates
    - Consumables
    - Schemas
    - Abilities
    - Augments

  Backed by ETS for high-performance lookup and safe cross-process access.
  """

  use GenServer

  @table :item_registry
  @item_path "priv/worlds/test_world/items/" # 💡 Make this configurable in the future

  @type item_id :: String.t()
  @type item_data :: map()

  # -----------------------------
  # Public API
  # -----------------------------

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec get(item_id()) :: item_data() | nil
  def get(id) when is_binary(id) do
    case :ets.lookup(@table, id) do
      [{^id, item}] -> item
      _ -> nil
    end
  end

  @spec reload() :: :ok | {:error, term()}
  def reload do
    GenServer.cast(__MODULE__, :reload)
  end

  # -----------------------------
  # Server Initialization
  # -----------------------------

  @impl true
  def init(_) do
    :ets.new(@table, [:named_table, :public, :set, read_concurrency: true])
    load_all_items()
    {:ok, %{}}
  end

  @impl true
  def handle_cast(:reload, state) do
    :ets.delete_all_objects(@table)
    load_all_items()
    {:noreply, state}
  end

  defp load_all_items do
    item_path = Path.expand(@item_path)

    case File.ls(item_path) do
      {:ok, files} ->
        files
        |> Enum.filter(&String.ends_with?(&1, ".json"))
        |> Enum.each(fn file ->
          path = Path.join(item_path, file)

          with {:ok, json} <- File.read(path),
               {:ok, data} <- Jason.decode(json),
               %{"id" => id} = item <- normalize_item(data) do
            :ets.insert(@table, {id, item})
          else
            error ->
              IO.warn("Failed to load item from #{file}: #{inspect(error)}")
          end
        end)

      {:error, reason} ->
        IO.warn("ItemRegistry could not read item directory: #{inspect(reason)}")
    end
  end

  defp normalize_item(data) do
    # Optional: perform runtime casting, key atomization, schema enforcement
    data
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No item schema enforcement yet
  #    - ❗ Use Mythweave.Inventory.ItemSchema.validate/1
  #
  # 2. Directory is hardcoded
  #    - ✅ Move to config for multi-world support
  #
  # 3. No diagnostics or loading stats
  #    - 📊 Emit metrics or logs for number of items loaded

end
