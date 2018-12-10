defmodule InnWeb.PageController do
  use InnWeb, :controller

  def index(conn, _params) do
    changeset = Inn.Number.changeset(%Inn.Number{}, %{})
    render conn, "index.html", changeset: changeset
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
    %{"number" => string} = number
      validate_length(conn, string)
      get_status(string)
      final(conn, number)

    end

    def validate_length(conn, string) do
      if String.length(string) == 0 do
        conn
        |> put_flash(:error, "Введите номер ИНН")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        case String.length(string) do
          exp when exp < 10 ->
            conn
            |> put_flash(:error, "Очень мало символов")
            |> redirect(to: Routes.page_path(conn, :index))
          exp when exp == 11 ->
            conn
            |> put_flash(:error, "Неверный номер")
            |> redirect(to: Routes.page_path(conn, :index))
          exp when exp > 12 ->
            conn
            |> put_flash(:error, "Очень много символов")
            |> redirect(to: Routes.page_path(conn, :index))
          exp when exp == 10 ->
            :ok
          exp when exp == 12 ->
            :ok
        end
      end
    end

    def final(conn, params) do
      changeset = conn.assigns.user
      |> Ecto.build_assoc(:inns)
      |> Inn.Number.changeset(params)

      case Inn.Repo.insert(changeset) do
        {:ok, _number} ->
          conn
          |> put_flash(:info, "Вы ввели номер")
          |> redirect(to: Routes.page_path(conn, :index))
        {:error, _changeset} ->
          conn
          |> put_flash(:error, " Пожалуйста введите номер")
          |> redirect(to: Routes.page_path(conn, :index))
      end
    end

    def validate_data(conn, string) do

    end

    def get_status(string) do
      IO.puts("+++++")
      IO.inspect(string)
    end
end
