defmodule MythweaveWeb.Endpoint do
  @moduledoc """
  Minimal stub Endpoint to satisfy supervision until a real web stack is added.
  This avoids bringing Phoenix/Plug into the dependency tree for now.
  """

  use GenServer

  @impl true
  def start_link(_args), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl true
  def init(:ok), do: {:ok, %{}}
end
