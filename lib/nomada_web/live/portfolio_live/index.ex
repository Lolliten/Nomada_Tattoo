defmodule NomadaWeb.PortfolioLive.Index do
  @moduledoc """
  Portfolio gallery page with search and filtering.

  TODO: Backend integration needed
  - Create Tattoo schema (title, description, category, s3_url, cloudfront_url, tags)
  - Implement search and filter functionality
  - Add pagination for large galleries
  """
  use NomadaWeb, :live_view

  import NomadaWeb.CoreComponents, only: [icon: 1]

  @impl true
  def mount(_params, _session, socket) do
    # TODO: Replace with database query when backend is implemented
    # tattoos = Nomada.Portfolio.list_tattoos()
    all_tattoos = [
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
    ]

    {:ok,
     assign(socket,
       all_tattoos: all_tattoos,
       filtered_tattoos: all_tattoos,
       selected_category: "All",
       search_query: ""
     )}
  end

  @impl true
  def handle_event("filter_category", %{"category" => category}, socket) do
    filtered =
      if category == "All" do
        socket.assigns.all_tattoos
      else
        Enum.filter(socket.assigns.all_tattoos, fn tattoo ->
          tattoo.category == category
        end)
      end

    # Apply search if there's an active query
    filtered =
      if socket.assigns.search_query != "" do
        apply_search(filtered, socket.assigns.search_query)
      else
        filtered
      end

    {:noreply,
     assign(socket, filtered_tattoos: filtered, selected_category: category)}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    filtered = apply_search(socket.assigns.all_tattoos, query)

    # Apply category filter if not "All"
    filtered =
      if socket.assigns.selected_category != "All" do
        Enum.filter(filtered, fn tattoo ->
          tattoo.category == socket.assigns.selected_category
        end)
      else
        filtered
      end

    {:noreply, assign(socket, filtered_tattoos: filtered, search_query: query)}
  end

  defp apply_search(tattoos, query) do
    query_lower = String.downcase(query)

    Enum.filter(tattoos, fn tattoo ->
      String.contains?(String.downcase(tattoo.title), query_lower) ||
        String.contains?(String.downcase(tattoo.description), query_lower) ||
        Enum.any?(tattoo.tags, fn tag ->
          String.contains?(String.downcase(tag), query_lower)
        end)
    end)
  end

  @impl true
  def render(assigns) do
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
                phx-keyup="search"
                phx-debounce="300"
                name="query"
                value={@search_query}
                class="w-full pl-12 pr-4 py-4 glass rounded-full text-foreground placeholder-[var(--color-muted)] focus:outline-none focus:ring-2 focus:ring-[var(--color-gold)] transition-all duration-300"
              />
            </div>
            <!-- Category Filter Buttons -->
            <div class="flex flex-wrap gap-3 justify-center">
              <%= for category <- ["All", "Geometric", "Realism", "Traditional", "Neo-Traditional"] do %>
                <button
                  phx-click="filter_category"
                  phx-value-category={category}
                  class={[
                    "px-6 py-3 rounded-full font-bold text-sm tracking-wider transition-all duration-300 border",
                    if(@selected_category == category,
                      do:
                        "bg-[var(--color-gold)] text-black border-[var(--color-gold)] shadow-glow",
                      else:
                        "glass text-foreground hover:bg-[var(--color-gold)] hover:text-black border-[var(--color-border)]"
                    )
                  ]}
                >
                  {category}
                </button>
              <% end %>
            </div>
          </div>
        </div>
        <!-- Portfolio Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 max-w-8xl mx-auto">
          <%= if Enum.empty?(@filtered_tattoos) do %>
            <div class="col-span-full text-center py-16">
              <.icon name="hero-magnifying-glass" class="w-16 h-16 text-[var(--color-muted)] mx-auto mb-4" />
              <p class="text-xl text-[var(--color-muted)]">
                No tattoos found matching your search criteria.
              </p>
            </div>
          <% end %>
          <%= for tattoo <- @filtered_tattoos do %>
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
          <.link
            navigate={~p"/#contact"}
            class="inline-block bg-gradient-gold text-black px-12 py-5 rounded-full font-bold text-lg hover:shadow-glow transition-all duration-300 transform hover:scale-105 tracking-wider"
          >
            BOOK FREE CONSULTATION
          </.link>
        </div>
      </div>
    </section>
    """
  end
end
