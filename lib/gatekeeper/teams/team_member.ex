defmodule Gatekeeper.Teams.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset


  schema "team_members" do
    field :role, :string
    timestamps()
  end

  @doc false
  def changeset(team_member, attrs) do
    team_member
    |> cast(attrs, [])
    |> validate_required([])
  end
end
