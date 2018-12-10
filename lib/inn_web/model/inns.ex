defmodule Inn.Number do
  use InnWeb, :model


  schema "inns" do
    field :number, :string
    field :status, :string
    belongs_to :user, Inn.User

    timestamps()
  end
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number, :status])
    |> validate_required([:number])
  end
end
