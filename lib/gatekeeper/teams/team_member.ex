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
end
