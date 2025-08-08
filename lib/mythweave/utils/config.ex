defmodule Mythweave.Utils.Config do
  @moduledoc """
  Centralized access to static configuration values and environment flags.

  Values are resolved in the following order:
    1. Application environment (`config/*.exs`)
    2. Default fallback from internal map
    3. Optional runtime overrides (planned)

  This module should be the only access point for retrieving project-wide
  constants and server flags.
  """

  @type config_key ::
          :tick_rate
          | :zone_size
          | :max_inventory
          | :world_dir
          | atom()

  @type config_value :: term()

  @defaults %{
    tick_rate: 100,
    zone_size: 64,
    max_inventory: 40
  }

  # -----------------------------
  # Public API
  # -----------------------------

  @spec get(config_key()) :: config_value()
  def get(key),
    do: Application.get_env(:mythweave, key, Map.get(@defaults, key))

  @spec env() :: :dev | :test | :prod
  def env(), do: Mix.env()

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No centralized validation of config values
  #    - ❗ Future: enforce type/shape constraints on loaded values
  #
  # 2. No support for runtime reload or dynamic override
  #    - 🔄 Optional: enable hot-reload or config override at runtime
  #
  # 3. No grouped configs or submodules
  #    - ❗ Future: split into logical sub-configs (e.g., `Config.Zone`, `Config.Player`)

end
