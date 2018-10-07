defmodule Gatekeeper.Releases.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gatekeeper.Releases.Release
  alias Gatekeeper.Releases.Approval
  alias Gatekeeper.Users.User

  schema "comments" do
    field(:content, :string)

    belongs_to(:user, User)
    belongs_to(:approval, Approval)
    belongs_to(:release, Release)
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
