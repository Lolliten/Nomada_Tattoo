defmodule Nomada.Repo.Migrations.SimplifyTattoosImageFields do
  use Ecto.Migration

  def change do
    alter table(:tattoos) do
      remove :s3_key
      remove :s3_url
    end

    rename table(:tattoos), :cloudfront_url, to: :image_url
  end
end
