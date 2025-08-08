ExUnit.start()

# Ensure deterministic RNG in tests that rely on :rand
:rand.seed(:exsplus, {101, 202, 303})

# Point the app at the bundled test world by default (if app env is used).
Application.put_env(:mythweave, :world_dir, "test_world")
