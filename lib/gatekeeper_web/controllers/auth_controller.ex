defmodule GatekeeperWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """
  require Logger

  use GatekeeperWeb, :controller
  plug(Ueberauth)

  alias Ueberauth.Strategy.Helpers
  alias Gatekeeper.Users

  def request(conn, _params) do
    conn
    |> redirect(to: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: user}} = conn, _params) do
    case Users.find_or_create_from_auth(user) do
      {:ok, user} ->
        Logger.debug(inspect(user))

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> put_session(:current_user, %Gatekeeper.Users.User{name: "unknown"})
        |> redirect(to: "/")
    end
  end
end
