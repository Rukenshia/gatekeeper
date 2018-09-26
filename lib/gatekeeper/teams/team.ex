defmodule Gatekeeper.Teams.Team do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field(:name, :string)
    field(:api_key, Ecto.UUID)

    many_to_many(:members, Gatekeeper.Users.User, join_through: "team_members")
    has_many(:memberships, Gatekeeper.Teams.TeamMember)
    has_many(:releases, Gatekeeper.Releases.Release)
    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
