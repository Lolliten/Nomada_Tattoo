# Phase 3: AWS S3 Integration & Image Upload

This document outlines the steps to implement AWS S3 storage for tattoo images.

## Overview

Replace local image storage with AWS S3 for:
- Scalable image storage
- Professional URL structure
- Easy backup and management
- Cost-effective at scale

## Step 1: Set Up AWS S3

### 1.1 Create S3 Bucket
```bash
# AWS CLI
aws s3 mb s3://nomada-tattoo-portfolio --region eu-north-1
```

Or via AWS Console:
1. Go to S3 service
2. Click "Create bucket"
3. Name: `nomada-tattoo-portfolio`
4. Region: `eu-north-1` (or your preferred region)
5. Block public access: **OFF** (we need public read)
6. Create bucket

### 1.2 Configure Bucket Policy
Add this policy to allow public read access:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::nomada-tattoo-portfolio/*"
    }
  ]
}
```

### 1.3 Enable CORS (for uploads)
```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
```

### 1.4 Create IAM User
1. Create user: `nomada-uploader`
2. Attach policy: `AmazonS3FullAccess` (or custom policy)
3. Generate access key
4. Save credentials securely

## Step 2: Add Dependencies

### 2.1 Update `mix.exs`
```elixir
defp deps do
  [
    # ... existing deps
    {:ex_aws, "~> 2.5"},
    {:ex_aws_s3, "~> 2.5"},
    {:sweet_xml, "~> 0.7"},
    {:hackney, "~> 1.20"}
  ]
end
```

### 2.2 Install
```bash
mix deps.get
```

## Step 3: Configure Application

### 3.1 Create `.env-example`
```bash
# AWS Configuration
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_REGION=eu-north-1
S3_BUCKET_NAME=nomada-tattoo-portfolio
```

### 3.2 Update `config/runtime.exs`
```elixir
if config_env() == :prod do
  config :ex_aws,
    access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
    region: System.get_env("AWS_REGION") || "eu-north-1"

  config :nomada,
    s3_bucket: System.get_env("S3_BUCKET_NAME")
end
```

### 3.3 Add to `config/dev.exs` (for local testing)
```elixir
config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION") || "eu-north-1"

config :nomada,
  s3_bucket: System.get_env("S3_BUCKET_NAME")
```

## Step 4: Create Upload Module

### 4.1 Create `lib/nomada/storage.ex`
```elixir
defmodule Nomada.Storage do
  @moduledoc """
  Handles image uploads to AWS S3.
  """

  alias ExAws.S3

  @bucket Application.compile_env(:nomada, :s3_bucket)

  def upload_image(file_path, filename) do
    key = generate_key(filename)
    content_type = MIME.from_path(filename)

    case S3.put_object(@bucket, key, File.read!(file_path),
           acl: :public_read,
           content_type: content_type
         )
         |> ExAws.request() do
      {:ok, _} ->
        {:ok, %{
          image_url: image_url(key),
          content_type: content_type,
          file_size: File.stat!(file_path).size
        }}

      {:error, error} ->
        {:error, error}
    end
  end

  def delete_image(image_url) do
    key = extract_key_from_url(image_url)

    S3.delete_object(@bucket, key)
    |> ExAws.request()
  end

  defp generate_key(filename) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    uuid = Ecto.UUID.generate() |> String.slice(0..7)
    ext = Path.extname(filename)

    "tattoos/#{timestamp}_#{uuid}#{ext}"
  end

  defp image_url(key) do
    region = Application.get_env(:ex_aws, :region, "eu-north-1")
    "https://#{@bucket}.s3.#{region}.amazonaws.com/#{key}"
  end

  defp extract_key_from_url(url) do
    # Extract key from S3 URL
    url
    |> String.split("/")
    |> Enum.drop(3)
    |> Enum.join("/")
  end
end
```

## Step 5: Create Upload Script

### 5.1 Create `priv/scripts/upload_tattoo.exs`
```elixir
# Usage: mix run priv/scripts/upload_tattoo.exs path/to/image.jpg "Title" "Description" "Category"

[file_path, title, description, category] = System.argv()

alias Nomada.Storage
alias Nomada.Gallery

IO.puts("Uploading #{file_path}...")

case Storage.upload_image(file_path, Path.basename(file_path)) do
  {:ok, %{image_url: image_url, content_type: content_type, file_size: file_size}} ->
    IO.puts("✅ Uploaded to: #{image_url}")

    attrs = %{
      title: title,
      description: description,
      category: category,
      image_url: image_url,
      content_type: content_type,
      file_size: file_size,
      published: true,
      display_order: 0
    }

    case Gallery.create_tattoo(attrs) do
      {:ok, tattoo} ->
        IO.puts("✅ Created tattoo ##{tattoo.id}: #{tattoo.title}")
      {:error, changeset} ->
        IO.puts("❌ Error creating tattoo: #{inspect(changeset.errors)}")
    end

  {:error, error} ->
    IO.puts("❌ Upload failed: #{inspect(error)}")
end
```

### 5.2 Usage
```bash
mix run priv/scripts/upload_tattoo.exs \
  ~/Desktop/tattoo.jpg \
  "Dragon Sleeve" \
  "Full sleeve Japanese dragon design" \
  "Neo-Traditional"
```

## Step 6: Add Bulk Upload Script

### 6.1 Create `priv/scripts/bulk_upload.exs`
```elixir
# Usage: mix run priv/scripts/bulk_upload.exs path/to/images/

[images_dir] = System.argv()

alias Nomada.Storage
alias Nomada.Gallery

IO.puts("Scanning #{images_dir}...")

Path.wildcard("#{images_dir}/*.{jpg,jpeg,png,JPG,JPEG,PNG}")
|> Enum.each(fn file_path ->
  filename = Path.basename(file_path, Path.extname(file_path))

  # Extract metadata from filename
  # Format: category-title-###.jpg
  [category_slug, title_slug | _] = String.split(filename, "-")

  category = case category_slug do
    "blackwork" -> "Blackwork"
    "neo" -> "Neo-Traditional"
    "dot" -> "Dot-Work"
    _ -> "Blackwork"
  end

  title = title_slug
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")

  IO.puts("\nUploading: #{filename}")

  case Storage.upload_image(file_path, Path.basename(file_path)) do
    {:ok, %{image_url: image_url, content_type: content_type, file_size: file_size}} ->
      attrs = %{
        title: title,
        description: "#{category} tattoo - #{title}",
        category: category,
        image_url: image_url,
        content_type: content_type,
        file_size: file_size,
        published: true,
        display_order: 0
      }

      case Gallery.create_tattoo(attrs) do
        {:ok, tattoo} ->
          IO.puts("✅ #{tattoo.title}")
        {:error, _} ->
          IO.puts("❌ Failed to create database entry")
      end

    {:error, _} ->
      IO.puts("❌ Upload failed")
  end

  # Rate limiting
  Process.sleep(500)
end)

IO.puts("\n✅ Bulk upload complete!")
```

### 6.2 Usage
Prepare files with naming convention:
```
blackwork-geometric-mandala-001.jpg
neo-traditional-rose-002.jpg
dot-work-sacred-geometry-003.jpg
```

Then run:
```bash
mix run priv/scripts/bulk_upload.exs ~/Desktop/tattoo_images/
```

## Step 7: Optional - Admin Upload Interface

Create a LiveView page for uploading images through the browser.

### 7.1 Create `lib/nomada_web/live/admin/upload_live.ex`
```elixir
defmodule NomadaWeb.Admin.UploadLive do
  use NomadaWeb, :live_view

  alias Nomada.Gallery
  alias Nomada.Storage

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 10_000_000
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"tattoo" => tattoo_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        filename = entry.client_name

        case Storage.upload_image(path, filename) do
          {:ok, upload_data} ->
            attrs = Map.merge(tattoo_params, upload_data)
            {:ok, Gallery.create_tattoo(attrs)}
          error ->
            error
        end
      end)

    {:noreply,
     socket
     |> put_flash(:info, "Tattoo uploaded successfully!")
     |> assign(:uploaded_files, uploaded_files)}
  end

  # ... render function with form
end
```

## Testing

### Local Testing
1. Set environment variables in `.env`
2. Load with: `source .env`
3. Test upload:
```bash
iex -S mix
iex> Nomada.Storage.upload_image("test.jpg", "test.jpg")
```

### Verify Upload
Check S3 console or visit the generated URL.

## Deployment Checklist

- [ ] S3 bucket created and configured
- [ ] IAM user created with access keys
- [ ] Environment variables set on hosting platform
- [ ] Dependencies added and installed
- [ ] Upload scripts tested locally
- [ ] All existing tattoo images uploaded to S3
- [ ] Database updated with S3 URLs
- [ ] Old local images backed up and removed

## Cost Estimate

**AWS S3 Pricing (eu-north-1):**
- Storage: $0.023 per GB/month
- Requests: $0.005 per 1000 PUT, $0.0004 per 1000 GET

**Example for 1000 images:**
- 1000 images × 5MB = 5GB storage
- Storage: 5GB × $0.023 = ~$0.12/month
- Requests: ~10k GET/month = ~$0.004
- **Total: ~$0.15/month**

Very affordable! CloudFront can be added later if needed.

## Rollback Plan

If S3 integration has issues:
1. Keep local images as backup
2. Add `image_url` fallback in view:
```elixir
src={tattoo.image_url || "/images/tattoo/#{tattoo.id}.jpg"}
```
3. Can revert to local serving anytime
