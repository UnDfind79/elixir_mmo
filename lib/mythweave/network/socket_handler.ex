defmodule Mythweave.Network.SocketHandler do
  @moduledoc """
  Entry point for each player connection.

  Responsibilities:
    - Receive raw data from client
    - Decode and route messages
    - Handle disconnection and session teardown
  """

  use GenServer

  alias Mythweave.Network.Packet
  alias Mythweave.Network.MessageRouter

  @spec start_link(any()) :: GenServer.on_start()
  def start_link(socket_pid), do: GenServer.start_link(__MODULE__, socket_pid)

  @impl true
  def init(socket_pid) do
    {:ok, socket_pid}
  end

  @impl true
  def handle_info({:recv, binary}, socket_pid) do
    {opcode, payload} = Packet.decode(binary)
    MessageRouter.route(socket_pid, opcode, payload)
    {:noreply, socket_pid}
  end

  def handle_info(:disconnect, socket_pid) do
    Process.exit(socket_pid, :normal)
    {:stop, :normal, socket_pid}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No encryption or authentication layer
  #    - ✅ Add pre-auth state to init phase
  #
  # 2. No connection-level metrics or ping tracking
  #    - 🚧 Track round-trip latency for client stats
  #
  # 3. No crash recovery
  #    - ❗ Add supervision and restart backoff logic

end
