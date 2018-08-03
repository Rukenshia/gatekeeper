defmodule Gatekeeper.Repo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def change do
    create table(:team_members) do
      add :role, :string

      add :user_id, references(:users)
      add :team_id, references(:teams)

      timestamps()
    end

    create unique_index(:team_members, [:user_id, :team_id])
  end
end
