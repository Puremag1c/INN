defmodule Inn.User do
use InnWeb, :model

@derive {Jason.Encoder, only: [:email]}

schema "users" do
  field :email, :string
  field :provider, :string
  field :token, :string
  has_many :inns, Inn.Number

  timestamps()
end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,[:email, :provider, :token])
    |> validate_required([:email, :provider, :token])

  end
end
