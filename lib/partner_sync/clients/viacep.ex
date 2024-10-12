defmodule PartnerSync.Clients.Viacep do
  @moduledoc false
  @expected_fields ~w(cep logradouro complemento bairro localidade uf ibge ddd siafi)

  def get_address(cep) do
    "https://viacep.com.br/ws/#{cep}/json/"
    |> HTTPoison.get()
    |> handle_response()
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: "{\n  \"erro\": true\n}"}} ->
        {:error, :not_found}

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded_body} = Jason.decode(body)

        result =
          decoded_body
          |> Map.take(@expected_fields)
          |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
          |> format_cep()

        {:ok, result}

      _error ->
        {:error, :bad_request}
    end
  end

  defp format_cep(result) do
    %{result | cep: String.replace(result.cep, "-", "")}
  end
end
