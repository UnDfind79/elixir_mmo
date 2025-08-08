defmodule Mythweave.Network.Packet do
  @moduledoc """
  Encodes and decodes binary messages between client and server.

  Responsibilities:
    - Translate Elixir structs or maps into compact binaries
    - Support JSON, MsgPack, or raw binaries
    - Attach opcodes and length headers for framing
  """

  alias Mythweave.Network.Protocol.Opcodes

  @spec encode(atom(), map()) :: binary()
  def encode(opcode_sym, payload) do
    opcode = Opcodes.encode(opcode_sym)
    body = Jason.encode!(payload)
    <<opcode::8, body::binary>>
  end

  @spec decode(binary()) :: {integer(), map()}
  def decode(<<opcode::8, rest::binary>>) do
    {:ok, decoded} = Jason.decode(rest)
    {opcode, decoded}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Hardcoded JSON encoding
  #    - ✅ Add compression (e.g., zlib) or MsgPack option
  #
  # 2. No length framing for streaming protocols
  #    - 🚧 Use <<len::16, opcode::8, body::binary>> format
  #
  # 3. No error handling on bad decode
  #    - ❗ Add try/catch + telemetry

end
