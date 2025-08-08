defmodule Mythweave.Networking.WSMessages.CreateCharacter do
  @moduledoc """
  Creates a new character for a player.
  """

  defstruct [:name, :class]

  alias Mythweave.Player.PlayerState

  def handle(%__MODULE__{name: name, class: class}, player_id) do
    PlayerState.create_character(player_id, name, class)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No validation on character name or class
  #    - ❗ Enforce naming rules, profanity filter, and class whitelist
  #
  # 2. No check for character slot limits per account
  #    - 🚧 Query account metadata to limit max characters
  #
  # 3. Returns raw PlayerState result
  #    - ✅ Wrap in standardized response format for WS consumers
end
