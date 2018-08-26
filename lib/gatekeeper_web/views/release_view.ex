defmodule GatekeeperWeb.ReleaseView do
  use GatekeeperWeb, :view

  def render(conn, approvals: approvals) do
    approvals
    |> Enum.map(fn a ->
      %{release_id: a.release_id, user_id: a.user_id, created_at: a.created_at}
    end)
  end

  def approval_icon(approval) do
    case approval.status do
      "initial" ->
        "check_box_outline_blank"

      "approved" ->
        "check_box"

      "declined" ->
        "error"

      _ ->
        "warning"
    end
  end

  def approval_icon_color_class(approval) do
    case approval.status do
      "initial" ->
        ""

      "approved" ->
        "gk-typography--color__success"

      _ ->
        "gk-typography--color__error"
    end
  end
end
