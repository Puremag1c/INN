defmodule InnWeb.PageController do
  use InnWeb, :controller

  def index(conn, _params) do
    changeset = Inn.Number.changeset(%Inn.Number{}, %{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, %{"number" => number}) do
    %{"number" => string} = number
    if validator(conn, string) == :ok do
      get_status(string)
      final(conn, number)
    end
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
      list = String.codepoints(string)
      for char <- list do
        if String.contains?(char, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]) == true do
          :ok
        else
          conn
          |> put_flash(:error, "Вы ввели какую-то дичь, введите номер")
          |> redirect(to: Routes.page_path(conn, :index))
        end
      end
    end

    def validator(conn, string) do
      if validate_length(conn, string) == :ok do
        validate_data(conn, string)
      end
    end

    def get_status(string) do
      IO.puts("+++++")
      IO.inspect(string)
    end
end
