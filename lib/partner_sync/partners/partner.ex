defmodule PartnerSync.Partners.Partner do
  @moduledoc false
  use Ecto.Schema

  import Brcpfcnpj.Changeset
  import Ecto.Changeset

  alias PartnerSync.Addresses.Address

  @required_fields ~w(cnpj razao email address_id)a
  @optional_fields ~w(fantasia telefone)a

  schema "partners" do
    field :cnpj, :string
    field :email, :string
    field :fantasia, :string
    field :razao, :string
    field :telefone, :string
    belongs_to :address, Address

    timestamps()
  end

  @doc false
  def changeset(partner, attrs) do
    partner
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_partner()
  end

  defp validate_partner(changeset) do
    changeset
    |> validate_cnpj(:cnpj)
    |> unique_constraint(:cnpj)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint(:email)
  end
end
