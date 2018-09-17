defmodule GatekeeperWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  require Logger

  use GatekeeperWeb, :controller
  plug(Ueberauth)

  alias Ueberauth.Strategy.Helpers
  alias Gatekeeper.Users
  alias Gatekeeper.Teams
  alias Gatekeeper.Guardian

  def request(conn, _params) do
    conn
    |> redirect(to: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: user}} = conn, _params) do
    Logger.info(inspect(user))
    Logger.info(inspect(user.extra.raw_info.user))

    for team <- user.extra.raw_info.user["teams"] || [] do
      Teams.check_or_create!(team)
    end

    case Users.find_or_create_from_auth(user, user.extra.raw_info.user["teams"] || []) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Good to see you, #{user.name}")
        |> Guardian.Plug.sign_in(user, %{}, ttl: {60, :minute})
        |> redirect(to: "/home")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
