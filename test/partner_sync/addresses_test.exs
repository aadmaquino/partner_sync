defmodule PartnerSync.AddressesTest do
  use PartnerSync.DataCase

  alias PartnerSync.Addresses

  describe "addresses" do
    alias PartnerSync.Addresses.Address

    import PartnerSync.AddressesFixtures

    @invalid_attrs %{
      bairro: nil,
      cep: nil,
      complemento: nil,
      ddd: nil,
      ibge: nil,
      localidade: nil,
      logradouro: nil,
      siafi: nil,
      uf: nil
    }

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      list_addresses = Addresses.list_addresses()

      assert address in list_addresses
      assert length(list_addresses) == 2
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Addresses.get_address!(address.id) == address
    end

    test "get_address_by_cep/1 returns the address with given cep" do
      address = address_fixture()
      assert Addresses.get_address_by_cep(address.cep) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{
        bairro: "Cruzeiro",
        cep: "30310190",
        complemento: "",
        ddd: "31",
        ibge: "3106200",
        localidade: "Belo Horizonte",
        logradouro: "Rua Cobre",
        siafi: "4123",
        uf: "MG"
      }

      assert {:ok, %Address{} = address} = Addresses.create_address(valid_attrs)
      assert address.bairro == "Cruzeiro"
      assert address.cep == "30310190"
      assert address.complemento == nil
      assert address.ddd == "31"
      assert address.ibge == "3106200"
      assert address.localidade == "Belo Horizonte"
      assert address.logradouro == "Rua Cobre"
      assert address.siafi == "4123"
      assert address.uf == "MG"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Addresses.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()

      update_attrs = %{
        bairro: "Funcionários",
        cep: "30140100",
        complemento: "até 399/400",
        ddd: "31",
        ibge: "3106200",
        localidade: "Belo Horizonte",
        logradouro: "Rua Cláudio Manoel",
        siafi: "4123",
        uf: "MG"
      }

      assert {:ok, %Address{} = address} = Addresses.update_address(address, update_attrs)
      assert address.bairro == "Funcionários"
      assert address.cep == "30140100"
      assert address.complemento == "até 399/400"
      assert address.ddd == "31"
      assert address.ibge == "3106200"
      assert address.localidade == "Belo Horizonte"
      assert address.logradouro == "Rua Cláudio Manoel"
      assert address.siafi == "4123"
      assert address.uf == "MG"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Addresses.update_address(address, @invalid_attrs)
      assert address == Addresses.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Addresses.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Addresses.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Addresses.change_address(address)
    end
  end
end
