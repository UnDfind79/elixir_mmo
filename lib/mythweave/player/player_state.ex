defmodule Mythweave.Player.PlayerState do
  @moduledoc """
  Represents the runtime simulation state of a player.

  This struct is used inside the `PlayerServer` process and is the canonical
  source of truth for:
    - Position and zone
    - Health and stats
    - Inventory and gold
    - Combat targeting
    - Experience and level tracking

  Use `new/1` to construct a player with merged defaults.
  """

  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :name,
    :zone_id,
    :position,
    :inventory,
    :stats,
    :target_id,
    :current_hp,
    :max_hp,
    :xp,
    :level,
    :gold
  ]

  @type stat_block :: %{
          optional(:attack) => number(),
          optional(:defense) => number(),
          optional(:speed) => number()
        }

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          zone_id: String.t(),
          position: {number(), number()},
          inventory: [map()],
          stats: stat_block(),
          target_id: String.t() | nil,
          current_hp: non_neg_integer(),
          max_hp: non_neg_integer(),
          xp: non_neg_integer(),
          level: pos_integer(),
          gold: non_neg_integer()
        }

  # -----------------------------
  # Constructor
  # -----------------------------

  @spec new(map()) :: t()
  def new(attrs) when is_map(attrs) do
    struct(__MODULE__, Map.merge(defaults(), attrs))
  end

  # -----------------------------
  # Defaults
  # -----------------------------

  defp defaults do
    %{
      zone_id: "zone_1",
      position: {0, 0},
      inventory: [],
      stats: %{},
      target_id: nil,
      current_hp: 100,
      max_hp: 100,
      xp: 0,
      level: 1,
      gold: 0
    }
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No derived fields (e.g., schema bonuses, augment effects)
  #    - ❗ Future: compute `effective_stats` from equipment/schema
  #
  # 2. `inventory` is untyped
  #    - 🔄 Optional: define and enforce structure of inventory items
  #
  # 3. No helper functions for combat or XP level-up logic
  #    - ❗ Future: add `take_damage/2`, `gain_xp/2`, etc.

end
