defmodule PartnerSync.Repo do
  use Ecto.Repo,
    otp_app: :partner_sync,
    adapter: Ecto.Adapters.Postgres
end
