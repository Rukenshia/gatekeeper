defmodule Gatekeeper.Releases.Release do
  use Ecto.Schema
  import Ecto.Changeset

  schema "releases" do
    field(:commit_hash, :string)
    field(:description, :string)
    field(:released_at, :utc_datetime)
    field(:version, :string)

    belongs_to(:team, Gatekeeper.Teams.Team)
    has_many(:approvals, Gatekeeper.Releases.Approval)
    timestamps()
  end

  @doc false
  def changeset(release, attrs) do
    release
    |> cast(attrs, [:commit_hash, :description, :version, :team_id, :released_at])
    |> validate_required([:commit_hash, :description, :version, :team_id])
  end
end
