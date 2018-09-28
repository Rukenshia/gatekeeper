defmodule Gatekeeper.Repo.Migrations.AddTeamApiKey do
  use Ecto.Migration
  import Ecto.Query

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA public;")

    alter table(:teams) do
      add(:api_key, :uuid, default: fragment("uuid_generate_v4()"), null: false)
    end

    create(unique_index(:teams, [:api_key]))
  end

  def down do
    execute("DROP EXTENSION \"uuid-ossp\";")

    alter table(:teams) do
      remove(:api_key)
    end
  end
end
