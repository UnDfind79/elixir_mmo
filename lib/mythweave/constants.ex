defmodule Mythweave.Constants do
  @moduledoc """
  Centralized store for hardcoded game values, timeouts, and limits.

  Responsibilities:
    - Prevent magic numbers and repeated literals
    - Provide tuning-friendly structure
    - Enable shared access to critical values
  """

  @tick_rate 100
  @max_inventory_size 50
  @starting_zone "zone_elwyn"

  def tick_rate, do: @tick_rate
  def max_inventory_size, do: @max_inventory_size
  def starting_zone, do: @starting_zone

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Uses module attributes only
  #    - ✅ Move to config loader or database overrides
  #
  # 2. No grouping or namespacing
  #    - 🚧 Consider `Constants.Combat`, `Constants.Player`, etc.
  #
  # 3. Not hot-reloadable
  #    - ❗ Use ETS/cache layer for dynamic tuning in production

end
