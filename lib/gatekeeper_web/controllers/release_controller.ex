defmodule GatekeeperWeb.ReleaseController do
  use GatekeeperWeb, :controller

  alias Gatekeeper.Releases
  alias Gatekeeper.Releases.Release

  def index(conn, %{"team_id" => team_id}) do
    releases = Releases.list_releases()
    render(conn, "index.html", releases: releases, team_id: team_id)
  end

  def new(conn, %{"team_id" => team_id}) do
    changeset = Releases.change_release(%Release{})
    render(conn, "new.html", changeset: changeset, team_id: team_id)
  end

  def create(conn, %{"release" => release_params, "team_id" => team_id}) do
    release_params =
      release_params
      |> Map.put("team_id", team_id)

    case Releases.create_release(release_params) do
      {:ok, release} ->
        conn
        |> put_flash(:info, "Release created successfully.")
        |> redirect(to: team_release_path(conn, :show, team_id, release))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, team_id: team_id)
    end
  end

  def show(conn, %{"id" => id}) do
    release = Releases.get_release!(id)
    render(conn, "show.html", release: release)
  end

  def edit(conn, %{"id" => id}) do
    release = Releases.get_release!(id)
    changeset = Releases.change_release(release)
    render(conn, "edit.html", release: release, changeset: changeset, team_id: release.team_id)
  end

  def update(conn, %{"id" => id, "release" => release_params}) do
    release = Releases.get_release!(id)

    case Releases.update_release(release, release_params) do
      {:ok, release} ->
        conn
        |> put_flash(:info, "Release updated successfully.")
        |> redirect(to: team_release_path(conn, :show, release.team_id, release))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", release: release, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    release = Releases.get_release!(id)
    {:ok, _release} = Releases.delete_release(release)

    conn
    |> put_flash(:info, "Release deleted successfully.")
    |> redirect(to: team_release_path(conn, :index, release.team_id))
  end
end
