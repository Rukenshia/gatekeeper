defmodule GatekeeperWeb.Router do
  use GatekeeperWeb, :router
  alias Gatekeeper.Repo
  alias Gatekeeper.Users

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:set_current_user)
  end

  def set_current_user(conn, _args) do
    if !get_session(conn, :current_user) do
      # FIXME(jan): proper session handling... sometime...
      user =
        Users.get_user!(2)
        |> Repo.preload(:teams)

      conn = put_session(conn, :current_user, user)
    end

    conn
    |> assign(:current_user, get_session(conn, :current_user))
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", GatekeeperWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/teams", TeamController)

    resources("/users", UserController)
  end

  # Other scopes may use custom stacks.
  scope "/api", GatekeeperWeb do
    pipe_through(:api)

    get("/users", UserController, :api_get_users)

    get("/teams/:team_id/members", TeamMemberController, :api_get_members)
    post("/teams/:team_id/members", TeamMemberController, :api_add_member)
    delete("/teams/:team_id/members/:user_id", TeamMemberController, :api_remove_member)
  end
end
