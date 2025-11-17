defmodule NomadaWeb.Components.UI.Portfolio do
  @moduledoc """
  Portfolio gallery section component.
  """
  use Phoenix.Component
  use NomadaWeb, :verified_routes

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @doc """
  Renders the portfolio gallery section with search and filtering.

  TODO: Backend integration needed
  - Create Tattoo schema (title, description, category, s3_url, cloudfront_url, tags)
  - Implement search and filter functionality
  - Add pagination for large galleries
  """
  attr :tattoos, :list, required: true

  def portfolio(assigns) do
    ~H"""
    <section id="portfolio" class="py-32 bg-[rgba(30,30,30,0.3)] min-h-screen">
      <div class="container mx-auto px-6">
        <div class="text-center mb-20">
          <h2 class="font-gothic text-7xl font-bold text-foreground mb-8">
            MY <span class="text-[var(--color-gold)]">PORTFOLIO</span>
          </h2>
          <p class="text-2xl text-[var(--color-muted)] max-w-3xl mx-auto leading-relaxed">
            Explore a curated selection of my tattoo artistry.
            Each tattoo is a unique expression of creativity and craftsmanship.
          </p>
        </div>
        <!-- Search and Filter -->
        <div class="max-w-4xl mx-auto mb-16">
          <div class="flex flex-col md:flex-row gap-6 items-center justify-center">
            <!-- Search -->
            <div class="relative flex-1 max-w-md">
              <.icon
                name="hero-magnifying-glass"
                class="absolute left-4 top-1/2 transform -translate-y-1/2 text-[var(--color-muted)] w-5 h-5"
              />
              <input
                type="text"
                placeholder="Search tattoos, styles, or tags..."
                class="w-full pl-12 pr-4 py-4 glass rounded-full text-foreground placeholder-[var(--color-muted)] focus:outline-none focus:ring-2 focus:ring-[var(--color-gold)] transition-all duration-300"
              />
            </div>
            <!-- Category Filter Buttons -->
            <div class="flex flex-wrap gap-3 justify-center">
              <%= for category <- ["All", "Geometric", "Realism", "Traditional", "Neo-Traditional"] do %>
                <button class="px-6 py-3 rounded-full font-bold text-sm tracking-wider transition-all duration-300 glass text-foreground hover:bg-[var(--color-gold)] hover:text-black border border-[var(--color-border)]">
                  {category}
                </button>
              <% end %>
            </div>
          </div>
        </div>
        <!-- Portfolio Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 max-w-8xl mx-auto">
          <%= for tattoo <- @tattoos do %>
            <div class="group relative glass rounded-2xl overflow-hidden shadow-elegant hover:shadow-glow transition-all duration-700 transform hover:scale-105 hover:-rotate-1">
              <div class="aspect-square overflow-hidden">
                <img
                  src={tattoo.image}
                  alt={tattoo.title}
                  class="w-full h-full object-cover image-zoom"
                />
              </div>

              <div class="absolute inset-0 bg-gradient-overlay opacity-0 group-hover:opacity-100 transition-opacity duration-500 flex items-end">
                <div class="p-6 text-white w-full">
                  <span class="inline-block px-4 py-2 bg-[var(--color-gold)] text-black text-sm font-bold rounded-full mb-4 glass">
                    {tattoo.category}
                  </span>
                  <h3 class="font-gothic text-2xl font-bold mb-3 tracking-wider">
                    {tattoo.title}
                  </h3>
                  <p class="text-gray-200 mb-4 leading-relaxed">{tattoo.description}</p>
                  <div class="flex flex-wrap gap-2">
                    <%= for tag <- tattoo.tags do %>
                      <span class="text-xs px-2 py-1 glass rounded-full text-gray-300">
                        #{tag}
                      </span>
                    <% end %>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>

        <div class="text-center mt-20">
          <p class="text-xl text-[var(--color-muted)] mb-8 font-medium">
            Interested in a custom tattoo? Let's discuss your ideas and create something unique
            together.
          </p>
          <a
            href="#contact"
            class="inline-block bg-gradient-gold text-black px-12 py-5 rounded-full font-bold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105 tracking-wider"
          >
            BOOK FREE CONSULTATION
          </a>
        </div>
      </div>
    </section>
    """
  end
end
