defmodule PartnerSync.AddressesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PartnerSync.Addresses` context.
  """

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        bairro: "Pinheiros",
        cep: "05420020",
        complemento: "",
        ddd: "11",
        ibge: "3550308",
        localidade: "São Paulo",
        logradouro: "Praça Roquete Pinto",
        siafi: "7107",
        uf: "SP"
      })
      |> PartnerSync.Addresses.create_address()

    address
  end
end
