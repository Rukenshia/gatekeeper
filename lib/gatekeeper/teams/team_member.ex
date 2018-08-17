defmodule Gatekeeper.Teams.TeamMember do
  require Logger
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

  def safe_json(team_member) do
    %{user_id: team_member.user_id, team_id: team_member.team_id, role: team_member.role}
  end
end
