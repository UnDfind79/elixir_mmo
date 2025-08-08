defmodule Mythweave.TestUtils.MockSocket do
  @moduledoc """
  Test helper module that simulates a player socket connection.

  Responsibilities:
    - Emulate socket PID for player session handling
    - Log or assert messages sent via `send/2`
    - Support inspection of outbound packets
  """

  use GenServer

  @type t :: pid()

  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(player_id), do: GenServer.start_link(__MODULE__, player_id, name: via(player_id))

  defp via(player_id), do: {:via, Registry, {Mythweave.Player.Registry, player_id}}

  @impl true
  def init(player_id) do
    {:ok, %{player_id: player_id, inbox: []}}
  end

  @impl true
  def handle_info({:recv, message}, state) do
    # Simulates receiving a message from client
    {:noreply, update_in(state.inbox, &[message | &1])}
  end

  @impl true
  def handle_call(:inbox, _from, state), do: {:reply, Enum.reverse(state.inbox), state}

  # -------------------------
  # ✅ Public API
  # -------------------------

  @spec send_recv(t(), any()) :: :ok
  def send_recv(pid, message) do
    send(pid, {:recv, message})
    :ok
  end

  @spec get_inbox(t()) :: list()
  def get_inbox(pid) do
    GenServer.call(pid, :inbox)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Inbox is not capped
  #    - ✅ Add max limit to avoid memory overflow
  #
  # 2. No support for protocol framing
  #    - 🚧 Add encoding/decoding simulation with Packet module
  #
  # 3. No broadcast or error simulation
  #    - ❗ Add support for test hooks (disconnect, timeout, etc.)

end
