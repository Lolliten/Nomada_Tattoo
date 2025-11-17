defmodule NomadaWeb.Components.UI.About do
  @moduledoc """
  About section component.
  """
  use Phoenix.Component

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @doc """
  Renders the about section with feature cards.
  """
  attr :features, :list, required: true

  def about(assigns) do
    ~H"""
    <section id="about" class="py-24 bg-background">
      <div class="container mx-auto px-6">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="font-display text-5xl font-bold text-foreground mb-6">
              About <span class="text-[var(--color-gold)]">Nomada</span>
            </h2>
            <p class="text-xl text-[var(--color-muted)] max-w-3xl mx-auto leading-relaxed">
              As a professional tattoo artist in Södermalm,
              Stockholm, I want to create unique, personal tattoos that reflect my style and your story.
              My studio is a place where creativity meets professionalism.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-16">
            <%= for feature <- @features do %>
              <div class="glass p-8 rounded-xl shadow-elegant hover:shadow-glow transition-all duration-300 text-center group">
                <div class="mb-4 flex justify-center group-hover:scale-110 transition-transform duration-300">
                  <.icon name={feature.icon} class="w-8 h-8 text-[var(--color-gold)]" />
                </div>
                <h3 class="font-display text-xl font-semibold text-foreground mb-3">
                  {feature.title}
                </h3>
                <p class="text-[var(--color-muted)] text-sm leading-relaxed">
                  {feature.description}
                </p>
              </div>
            <% end %>
          </div>

          <div class="bg-gradient-hero p-12 rounded-2xl text-center">
            <h3 class="font-display text-3xl font-bold text-foreground mb-4">
              Ready for Your Next Tattoo?
            </h3>
            <p class="text-xl text-[var(--color-muted)] mb-8 max-w-2xl mx-auto">
              Let's discuss your ideas and create something together.
              Book a free consultation today to begin your tattoo journey.
            </p>
            <a
              href="#contact"
              class="inline-block bg-gradient-gold text-black px-10 py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
            >
              Book a Free Consultation Now
            </a>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
