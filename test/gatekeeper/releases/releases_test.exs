defmodule Gatekeeper.ReleasesTest do
  use Gatekeeper.DataCase

  alias Gatekeeper.Releases

  describe "releases" do
    alias Gatekeeper.Releases.Release

    @valid_attrs %{commit_hash: "some commit_hash", description: "some description", released_at: "2010-04-17 14:00:00.000000Z", version: "some version"}
    @update_attrs %{commit_hash: "some updated commit_hash", description: "some updated description", released_at: "2011-05-18 15:01:01.000000Z", version: "some updated version"}
    @invalid_attrs %{commit_hash: nil, description: nil, released_at: nil, version: nil}

    def release_fixture(attrs \\ %{}) do
      {:ok, release} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Releases.create_release()

      release
    end

    test "list_releases/0 returns all releases" do
      release = release_fixture()
      assert Releases.list_releases() == [release]
    end

    test "get_release!/1 returns the release with given id" do
      release = release_fixture()
      assert Releases.get_release!(release.id) == release
    end

    test "create_release/1 with valid data creates a release" do
      assert {:ok, %Release{} = release} = Releases.create_release(@valid_attrs)
      assert release.commit_hash == "some commit_hash"
      assert release.description == "some description"
      assert release.released_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert release.version == "some version"
    end

    test "create_release/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Releases.create_release(@invalid_attrs)
    end

    test "update_release/2 with valid data updates the release" do
      release = release_fixture()
      assert {:ok, release} = Releases.update_release(release, @update_attrs)
      assert %Release{} = release
      assert release.commit_hash == "some updated commit_hash"
      assert release.description == "some updated description"
      assert release.released_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert release.version == "some updated version"
    end

    test "update_release/2 with invalid data returns error changeset" do
      release = release_fixture()
      assert {:error, %Ecto.Changeset{}} = Releases.update_release(release, @invalid_attrs)
      assert release == Releases.get_release!(release.id)
    end

    test "delete_release/1 deletes the release" do
      release = release_fixture()
      assert {:ok, %Release{}} = Releases.delete_release(release)
      assert_raise Ecto.NoResultsError, fn -> Releases.get_release!(release.id) end
    end

    test "change_release/1 returns a release changeset" do
      release = release_fixture()
      assert %Ecto.Changeset{} = Releases.change_release(release)
    end
  end

  describe "release_approvals" do
    alias Gatekeeper.Releases.Approval

    @valid_attrs %{approved_at: "2010-04-17 14:00:00.000000Z", release_id: 42, user_id: 42}
    @update_attrs %{approved_at: "2011-05-18 15:01:01.000000Z", release_id: 43, user_id: 43}
    @invalid_attrs %{approved_at: nil, release_id: nil, user_id: nil}

    def approval_fixture(attrs \\ %{}) do
      {:ok, approval} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Releases.create_approval()

      approval
    end

    test "list_release_approvals/0 returns all release_approvals" do
      approval = approval_fixture()
      assert Releases.list_release_approvals() == [approval]
    end

    test "get_approval!/1 returns the approval with given id" do
      approval = approval_fixture()
      assert Releases.get_approval!(approval.id) == approval
    end

    test "create_approval/1 with valid data creates a approval" do
      assert {:ok, %Approval{} = approval} = Releases.create_approval(@valid_attrs)
      assert approval.approved_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert approval.release_id == 42
      assert approval.user_id == 42
    end

    test "create_approval/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Releases.create_approval(@invalid_attrs)
    end

    test "update_approval/2 with valid data updates the approval" do
      approval = approval_fixture()
      assert {:ok, approval} = Releases.update_approval(approval, @update_attrs)
      assert %Approval{} = approval
      assert approval.approved_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert approval.release_id == 43
      assert approval.user_id == 43
    end

    test "update_approval/2 with invalid data returns error changeset" do
      approval = approval_fixture()
      assert {:error, %Ecto.Changeset{}} = Releases.update_approval(approval, @invalid_attrs)
      assert approval == Releases.get_approval!(approval.id)
    end

    test "delete_approval/1 deletes the approval" do
      approval = approval_fixture()
      assert {:ok, %Approval{}} = Releases.delete_approval(approval)
      assert_raise Ecto.NoResultsError, fn -> Releases.get_approval!(approval.id) end
    end

    test "change_approval/1 returns a approval changeset" do
      approval = approval_fixture()
      assert %Ecto.Changeset{} = Releases.change_approval(approval)
    end
  end
end
