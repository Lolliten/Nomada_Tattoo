defmodule Nomada.Contact do
  @moduledoc """
  The Contact context for managing contact form submissions.
  """

  import Ecto.Query, warn: false
  alias Nomada.Repo
  alias Nomada.Contact.Message
  alias Nomada.Mailer
  import Swoosh.Email

  @doc """
  Returns the list of contact messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Message
    |> order_by([m], desc: m.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message and sends email notification.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    with {:ok, message} <-
           %Message{}
           |> Message.changeset(attrs)
           |> Repo.insert() do
      # Send email notification
      send_notification_email(message)

      {:ok, message}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Marks a message as read.

  ## Examples

      iex> mark_as_read(message)
      {:ok, %Message{}}

  """
  def mark_as_read(%Message{} = message) do
    update_message(message, %{status: "read"})
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  # Private functions

  defp send_notification_email(message) do
    email =
      new()
      |> to("nomadatatts@gmail.com")
      |> Swoosh.Email.from({"Nomada Website", "noreply@nomadatattoo.com"})
      |> subject("New Consultation Request from #{message.name}")
      |> html_body("""
      <h2>New Consultation Request</h2>
      <p><strong>Name:</strong> #{message.name}</p>
      <p><strong>Email:</strong> #{message.email}</p>
      <p><strong>Message:</strong></p>
      <p>#{String.replace(message.message, "\n", "<br>")}</p>
      <p><small>Submitted at: #{message.inserted_at}</small></p>
      """)
      |> text_body("""
      New Consultation Request

      Name: #{message.name}
      Email: #{message.email}

      Message:
      #{message.message}

      Submitted at: #{message.inserted_at}
      """)

    Mailer.deliver(email)
  end
end
