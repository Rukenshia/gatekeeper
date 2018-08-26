defmodule Gatekeeper.Repo.Migrations.CreateReleaseApprovals do
  use Ecto.Migration

  def change do
    create table(:release_approvals) do
      add(:user_id, :integer)
      add(:release_id, :integer)
      add(:status, :string)

      timestamps()
    end

    create(unique_index(:release_approvals, [:release_id, :user_id]))
  end
end
