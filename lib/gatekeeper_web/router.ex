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
      pipe_through(Gatekeeper.TeamAuthorizer)
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
    pipe_through([:api])

    scope "/v1" do
      scope "/integrations" do
        pipe_through(Gatekeeper.TokenAuthorizer)

        scope "/teams" do
          scope "/:team_id/releases" do
            get("/", ReleaseController, :api_get_releases)
            post("/", ReleaseController, :api_create_release)

            get("/:release_id", ReleaseController, :api_get_release)
          end
        end
      end

      scope "/teams" do
        scope "/:team_id" do
          pipe_through([:maybe_auth, :ensure_authed_access, Gatekeeper.TeamAuthorizer])

          scope "/members" do
            get("/", TeamMemberController, :api_get_members)
          end

          scope "/releases" do
            post("/:release_id/release", ReleaseController, :api_release)
            get("/:release_id/approvals", ReleaseController, :api_get_approvals)

            scope "/:release_id/approvals/:approval_id" do
              post(
                "/approve",
                ReleaseController,
                :api_approve_release
              )

              post(
                "/decline",
                ReleaseController,
                :api_decline_release
              )
            end
          end
        end
      end
    end
  end
end
