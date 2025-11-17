defmodule NomadaWeb.Components.UI.Footer do
  @moduledoc """
  Footer component with links and contact information.
  """
  use Phoenix.Component
  use NomadaWeb, :verified_routes

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @doc """
  Renders the page footer with links and social media.
  """
  def footer(assigns) do
    ~H"""
    <footer class="bg-background border-t border-[var(--color-border)] py-12">
      <div class="container mx-auto px-6">
        <div class="max-w-6xl mx-auto">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <!-- Brand -->
            <div class="text-center md:text-left">
              <h3 class="font-display text-2xl font-bold text-[var(--color-gold)] mb-4">NOMADA</h3>
              <p class="text-[var(--color-muted)] mb-4">
                Professional tattoo artist in Södermalm, Stockholm.
                Creates unique tattoos with my own style.
              </p>
              <div class="flex justify-center md:justify-start space-x-4">
                <a
                  href="https://instagram.com/nomada_ink"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  <.icon name="hero-camera" class="w-6 h-6" />
                </a>
                <a
                  href="mailto:hello@nomada.art"
                  class="text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  <.icon name="hero-envelope" class="w-6 h-6" />
                </a>
                <a
                  href="https://maps.google.com/?q=Södermalm,Stockholm"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  <.icon name="hero-map-pin" class="w-6 h-6" />
                </a>
              </div>
            </div>
            <!-- Quick Links -->
            <div class="text-center">
              <h4 class="font-semibold text-foreground mb-4">Quick Links</h4>
              <div class="space-y-2">
                <.link
                  navigate={~p"/portfolio"}
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  Portfolio
                </.link>
                <.link
                  navigate={~p"/about"}
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  About Me
                </.link>
                <.link
                  navigate={~p"/contact"}
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  Contact
                </.link>
              </div>
            </div>
            <!-- Contact Info -->
            <div class="text-center md:text-right">
              <h4 class="font-semibold text-foreground mb-4">Contact</h4>
              <div class="space-y-2 text-[var(--color-muted)]">
                <p>Södermalm, Stockholm</p>
                <p>+46 72 309 37 55</p>
                <p>nomadatatts@gmail.com</p>
              </div>
            </div>
          </div>

          <div class="border-t border-[var(--color-border)] pt-8 text-center">
            <p class="text-[var(--color-muted)]">
              © 2025 Nomada Tattoo Artist. All rights reserved.
            </p>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
