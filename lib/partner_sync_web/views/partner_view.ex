defmodule PartnerSyncWeb.PartnerView do
  use PartnerSyncWeb, :view

  alias PartnerSyncWeb.PartnerView

  def render("index.json", %{partners: partners}) do
    %{data: render_many(partners, PartnerView, "partner.json")}
  end

  def render("show.json", %{partner: partner}) do
    %{data: render_one(partner, PartnerView, "partner.json")}
  end

  def render("partner.json", %{partner: partner}) do
    %{
      cnpj: partner.cnpj,
      razao: partner.razao,
      fantasia: partner.fantasia,
      telefone: partner.telefone,
      email: partner.email,
      address: %{
        cep: partner.address.cep,
        logradouro: partner.address.logradouro,
        complemento: partner.address.complemento,
        bairro: partner.address.bairro,
        localidade: partner.address.localidade,
        uf: partner.address.uf,
        ibge: partner.address.ibge,
        ddd: partner.address.ddd,
        siafi: partner.address.siafi
      }
    }
  end

  def render("csv.json", %{result: result}) do
    %{
      message: "CSV accepted and processed",
      result: result
    }
  end

  def render("csv_error.json", _params) do
    %{errors: %{detail: "CSV file is not valid"}}
  end
end
