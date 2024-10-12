defmodule PartnerSyncWeb.AddressControllerTest do
  use PartnerSyncWeb.ConnCase

  import PartnerSync.AddressesFixtures

  @invalid_cep -1

  @default_cep_not_found %{
    "bairro" => "",
    "cep" => "00000000",
    "complemento" => "",
    "ddd" => "",
    "ibge" => "",
    "localidade" => "",
    "logradouro" => "CEP não localizado",
    "siafi" => "",
    "uf" => ""
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :index))
      assert json_response(conn, 200)["data"] == [@default_cep_not_found]
    end
  end

  describe "show" do
    test "returns an address", %{conn: conn} do
      address = address_fixture()
      conn = get(conn, Routes.address_path(conn, :show, address.cep))

      assert json_response(conn, 200)["data"] == %{
               "bairro" => address.bairro,
               "cep" => address.cep,
               "complemento" => address.complemento,
               "ddd" => address.ddd,
               "ibge" => address.ibge,
               "localidade" => address.localidade,
               "logradouro" => address.logradouro,
               "siafi" => address.siafi,
               "uf" => address.uf
             }
    end

    test "returns an error", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :show, @invalid_cep))

      assert json_response(conn, 404) == %{
               "errors" => %{
                 "detail" => "Not Found"
               }
             }
    end
  end
end
