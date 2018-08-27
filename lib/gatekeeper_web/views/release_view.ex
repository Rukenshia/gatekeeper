defmodule GatekeeperWeb.ReleaseView do
  use GatekeeperWeb, :view

  def render("release_update.json", %{release: release}) do
    %{
      ok: true,
      release: %{
        id: release.id,
        version: release.version,
        commit_hash: release.commit_hash,
        team_id: release.team_id,
        description: release.description,
        released_at: release.released_at
      }
    }
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
