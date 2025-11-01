defmodule NomadaWeb.PageComponents do
  @moduledoc """
  Page-specific components for the Nomada Tattoo Artist portfolio website.

  These components are designed for the main landing page and include:
  - Top bar with social links
  - Navigation menu
  - Hero section
  - Portfolio gallery
  - About section
  - Contact form
  - Footer
  """
  use Phoenix.Component
  use NomadaWeb, :verified_routes

  import NomadaWeb.CoreComponents, only: [icon: 1]

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
              href="https://instagram.com/nomada_ink"
              target="_blank"
              rel="noopener noreferrer"
              class="text-[var(--color-gold)] hover:text-[var(--color-gold-light)] transition-colors flex items-center space-x-2"
            >
              <.icon name="hero-camera" class="w-5 h-5" />
              <span class="text-foreground">@NOMADA_INK</span>
            </a>
            <a
              href="mailto:hello@nomada.art"
              class="text-[var(--color-gold)] hover:text-[var(--color-gold-light)] transition-colors flex items-center space-x-2"
            >
              <.icon name="hero-envelope" class="w-5 h-5" />
              <span class="text-foreground">HELLO@NOMADA.ART</span>
            </a>
          </div>
          <!-- Address -->
          <div class="hidden md:flex items-center space-x-2 text-[var(--color-muted)]">
            <.icon name="hero-map-pin" class="w-4 h-4" />
            <span>167 SÖDERMALM STREET</span>
            <span class="text-foreground">STOCKHOLM, SWE 10036</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders the main navigation menu with hexagonal button styling.
  """
  def navigation(assigns) do
    ~H"""
    <nav class="relative bg-background border-b border-[var(--color-border)]">
      <div class="container mx-auto px-6 py-6">
        <div class="flex items-center justify-center">
          <!-- Desktop Navigation -->
          <div class="hidden md:flex items-center justify-center space-x-8">
            <%= for {item, index} <- Enum.with_index([
              {"HOME", "#home"},
              {"ABOUT US", "#about"},
              {"PORTFOLIO", "#portfolio"},
              {"APPOINTMENT", "#contact"},
              {"CONTACT", "#contact"}
            ]) do %>
              <div class="flex items-center">
                <a
                  href={elem(item, 1)}
                  class="relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 hover:scale-105 transform font-metal group nav-hex glass"
                >
                  <span class="relative z-10">{elem(item, 0)}</span>
                  <div class="absolute inset-0 bg-foreground opacity-0 group-hover:opacity-20 transition-opacity duration-300 nav-hex" />
                </a>
                <%= if index == 0 do %>
                  <div class="ml-8 w-px h-8 bg-[var(--color-gold)] opacity-30"></div>
                <% end %>
              </div>
            <% end %>
          </div>
          <!-- Mobile Menu Button -->
          <button
            class="md:hidden text-foreground"
            onclick="document.getElementById('mobile-menu').classList.toggle('hidden')"
          >
            <.icon name="hero-bars-3" class="w-6 h-6" />
          </button>
        </div>
        <!-- Mobile Navigation -->
        <div id="mobile-menu" class="hidden md:hidden mt-4 pb-4 border-t border-[var(--color-border)]">
          <div class="flex flex-col space-y-4 pt-4">
            <%= for {label, href} <- [
              {"HOME", "#home"},
              {"ABOUT US", "#about"},
              {"PORTFOLIO", "#portfolio"},
              {"APPOINTMENT", "#contact"},
              {"CONTACT", "#contact"}
            ] do %>
              <a
                href={href}
                class="relative text-foreground hover:text-[var(--color-gold)] transition-all duration-300 font-bold tracking-widest text-xs uppercase px-8 py-4 text-center hover:scale-105 transform font-metal nav-hex glass"
              >
                {label}
              </a>
            <% end %>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  @doc """
  Renders the hero section with logo, tagline, and call-to-action buttons.
  """
  def hero(assigns) do
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
          Creating unique artistic tattoos with passion and precision.
        </p>

        <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <a
            href="#portfolio"
            class="bg-gradient-gold text-black px-8 py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
          >
            View My Portfolio
          </a>
          <a
            href="#contact"
            class="border-2 border-[var(--color-gold)] text-[var(--color-gold)] px-8 py-4 rounded-lg font-semibold text-lg hover:bg-[var(--color-gold)] hover:text-black transition-all duration-300"
          >
            Book Consultation
          </a>
        </div>
      </div>
      <!-- Scroll Indicator -->
      <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-10">
        <.icon name="hero-chevron-down" class="text-[var(--color-gold)] animate-bounce w-8 h-8" />
      </div>
    </section>
    """
  end

  @doc """
  Renders the portfolio gallery section with search and filtering.

  TODO: Backend integration needed
  - Create Tattoo schema (title, description, category, s3_url, cloudfront_url, tags)
  - Implement search and filter functionality
  - Add pagination for large galleries
  """
  def portfolio(assigns) do
    # TODO: Replace with database query when backend is implemented
    # tattoos = Nomada.Portfolio.list_tattoos()
    assigns =
      assign(assigns, :tattoos, [
        %{
          id: 1,
          image: "/images/tattoo/tattoo-1.jpg",
          title: "Geometric Mandala",
          description: "Detailed geometric mandala design in black & grey",
          category: "Geometric",
          tags: ["geometric", "mandala", "blackwork"]
        },
        %{
          id: 2,
          image: "/images/tattoo/tattoo-2.jpg",
          title: "Realistic Portrait",
          description: "Realistic female portrait in black and grey",
          category: "Realism",
          tags: ["portrait", "realism", "blackgrey"]
        },
        %{
          id: 3,
          image: "/images/tattoo/tattoo-3.jpg",
          title: "Japanese Dragon",
          description: "Traditional Japanese dragon sleeve with bold lines",
          category: "Traditional",
          tags: ["dragon", "japanese", "traditional", "sleeve"]
        },
        %{
          id: 4,
          image: "/images/tattoo/tattoo-1.jpg",
          title: "Sacred Geometry",
          description: "Complex sacred geometry patterns",
          category: "Geometric",
          tags: ["sacred", "geometry", "patterns", "linework"]
        },
        %{
          id: 5,
          image: "/images/tattoo/tattoo-2.jpg",
          title: "Dark Portrait",
          description: "Gothic style portrait with shadows",
          category: "Realism",
          tags: ["gothic", "portrait", "dark", "shadows"]
        },
        %{
          id: 6,
          image: "/images/tattoo/tattoo-3.jpg",
          title: "Neo Traditional",
          description: "Modern take on traditional tattoo style",
          category: "Neo-Traditional",
          tags: ["neo-traditional", "color", "modern", "bold"]
        }
      ])

    ~H"""
    <section id="portfolio" class="py-32 bg-[rgba(30,30,30,0.3)] min-h-screen">
      <div class="container mx-auto px-6">
        <div class="text-center mb-20">
          <h2 class="font-gothic text-7xl font-bold text-foreground mb-8">
            MY <span class="text-[var(--color-gold)]">PORTFOLIO</span>
          </h2>
          <p class="text-2xl text-[var(--color-muted)] max-w-3xl mx-auto leading-relaxed">
            Explore my artistic journey through ink and skin.
            Each piece tells a story of transformation and self-expression.
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
            Ready to create your own masterpiece?
          </p>
          <a
            href="#contact"
            class="inline-block bg-gradient-gold text-black px-12 py-5 rounded-full font-bold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105 tracking-wider"
          >
            BOOK CONSULTATION
          </a>
        </div>
      </div>
    </section>
    """
  end

  @doc """
  Renders the about section with feature cards.
  """
  def about(assigns) do
    assigns =
      assign(assigns, :features, [
        %{
          icon: "hero-trophy",
          title: "Professional Quality",
          description:
            "Over 8 years of experience in tattoo artistry with focus on detail and precision."
        },
        %{
          icon: "hero-heart",
          title: "Passionate Craft",
          description: "Every tattoo is created with love and respect for the art and the client."
        },
        %{
          icon: "hero-map-pin",
          title: "Södermalm Studio",
          description:
            "Located in the heart of Stockholm's creative district with modern equipment."
        },
        %{
          icon: "hero-clock",
          title: "Flexible Hours",
          description: "Customized bookings to fit your schedule and needs."
        }
      ])

    ~H"""
    <section id="about" class="py-24 bg-background">
      <div class="container mx-auto px-6">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="font-display text-5xl font-bold text-foreground mb-6">
              About <span class="text-[var(--color-gold)]">Nomada</span>
            </h2>
            <p class="text-xl text-[var(--color-muted)] max-w-3xl mx-auto leading-relaxed">
              Welcome to my world of tattoo artistry. As a professional tattoo artist in Södermalm,
              Stockholm, I work with passion to create unique, personal tattoos that
              tell your story. My studio is a place where creativity meets professionalism.
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
              Let's discuss your ideas and create something unique together.
              Book a consultation today to begin your tattoo journey.
            </p>
            <a
              href="#contact"
              class="inline-block bg-gradient-gold text-black px-10 py-4 rounded-lg font-semibold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105"
            >
              Book Consultation Now
            </a>
          </div>
        </div>
      </div>
    </section>
    """
  end

  @doc """
  Renders the contact section with form and contact information.

  TODO: Backend integration needed
  - Create Contact schema for form submissions
  - Implement form validation
  - Set up email notifications using Swoosh
  - Add CSRF protection
  - Store submissions in PostgreSQL
  """
  def contact(assigns) do
    assigns =
      assign(assigns, :contact_info, [
        %{
          icon: "hero-map-pin",
          title: "Studio Address",
          details: ["Södermalm", "Stockholm, Sweden"],
          link: "https://maps.google.com/?q=Södermalm,Stockholm"
        },
        %{
          icon: "hero-phone",
          title: "Phone",
          details: ["+46 70 123 45 67"],
          link: "tel:+46701234567"
        },
        %{
          icon: "hero-envelope",
          title: "Email",
          details: ["hello@nomada.art"],
          link: "mailto:hello@nomada.art"
        },
        %{
          icon: "hero-clock",
          title: "Opening Hours",
          details: ["Monday - Friday: 10:00 - 18:00", "Saturday: 11:00 - 16:00"],
          link: nil
        }
      ])

    ~H"""
    <section id="contact" class="py-24 bg-[rgba(30,30,30,0.2)]">
      <div class="container mx-auto px-6">
        <div class="max-w-6xl mx-auto">
          <div class="text-center mb-16">
            <h2 class="font-display text-5xl font-bold text-foreground mb-6">
              Get in <span class="text-[var(--color-gold)]">Touch</span>
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
                    href="https://instagram.com/nomada_ink"
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
                        @nomada_ink
                      </p>
                    </div>
                  </a>
                  <a
                    href="https://wa.me/46701234567"
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
    """
  end

  @doc """
  Renders the footer with links and social media.
  """
  def page_footer(assigns) do
    ~H"""
    <footer class="bg-background border-t border-[var(--color-border)] py-12">
      <div class="container mx-auto px-6">
        <div class="max-w-6xl mx-auto">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <!-- Brand -->
            <div class="text-center md:text-left">
              <h3 class="font-display text-2xl font-bold text-[var(--color-gold)] mb-4">NOMADA</h3>
              <p class="text-[var(--color-muted)] mb-4">
                Professionell tatuerare på Södermalm, Stockholm.
                Skapar unika konstnärliga tatueringar med passion och precision.
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
              <h4 class="font-semibold text-foreground mb-4">Snabblänkar</h4>
              <div class="space-y-2">
                <a
                  href="#portfolio"
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  Portfolio
                </a>
                <a
                  href="#about"
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  Om Mig
                </a>
                <a
                  href="#contact"
                  class="block text-[var(--color-muted)] hover:text-[var(--color-gold)] transition-colors duration-300"
                >
                  Kontakt
                </a>
              </div>
            </div>
            <!-- Contact Info -->
            <div class="text-center md:text-right">
              <h4 class="font-semibold text-foreground mb-4">Kontakt</h4>
              <div class="space-y-2 text-[var(--color-muted)]">
                <p>Södermalm, Stockholm</p>
                <p>+46 70 123 45 67</p>
                <p>hello@nomada.art</p>
              </div>
            </div>
          </div>

          <div class="border-t border-[var(--color-border)] pt-8 text-center">
            <p class="text-[var(--color-muted)]">
              © 2024 Nomada Tattoo Artist. Alla rättigheter förbehållna.
            </p>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
