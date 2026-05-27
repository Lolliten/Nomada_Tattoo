# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nomada.Repo.insert!(%Nomada.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Nomada.Repo
alias Nomada.Gallery.Tattoo

# Clear existing tattoos (optional - remove in production)
Repo.delete_all(Tattoo)

# Sample tattoos for development
# NOTE: Replace image URLs with real S3 URLs when you upload actual images

tattoos = [
  %{
    title: "Geometric Mandala",
    description: "Detailed geometric mandala design in black & grey",
    category: "Blackwork",
    image_url: "/images/tattoo/tattoo-1.jpg",
    display_order: 1,
    published: true
  },
  %{
    title: "Realistic Portrait",
    description: "Realistic female portrait in black and grey",
    category: "Blackwork",
    image_url: "/images/tattoo/tattoo-2.jpg",
    display_order: 2,
    published: true
  },
  %{
    title: "Japanese Dragon",
    description: "Traditional Japanese dragon sleeve with bold lines",
    category: "Neo-Traditional",
    image_url: "/images/tattoo/tattoo-3.jpg",
    display_order: 3,
    published: true
  },
  %{
    title: "Sacred Geometry",
    description: "Complex sacred geometry patterns",
    category: "Dot-Work",
    image_url: "/images/tattoo/tattoo-1.jpg",
    display_order: 4,
    published: true
  },
  %{
    title: "Dark Portrait",
    description: "Gothic style portrait with shadows",
    category: "Blackwork",
    image_url: "/images/tattoo/tattoo-2.jpg",
    display_order: 5,
    published: true
  },
  %{
    title: "Neo Traditional Rose",
    description: "Modern take on traditional tattoo style",
    category: "Neo-Traditional",
    image_url: "/images/tattoo/tattoo-3.jpg",
    display_order: 6,
    published: true
  }
]

Enum.each(tattoos, fn tattoo_attrs ->
  %Tattoo{}
  |> Tattoo.changeset(tattoo_attrs)
  |> Repo.insert!()
end)

IO.puts("✅ Seeded #{length(tattoos)} tattoos")
