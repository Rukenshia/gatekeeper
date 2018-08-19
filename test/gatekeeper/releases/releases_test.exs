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
end
