defmodule GatekeeperWeb.Router do
  use GatekeeperWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
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

    post("/teams/:team_id/members", TeamController, :api_add_member)
    delete("/teams/:team_id/members/:user_id", TeamController, :api_remove_member)
  end
end
