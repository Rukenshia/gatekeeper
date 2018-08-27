defmodule GatekeeperWeb.ReleaseController do
  require Logger

  use GatekeeperWeb, :controller

  alias Gatekeeper.Releases
  alias Gatekeeper.Releases.Release
  alias Gatekeeper.Repo

  import Ecto.Query, only: [from: 2]

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
    release =
      Releases.get_release!(id)
      |> Repo.preload(:approvals)

    release =
      Map.put(
        release,
        :approvals,
        Enum.map(release.approvals, fn a -> Repo.preload(a, :user) end)
      )

    user =
      conn
      |> get_session(:current_user)

    required_approvers =
      release.approvals
      |> Enum.map(fn a ->
        Repo.get_by!(Gatekeeper.Teams.TeamMember, user_id: a.user_id, team_id: release.team_id)
      end)
      |> Enum.filter(fn tm -> tm.mandatory_approver end)
      |> Enum.filter(fn tm ->
        Enum.any?(release.approvals, fn a ->
          a.user_id == tm.user_id and a.status != "approved"
        end)
      end)

    Logger.debug(inspect(required_approvers))

    can_release =
      if length(required_approvers) == 0 && is_nil(release.released_at) &&
           !Enum.any?(release.approvals, fn a -> a.status == "declined" end) do
        true
      else
        false
      end

    render(conn, "show.html",
      release: release,
      user_approval:
        Enum.find(release.approvals, fn a -> a.user_id == get_session(conn, :current_user).id end),
      can_release: can_release
    )
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

  def api_get_approvals(conn, %{"release_id" => id, "release_id" => id}) do
    release =
      Releases.get_release!(id)
      |> Repo.preload(:approvals)

    render(conn, "approvals.json", approvals: release.approvals)
  end

  def api_approve_release(conn, %{"approval_id" => approval}) do
    # TODO: guard for user id
    # TODO: guard for approval id -> release id
    approval = Releases.get_approval!(approval)

    case Releases.update_approval(approval, %{status: "approved"}) do
      {:ok, _} ->
        conn
        |> json(%{ok: true})

      {:error, _} ->
        conn
        |> put_status(500)
        |> json(%{ok: false})
    end
  end

  def api_decline_release(conn, %{"approval_id" => approval}) do
    # TODO: guard for user id
    # TODO: guard for approval id -> release id
    approval = Releases.get_approval!(approval)

    case Releases.update_approval(approval, %{status: "declined"}) do
      {:ok, _} ->
        conn
        |> json(%{ok: true})

      {:error, _} ->
        conn
        |> put_status(500)
        |> json(%{ok: false})
    end
  end

  def api_release(conn, %{"release_id" => release}) do
    require Logger
    # TODO: guard for user id
    release =
      Releases.get_release!(release)
      |> Repo.preload(:approvals)

    if is_nil(release.released_at) do
      case Releases.update_release(release, %{
             released_at: Ecto.DateTime.to_string(Ecto.DateTime.utc())
           }) do
        {:ok, release} ->
          conn
          |> render("release_update.json", release: release)

        {:error, _} ->
          conn
          |> put_status(500)
          |> json(%{ok: false, message: "Database update failed"})
      end
    else
      conn
      |> put_status(409)
      |> json(%{ok: false, message: "Already released"})
    end
  end
end
