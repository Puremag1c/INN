defmodule Inn.Repo.Migrations.AddInn do
  use Ecto.Migration

  def change do
    create table(:inns) do
      add :number, :integer
      add :status, :string
      add :user_id, references(:users)

      timestamps()
    end
  end
end
