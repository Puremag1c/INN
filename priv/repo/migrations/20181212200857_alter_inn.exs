defmodule Inn.Repo.Migrations.AlterInn do
  use Ecto.Migration

  def change do
    alter table(:inns) do
      modify :number, :string

    end
  end
end
