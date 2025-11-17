defmodule NomadaWeb.ContactLive do
  @moduledoc """
  Contact page with form and contact information.

  TODO: Backend integration needed
  - Create Contact schema for form submissions
  - Implement form validation
  - Set up email notifications using Swoosh
  - Add CSRF protection
  - Store submissions in PostgreSQL
  """
  use NomadaWeb, :live_view

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @impl true
  def mount(_params, _session, socket) do
    contact_info = [
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
    ]

    {:ok, assign(socket, contact_info: contact_info)}
  end

  @impl true
  def render(assigns) do
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
    """
  end
end
