defmodule Mythweave.Player.Equipment do
  @moduledoc """
  Manages gear equipped by the player.

  Responsibilities:
    - Track equipped items per slot
    - Apply gear bonuses to combat stats
    - Validate item types and encumbrance
  """

  @default_slots ~w[head chest legs weapon trinket]a

  @type slot :: atom()
  @type item :: map()
  @type gear :: %{optional(slot()) => item()}

  @spec equip(gear(), slot(), item()) :: gear()
  def equip(gear, slot, item) when slot in @default_slots do
    Map.put(gear, slot, item)
  end

  @spec unequip(gear(), slot()) :: {item() | nil, gear()}
  def unequip(gear, slot) do
    {Map.get(gear, slot), Map.delete(gear, slot)}
  end

  @spec get_bonus(gear(), atom()) :: integer()
  def get_bonus(gear, stat) do
    gear
    |> Map.values()
    |> Enum.map(&Map.get(&1.meta, stat, 0))
    |> Enum.sum()
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation of item type for slot
  #    - ✅ Add tag system for item-slot compatibility
  #
  # 2. No encumbrance or weight handling
  #    - 🚧 Introduce total weight cap per player
  #
  # 3. No visual update or event broadcast
  #    - ❗ Add gear change hook for HUD refresh

end
