defmodule Mythweave.Entity do
  @moduledoc """
  Base representation of any in-world actor or object.

  Responsibilities:
    - Positioning in 2D zone space
    - Tracking ID, type, name, and zone
    - Holding dynamic stats and static metadata
    - Managing tags and state for runtime behaviors

  Used by:
    - Players
    - NPCs
    - Props, Portals, Triggers
  """

  @derive {Jason.Encoder, only: [:id, :type, :name, :position, :zone_id, :stats, :metadata, :tags, :state]}
  defstruct [
    :id,
    :type,       # :player | :npc | :prop | :portal | :trigger
    :name,
    :position,   # {x, y}
    :zone_id,
    stats: %{},
    metadata: %{},
    tags: MapSet.new(),
    state: %{}
  ]

  @type position :: {integer(), integer()}
  @type stat_map :: %{optional(atom()) => number()}
  @type metadata :: map()
  @type tag :: atom()

  @type t :: %__MODULE__{
          id: String.t(),
          type: atom(),
          name: String.t(),
          position: position(),
          zone_id: String.t(),
          stats: stat_map(),
          metadata: metadata(),
          tags: MapSet.t(tag()),
          state: map()
        }

  # -------------------------
  # ✅ CONSTRUCTOR
  # -------------------------

  @spec new(String.t(), atom(), String.t(), position(), String.t(), stat_map(), metadata()) :: t()
  def new(id, type, name, position, zone_id, stats \\ %{}, metadata \\ %{}) do
    %__MODULE__{
      id: id,
      type: type,
      name: name,
      position: position,
      zone_id: zone_id,
      stats: stats,
      metadata: metadata,
      tags: MapSet.new(),
      state: %{}
    }
  end

  # -------------------------
  # ✅ MUTATORS
  # -------------------------

  @spec move(t(), position()) :: t()
  def move(%__MODULE__{} = entity, {x, y}) when is_integer(x) and is_integer(y) do
    %{entity | position: {x, y}}
  end

  @spec tag(t(), tag()) :: t()
  def tag(%__MODULE__{} = entity, tag) when is_atom(tag) do
    %{entity | tags: MapSet.put(entity.tags, tag)}
  end

  @spec untag(t(), tag()) :: t()
  def untag(%__MODULE__{} = entity, tag) when is_atom(tag) do
    %{entity | tags: MapSet.delete(entity.tags, tag)}
  end

  @spec set_state(t(), map()) :: t()
  def set_state(%__MODULE__{} = entity, state) when is_map(state) do
    %{entity | state: state}
  end

  @spec get_stat(t(), atom()) :: number() | nil
  def get_stat(%__MODULE__{stats: stats}, key), do: Map.get(stats, key)

  @spec update_stat(t(), atom(), number()) :: t()
  def update_stat(%__MODULE__{} = entity, key, value) when is_number(value) do
    %{entity | stats: Map.put(entity.stats, key, value)}
  end

  # -------------------------
  # 🧩 FUTURE ENHANCEMENTS
  # -------------------------

  # - Add elevation/layer (e.g. {:x, :y, :z}) for vertical zone levels
  # - Separate persistent stats (max_hp) from runtime state (hp)
  # - Use metadata for schema associations, faction, AI profile, etc.
end
