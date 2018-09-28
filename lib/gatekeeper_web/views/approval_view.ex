defmodule GatekeeperWeb.ApprovalView do
  use GatekeeperWeb, :view
  alias GatekeeperWeb.ApprovalView

  def render("index.json", %{release_approvals: release_approvals}) do
    %{data: render_many(release_approvals, ApprovalView, "approval.json")}
  end

  def render("show.json", %{approval: approval}) do
    %{data: render_one(approval, ApprovalView, "approval.json")}
  end

  def render("approval.json", %{approval: approval}) do
    %{id: approval.id, user_id: approval.user_id, release_id: approval.release_id}
  end
end
