defmodule InnWeb.PageController do
  use InnWeb, :controller

  def index(conn, _params) do

    render conn, "index.html"
  end

  def profile(conn, params) do
      if conn.assigns.user == nil do
        conn
        |> put_flash(:error, "Нельзя")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        changeset = Inn.Number.changeset(%Inn.Number{}, %{})

        render conn, "profile.html", changeset: changeset
      end
  end

  def create(conn, %{"number" => number}) do
    %{"number" => new} = number
IO.puts("+++++")
new2 = to_string(new)
    IO.inspect(is_binary(new2))
      changeset = conn.assigns.user
      |> Ecto.build_assoc(:inns)
      |> Inn.Number.changeset(number)

      case Inn.Repo.insert(changeset) do
        {:ok, _number} ->
          conn
          |> put_flash(:info, "Новый номер")
          |> redirect(to: Routes.page_path(conn, :profile))
        {:error, _changeset} ->
          conn
          |> put_flash(:error, "Введите номер")
          |> redirect(to: Routes.page_path(conn, :profile))
      end

  end
end
