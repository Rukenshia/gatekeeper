defmodule Gatekeeper.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:content, :text)
      add(:user_id, references(:users, on_delete: :nilify_all))
      add(:release_id, references(:releases, on_delete: :delete_all))
      add(:approval_id, references(:release_approvals, on_delete: :nilify_all))

      timestamps()
    end

    create(index(:comments, [:user_id]))
    create(index(:comments, [:release_id]))
    create(index(:comments, [:approval_id]))
  end
end
