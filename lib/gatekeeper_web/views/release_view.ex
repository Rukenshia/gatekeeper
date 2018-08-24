defmodule GatekeeperWeb.ReleaseView do
  use GatekeeperWeb, :view

  def render(conn, approvals: approvals) do
    approvals
    |> Enum.map(fn a ->
      %{release_id: a.release_id, user_id: a.user_id, created_at: a.created_at}
    end)
  end
end
