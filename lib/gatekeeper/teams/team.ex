defmodule Gatekeeper.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field(:name, :string)

    many_to_many(:members, Gatekeeper.Users.User, join_through: "team_members")
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
      name: team.name,
      members: Enum.map(team.members, fn m -> Gatekeeper.Users.User.safe_json(m) end)
    }
  end
end
