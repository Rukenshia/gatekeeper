defmodule GatekeeperWeb.ReleaseControllerTest do
  use GatekeeperWeb.ConnCase

  alias Gatekeeper.Releases

  @create_attrs %{
    commit_hash: "some commit_hash",
    description: "some description",
    released_at: "2010-04-17 14:00:00.000000Z",
    version: "some version"
  }
  @update_attrs %{
    commit_hash: "some updated commit_hash",
    description: "some updated description",
    released_at: "2011-05-18 15:01:01.000000Z",
    version: "some updated version"
  }
  @invalid_attrs %{commit_hash: nil, description: nil, released_at: nil, version: nil}

  def fixture(:release) do
    {:ok, release} = Releases.create_release(@create_attrs)
    release
  end

  describe "index" do
    test "lists all releases", %{conn: conn} do
      conn = get(conn, team_release_path(conn, :index, 1))
      assert html_response(conn, 200) =~ "Listing Releases"
    end
  end

  describe "new release" do
    test "renders form", %{conn: conn} do
      conn = get(conn, team_release_path(conn, :new, 1))
      assert html_response(conn, 200) =~ "New Release"
    end
  end

  describe "create release" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, team_release_path(conn, :create, 1), release: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == team_release_path(conn, :show, 1, id)

      conn = get(conn, team_release_path(conn, :show, 1, id))
      assert html_response(conn, 200) =~ "Show Release"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, team_release_path(conn, :create, 1), release: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Release"
    end
  end

  describe "edit release" do
    setup [:create_release]

    test "renders form for editing chosen release", %{conn: conn, release: release} do
      conn = get(conn, team_release_path(conn, :edit, 1, release))
      assert html_response(conn, 200) =~ "Edit Release"
    end
  end

  describe "update release" do
    setup [:create_release]

    test "redirects when data is valid", %{conn: conn, release: release} do
      conn = put(conn, team_release_path(conn, :update, 1, release), release: @update_attrs)
      assert redirected_to(conn) == team_release_path(conn, :show, 1, release)

      conn = get(conn, team_release_path(conn, :show, 1, release))
      assert html_response(conn, 200) =~ "some updated commit_hash"
    end

    test "renders errors when data is invalid", %{conn: conn, release: release} do
      conn = put(conn, team_release_path(conn, :update, 1, release), release: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Release"
    end
  end

  describe "delete release" do
    setup [:create_release]

    test "deletes chosen release", %{conn: conn, release: release} do
      conn = delete(conn, team_release_path(conn, :delete, 1, release))
      assert redirected_to(conn) == team_release_path(conn, :index, 1)

      assert_error_sent(404, fn ->
        get(conn, team_release_path(conn, :show, 1, release))
      end)
    end
  end

  defp create_release(_) do
    release = fixture(:release)
    {:ok, release: release}
  end
end
