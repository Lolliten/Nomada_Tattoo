defmodule Nomada.Repo.Migrations.CreateContactMessages do
  use Ecto.Migration

  def change do
    create table(:contact_messages) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :message, :text, null: false
      add :status, :string, default: "new"
      add :ip_address, :string
      add :user_agent, :text

      timestamps(type: :utc_datetime)
    end

    create index(:contact_messages, [:status])
    create index(:contact_messages, [:inserted_at])
  end
end
