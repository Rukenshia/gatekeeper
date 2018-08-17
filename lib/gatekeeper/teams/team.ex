defmodule Gatekeeper.Teams.Team do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field(:name, :string)

    many_to_many(:members, Gatekeeper.Users.User, join_through: "team_members")
    has_many(:memberships, Gatekeeper.Teams.TeamMember)
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def safe_json(team) do
    %{
      id: team.id,
      name: team.name
    }
    |> safe_json_memberships(team)
  end

  def safe_json_memberships(obj, team) do
    if Ecto.assoc_loaded?(team.memberships) do
      obj
      |> Map.put(
        "memberships",
        Enum.map(team.memberships, fn m -> Gatekeeper.Teams.TeamMember.safe_json(m) end)
      )
    else
      obj
    end
  end
end
