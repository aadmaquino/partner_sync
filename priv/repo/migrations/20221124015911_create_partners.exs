defmodule PartnerSync.Repo.Migrations.CreatePartners do
  use Ecto.Migration

  def change do
    create table(:partners) do
      add :cnpj, :string, size: 14
      add :razao, :string
      add :fantasia, :string
      add :telefone, :string, size: 11
      add :email, :string
      add :address_id, references(:addresses, on_delete: :nothing)

      timestamps()
    end

    create index(:partners, [:address_id])
  end
end
