defmodule Gatekeeper.Releases.Approval do
  use Ecto.Schema
  import Ecto.Changeset

  schema "release_approvals" do
    field(:status, :string)
    field(:mandatory, :boolean)
    belongs_to(:release, Gatekeeper.Releases.Release)
    belongs_to(:user, Gatekeeper.Users.User)
    has_one(:comment, Gatekeeper.Releases.Comment, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(approval, attrs) do
    approval
    |> cast(attrs, [:user_id, :release_id, :status, :mandatory])
    |> validate_required([:user_id, :release_id, :status, :mandatory])
  end
end
