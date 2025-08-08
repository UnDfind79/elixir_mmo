defmodule Mythweave.Network.Protocol.Opcodes do
  @moduledoc """
  Maps symbolic message names to numeric opcodes for networking efficiency.

  Responsibilities:
    - Define all inbound and outbound client-server messages
    - Provide encoding and reverse decoding functions
    - Optimize transmission via compact codes
  """

  @opcode_map %{
    # Client → Server
    auth: 1,
    move: 2,
    cast: 3,
    chat: 4,
    inspect: 5,

    # Server → Client
    update: 100,
    teleport: 101,
    effect: 102,
    message: 103,
    entity_spawn: 104
  }

  @reverse_map Map.new(@opcode_map, fn {k, v} -> {v, k} end)

  @spec encode(atom()) :: integer()
  def encode(symbol) do
    Map.get(@opcode_map, symbol, -1)
  end

  @spec decode(integer()) :: atom()
  def decode(code) do
    Map.get(@reverse_map, code, :unknown)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Opcode list is hardcoded
  #    - ✅ Consider loading from JSON schema or registry file
  #
  # 2. No support for optional versioning or compression flags
  #    - 🚧 Add bitmask extensions for protocol evolution
  #
  # 3. `:unknown` is used for decoding errors
  #    - ❗ Add error telemetry for tracking invalid packets

end
