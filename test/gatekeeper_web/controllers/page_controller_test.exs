defmodule GatekeeperWeb.PageControllerTest do
  use GatekeeperWeb.ConnCase

  alias Gatekeeper.Repo
  alias Gatekeeper.Users
  alias Gatekeeper.Guardian

  @create_attrs %{id: 1, name: "Fixture User", email: "fixture.user@test.com"}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)

    user
    |> Repo.preload(:teams)
    |> Repo.preload(:approvals)
  end

  defp create_user(_) do
    user = fixture(:user)

    {:ok, user: user}
  end

  describe "landing page" do
    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "<h2 class=\"mdc-typography--headline1\">Gatekeeper</h2>"
    end
  end

  describe "home when user is unauthenticated" do
    test "GET /home", %{conn: conn} do
      conn = get(conn, "/home")
      assert text_response(conn, 401) =~ "unauthenticated"
    end
  end

  describe("home when user is authenticated") do
    setup([:create_user])

    test "GET /home", %{conn: conn, user: user} do
      conn =
        conn
        |> Guardian.Plug.sign_in(user, %{})
        |> get("/home")

      assert html_response(conn, 200) =~ "Logged in as #{user.name}"
    end
  end
end
