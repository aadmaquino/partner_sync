defmodule PartnerSync.Addresses.Address do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(cep logradouro bairro localidade uf ibge ddd siafi)a
  @optional_fields ~w(complemento)a

  schema "addresses" do
    field :bairro, :string
    field :cep, :string
    field :complemento, :string
    field :ddd, :string
    field :ibge, :string
    field :localidade, :string
    field :logradouro, :string
    field :siafi, :string
    field :uf, :string

    timestamps()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:cep)
  end
end
