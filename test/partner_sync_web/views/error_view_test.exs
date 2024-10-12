defmodule PartnerSyncWeb.ErrorViewTest do
  use PartnerSyncWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json" do
    assert render(PartnerSyncWeb.ErrorView, "400.json", []) == %{
             errors: %{detail: "Bad Request"}
           }
  end

  test "renders 404.json" do
    assert render(PartnerSyncWeb.ErrorView, "404.json", []) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 422.json" do
    assert render(PartnerSyncWeb.ErrorView, "422.json", []) == %{
             errors: %{detail: "Unprocessable Entity"}
           }
  end

  test "renders 500.json" do
    assert render(PartnerSyncWeb.ErrorView, "500.json", []) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
