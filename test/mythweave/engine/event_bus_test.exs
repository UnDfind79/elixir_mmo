defmodule Mythweave.Engine.EventBusTest do
  use ExUnit.Case, async: false  # uses local Registry

  alias Mythweave.Engine.EventBus

  setup do
    {:ok, _pid} = EventBus.start_link(nil)
    :ok
  end

  test "subscribe and broadcast delivers message" do
    topic = :test_topic
    {:ok, _} = EventBus.subscribe(topic)
    EventBus.broadcast(topic, %{hello: :world})
    assert_receive {:event, ^topic, %{hello: :world}}, 100
  end
end
