defmodule PartnerSyncWeb.AddressController do
  use PartnerSyncWeb, :controller

  alias PartnerSync.Addresses

  action_fallback PartnerSyncWeb.FallbackController

  def index(conn, _params) do
    addresses = Addresses.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def show(conn, %{"cep" => cep}) do
    case Addresses.get_address_by_cep(cep) do
      nil -> {:error, :not_found}
      address -> render(conn, "show.json", address: address)
    end
  end
end
