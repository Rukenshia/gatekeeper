defmodule Gatekeeper.Releases.Approval do
  use Ecto.Schema
  import Ecto.Changeset

  schema "release_approvals" do
    field(:status, :string)
    belongs_to(:release, Gatekeeper.Releases.Release)
    belongs_to(:user, Gatekeeper.Users.User)
    timestamps()
  end

  @doc false
  def changeset(approval, attrs) do
    approval
    |> cast(attrs, [:user_id, :release_id, :status])
    |> validate_required([:user_id, :release_id, :status])
  end
end
