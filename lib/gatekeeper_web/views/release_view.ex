defmodule GatekeeperWeb.ReleaseView do
  use GatekeeperWeb, :view
  require Logger

  import Gatekeeper.Releases.Release

  def render("release_update.json", %{release: release}) do
    %{
      ok: true,
      release: render("release.json", %{release: release})
    }
  end

  def render("releases.json", %{releases: releases}) do
    releases
    |> Enum.map(fn r -> render("release.json", %{release: r}) end)
  end

  def render("release_comment.json", %{comment: comment}) do
    %{
      content: comment.content
    }
  end

  def render("release.json", %{release: release}) do
    %{
      id: release.id,
      version: release.version,
      commit_hash: release.commit_hash,
      team_id: release.team_id,
      description: release.description,
      released_at: release.released_at
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

  def format_date(date) do
    "#{date.year}-#{date.month}-#{date.day}"
  end

  def approval_comment(comments, approval_id) do
    comment =
      comments
      |> Enum.find(fn c -> c.approval_id == approval_id end)

    if comment != nil do
      render("release_comment.json", %{comment: comment})
    else
      nil
    end
  end
end
