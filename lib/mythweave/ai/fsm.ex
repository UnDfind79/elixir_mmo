defmodule Mythweave.AI.FSM do
  @moduledoc """
  Finite State Machine module for controlling AI entity behavior.

  Responsibilities:
    - Define and transition between AI states (idle, aggro, patrol, etc.)
    - Persist contextual metadata between ticks
    - Provide safe, validated state transitions for runtime logic
  """

  @type state :: :idle | :patrol | :aggro | :flee | :return
  @type context :: map()
  @type fsm :: %{state: state(), context: context()}

  @allowed_transitions %{
    idle: [:patrol, :aggro],
    patrol: [:idle, :aggro],
    aggro: [:flee, :return, :idle],
    flee: [:return, :idle],
    return: [:idle]
  }

  @doc """
  Initializes a new FSM in the given state with optional context.
  """
  @spec new(state(), context()) :: fsm()
  def new(state, context \\ %{}) when is_map(context) do
    %{state: state, context: context}
  end

  @doc """
  Safely transitions to a new FSM state, validating against allowed paths.
  """
  @spec transition(fsm(), state()) :: fsm()
  def transition(%{state: from, context: ctx} = fsm, to) do
    if valid_transition?(from, to) do
      %{fsm | state: to, context: ctx}
    else
      fsm
    end
  end

  @doc """
  Applies a function to modify the FSM's context map.
  """
  @spec update_context(fsm(), (context() -> context())) :: fsm()
  def update_context(%{context: ctx} = fsm, fun) when is_function(fun, 1) do
    %{fsm | context: fun.(ctx)}
  end

  @doc """
  Returns whether a transition is allowed from the current state.
  """
  @spec valid_transition?(state(), state()) :: boolean()
  def valid_transition?(from, to) do
    Map.get(@allowed_transitions, from, []) |> Enum.member?(to)
  end

  @doc """
  Peeks into the current FSM state and context.
  """
  @spec inspect(fsm()) :: String.t()
  def inspect(%{state: s, context: c}) do
    "[FSM #{s}] → #{Kernel.inspect(c)}"
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No time-based transition support
  #    - ✅ Store tick timestamps in context if needed
  #
  # 2. State loop logic is external to this module
  #    - 🚧 Consider a `tick/1` callback pattern or behavior
  #
  # 3. Context is raw map only
  #    - ❗ Refactor to struct for type guarantees per state
end
