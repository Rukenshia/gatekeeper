defmodule GatekeeperWeb.ApprovalControllerTest do
  use GatekeeperWeb.ConnCase

  alias Gatekeeper.Releases
  alias Gatekeeper.Releases.Approval

  @create_attrs %{approved_at: "2010-04-17 14:00:00.000000Z", release_id: 42, user_id: 42}
  @update_attrs %{approved_at: "2011-05-18 15:01:01.000000Z", release_id: 43, user_id: 43}
  @invalid_attrs %{approved_at: nil, release_id: nil, user_id: nil}

  def fixture(:approval) do
    {:ok, approval} = Releases.create_approval(@create_attrs)
    approval
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all release_approvals", %{conn: conn} do
      conn = get conn, approval_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create approval" do
    test "renders approval when data is valid", %{conn: conn} do
      conn = post conn, approval_path(conn, :create), approval: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, approval_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "approved_at" => "2010-04-17 14:00:00.000000Z",
        "release_id" => 42,
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, approval_path(conn, :create), approval: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update approval" do
    setup [:create_approval]

    test "renders approval when data is valid", %{conn: conn, approval: %Approval{id: id} = approval} do
      conn = put conn, approval_path(conn, :update, approval), approval: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, approval_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "approved_at" => "2011-05-18 15:01:01.000000Z",
        "release_id" => 43,
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, approval: approval} do
      conn = put conn, approval_path(conn, :update, approval), approval: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete approval" do
    setup [:create_approval]

    test "deletes chosen approval", %{conn: conn, approval: approval} do
      conn = delete conn, approval_path(conn, :delete, approval)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, approval_path(conn, :show, approval)
      end
    end
  end

  defp create_approval(_) do
    approval = fixture(:approval)
    {:ok, approval: approval}
  end
end
