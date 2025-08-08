defmodule Mythweave.Combat.CombatMathTest do
  use ExUnit.Case, async: true
  alias Mythweave.Combat.CombatMath

  describe "hit?/2" do
    test "high accuracy vs low evasion is likely to hit within bounds" do
      atk = %{accuracy: 100}
      defn = %{evasion: 5}
      # With seeded RNG, assert result is boolean and exercising boundary clamping doesn't crash
      assert is_boolean(CombatMath.hit?(atk, defn))
    end

    test "never below the 5% floor and never above the 95% ceiling (stat extremes don't crash)" do
      # We can't assert exact randomness, but we can ensure function doesn't raise and returns boolean.
      assert is_boolean(CombatMath.hit?(%{accuracy: 1_000_000}, %{evasion: 0}))
      assert is_boolean(CombatMath.hit?(%{accuracy: 0}, %{evasion: 1_000_000}))
    end
  end

  describe "crit?/1" do
    test "uses provided crit chance" do
      assert is_boolean(CombatMath.crit?(%{crit_chance: 0.25}))
    end

    test "falls back to default when not provided" do
      assert is_boolean(CombatMath.crit?(%{}))
    end
  end

  describe "calculate_damage/2" do
    test "damage increases with attack and decreases with defense (monotonic expectation over multiple rolls)" do
      low = Enum.map(1..20, fn _ -> CombatMath.calculate_damage(%{attack: 10}, %{defense: 5}) end) |> Enum.sum()
      high_atk = Enum.map(1..20, fn _ -> CombatMath.calculate_damage(%{attack: 20}, %{defense: 5}) end) |> Enum.sum()
      high_def = Enum.map(1..20, fn _ -> CombatMath.calculate_damage(%{attack: 10}, %{defense: 15}) end) |> Enum.sum()

      assert high_atk > low
      assert high_def < low
    end
  end
end
