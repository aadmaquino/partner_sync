defmodule PartnerSync.Clients.ViacepTest do
  use PartnerSync.DataCase

  alias PartnerSync.Clients.Viacep

  describe "viacep" do
    @valid_cep "05420020"
    @not_found_cep "99999999"
    @invalid_cep nil

    test "get_address/1 returns the address when CEP is valid" do
      response = Viacep.get_address(@valid_cep)

      assert {:ok,
              %{
                bairro: "Pinheiros",
                cep: "05420020",
                complemento: "",
                ddd: "11",
                ibge: "3550308",
                localidade: "São Paulo",
                logradouro: "Praça Roquete Pinto",
                siafi: "7107",
                uf: "SP"
              }} == response
    end

    test "get_address/1 returns the address when CEP is not found" do
      response = Viacep.get_address(@not_found_cep)
      assert {:error, :not_found} == response
    end

    test "get_address/1 returns the address when CEP is invalid" do
      response = Viacep.get_address(@invalid_cep)
      assert {:error, :bad_request} == response
    end
  end
end
