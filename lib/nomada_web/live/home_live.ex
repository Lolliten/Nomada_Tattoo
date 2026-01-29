defmodule NomadaWeb.HomeLive do
  @moduledoc """
  Single-page home with hero, gallery preview, and contact form sections.
  """
  use NomadaWeb, :live_view

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @impl true
  def mount(_params, _session, socket) do
    # Sample tattoos for gallery preview (TODO: Replace with database query)
    preview_tattoos = [
      %{
        id: 1,
        image: "/images/tattoo/tattoo-1.jpg",
        title: "Geometric Mandala",
        category: "Geometric"
      },
      %{
        id: 2,
        image: "/images/tattoo/tattoo-2.jpg",
        title: "Realistic Portrait",
        category: "Realism"
      },
      %{
        id: 3,
        image: "/images/tattoo/tattoo-3.jpg",
        title: "Japanese Dragon",
        category: "Traditional"
      },
      %{
        id: 4,
        image: "/images/tattoo/tattoo-1.jpg",
        title: "Sacred Geometry",
        category: "Geometric"
      },
      %{
        id: 5,
        image: "/images/tattoo/tattoo-2.jpg",
        title: "Dark Portrait",
        category: "Realism"
      },
      %{
        id: 6,
        image: "/images/tattoo/tattoo-3.jpg",
        title: "Neo Traditional",
        category: "Neo-Traditional"
      }
    ]

    contact_info = [
      %{
        icon: "hero-map-pin",
        title: "Studio Address",
        details: ["Östgötagatan 79", "11664 Södermalm, Stockholm"],
        link: "https://maps.google.com/?q=Östgötagatan+79,Stockholm"
      },
      %{
        icon: "hero-phone",
        title: "Phone",
        details: ["+46 72 309 37 55"],
        link: "tel:+46723093755"
      },
      %{
        icon: "hero-envelope",
        title: "Email",
        details: ["nomadatatts@gmail.com"],
        link: "mailto:nomadatatts@gmail.com"
      },
      %{
        icon: "hero-clock",
        title: "Opening Hours",
        details: ["By Appointment Only", "Flexible scheduling available"],
        link: nil
      }
    ]

    {:ok, assign(socket, preview_tattoos: preview_tattoos, contact_info: contact_info)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <!-- Hero Section -->
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

          <p class="text-xl md:text-2xl text-[var(--color-muted)] mb-4 max-w-2xl mx-auto">
            Professional tattoo artist in Södermalm, Stockholm.
          </p>
          <p class="text-lg md:text-xl text-[var(--color-muted)] mb-8 max-w-3xl mx-auto leading-relaxed">
            Over 20 years of experience creating unique, personal tattoos that reflect
            both artistic vision and your story. My studio is a welcoming space where
            creativity meets professionalism.
          </p>

          <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <.link
              navigate={~p"/portfolio"}
              class="bg-gradient-gold text-black px-8 py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
            >
              View Full Portfolio
            </.link>
            <a
              href="#contact"
              class="border-2 border-[var(--color-gold)] text-[var(--color-gold)] px-8 py-4 rounded-lg font-semibold text-lg hover:bg-[var(--color-gold)] hover:text-black transition-all duration-300"
            >
              Book Free Consultation
            </a>
          </div>
        </div>
        <!-- Scroll Indicator -->
        <a
          href="#gallery-preview"
          class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-10"
        >
          <.icon name="hero-chevron-down" class="text-[var(--color-gold)] animate-bounce w-8 h-8" />
        </a>
      </section>
      <!-- Gallery Preview Section -->
      <section id="gallery-preview" class="py-24 bg-[rgba(30,30,30,0.2)]">
        <div class="container mx-auto px-6">
          <div class="text-center mb-16">
            <h2 class="font-gothic text-5xl md:text-6xl font-bold text-foreground mb-6">
              RECENT <span class="text-[var(--color-gold)]">WORK</span>
            </h2>
            <p class="text-xl text-[var(--color-muted)] max-w-3xl mx-auto">
              A selection of my latest tattoo artistry. Each piece tells a unique story.
            </p>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
            <%= for tattoo <- @preview_tattoos do %>
              <div class="group relative glass rounded-2xl overflow-hidden shadow-elegant hover:shadow-glow transition-all duration-500 transform hover:scale-105">
                <div class="aspect-square overflow-hidden">
                  <img
                    src={tattoo.image}
                    alt={tattoo.title}
                    class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                </div>
                <div class="absolute inset-0 bg-gradient-overlay opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end">
                  <div class="p-6 text-white w-full">
                    <span class="inline-block px-4 py-2 bg-[var(--color-gold)] text-black text-sm font-bold rounded-full mb-3">
                      {tattoo.category}
                    </span>
                    <h3 class="font-gothic text-xl font-bold tracking-wider">
                      {tattoo.title}
                    </h3>
                  </div>
                </div>
              </div>
            <% end %>
          </div>

          <div class="text-center mt-16">
            <.link
              navigate={~p"/portfolio"}
              class="inline-block bg-gradient-gold text-black px-10 py-4 rounded-full font-bold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105 tracking-wider"
            >
              VIEW FULL PORTFOLIO
            </.link>
          </div>
        </div>
      </section>
      <!-- Contact Section -->
      <section id="contact" class="py-24 bg-background">
        <div class="container mx-auto px-6">
          <div class="max-w-6xl mx-auto">
            <div class="text-center mb-16">
              <h2 class="font-gothic text-5xl md:text-6xl font-bold text-foreground mb-6">
                GET IN <span class="text-[var(--color-gold)]">TOUCH</span>
              </h2>
              <p class="text-xl text-[var(--color-muted)] max-w-3xl mx-auto">
                Have questions or want to book a consultation? I look forward to hearing from you
                and discussing your ideas for your next tattoo.
              </p>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
              <!-- Contact Information -->
              <div>
                <h3 class="font-display text-3xl font-semibold text-foreground mb-8">
                  Contact Information
                </h3>

                <div class="space-y-6">
                  <%= for info <- @contact_info do %>
                    <div class="flex items-start space-x-4 group">
                      <div class="text-[var(--color-gold)] group-hover:scale-110 transition-transform duration-300 mt-1">
                        <.icon name={info.icon} class="w-6 h-6" />
                      </div>
                      <div>
                        <h4 class="font-semibold text-foreground mb-2">{info.title}</h4>
                        <%= for detail <- info.details do %>
                          <p class="text-[var(--color-muted)]">
                            <%= if info.link do %>
                              <a
                                href={info.link}
                                class="hover:text-[var(--color-gold)] transition-colors duration-300"
                                target={if String.starts_with?(info.link, "http"), do: "_blank"}
                                rel={
                                  if String.starts_with?(info.link, "http"), do: "noopener noreferrer"
                                }
                              >
                                {detail}
                              </a>
                            <% else %>
                              {detail}
                            <% end %>
                          </p>
                        <% end %>
                      </div>
                    </div>
                  <% end %>
                </div>
                <!-- Social Media -->
                <div class="mt-12">
                  <h4 class="font-display text-2xl font-semibold text-foreground mb-6">
                    Follow My Work
                  </h4>
                  <div class="flex flex-col space-y-4">
                    <a
                      href="https://www.instagram.com/nomadatattoo?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
                      target="_blank"
                      rel="noopener noreferrer"
                      class="flex items-center space-x-3 glass p-4 rounded-lg hover:bg-[var(--color-gold)] hover:text-black transition-all duration-300 group"
                    >
                      <span class="text-[var(--color-gold)] group-hover:text-black">
                        <.icon name="hero-camera" class="w-6 h-6" />
                      </span>
                      <div>
                        <p class="font-medium">Instagram</p>
                        <p class="text-sm text-[var(--color-muted)] group-hover:text-black">
                          @nomadatattoo
                        </p>
                      </div>
                    </a>
                    <a
                      href="https://wa.me/46723093755"
                      target="_blank"
                      rel="noopener noreferrer"
                      class="flex items-center space-x-3 glass p-4 rounded-lg hover:bg-[var(--color-gold)] hover:text-black transition-all duration-300 group"
                    >
                      <span class="text-[var(--color-gold)] group-hover:text-black">
                        <.icon name="hero-chat-bubble-left-right" class="w-6 h-6" />
                      </span>
                      <div>
                        <p class="font-medium">WhatsApp</p>
                        <p class="text-sm text-[var(--color-muted)] group-hover:text-black">
                          Chat with me
                        </p>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              <!-- Quick Contact Form -->
              <!-- TODO: Implement form handling with Phoenix.HTML.Form -->
              <!-- TODO: Add changeset validation -->
              <!-- TODO: Connect to Contact context for database storage -->
              <!-- TODO: Set up email notifications via Swoosh -->
              <div class="glass p-8 rounded-xl shadow-elegant">
                <h3 class="font-display text-3xl font-semibold text-foreground mb-6">
                  Quick Contact
                </h3>

                <form class="space-y-6">
                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Name *</label>
                    <input
                      type="text"
                      class="w-full px-4 py-3 bg-[var(--color-input)] border border-[var(--color-border)] rounded-lg focus:ring-2 focus:ring-[var(--color-gold)] focus:border-transparent transition-all duration-300 text-foreground"
                      placeholder="Your full name"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Email *</label>
                    <input
                      type="email"
                      class="w-full px-4 py-3 bg-[var(--color-input)] border border-[var(--color-border)] rounded-lg focus:ring-2 focus:ring-[var(--color-gold)] focus:border-transparent transition-all duration-300 text-foreground"
                      placeholder="your.email@example.com"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-foreground mb-2">Message *</label>
                    <textarea
                      rows="5"
                      class="w-full px-4 py-3 bg-[var(--color-input)] border border-[var(--color-border)] rounded-lg focus:ring-2 focus:ring-[var(--color-gold)] focus:border-transparent transition-all duration-300 text-foreground"
                      placeholder="Describe your tattoo idea, size, placement and any questions..."
                    >
                    </textarea>
                  </div>

                  <button
                    type="submit"
                    class="w-full bg-gradient-gold text-black py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
                  >
                    Send Message
                  </button>
                </form>

                <p class="text-sm text-[var(--color-muted)] mt-4 text-center">
                  I usually respond within 24 hours
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    """
  end
end
