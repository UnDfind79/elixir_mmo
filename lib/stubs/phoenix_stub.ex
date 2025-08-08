defmodule Phoenix.Socket do
  @moduledoc """
  Minimal stub for Phoenix.Socket to support assignment of values in tests/dev.
  """

  defstruct assigns: %{}, id: nil, topic: nil

  @spec assign(map() | %__MODULE__{}, atom(), any()) :: map()
  def assign(%__MODULE__{} = socket, key, value) when is_atom(key) do
    %{socket | assigns: Map.put(socket.assigns, key, value)}
  end

  def assign(%{} = socket, key, value) when is_atom(key) do
    Map.update(socket, :assigns, %{key => value}, &Map.put(&1, key, value))
  end
end

defmodule Phoenix.Channel do
  @moduledoc """
  Minimal stub for `use Phoenix.Channel` to allow modules to compile.
  These functions are *not* production-capable; they just provide scaffolding.
  """

  defmacro __using__(_opts) do
    quote do
      @behaviour Phoenix.Channel
      def join(_topic, _payload, socket), do: {:ok, socket}
      def handle_in(_event, _payload, socket), do: {:noreply, socket}
      def terminate(_reason, _socket), do: :ok
    end
  end

  @callback join(binary(), map(), any()) :: any()
  @callback handle_in(binary(), map(), any()) :: any()
  @callback terminate(any(), any()) :: any()
end
