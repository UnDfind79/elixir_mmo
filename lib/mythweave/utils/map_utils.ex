defmodule Mythweave.Utils.MapUtils do
  @moduledoc """
  Provides helper functions for deep merging, extraction, and filtering of maps.

  Responsibilities:
    - Simplify recursive map operations
    - Provide partial filtering and difference detection
    - Wrap common Map-related tasks
  """

  @spec deep_merge(map(), map()) :: map()
  def deep_merge(map1, map2) do
    Map.merge(map1, map2, fn _key, v1, v2 ->
      if is_map(v1) and is_map(v2), do: deep_merge(v1, v2), else: v2
    end)
  end

  @spec select_keys(map(), [any()]) :: map()
  def select_keys(map, keys), do: Map.take(map, keys)

  @spec diff(map(), map()) :: map()
  def diff(map1, map2) do
    Enum.reduce(map1, %{}, fn {k, v}, acc ->
      if Map.get(map2, k) != v, do: Map.put(acc, k, v), else: acc
    end)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No recursive diff
  #    - ✅ Add optional deep diff if needed
  #
  # 2. No map flattening tools
  #    - 🚧 Add flatten/unflatten helpers
  #
  # 3. No schema-aware filters
  #    - ❗ Add plug-in schema filtering for safe serialization

end
