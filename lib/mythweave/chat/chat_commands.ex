defmodule Mythweave.Chat.ChatCommands do
  @moduledoc """
  Parses and dispatches slash commands from player chat input.

  Supported commands:
    - /help     — Shows help info
    - /roll     — Rolls a random number (1–100)
    - /emote    — Sends a local emote

  Uses `ChatService` for output. Extendable via `dispatch/3`.
  """

  alias Mythweave.Chat.ChatService

  @type player_id :: String.t()

  @spec parse(String.t(), player_id()) :: :handled | :unhandled
  def parse("/" <> command_string, player_id) do
    [cmd | args] = parse_args(command_string)
    dispatch(String.downcase(cmd), args, player_id)
    :handled
  end

  def parse(_, _), do: :unhandled

  @spec dispatch(String.t(), list(String.t()), player_id()) :: :ok
  defp dispatch("help", _args, player_id) do
    ChatService.send_system(player_id, """
    🧠 Commands available:
      /help         - Show this help message
      /roll         - Roll a number from 1–100
      /emote [msg]  - Perform an emote (e.g. /emote waves)
    """)
  end

  defp dispatch("roll", _args, player_id) do
    result = Enum.random(1..100)
    ChatService.send_local(player_id, "rolled a 🎲 #{result}")
  end

  defp dispatch("emote", [], player_id) do
    ChatService.send_system(player_id, "Usage: /emote [action]")
  end

  defp dispatch("emote", args, player_id) do
    text = Enum.join(args, " ") |> String.trim()
    ChatService.send_local(player_id, "* #{text}")
  end

  defp dispatch(_unknown, _args, player_id) do
    ChatService.send_system(player_id, "Unknown command. Type /help for options.")
  end

  defp parse_args(command_string) do
    command_string
    |> String.trim()
    |> String.split(~r/\s+/, trim: true)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No quote handling for multi-word arguments
  #    - ✅ Replace `String.split/1` with proper tokenizer if needed
  #
  # 2. Commands are static atoms
  #    - 🚧 Refactor to plug-in registry if commands grow
  #
  # 3. Emotes are unfiltered
  #    - ❗ Consider length or content restrictions
end
