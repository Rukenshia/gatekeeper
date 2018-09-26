defmodule GatekeeperWeb.Router do
  use GatekeeperWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :maybe_auth do
    plug(Gatekeeper.MaybeAuthPipeline)
    plug(:set_current_user)
  end

  pipeline :ensure_authed_access do
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(:set_user_jwt)
  end

  def set_current_user(conn, _args) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end

  def set_user_jwt(conn, _args) do
    with {:ok, token, _claims} <- Gatekeeper.Guardian.encode_and_sign(conn.assigns[:current_user]) do
      conn
      |> assign(:jwt, token)
    else
      _ ->
        conn
    end
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", GatekeeperWeb do
    # Use the default browser stack
    pipe_through([:browser, :maybe_auth, :ensure_authed_access])

    get("/home", PageController, :index)

    scope "/teams" do
      pipe_through(GatekeeperWeb.TeamAuthorizer)
      resources("/", TeamController, only: [:show, :edit], param: "team_id")
      resources("/:team_id/releases", ReleaseController, as: "team_release")
    end

    resources("/users", UserController, only: [:show])
  end


  scope "/", GatekeeperWeb do
    pipe_through([:browser])
    get("/", PageController, :landing)
    get("/logout", AuthController, :delete)
  end

  scope "/auth", GatekeeperWeb do
    pipe_through([:browser])

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  scope "/api", GatekeeperWeb do
    pipe_through([:api, :maybe_auth, :ensure_authed_access])

    scope "/v1" do
      scope "/teams" do
        pipe_through(GatekeeperWeb.TeamAuthorizer)
        get("/:team_id/members", TeamMemberController, :api_get_members)

        post("/:team_id/releases/:release_id/release", ReleaseController, :api_release)
        get("/:team_id/releases/:release_id/approvals", ReleaseController, :api_get_approvals)

        post(
          "/:team_id/releases/:release_id/approvals/:approval_id/approve",
          ReleaseController,
          :api_approve_release
        )

        post(
          "/:team_id/releases/:release_id/approvals/:approval_id/decline",
          ReleaseController,
          :api_decline_release
        )
      end
    end
  end
end
