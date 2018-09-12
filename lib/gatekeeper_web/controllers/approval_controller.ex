defmodule GatekeeperWeb.ApprovalController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Releases
  alias Gatekeeper.Releases.Approval

  action_fallback(GatekeeperWeb.FallbackController)

  def index(conn, _params) do
    release_approvals = Releases.list_release_approvals()
    render(conn, "index.json", release_approvals: release_approvals)
  end

  def create(conn, %{"approval" => approval_params}) do
    with {:ok, %Approval{} = approval} <- Releases.create_approval(approval_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        approval_path(conn, :show, approval)
      )
      |> render("show.json", approval: approval)
    end
  end

  def show(conn, %{"id" => id}) do
    approval = Releases.get_approval!(id)
    render(conn, "show.json", approval: approval)
  end

  def update(conn, %{"id" => id, "approval" => approval_params}) do
    approval = Releases.get_approval!(id)

    with {:ok, %Approval{} = approval} <- Releases.update_approval(approval, approval_params) do
      render(conn, "show.json", approval: approval)
    end
  end

  def delete(conn, %{"id" => id}) do
    approval = Releases.get_approval!(id)

    with {:ok, %Approval{}} <- Releases.delete_approval(approval) do
      send_resp(conn, :no_content, "")
    end
  end
end
