defmodule Mythweave.Networking.WSMessages.Register do
  @moduledoc """
  Registers a new player account.

  Expects:
    - Email and password credentials

  Delegates to:
    - `AuthService.register/2`
  """

  defstruct [:email, :password]

  alias Mythweave.Auth.AuthService

  @type t :: %__MODULE__{
          email: String.t(),
          password: String.t()
        }

  @spec handle(t(), String.t()) :: {:ok, map()} | {:error, term()}
  def handle(%__MODULE__{email: e, password: p}, _pid) do
    AuthService.register(e, p)
  end

  # -------------------------
  # 🔧 PLACEHOLDERS & TODOs
  # -------------------------

  # 1. No email validation or format checks
  #    - ✅ Add email regex validation
  #
  # 2. No password strength enforcement
  #    - 🚧 Enforce min length / complexity
  #
  # 3. No duplicate email check in this layer
  #    - ❗ Ensure AuthService prevents account reuse
end
