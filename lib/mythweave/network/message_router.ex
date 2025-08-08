defmodule Mythweave.Network.MessageRouter do
  @moduledoc """
  Routes incoming client messages to the appropriate system handlers.

  Responsibilities:
    - Decode message opcodes into symbolic handlers
    - Dispatch to zone, player, or global context
    - Ensure message safety and input validation
  """

  alias Mythweave.Network.Protocol.Opcodes
  alias Mythweave.Player.Session

  @spec route(pid(), integer(), map()) :: :ok | {:error, atom()}
  def route(socket_pid, opcode, payload) do
    case Opcodes.decode(opcode) do
      :move -> Session.handle_move(socket_pid, payload)
      :cast -> Session.handle_cast(socket_pid, payload)
      :chat -> Session.handle_chat(socket_pid, payload)
      :inspect -> Session.handle_inspect(socket_pid, payload)
      :auth -> Session.handle_auth(socket_pid, payload)
      :unknown -> {:error, :unknown_opcode}
    end
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Router assumes all socket pids map to valid sessions
  #    - ✅ Add session validation or fallback
  #
  # 2. No pre-decode schema validation
  #    - 🚧 Integrate input schema per opcode type
  #
  # 3. No flood protection
  #    - ❗ Add cooldowns or rate limiter

end
