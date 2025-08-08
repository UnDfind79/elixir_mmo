# 💬 Elixir MMORPG – Chat Relay Engine

## 📌 Purpose
This module defines the chat relay system for the Elixir MMORPG server, enabling real-time, channel-based communication between players. Built on top of Elixir's process-oriented architecture and leveraging GenServer and PubSub for scalability and fault-tolerance, it supports global, zone, and party-level chats.

---

## 📁 Module Overview

| Component         | Type        | Responsibility                                  |
|------------------|-------------|--------------------------------------------------|
| `ChatRelay`       | GenServer   | Main process handling message intake and routing |
| `ChatEvent`       | Struct      | Represents formatted chat data                   |
| `ChatPubSub`      | PubSub      | Delivers messages to subscribed client handlers  |

---

## ⚙️ GenServer Initialization

```elixir
def start_link(_opts) do
  GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
end
```

- Initializes empty state or prepares channel metadata.

---

## 📤 Public API

### `send_message/3`
```elixir
@spec send_message(String.t(), String.t(), atom()) :: :ok
def send_message(sender, message, channel \\ :global)
```

- Formats and routes a chat message to subscribers based on channel.
- Supported channels: `:global`, `:zone`, `:party`, `:whisper`.

### `subscribe/2`
```elixir
@spec subscribe(pid(), atom()) :: :ok
def subscribe(pid, channel)
```

- Allows a process (typically a player session) to listen to messages on a given channel.

### `unsubscribe/2`
```elixir
@spec unsubscribe(pid(), atom()) :: :ok
def unsubscribe(pid, channel)
```

- Removes the process from channel broadcast list.

---

## 📦 ChatEvent Struct

```elixir
defmodule ChatEvent do
  defstruct [:sender, :message, :channel, :timestamp]
end
```

- Wraps metadata around a raw message.
- Timestamp is assigned at creation.

---

## 🔁 GenServer Callbacks

### `_on_chat_event/2`

Handles incoming messages and relays them via PubSub.

```elixir
def handle_cast({:chat_event, %ChatEvent{} = event}, state) do
  Phoenix.PubSub.broadcast(ChatPubSub, topic(event.channel), {:new_chat, event})
  {:noreply, state}
end
```

---

## 💬 Whisper and Global Support

```elixir
def send_whisper(from, to, message) do
  # Sends message directly to a named PID or session
end

def send_global(sender, message) do
  send_message(sender, message, :global)
end
```

---

## 🔄 Interaction Flow

1. Player sends input to client.
2. WebSocket handler invokes `ChatRelay.send_message/3`.
3. Message is cast into a `ChatEvent` and sent to relevant subscribers via `Phoenix.PubSub`.

---

## 🔐 Moderation Hooks

Pluggable interceptors (via dispatcher or message middleware) can:

- Sanitize text
- Filter spam or banned phrases
- Rate-limit per player or IP

---

## 🧪 Testing

- Unit tests exist under `test/chat_relay_test.exs`
- Tests validate relay delivery, channel subscriptions, and edge cases

---

## ✅ Summary

The Elixir `ChatRelay` system is a channel-driven messaging backbone built for concurrency and responsiveness. It enables efficient multiplayer communication and is built to support future expansions like emoji reactions, NPC messages, or AI-based moderation.
