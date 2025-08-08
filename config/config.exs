# config/config.exs
import Config

config :logger, level: :info

# App-specific defaults (overridden in tests by test_helper or config/test.exs)
config :mythweave,
  world_dir: "test_world"
