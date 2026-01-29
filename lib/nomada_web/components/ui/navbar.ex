defmodule NomadaWeb.Components.UI.Navbar do
  @moduledoc """
  Navigation bar component with top bar (social links) and main navigation menu.
  """
  use Phoenix.Component
  use NomadaWeb, :verified_routes

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @doc """
  Renders the complete navigation including top bar and main menu.
  """
  attr :current_page, :atom, default: :home

  def navbar(assigns) do
    ~H"""
    <div>
      <.top_bar />
      <.navigation current_page={@current_page} />
    </div>
    """
  end

  @doc """
  Renders the top bar with social media links and studio address.
  """
  def top_bar(assigns) do
    ~H"""
    <div class="bg-background border-b border-[var(--color-border)] py-3 text-sm">
      <div class="container mx-auto px-6">
        <div class="flex items-center justify-between">
          <!-- Social Media -->
          <div class="flex items-center space-x-6">
            <a
              href="https://www.instagram.com/nomadatattoo?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
              target="_blank"
              rel="noopener noreferrer"
              class="text-[var(--color-gold)] hover:text-[var(--color-gold-light)] transition-colors flex items-center space-x-2"
            >
              <.icon name="hero-camera" class="w-5 h-5" />
              <span class="text-foreground">@NOMADATATTOO</span>
            </a>
            <a
              href="mailto:hello@nomada.art"
              class="text-[var(--color-gold)] hover:text-[var(--color-gold-light)] transition-colors flex items-center space-x-2"
            >
              <.icon name="hero-envelope" class="w-5 h-5" />
              <span class="text-foreground">NOMADATATTS@GMAIL.COM</span>
            </a>
          </div>
          <!-- Address -->
          <div class="hidden md:flex items-center space-x-2 text-[var(--color-muted)]">
            <.icon name="hero-map-pin" class="w-4 h-4" />
            <span>ÖSTGÖTAGATAN 79</span>
            <span class="text-foreground">11664, SÖDERMALM</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders the main navigation menu with smooth scroll anchor links.
  """
  attr :current_page, :atom, default: :home

  def navigation(assigns) do
    ~H"""
    <nav class="relative bg-background border-b border-[var(--color-border)]">
      <div class="container mx-auto px-6 py-6">
        <div class="flex items-center justify-center">
          <!-- Desktop Navigation -->
          <div class="hidden md:flex items-center justify-center space-x-8">
            <%= for {item, index} <- Enum.with_index([
              {"HOME", "/#home"},
              {"GALLERY", "/#gallery-preview"},
              {"CONTACT", "/#contact"},
              {"FULL PORTFOLIO", ~p"/portfolio"}
            ]) do %>
              <div class="flex items-center">
                <%= if String.starts_with?(elem(item, 1), "/#") do %>
                  <a
                    href={elem(item, 1)}
                    class="smooth-scroll relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 hover:scale-105 transform font-metal group nav-hex glass"
                  >
                    <span class="relative z-10">{elem(item, 0)}</span>
                    <div class="absolute inset-0 bg-foreground opacity-0 group-hover:opacity-20 transition-opacity duration-300 nav-hex" />
                  </a>
                <% else %>
                  <.link
                    navigate={elem(item, 1)}
                    class="relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 hover:scale-105 transform font-metal group nav-hex glass"
                  >
                    <span class="relative z-10">{elem(item, 0)}</span>
                    <div class="absolute inset-0 bg-foreground opacity-0 group-hover:opacity-20 transition-opacity duration-300 nav-hex" />
                  </.link>
                <% end %>
                <%= if index == 0 do %>
                  <div class="ml-8 w-px h-8 bg-[var(--color-gold)] opacity-30"></div>
                <% end %>
              </div>
            <% end %>
          </div>
          <!-- Mobile Menu Button -->
          <button
            class="md:hidden text-foreground"
            phx-click={toggle_mobile_menu()}
          >
            <.icon name="hero-bars-3" class="w-6 h-6" />
          </button>
        </div>
        <!-- Mobile Navigation -->
        <div
          id="mobile-menu"
          class="hidden md:hidden mt-4 pb-4 border-t border-[var(--color-border)]"
        >
          <div class="flex flex-col space-y-4 pt-4">
            <%= for {label, href} <- [
              {"HOME", "/#home"},
              {"GALLERY", "/#gallery-preview"},
              {"CONTACT", "/#contact"},
              {"FULL PORTFOLIO", ~p"/portfolio"}
            ] do %>
              <%= if String.starts_with?(href, "/#") do %>
                <a
                  href={href}
                  class="smooth-scroll relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 text-center hover:scale-105 transform font-metal nav-hex glass"
                  phx-click={toggle_mobile_menu()}
                >
                  {label}
                </a>
              <% else %>
                <.link
                  navigate={href}
                  class="relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 text-center hover:scale-105 transform font-metal nav-hex glass"
                >
                  {label}
                </.link>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  defp toggle_mobile_menu do
    Phoenix.LiveView.JS.toggle(to: "#mobile-menu")
  end
end
