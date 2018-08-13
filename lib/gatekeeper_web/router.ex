defmodule GatekeeperWeb.Router do
  use GatekeeperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GatekeeperWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/teams", TeamController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  scope "/api", GatekeeperWeb do
    pipe_through :api

    post "/teams/:id/members", TeamController.Add
  end
end
