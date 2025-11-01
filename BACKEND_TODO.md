# Backend Implementation TODO

This document outlines all the backend features that need to be implemented for the Nomada Tattoo Artist portfolio website.

## 1. Database Schema

### Tattoo Schema
Create a `Tattoo` schema for portfolio items:

```elixir
# lib/nomada/portfolio/tattoo.ex
defmodule Nomada.Portfolio.Tattoo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tattoos" do
    field :title, :string
    field :description, :text
    field :category, :string  # "Geometric", "Realism", "Traditional", "Neo-Traditional"
    field :tags, {:array, :string}

    # S3 & CloudFront URLs
    field :s3_key, :string          # S3 object key
    field :s3_url, :string          # Full S3 URL
    field :cloudfront_url, :string  # CloudFront CDN URL

    # Image metadata
    field :file_size, :integer
    field :content_type, :string
    field :width, :integer
    field :height, :integer

    # Display options
    field :featured, :boolean, default: false
    field :display_order, :integer
    field :published, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  def changeset(tattoo, attrs) do
    tattoo
    |> cast(attrs, [:title, :description, :category, :tags, :s3_key, :s3_url,
                    :cloudfront_url, :file_size, :content_type, :width, :height,
                    :featured, :display_order, :published])
    |> validate_required([:title, :description, :category, :s3_url, :cloudfront_url])
    |> validate_inclusion(:category, ["Geometric", "Realism", "Traditional", "Neo-Traditional"])
  end
end
```

### Contact Schema
Create a `Contact` schema for form submissions:

```elixir
# lib/nomada/contact/message.ex
defmodule Nomada.Contact.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :message, :text
    field :phone, :string
    field :status, :string, default: "new"  # "new", "read", "replied"
    field :ip_address, :string
    field :user_agent, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :email, :message, :phone, :status, :ip_address, :user_agent])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:message, min: 10, max: 5000)
  end
end
```

## 2. Context Modules

### Portfolio Context
```elixir
# lib/nomada/portfolio.ex
defmodule Nomada.Portfolio do
  import Ecto.Query
  alias Nomada.Repo
  alias Nomada.Portfolio.Tattoo

  def list_tattoos(opts \\ []) do
    Tattoo
    |> filter_by_category(opts[:category])
    |> filter_by_search(opts[:search])
    |> filter_published()
    |> order_by_display_order()
    |> Repo.all()
  end

  def get_tattoo!(id), do: Repo.get!(Tattoo, id)

  def create_tattoo(attrs \\ %{}) do
    %Tattoo{}
    |> Tattoo.changeset(attrs)
    |> Repo.insert()
  end

  def update_tattoo(%Tattoo{} = tattoo, attrs) do
    tattoo
    |> Tattoo.changeset(attrs)
    |> Repo.update()
  end

  def delete_tattoo(%Tattoo{} = tattoo) do
    Repo.delete(tattoo)
  end

  # Private query helpers
  defp filter_by_category(query, nil), do: query
  defp filter_by_category(query, category) do
    where(query, [t], t.category == ^category)
  end

  defp filter_by_search(query, nil), do: query
  defp filter_by_search(query, search) do
    search_pattern = "%#{search}%"
    where(query, [t],
      ilike(t.title, ^search_pattern) or
      ilike(t.description, ^search_pattern) or
      fragment("? && string_to_array(?, ',')", t.tags, ^search_pattern)
    )
  end

  defp filter_published(query) do
    where(query, [t], t.published == true)
  end

  defp order_by_display_order(query) do
    order_by(query, [t], [asc: t.display_order, desc: t.inserted_at])
  end
end
```

### Contact Context
```elixir
# lib/nomada/contact.ex
defmodule Nomada.Contact do
  alias Nomada.Repo
  alias Nomada.Contact.Message
  alias Nomada.Mailer
  alias Nomada.Contact.NotificationEmail

  def create_message(attrs \\ %{}) do
    with {:ok, message} <- %Message{}
                          |> Message.changeset(attrs)
                          |> Repo.insert() do
      # Send email notification
      message
      |> NotificationEmail.new_contact()
      |> Mailer.deliver()

      {:ok, message}
    end
  end

  def list_messages do
    Repo.all(Message)
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def mark_as_read(message) do
    update_message(message, %{status: "read"})
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end
end
```

## 3. AWS S3 & CloudFront Integration

### Dependencies
Add to `mix.exs`:

```elixir
{:ex_aws, "~> 2.5"},
{:ex_aws_s3, "~> 2.5"},
{:sweet_xml, "~> 0.7"},
{:hackney, "~> 1.20"}
```

### Configuration
Add to `config/runtime.exs` (NOT config.exs for security):

```elixir
config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION") || "eu-north-1"

config :nomada,
  s3_bucket: System.get_env("S3_BUCKET_NAME"),
  cloudfront_domain: System.get_env("CLOUDFRONT_DOMAIN")
```

### Upload Module
```elixir
# lib/nomada/storage/upload.ex
defmodule Nomada.Storage.Upload do
  alias ExAws.S3

  @bucket Application.compile_env(:nomada, :s3_bucket)
  @cloudfront_domain Application.compile_env(:nomada, :cloudfront_domain)

  def upload_tattoo_image(file_path, filename) do
    key = generate_key(filename)

    case S3.put_object(@bucket, key, File.read!(file_path),
                        acl: :public_read,
                        content_type: MIME.from_path(filename))
         |> ExAws.request() do
      {:ok, _} ->
        {:ok, %{
          s3_key: key,
          s3_url: s3_url(key),
          cloudfront_url: cloudfront_url(key)
        }}
      {:error, error} -> {:error, error}
    end
  end

  def delete_image(s3_key) do
    S3.delete_object(@bucket, s3_key)
    |> ExAws.request()
  end

  defp generate_key(filename) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    uuid = Ecto.UUID.generate()
    ext = Path.extname(filename)
    "tattoos/#{timestamp}_#{uuid}#{ext}"
  end

  defp s3_url(key) do
    "https://#{@bucket}.s3.amazonaws.com/#{key}"
  end

  defp cloudfront_url(key) do
    "https://#{@cloudfront_domain}/#{key}"
  end
end
```

## 4. Email Notifications

### Email Template
```elixir
# lib/nomada/contact/notification_email.ex
defmodule Nomada.Contact.NotificationEmail do
  import Swoosh.Email

  def new_contact(message) do
    new()
    |> to("hello@nomada.art")
    |> from({"Nomada Website", "noreply@nomada.art"})
    |> subject("New Contact Form Submission")
    |> html_body("""
      <h2>New Contact Message</h2>
      <p><strong>Name:</strong> #{message.name}</p>
      <p><strong>Email:</strong> #{message.email}</p>
      <p><strong>Phone:</strong> #{message.phone}</p>
      <p><strong>Message:</strong></p>
      <p>#{message.message}</p>
      <p><small>Submitted at: #{message.inserted_at}</small></p>
    """)
  end
end
```

## 5. Admin Panel (Future Feature)

Create a LiveView admin panel for managing portfolio and contacts:

- `/admin/tattoos` - CRUD for portfolio items
- `/admin/tattoos/upload` - Image upload interface
- `/admin/contacts` - View contact form submissions
- Add authentication with `phx.gen.auth`

## 6. Migrations

### Create Tattoos Table
```bash
mix ecto.gen.migration create_tattoos
```

```elixir
defmodule Nomada.Repo.Migrations.CreateTattoos do
  use Ecto.Migration

  def change do
    create table(:tattoos) do
      add :title, :string, null: false
      add :description, :text, null: false
      add :category, :string, null: false
      add :tags, {:array, :string}, default: []

      add :s3_key, :string, null: false
      add :s3_url, :string, null: false
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
```

### Create Contact Messages Table
```bash
mix ecto.gen.migration create_contact_messages
```

```elixir
defmodule Nomada.Repo.Migrations.CreateContactMessages do
  use Ecto.Migration

  def change do
    create table(:contact_messages) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :message, :text, null: false
      add :phone, :string
      add :status, :string, default: "new"
      add :ip_address, :string
      add :user_agent, :text

      timestamps(type: :utc_datetime)
    end

    create index(:contact_messages, [:status])
    create index(:contact_messages, [:inserted_at])
  end
end
```

## 7. LiveView Updates

Update components to use real data from contexts:

### Portfolio Component
```elixir
# In page_components.ex, replace static data with:
assigns = assign(assigns, :tattoos, Nomada.Portfolio.list_tattoos())
```

### Contact Form
Create a LiveView for the contact form with real-time validation:

```elixir
# lib/nomada_web/live/contact_live.ex
defmodule NomadaWeb.ContactLive do
  use NomadaWeb, :live_view

  alias Nomada.Contact
  alias Nomada.Contact.Message

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(Contact.change_message(%Message{})))}
  end

  def handle_event("validate", %{"message" => message_params}, socket) do
    # Validate and show errors
  end

  def handle_event("submit", %{"message" => message_params}, socket) do
    case Contact.create_message(message_params) do
      {:ok, _message} ->
        # Show success message
      {:error, changeset} ->
        # Show errors
    end
  end
end
```

## 8. Environment Variables

Create `.env-example` file (as per user's instructions, don't edit .env directly):

```bash
# AWS Configuration
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=eu-north-1
S3_BUCKET_NAME=nomada-tattoo-portfolio
CLOUDFRONT_DOMAIN=your-cloudfront-id.cloudfront.net

# Email Configuration
SMTP_RELAY=smtp.sendgrid.net
SMTP_USERNAME=apikey
SMTP_PASSWORD=your_sendgrid_api_key
SMTP_PORT=587

# Database
DATABASE_URL=ecto://postgres:postgres@localhost/nomada_dev
```

## 9. Next Steps

1. Run migrations: `mix ecto.migrate`
2. Install AWS dependencies: `mix deps.get`
3. Set up AWS S3 bucket and CloudFront distribution
4. Configure environment variables
5. Create admin authentication system
6. Build admin LiveView interfaces
7. Update frontend components to use real data
8. Set up production email service (SendGrid, Mailgun, etc.)
9. Add rate limiting for contact form
10. Implement image optimization pipeline

## Notes

- Store only metadata in PostgreSQL, never the actual image files
- Use CloudFront for CDN delivery to ensure fast global access
- Implement proper authentication for admin panel
- Add logging for S3 operations
- Consider adding image thumbnails for faster gallery loading
- Implement proper CSRF protection for forms
- Add honeypot fields to contact form to prevent spam
