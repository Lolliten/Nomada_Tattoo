defmodule Nomada.Contact.Message do
  @moduledoc """
  Schema for contact form submissions.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :message, :string
    field :status, :string, default: "new"
    field :ip_address, :string
    field :user_agent, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :email, :message, :status, :ip_address, :user_agent])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:message, min: 10, max: 5000)
    |> validate_inclusion(:status, ["new", "read", "replied"])
  end
end
