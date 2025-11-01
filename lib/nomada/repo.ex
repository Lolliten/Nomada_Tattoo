defmodule Nomada.Repo do
  use Ecto.Repo,
    otp_app: :nomada,
    adapter: Ecto.Adapters.Postgres
end
