defmodule Gatekeeper.TokenAuthorizer do
  import Plug.Conn
  import Phoenix.Controller

  import Ecto.Query

  alias Gatekeeper.Repo
  alias Gatekeeper.Teams.Team

  require Logger

  def init(opts), do: opts

  def call(
        %Plug.Conn{
          params: %{"team_id" => team},
          req_headers: headers
        } = conn,
        _opts
      ) do
    with authorization <- headers |> Enum.find(fn {n, _} -> n == "authorization" end),
         false <- is_nil(authorization),
         uuid <- authorization |> elem(1) |> String.split(" ") |> List.last() do
      team =
        from(t in Team,
          where: [
            id: ^team,
            api_key: ^uuid
          ]
        )
        |> Repo.get_by([])

      if !is_nil(team) do
        conn
      else
        conn
        |> put_status(401)
        |> json(%{ok: false, message: "invalid_api_token"})
        |> halt()
      end
    else
      result ->
        Logger.warn("TokenAuthorizer failed. result: #{inspect(result)}")

        conn
        |> put_status(401)
        |> json(%{ok: false, message: "authorization_failed"})
        |> halt()
    end
  end
end
