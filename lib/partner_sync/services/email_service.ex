defmodule PartnerSync.Services.EmailService do
  @moduledoc false
  import Swoosh.Email
  alias PartnerSync.Mailer

  def welcome(email) do
    new()
    |> from("noreply@solfacil.com.br")
    |> to({email, email})
    |> subject("Boas-vindas - Solfácil")
    |> html_body("<h1>Olá, #{email}!</h1><h2>Seus dados foram cadastrados com sucesso!</h2>")
    |> text_body("Olá, #{email}! Seus dados foram cadastrados com sucesso!")
    |> Mailer.deliver()
  end
end
