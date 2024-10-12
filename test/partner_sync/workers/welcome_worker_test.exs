defmodule PartnerSync.Workers.WelcomeWorkerTest do
  use PartnerSync.DataCase
  use Oban.Testing, repo: PartnerSync.Repo

  import PartnerSync.PartnersFixtures

  alias PartnerSync.Workers.WelcomeWorker

  describe "perform/1" do
    test "create job" do
      partner = partner_fixture()

      assert {:ok, email} = perform_job(WelcomeWorker, %{email: partner.email})
      assert email == {:ok, %{}}
    end
  end
end
