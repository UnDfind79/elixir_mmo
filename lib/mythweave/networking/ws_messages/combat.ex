defmodule Mythweave.Networking.WSMessages.Combat do
  @moduledoc """
  Routes generic combat actions.
  """

  defstruct [:action, :target_id]

  def handle(%__MODULE__{action: "attack", target_id: tid}, pid) do
    Mythweave.Networking.WSMessages.Attack.handle(%{__struct__: Mythweave.Networking.WSMessages.Attack, target_id: tid}, pid)
  end

  def handle(_, _), do: {:error, :unsupported_combat_action}

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Hardcoded dispatch only supports "attack"
  #    - 🚧 Add dynamic routing for other combat actions (e.g., block, flee, skill)
  #
  # 2. Struct creation for Attack is verbose and brittle
  #    - ✅ Refactor with helper or protocol dispatch
  #
  # 3. No validation on action or target_id
  #    - ❗ Add guards and preflight checks
end
