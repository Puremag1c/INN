defmodule Inn.Repo do
  use Ecto.Repo,
    otp_app: :inn,
    adapter: Ecto.Adapters.Postgres
end
