defmodule Unity.Repo do
  use Ecto.Repo,
    otp_app: :unity,
    adapter: Ecto.Adapters.Postgres
end
