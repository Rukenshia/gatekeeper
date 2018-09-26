defmodule GatekeeperWeb.ReleaseController do
  require Logger

  use GatekeeperWeb, :controller

  alias Gatekeeper.Releases
  alias Gatekeeper.Releases.Release
  alias Gatekeeper.Users.User
  alias Gatekeeper.Repo

  def index(conn, %{"team_id" => team_id}) do
    releases =
      Releases.list_releases()
      |> Enum.map(fn r -> Repo.preload(r, :approvals) end)

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

    render(conn, "show.html",
      release: release,
      user_approval:
        Enum.find(release.approvals, fn a ->
          a.user_id == Gatekeeper.Guardian.Plug.current_resource(conn).id
        end),
      can_release: Releases.Release.releasable?(release)
    )
  end

  def edit(conn, %{"id" => id}) do
    release = Releases.get_release!(id)

    if Releases.Release.released?(release) do
      conn
      |> put_flash(:error, "You cannot edit this release, it has already been released.")
      |> redirect(to: team_release_path(conn, :show, release.team_id, release))
    else
      changeset = Releases.change_release(release)
      render(conn, "edit.html", release: release, changeset: changeset, team_id: release.team_id)
    end
  end

  @doc """
    This function recursively resets the approval status to "initial". Upon the first failure,
    the error from Ecto will be returned
  """
  def reset_approval([approval | t], _last) do
    case Releases.update_approval(approval, %{status: "initial"}) do
      {:ok, approval} ->
        reset_approval(t, approval)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}
    end
  end

  def reset_approval([], last) do
    {:ok, last}
  end

  def update(conn, %{"id" => id, "release" => release_params}) do
    release = Releases.get_release!(id)

    with {:ok, release} <- Releases.update_release(release, release_params),
         {:ok, _approval} <- reset_approval(Repo.preload(release, :approvals).approvals, nil) do
      release =
        release
        |> Repo.preload(:approvals)

      conn
      |> put_flash(:info, "Release updated successfully.")
      |> redirect(to: team_release_path(conn, :show, release.team_id, release))
    else
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
    user = Guardian.Plug.current_resource(conn)

    approval = Releases.get_approval!(approval)

    if user.id == approval.user_id do
      case Releases.update_approval(approval, %{status: "approved"}) do
        {:ok, _} ->
          conn
          |> json(%{ok: true})

        {:error, _} ->
          conn
          |> put_status(500)
          |> json(%{ok: false})
      end
    else
      conn
      |> put_status(401)
      |> json(%{ok: false})
    end
  end

  def api_decline_release(conn, %{"approval_id" => approval}) do
    user = Guardian.Plug.current_resource(conn)
    approval = Releases.get_approval!(approval)

    if user.id == approval.user_id do
      case Releases.update_approval(approval, %{status: "declined"}) do
        {:ok, _} ->
          conn
          |> json(%{ok: true})

        {:error, _} ->
          conn
          |> put_status(500)
          |> json(%{ok: false})
      end
    else
      conn
      |> put_status(401)
      |> json(%{ok: false})
    end
  end

  def api_release(conn, %{"release_id" => release}) do
    user =
      Guardian.Plug.current_resource(conn)
      |> Repo.preload(:memberships)

    release =
      Releases.get_release!(release)
      |> Repo.preload(:approvals)

    with _membership <- User.get_membership(user, release.team_id),
         true <- Release.releasable?(release) do
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
      nil ->
        conn
        |> put_status(401)
        |> json(%{ok: false})

      _ ->
        conn
        |> put_status(409)
        |> json(%{ok: false, message: "Already released"})
    end
  end
end
