defmodule Mythweave.Utils.VectorTest do
  use ExUnit.Case, async: true
  alias Mythweave.Utils.Vector

  test "vector add/2 and dot/2 produce expected results" do
    assert Vector.add({1,2}, {3,4}) == {4,6}
    assert is_number(Vector.dot({1,2,3}, {4,5,6}))
  end
end
