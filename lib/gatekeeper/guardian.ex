defmodule Gatekeeper.Guardian do
  use Guardian, otp_app: :gatekeeper

  alias Gatekeeper.Users
  alias Gatekeeper.Repo

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user!(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, Repo.preload(user, :teams)}
    end
  end
end
