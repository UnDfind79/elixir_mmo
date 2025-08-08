defmodule Mythweave.UI.SystemMessage do
  @moduledoc """
  Provides standard formatting for in-game system messages.

  Responsibilities:
    - Generate messages for combat, loot, errors, events
    - Provide consistent structure for front-end rendering
    - Define categories for coloring, priority, or icons
  """

  @type t :: %{
          text: String.t(),
          category: :info | :warning | :error | :combat | :loot,
          timestamp: integer()
        }

  @spec build(String.t(), atom()) :: t()
  def build(text, category \\ :info) do
    %{
      text: text,
      category: category,
      timestamp: System.system_time(:second)
    }
  end

  @spec error(String.t()) :: t()
  def error(text), do: build("[ERROR] " <> text, :error)

  @spec combat(String.t()) :: t()
  def combat(text), do: build(text, :combat)

  @spec loot(String.t()) :: t()
  def loot(text), do: build(text, :loot)

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Timestamp format is epoch
  #    - ✅ Convert to client-local time during render
  #
  # 2. No localization or pluralization
  #    - 🚧 Integrate with i18n system
  #
  # 3. No severity/urgency flags for modal messages
  #    - ❗ Add field for client-side toast, overlay, or log

end
