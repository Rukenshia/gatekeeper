defmodule Gatekeeper.Releases.Release do
  use Ecto.Schema
  import Ecto.Changeset

  alias Gatekeeper.Repo

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

  def released?(release) do
    !is_nil(release.released_at)
  end

  def declined?(release) do
    release =
      release
      |> Repo.preload(:approvals)

    Enum.any?(release.approvals, fn a -> a.status == "declined" end)
  end

  def releasable?(release) do
    release =
      release
      |> Repo.preload(:approvals)

    with false <- released?(release),
         false <- declined?(release),
         true <-
           Enum.all?(release.approvals, fn a ->
             !a.is_mandatory || (a.is_mandatory && a.status == "approved")
           end) do
      true
    else
      _ ->
        false
    end
  end
end
