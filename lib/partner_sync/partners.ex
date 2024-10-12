defmodule PartnerSync.Partners do
  @moduledoc """
  The Partners context.
  """

  import Ecto.Query, warn: false

  alias PartnerSync.{
    Addresses,
    Clients.Viacep,
    Partners.Partner,
    Repo,
    Workers.WelcomeWorker
  }

  @temporary_address_id 1

  @doc """
  Returns the list of partners.

  ## Examples

      iex> list_partners()
      [%Partner{}, ...]

  """
  def list_partners do
    Repo.all(Partner) |> Repo.preload(:address)
  end

  @doc """
  Gets a single partner.

  Raises `Ecto.NoResultsError` if the Partner does not exist.

  ## Examples

      iex> get_partner!(123)
      %Partner{}

      iex> get_partner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_partner!(id), do: Repo.get!(Partner, id)

  @doc """
  Gets a single partner.

  Returns nil if the Partner does not exist.

  ## Examples

      iex> get_partner_by_cnpj(11111111111111)
      %Partner{}

      iex> get_partner_by_cnpj(0)
      nil

  """
  def get_partner_by_cnpj(cnpj), do: Repo.get_by(Partner, cnpj: cnpj) |> Repo.preload(:address)

  @doc """
  Creates a partner.

  ## Examples

      iex> create_partner(%{field: value})
      {:ok, %Partner{}}

      iex> create_partner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_partner(attrs \\ %{}) do
    %Partner{}
    |> Partner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a partner.

  ## Examples

      iex> update_partner(partner, %{field: new_value})
      {:ok, %Partner{}}

      iex> update_partner(partner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_partner(%Partner{} = partner, attrs) do
    partner
    |> Partner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a partner.

  ## Examples

      iex> delete_partner(partner)
      {:ok, %Partner{}}

      iex> delete_partner(partner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_partner(%Partner{} = partner) do
    Repo.delete(partner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking partner changes.

  ## Examples

      iex> change_partner(partner)
      %Ecto.Changeset{data: %Partner{}}

  """
  def change_partner(%Partner{} = partner, attrs \\ %{}) do
    Partner.changeset(partner, attrs)
  end

  @doc """
  Creates a worker.

  ## Examples

      iex> build_welcome_email("email@domain.com")
      {:ok, %Job{}}

  """
  def build_welcome_email(email) do
    %{email: email}
    |> WelcomeWorker.new()
    |> Oban.insert()
  end

  def parse_fields(partner) do
    %{
      cnpj: String.replace(partner["CNPJ"], ~r/[^\d]/, ""),
      razao: partner["Razão Social"],
      fantasia: partner["Nome Fantasia"],
      telefone: String.replace(partner["Telefone"], ~r/[^\d]/, ""),
      email: partner["Email"],
      cep: String.replace(partner["CEP"], ~r/[^\d]/, "")
    }
  end

  def insert_or_update_partners(partners_list) do
    Enum.map(partners_list, fn partner ->
      partner = insert_address_for_partner(partner)

      with nil <- get_partner_by_cnpj(partner.cnpj),
           {:ok, _changeset} <- create_partner(partner) do
        build_welcome_email(partner.email)

        %{
          cep_status: set_cep_status(partner.address_id),
          import_status: :created,
          partner: partner
        }
      else
        {:error, changeset} ->
          %{
            import_status: :failed,
            partner: partner,
            errors: handle_partner_errors(changeset)
          }

        partner_found ->
          case update_partner(partner_found, %{
                 razao: partner.razao,
                 fantasia: partner.fantasia,
                 telefone: partner.telefone,
                 email: partner.email,
                 address_id: partner.address_id,
                 updated_at: NaiveDateTime.utc_now()
               }) do
            {:ok, _changeset} ->
              %{
                cep_status: set_cep_status(partner.address_id),
                import_status: :updated,
                partner: partner
              }

            {:error, changeset} ->
              %{
                import_status: :failed,
                partner: partner,
                errors: handle_partner_errors(changeset)
              }
          end
      end
    end)
  end

  defp insert_address_for_partner(partner) do
    with nil <- Addresses.get_address_by_cep(partner.cep),
         {:ok, viacep_response} <- Viacep.get_address(partner.cep),
         {:ok, address} <- Addresses.create_address(viacep_response) do
      set_address_id_for_partner(partner, address.id)
    else
      {:error, _reason} ->
        set_address_id_for_partner(partner, @temporary_address_id)

      address_found ->
        set_address_id_for_partner(partner, address_found.id)
    end
  end

  defp set_address_id_for_partner(partner, address_id) do
    partner
    |> Map.put(:address_id, address_id)
    |> Map.delete(:cep)
  end

  defp set_cep_status(address_id) do
    case address_id do
      @temporary_address_id -> :not_found
      _ -> :ok
    end
  end

  defp handle_partner_errors(changeset) do
    Enum.reduce(changeset.errors, [], fn field_error, errors ->
      {field, {error_message, _}} = field_error
      ["#{Atom.to_string(field)}: #{error_message}" | errors]
    end)
  end
end
