defmodule Mythweave.Progression.TalentTree do
  @moduledoc """
  Models talent/upgrade paths unlockable by XP or achievements.

  Responsibilities:
    - Track available and purchased nodes
    - Validate unlock conditions (tier, parent dependencies)
    - Integrate with XP currency module for unlock costs
  """

  @type tree :: map()
  @type node_id :: String.t()

  @spec unlocked?(tree(), node_id()) :: boolean()
  def unlocked?(tree, id), do: Map.get(tree, id, false)

  @spec unlock(tree(), node_id()) :: {:ok, tree()} | {:error, :already_unlocked}
  def unlock(tree, id) do
    if unlocked?(tree, id) do
      {:error, :already_unlocked}
    else
      {:ok, Map.put(tree, id, true)}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No dependency graph enforcement
  #    - ✅ Add tier and parent gating
  #
  # 2. No XP spend built-in (delegated to Currency.XP)
  #    - 🚧 Hook into unlock + XP transaction
  #
  # 3. No UI tree rendering or metadata storage
  #    - ❗ Add node data from schema JSON

end
