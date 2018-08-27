defmodule Gatekeeper.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)

    many_to_many(:teams, Gatekeeper.Teams.Team, join_through: "team_members")
    has_many(:memberships, Gatekeeper.Teams.TeamMember)
    has_many(:approvals, Gatekeeper.Releases.Approval)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  def is_member_of(user, team) do
    Enum.any?(user.teams, fn x -> x.id == team.id end)
  end

  def safe_json(user) do
    %{id: user.id, name: user.name, email: user.email}
    |> safe_json_membership(user)
  end

  def safe_json_membership(obj, user) do
    if Ecto.assoc_loaded?(user.memberships) do
      obj
      |> Map.put(
        "membership",
        Enum.map(user.memberships, fn m -> Gatekeeper.Teams.TeamMember.safe_json(m) end)
      )
    else
      obj
    end
  end
end
