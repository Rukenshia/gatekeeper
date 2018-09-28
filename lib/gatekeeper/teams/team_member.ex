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
    |> unique_constraint(:team_id, name: :team_members_user_id_team_id_index)
  end
end
