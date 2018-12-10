defmodule InnWeb.AuthController do
  use InnWeb, :controller
  alias Inn.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end


  def signout(conn, _params) do
    conn
    |> put_flash(:info, "Заходите еще")
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp insert_or_update(changeset) do
    case Inn.Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Inn.Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
    defp signin(conn, changeset) do
      case insert_or_update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Привет")
          |> put_session(:user_id, user.id)
          |> redirect(to: Routes.page_path(conn, :profile))
        {:error, _reason} ->
          conn
          |> put_flash(:error, "Что-то пошло не так")
          |> redirect(to: Routes.page_path(conn, :index))
      end
    end
end
