defmodule Gatekeeper.Teams.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_members" do
    field(:role, :string)

    belongs_to(:user, Gatekeeper.Users.User)
    belongs_to(:team, Gatekeeper.Teams.Team)
    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:user_id, :team_id, :role])
    |> validate_required([:user_id, :team_id, :role])
  end
end
