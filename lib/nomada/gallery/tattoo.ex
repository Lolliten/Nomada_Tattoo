defmodule Nomada.Gallery.Tattoo do
  @moduledoc """
  Schema for tattoo gallery items.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tattoos" do
    field :title, :string
    field :description, :string
    field :category, :string

    # S3 & CloudFront URLs
    field :s3_key, :string
    field :s3_url, :string
    field :cloudfront_url, :string

    # Image metadata
    field :file_size, :integer
    field :content_type, :string
    field :width, :integer
    field :height, :integer

    # Display options
    field :featured, :boolean, default: false
    field :display_order, :integer, default: 0
    field :published, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tattoo, attrs) do
    tattoo
    |> cast(attrs, [
      :title,
      :description,
      :category,
      :s3_key,
      :s3_url,
      :cloudfront_url,
      :file_size,
      :content_type,
      :width,
      :height,
      :featured,
      :display_order,
      :published
    ])
    |> validate_required([:title, :description, :category, :cloudfront_url])
    |> validate_inclusion(:category, ["Blackwork", "Neo-Traditional", "Dot-Work"])
    |> validate_length(:title, min: 2, max: 255)
    |> validate_length(:description, min: 10, max: 5000)
  end
end
