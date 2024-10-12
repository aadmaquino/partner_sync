defmodule PartnerSyncWeb.Router do
  use PartnerSyncWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", PartnerSyncWeb do
    pipe_through [:api]

    get "/addresses", AddressController, :index
    get "/addresses/:cep", AddressController, :show

    get "/partners", PartnerController, :index
    get "/partners/:cnpj", PartnerController, :show
    post "/partners", PartnerController, :import
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
