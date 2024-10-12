defmodule PartnerSync.PartnersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PartnerSync.Partners` context.
  """

  import PartnerSync.AddressesFixtures

  @doc """
  Generate a partner.
  """
  def partner_fixture(attrs \\ %{}) do
    address = address_fixture()

    {:ok, partner} =
      attrs
      |> Enum.into(%{
        cnpj: "16470954000106",
        email: "atendimento@soleterno.com.br",
        fantasia: "Sol Eterno LTDA",
        razao: "Sol Eterno",
        telefone: "11987654321",
        address_id: address.id
      })
      |> PartnerSync.Partners.create_partner()

    partner
  end
end
