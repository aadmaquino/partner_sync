defmodule PartnerSync.PartnersTest do
  use PartnerSync.DataCase

  alias PartnerSync.Partners

  describe "partners" do
    alias PartnerSync.Partners.Partner

    import PartnerSync.AddressesFixtures
    import PartnerSync.PartnersFixtures

    @invalid_attrs %{
      cnpj: nil,
      email: nil,
      fantasia: nil,
      razao: nil,
      telefone: nil,
      address_id: nil
    }

    test "list_partners/0 returns all partners" do
      partner = Repo.preload(partner_fixture(), :address)
      assert Partners.list_partners() == [partner]
    end

    test "get_partner!/1 returns the partner with given id" do
      partner = partner_fixture()
      assert Partners.get_partner!(partner.id) == partner
    end

    test "get_partner_by_cep/1 returns the partner with given cnpj" do
      partner = Repo.preload(partner_fixture(), :address)
      assert Partners.get_partner_by_cnpj(partner.cnpj) == partner
    end

    test "create_partner/1 with valid data creates a partner" do
      address = address_fixture()

      valid_attrs = %{
        cnpj: "19478819000197",
        email: "atendimento@soldamanha.com.br",
        fantasia: "Sol da Manhã",
        razao: "Sol da Manhã LTDA",
        telefone: "11912345678",
        address_id: address.id
      }

      assert {:ok, %Partner{} = partner} = Partners.create_partner(valid_attrs)
      assert partner.cnpj == "19478819000197"
      assert partner.email == "atendimento@soldamanha.com.br"
      assert partner.fantasia == "Sol da Manhã"
      assert partner.razao == "Sol da Manhã LTDA"
      assert partner.telefone == "11912345678"
      assert partner.address_id == address.id
    end

    test "create_partner/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_partner(@invalid_attrs)
    end

    test "update_partner/2 with valid data updates the partner" do
      partner = partner_fixture()

      update_attrs = %{
        cnpj: "12473742000113",
        email: "atendimento@solforte.com.br",
        fantasia: "Sol Forte",
        razao: "Sol Forte LTDA",
        telefone: "11954321678"
      }

      assert {:ok, %Partner{} = partner} = Partners.update_partner(partner, update_attrs)
      assert partner.cnpj == "12473742000113"
      assert partner.email == "atendimento@solforte.com.br"
      assert partner.fantasia == "Sol Forte"
      assert partner.razao == "Sol Forte LTDA"
      assert partner.telefone == "11954321678"
    end

    test "update_partner/2 with invalid data returns error changeset" do
      partner = partner_fixture()
      assert {:error, %Ecto.Changeset{}} = Partners.update_partner(partner, @invalid_attrs)
      assert partner == Partners.get_partner!(partner.id)
    end

    test "delete_partner/1 deletes the partner" do
      partner = partner_fixture()
      assert {:ok, %Partner{}} = Partners.delete_partner(partner)
      assert_raise Ecto.NoResultsError, fn -> Partners.get_partner!(partner.id) end
    end

    test "change_partner/1 returns a partner changeset" do
      partner = partner_fixture()
      assert %Ecto.Changeset{} = Partners.change_partner(partner)
    end
  end
end
