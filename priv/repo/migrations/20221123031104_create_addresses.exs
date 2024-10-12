defmodule PartnerSync.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :cep, :string
      add :logradouro, :string
      add :complemento, :string
      add :bairro, :string
      add :localidade, :string
      add :uf, :string
      add :ibge, :string
      add :ddd, :string
      add :siafi, :string

      timestamps()
    end

    create unique_index(:addresses, [:cep])

    execute """
      INSERT INTO addresses (cep, logradouro, complemento, bairro, localidade, uf, ibge, ddd, siafi, inserted_at, updated_at)
      VALUES ('00000000', 'CEP não localizado', '', '', '', '', '', '', '', now(), now())
    """
  end
end
