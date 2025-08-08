defmodule Mythweave.AI.BehaviorTree do
  @moduledoc """
  Behavior tree evaluation engine for NPC AI.

  Responsibilities:
    - Evaluate common behavior control nodes: `:sequence`, `:selector`, `:parallel`
    - Dispatch leaf tick modules dynamically
    - Compose complex behaviors from reusable building blocks
  """

  @type t ::
          {:sequence, [t()]}
          | {:selector, [t()]}
          | {:parallel, [t()], :fail_on_one | :succeed_on_one}
          | {module(), keyword()}
  @type result :: :success | :failure | :running
  @type context :: map()

  @spec evaluate(t(), context()) :: result()
  def evaluate({:sequence, nodes}, context) do
    Enum.reduce_while(nodes, context, fn node, ctx ->
      case evaluate(node, ctx) do
        :success -> {:cont, ctx}
        :running -> {:halt, :running}
        :failure -> {:halt, :failure}
      end
    end)
  end

  def evaluate({:selector, nodes}, context) do
    Enum.reduce_while(nodes, context, fn node, ctx ->
      case evaluate(node, ctx) do
        :failure -> {:cont, ctx}
        :running -> {:halt, :running}
        :success -> {:halt, :success}
      end
    end)
  end

  def evaluate({:parallel, nodes, :fail_on_one}, context) do
    results = Enum.map(nodes, &evaluate(&1, context))

    cond do
      :failure in results -> :failure
      :running in results -> :running
      true -> :success
    end
  end

  def evaluate({:parallel, nodes, :succeed_on_one}, context) do
    results = Enum.map(nodes, &evaluate(&1, context))

    cond do
      :success in results -> :success
      :running in results -> :running
      true -> :failure
    end
  end

  def evaluate({module, opts}, context) when is_atom(module) do
    if Code.ensure_loaded?(module) and function_exported?(module, :tick, 2) do
      try do
        apply(module, :tick, [context, opts])
      rescue
        _ -> :failure
      end
    else
      :failure
    end
  end

  def evaluate(_unknown, _context), do: :failure

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Node formats aren't validated at compile time
  #    - ✅ Add optional DSL or macro-based tree compiler
  #
  # 2. No tick memoization or blackboard caching
  #    - 🚧 Add per-context working memory for AI routines
  #
  # 3. Leaf modules assumed to be crash-safe
  #    - ❗ Consider async isolation for long/unstable operations
end
