defmodule PartnerSyncWeb.PartnerController do
  use PartnerSyncWeb, :controller

  alias PartnerSync.Partners

  action_fallback PartnerSyncWeb.FallbackController

  @csv_columns ["CNPJ", "Razão Social", "Nome Fantasia", "Telefone", "Email", "CEP"]

  def index(conn, _params) do
    partners = Partners.list_partners()
    render(conn, "index.json", partners: partners)
  end

  def show(conn, %{"cnpj" => cnpj}) do
    case Partners.get_partner_by_cnpj(cnpj) do
      nil -> {:error, :not_found}
      partner -> render(conn, "show.json", partner: partner)
    end
  end

  def import(conn, %{"csv" => csv}) do
    data = csv_decoder(csv)

    case has_valid_csv_header?(data) do
      true ->
        render(conn, "csv.json", result: import_partners(data))

      false ->
        conn
        |> put_status(400)
        |> render("csv_error.json", params: nil)
    end
  end

  defp csv_decoder(file) do
    "#{file.path}"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn data -> data end)
  end

  defp has_valid_csv_header?(data) do
    data
    |> Enum.map(fn {:ok, partner} -> Enum.all?(@csv_columns, &Map.has_key?(partner, &1)) end)
    |> Enum.any?(fn value -> value == true end)
  end

  defp import_partners(partners) do
    partners = Enum.map(partners, fn {:ok, partner} -> Partners.parse_fields(partner) end)
    Partners.insert_or_update_partners(partners)
  end
end
