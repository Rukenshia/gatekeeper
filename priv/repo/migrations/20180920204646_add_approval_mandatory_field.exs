defmodule Gatekeeper.Repo.Migrations.AddApprovalMandatoryField do
  use Ecto.Migration

  def change do
    alter table("release_approvals") do
      add(:mandatory, :boolean)
    end
  end
end
