defmodule NomadaWeb.PageController do
  use NomadaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
