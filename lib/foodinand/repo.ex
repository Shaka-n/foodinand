defmodule Foodinand.Repo do
  use Ecto.Repo,
    otp_app: :foodinand,
    adapter: Ecto.Adapters.Postgres
end
