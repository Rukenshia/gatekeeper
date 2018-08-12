defmodule Gatekeeper.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :name, :string

    many_to_many :teams, Gatekeeper.Teams.Team, join_through: "team_members"
    has_many :memberships, Gatekeeper.Teams.TeamMember
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  def is_member_of(user, team) do
    Enum.member?(user.teams, team)
  end
end
