defmodule InnWeb.PageController do
  use InnWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  plug :validator when action in [:create]

  def index(conn, _params) do
    changeset = Inn.Number.changeset(%Inn.Number{}, %{})
    render conn, "index.html", changeset: changeset
  end

  def create(conn, %{"number" => number}) do
    if conn.assigns.valid == :ok do
      wow = Map.merge(number, conn.assigns.status)
      final(conn, wow)
    end

  end

# Проверяет длинну строки, игнорирует все кроме 10 или 12 символов
# Записывает в conn.assigns.length длину
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
            |> put_flash(:error, "Номер состоит из 10 или 12 цифр")
            |> redirect(to: Routes.page_path(conn, :index))
          exp when exp > 12 ->
            conn
            |> put_flash(:error, "Очень много символов")
            |> redirect(to: Routes.page_path(conn, :index))
          exp when exp == 10 ->
            assign(conn, :length, exp)
          exp when exp == 12 ->
            assign(conn, :length, exp)
        end
      end
    end

# кладет корректные данные в базу
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

# Проверяет содержание строки. Если введены буквы или другие символы - ошибка
    def validate_data(conn, string) do
      list = String.codepoints(string)
      check = for char <- list do
                String.contains?(char, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
              end
      if Enum.member?(check, false) == true do
        conn
        |> put_flash(:error, "Вы ввели какую-то дичь")
        |> redirect(to: Routes.page_path(conn, :index))
      else
        nr = :ok
        assign(conn, :valid, nr)
      end
    end

# Плаг осуществляющий полную проверку данных формы
    def validator(conn, _params) do
      %{params: %{"number" => %{"number" => string}}} = conn
      IO.puts("++++")
      IO.inspect(string)
      conn
      |> validate_length(string)
      |> validate_data(string)
      |> get_status(string)

    end

# Проверяет контрольные сумму номера ИНН
    def get_status(conn, string) do
      list = String.codepoints(string)
      love = for el <- list do
        String.to_integer(el)
      end
      case conn.assigns.length do
        10 ->
          sum = Enum.at(love,0)*2 + Enum.at(love,1)*4 + Enum.at(love,2)*10 + Enum.at(love,3)*3 + Enum.at(love,4)*5 + Enum.at(love,5)*9 + Enum.at(love,6)*4 + Enum.at(love,7)*6 + Enum.at(love,8)*8
          wow = div(sum, 11)
          pr = sum - wow * 11
          fin = if pr == 10 do 0 else pr end
            if fin == Enum.at(love,9) do
              assign(conn, :status, %{"status" => "Корректен"})
            else
              assign(conn, :status, %{"status" => "Не корректен"})
            end
        12 ->
          sum1 = Enum.at(love,0)*7 + Enum.at(love,1)*2 + Enum.at(love,2)*4 + Enum.at(love,3)*10 + Enum.at(love,4)*3 + Enum.at(love,5)*5 + Enum.at(love,6)*9 + Enum.at(love,7)*4 + Enum.at(love,8)*6 + Enum.at(love,9)*8
          sum2 = Enum.at(love,0)*3 + Enum.at(love,1)*7 + Enum.at(love,2)*2 + Enum.at(love,3)*4 + Enum.at(love,4)*10 + Enum.at(love,5)*3 + Enum.at(love,6)*5 + Enum.at(love,7)*9 + Enum.at(love,8)*4 + Enum.at(love,9)*6 + Enum.at(love,10)*8
          wow1 = div(sum1, 11)
          wow2 = div(sum2, 11)
          pr1 = sum1 - wow1 * 11
          pr2 = sum2 - wow2 * 11
          fin1 = if pr1 == 10 do 0 else pr1 end
          fin2 = if pr2 == 10 do 0 else pr2 end
          if fin1 == Enum.at(love,10) do
            if fin2 == Enum.at(love,11) do
                assign(conn, :status, %{"status" => "Корректен"})
              else
                assign(conn, :status, %{"status" => "Не корректен"})
            end
          else
            assign(conn, :status, %{"status" => "Не корректен"})
          end
      end
    end
end
