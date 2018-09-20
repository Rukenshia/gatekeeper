defmodule Gatekeeper.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

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

  def has_membership?(user, team_id) do
    Logger.debug("User.has_membership?(#{inspect(user.id)}, #{inspect(team_id)})")
    Enum.any?(user.memberships, fn x -> x.team_id == team_id end)
  end

  def get_membership(user, team_id) do
    Enum.find(user.memberships, fn x -> x.team_id == team_id end)
  end
end
