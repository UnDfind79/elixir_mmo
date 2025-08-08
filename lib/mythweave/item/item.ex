defmodule Mythweave.Item.Item do
  @moduledoc """
  Runtime item instance used across inventory, equipment, drops, and crafting.

  Combines static template reference with per-instance metadata.

  Responsibilities:
    - Maintain unique runtime identity and stack behavior
    - Support equip slots, augments, and modifiers
    - Allow schema-backed metadata (durability, rarity, rolls, etc)
  """

  @type item_type ::
          :consumable     # Usable items like potions
          | :equipment     # Armor, weapons, accessories
          | :augment       # Ability or equipment modifiers
          | :schema        # Ability slot templates
          | :ability       # Active/passive actions equippable into schemas
          | :misc          # Catch-all (e.g., crafting mats)

  @derive {Jason.Encoder, only: [:id, :template_id, :type, :slot, :effects, :stack_count, :augment_slots, :meta]}
  defstruct id: nil,
            template_id: nil,
            type: nil,
            slot: nil,
            effects: nil,
            stack_count: nil,
            augment_slots: nil,
            meta: %{}

  @type t :: %__MODULE__{
          id: String.t(),                         # Runtime unique ID
          template_id: String.t(),                # Static item definition key
          type: item_type() | nil,                # Resolved from template
          slot: atom() | nil,                     # Equipment slot (if any)
          effects: list(map()) | nil,             # Runtime effect definitions
          stack_count: non_neg_integer() | nil,   # Stack count (if stackable)
          augment_slots: non_neg_integer() | nil, # Number of sockets
          meta: map()                             # All override/custom data
        }

  @spec new(String.t(), map()) :: t()
  def new(template_id, overrides \\ %{}) do
    %__MODULE__{
      id: UUID.uuid4(),
      template_id: template_id,
      meta: overrides
    }
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation or template resolution
  #    - ✅ Add integration with ItemTemplate to populate `type`, `effects`, etc
  #
  # 2. Stackable vs unique logic not enforced
  #    - ❗ Respect stack rules during creation or merging
  #
  # 3. Meta is loose and untyped
  #    - 🔍 Consider schema validation from template or DSL

end
