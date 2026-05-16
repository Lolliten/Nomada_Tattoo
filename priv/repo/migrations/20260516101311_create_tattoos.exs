defmodule Nomada.Repo.Migrations.CreateTattoos do
  use Ecto.Migration

  def change do
    create table(:tattoos) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :category, :string, null: false

      add :s3_key, :string
      add :s3_url, :string
      add :cloudfront_url, :string, null: false

      add :file_size, :integer
      add :content_type, :string
      add :width, :integer
      add :height, :integer

      add :featured, :boolean, default: false
      add :display_order, :integer, default: 0
      add :published, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create index(:tattoos, [:category])
    create index(:tattoos, [:featured])
    create index(:tattoos, [:published])
    create index(:tattoos, [:display_order])
  end
end
