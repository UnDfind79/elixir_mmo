defmodule Mythweave.Item.InventoryService do
  @moduledoc """
  Core logic for player-item interactions, including:

    - Using consumables (potions, scrolls)
    - Equipping gear (with slot + encumbrance checks)
    - Dropping/removing items
    - Stackable item logic

  Inventory logic is stateless and returns updated player maps.
  """

  alias Mythweave.Inventory.Item
  alias Mythweave.Combat.EffectPipeline

  @type player :: map()
  @type item_id :: String.t()
  @type result :: {:ok, player()} | {:error, atom()}

  # -----------------------------
  # Public API
  # -----------------------------

  @spec use_item(player(), item_id()) :: result()
  def use_item(%{inventory: inv} = player, item_id) do
    case Enum.find(inv, &(&1.id == item_id)) do
      nil ->
        {:error, :not_found}

      %Item{type: :consumable, effects: effects} = item ->
        case EffectPipeline.run(player.id, effects) do
          {:ok, _applied_effects} ->
            updated_inventory = consume_item(inv, item.id)
            {:ok, %{player | inventory: updated_inventory}}

          {:error, _reason} ->
            {:error, :effect_failed}
        end

      _ ->
        {:error, :not_usable}
    end
  end

  @spec drop_item(player(), item_id()) :: result()
  def drop_item(%{inventory: inv, zone_id: zone_id, position: pos} = player, item_id) do
    case Enum.find(inv, &(&1.id == item_id)) do
      nil ->
        {:error, :not_found}

      item ->
        Mythweave.World.Zone.spawn_item(zone_id, pos, item)
        new_inv = Enum.reject(inv, &(&1.id == item_id))
        {:ok, %{player | inventory: new_inv}}
    end
  end

  @spec equip_item(player(), item_id()) :: result()
  def equip_item(%{inventory: inv, equipment: eq} = player, item_id) do
    with %Item{type: :equipment, slot: slot} = item <- Enum.find(inv, &(&1.id == item_id)),
         true <- within_encumbrance?(player, item) do
      updated_player = %{
        player
        | equipment: Map.put(eq, slot, item),
          inventory: Enum.reject(inv, &(&1.id == item_id))
      }

      {:ok, updated_player}
    else
      nil -> {:error, :not_found}
      false -> {:error, :over_encumbered}
      _ -> {:error, :invalid_item}
    end
  end

  # -----------------------------
  # Private Logic
  # -----------------------------

  defp consume_item(inventory, item_id) do
    Enum.reduce(inventory, [], fn
      %Item{id: ^item_id, stack_count: count} = item, acc when count > 1 ->
        [%{item | stack_count: count - 1} | acc]

      %Item{id: ^item_id}, acc ->
        acc

      other, acc ->
        [other | acc]
    end)
    |> Enum.reverse()
  end

  defp within_encumbrance?(%{equipment: eq, stats: %{encumbrance: max}}, %Item{metadata: meta}) do
    added_weight = Map.get(meta, :encumbrance, 0)

    current_weight =
      eq
      |> Map.values()
      |> Enum.reduce(0, fn
        %Item{metadata: m}, acc -> acc + Map.get(m, :encumbrance, 0)
        _, acc -> acc
      end)

    current_weight + added_weight <= max
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Augment slot support
  #    - 🚧 Expand equipment system to track socketed gems/mods
  #
  # 2. Item ownership and permissions
  #    - 🔐 Validate item belongs to player and is in a usable state
  #
  # 3. Persistence
  #    - 💾 Dropped items should be persisted (ETS or DB) and visible in world state

end
