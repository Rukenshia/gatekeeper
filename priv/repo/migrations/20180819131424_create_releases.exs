defmodule Gatekeeper.Repo.Migrations.CreateReleases do
  use Ecto.Migration

  def change do
    create table(:releases) do
      add(:commit_hash, :string)
      add(:description, :string)
      add(:version, :string)
      add(:released_at, :utc_datetime)

      add(:team_id, :integer)
      timestamps()
    end

    create(unique_index(:releases, [:team_id, :version]))
  end
end
