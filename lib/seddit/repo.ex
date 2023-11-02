defmodule Seddit.Repo do
  use Ecto.Repo,
    otp_app: :seddit,
    adapter: Ecto.Adapters.Postgres
end
