defmodule NomadaWeb.HomeLive do
  @moduledoc """
  Home page with hero section.
  """
  use NomadaWeb, :live_view

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section
      id="home"
      class="relative min-h-screen flex items-center justify-center overflow-hidden pt-0"
    >
      <!-- Background Image -->
      <div class="absolute inset-0 z-0">
        <img
          src={~p"/images/nomada-logo.jpg"}
          alt="Nomada gas mask logo"
          class="w-full h-full object-cover opacity-20"
          style="filter: invert(1);"
        />
        <div class="absolute inset-0 bg-gradient-overlay"></div>
      </div>
      <!-- Content -->
      <div class="relative z-10 text-center px-6 max-w-4xl">
        <div class="mb-8">
          <img
            src={~p"/images/nomada-logo.jpg"}
            alt="Nomada Logo"
            class="mx-auto h-32 md:h-40 w-auto mb-6"
            style="filter: invert(1);"
          />
        </div>

        <h1 class="font-gothic text-6xl md:text-8xl font-bold mb-6 text-foreground tracking-wider">
          <span class="block drop-shadow-lg">NOMADA</span>
          <span class="block text-[var(--color-gold)] text-4xl md:text-5xl font-bold mt-2 tracking-widest">
            TATTOO ARTIST
          </span>
        </h1>

        <p class="text-xl md:text-2xl text-[var(--color-muted)] mb-8 max-w-2xl mx-auto">
          Professional tattoo artist in Södermalm, Stockholm.
          Creating unique tattoos.
        </p>

        <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <.link
            navigate={~p"/portfolio"}
            class="bg-gradient-gold text-black px-8 py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
          >
            My Portfolio
          </.link>
          <.link
            navigate={~p"/contact"}
            class="border-2 border-[var(--color-gold)] text-[var(--color-gold)] px-8 py-4 rounded-lg font-semibold text-lg hover:bg-[var(--color-gold)] hover:text-black transition-all duration-300"
          >
            Book Free Consultation
          </.link>
        </div>
      </div>
      <!-- Scroll Indicator -->
      <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-10">
        <.icon name="hero-chevron-down" class="text-[var(--color-gold)] animate-bounce w-8 h-8" />
      </div>
    </section>
    """
  end
end
