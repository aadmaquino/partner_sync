defmodule PartnerSync.Workers.WelcomeWorker do
  @moduledoc false
  use Oban.Worker, queue: :welcome

  alias PartnerSync.Services.EmailService

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email}}) do
    {:ok, EmailService.welcome(email)}
  end
end
