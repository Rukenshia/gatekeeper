defmodule Gatekeeper.Teams.TeamMember do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_members" do
    field(:role, :string)
    field(:mandatory_approver, :boolean)

    belongs_to(:user, Gatekeeper.Users.User)
    belongs_to(:team, Gatekeeper.Teams.Team)
    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [:user_id, :team_id, :role, :mandatory_approver])
    |> validate_required([:user_id, :team_id, :role, :mandatory_approver])
  end

  def safe_json(team_member) do
    %{
      user_id: team_member.user_id,
      team_id: team_member.team_id,
      role: team_member.role,
      mandatory_approver: team_member.mandatory_approver
    }
    |> safe_json_user(team_member)
  end

  def safe_json_user(obj, team_member) do
    if Ecto.assoc_loaded?(team_member.user) do
      obj
      |> Map.put("user", Gatekeeper.Users.User.safe_json(team_member.user))
    else
      obj
    end
  end
end
