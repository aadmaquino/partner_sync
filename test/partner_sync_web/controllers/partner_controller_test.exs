defmodule PartnerSyncWeb.PartnerControllerTest do
  use PartnerSyncWeb.ConnCase

  import PartnerSync.PartnersFixtures

  alias PartnerSync.Repo

  @invalid_cnpj -1

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all partners", %{conn: conn} do
      conn = get(conn, Routes.partner_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "returns a partner", %{conn: conn} do
      partner = Repo.preload(partner_fixture(), :address)
      conn = get(conn, Routes.partner_path(conn, :show, partner.cnpj))

      assert json_response(conn, 200)["data"] == %{
               "address" => %{
                 "bairro" => partner.address.bairro,
                 "cep" => partner.address.cep,
                 "complemento" => partner.address.complemento,
                 "ddd" => partner.address.ddd,
                 "ibge" => partner.address.ibge,
                 "localidade" => partner.address.localidade,
                 "logradouro" => partner.address.logradouro,
                 "siafi" => partner.address.siafi,
                 "uf" => partner.address.uf
               },
               "cnpj" => partner.cnpj,
               "email" => partner.email,
               "fantasia" => partner.fantasia,
               "razao" => partner.razao,
               "telefone" => partner.telefone
             }
    end

    test "returns an error", %{conn: conn} do
      conn = get(conn, Routes.partner_path(conn, :show, @invalid_cnpj))

      assert json_response(conn, 404) == %{
               "errors" => %{
                 "detail" => "Not Found"
               }
             }
    end
  end
end
