defmodule Mythweave.ClassSchema.ThreadHash do
  @moduledoc """
  Generates a stable, canonical hash from a thread set defining an ability.

  Responsibilities:
    - Deterministically serialize `essence`, `form`, and `modifier`
    - Output a reproducible SHA-256 hash for caching and lookup
    - Enable reverse ability traceability from hash in HUD/logs
  """

  @type thread :: String.t()
  @type thread_set :: %{essence: thread(), form: thread(), modifier: thread()}
  @type hash :: String.t()

  @separator "|"

  @doc """
  Computes a lowercase base16 SHA256 hash from a thread set.

  ## Example

      iex> hash(%{essence: "fire", form: "nova", modifier: "lingering"})
      "34e1b3dff32a3b08..."

  Returns the hash as a lowercase string.
  """
  @spec hash(thread_set()) :: hash()
  def hash(%{essence: e, form: f, modifier: m}) do
    [e, f, m]
    |> Enum.join(@separator)
    |> then(&:crypto.hash(:sha256, &1))
    |> Base.encode16(case: :lower)
  end

  @doc """
  Validates that all required keys are present and string-typed.
  """
  @spec valid_thread_set?(map()) :: boolean()
  def valid_thread_set?(%{essence: e, form: f, modifier: m})
      when is_binary(e) and is_binary(f) and is_binary(m), do: true

  def valid_thread_set?(_), do: false

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. Thread order is fixed and must remain stable
  #    - ✅ Prevents key collisions from unordered inputs
  #
  # 2. No reverse lookup (hash → thread metadata)
  #    - 🚧 Consider ETS or GenServer cache if needed
  #
  # 3. No versioning or schema scoping
  #    - ❗ Add optional prefix for thread versioning to prevent future breakage
end
