defmodule Mythweave.Utils.Vector do
  @moduledoc """
  Provides 2D vector math utilities for movement, distance, direction, and basic geometry.

  Used in:
    - Movement systems
    - Collision detection
    - Pathfinding and AI steering
    - Prop and entity placement

  All vectors are tuples of `{x, y}` coordinates, using float-compatible math.
  """

  @type t :: {number(), number()}

  # -----------------------------
  # Basic Vector Operations
  # -----------------------------

  @spec add(t(), t()) :: t()
  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  @spec subtract(t(), t()) :: t()
  def subtract({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}

  @spec scale(t(), number()) :: t()
  def scale({x, y}, scalar), do: {x * scalar, y * scalar}

  # -----------------------------
  # Distance & Normalization
  # -----------------------------

  @spec distance(t(), t()) :: float()
  def distance({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end

  @spec normalize(t()) :: t()
  def normalize({0, 0}), do: {0, 0}

  def normalize({x, y}) do
    length = :math.sqrt(x * x + y * y)
    {x / length, y / length}
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No angle-based direction or orientation functions
  #    - ❗ Future: add `angle/2`, `direction_vector(angle)`
  #
  # 2. No dot product or projection helpers
  #    - 🔄 Optional: implement `dot/2`, `project/2` for advanced geometry
  #
  # 3. No clamping or bounding logic
  #    - ❗ Needed for collision or movement boundary systems
  #
  # 4. Consider upgrading to `Mythweave.Math.Vec2` struct-based API for clarity
  #    - ✅ Current tuple form is lightweight, but has no tagged typing

end
