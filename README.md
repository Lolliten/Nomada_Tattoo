# Nomada Tattoo Portfolio

A modern, single-page portfolio website for tattoo artists to showcase their work in high quality without censorship concerns. Built with Phoenix LiveView for real-time interactivity and PostgreSQL for robust data management.

## 🎨 About

This is a professional portfolio application designed for tattoo artists who want to:
- Showcase their work in **high-quality images** without platform censorship
- Organize tattoos by **category** (Blackwork, Neo-Traditional, Dot-Work)
- Accept **consultation requests** through an integrated contact form
- Maintain **full control** over their content and presentation

The application features a sleek, single-page design with smooth scrolling between sections: Hero → Gallery → Contact.

## ✨ Features

### Current (Phase 1 & 2 - Complete)
- ✅ **Single-page responsive design** with smooth section navigation
- ✅ **Database-backed gallery** with PostgreSQL storage
- ✅ **Category filtering** (All, Blackwork, Neo-Traditional, Dot-Work)
- ✅ **Contact form** that saves to database and sends email notifications
- ✅ **Real-time form validation** with LiveView
- ✅ **Elegant UI** with TailwindCSS and custom styling
- ✅ **SEO-friendly** structure

### Roadmap (Phase 3+)
- 🔄 AWS S3 integration for image storage
- 🔄 Admin panel for managing tattoos
- 🔄 User authentication
- 🔄 Image upload interface
- 🔄 Lazy loading for large galleries

## 🛠 Tech Stack

- **Backend**: Elixir 1.15+ with Phoenix 1.8+
- **Frontend**: Phoenix LiveView 1.1+ with TailwindCSS
- **Database**: PostgreSQL
- **Email**: Swoosh (local dev, configurable for production)
- **Image Storage**: Planned S3 (currently local files)
- **Deployment Ready**: Fly.io, Heroku, or any Elixir-friendly host

## 📋 Prerequisites

- **Elixir** 1.15 or higher
- **Erlang/OTP** 26+
- **PostgreSQL** 14+
- **Node.js** 18+ (for asset compilation)

## 🚀 Installation

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/nomada.git
cd nomada
```

### 2. Install dependencies
```bash
mix deps.get
```

### 3. Set up the database
```bash
mix ecto.setup
```

This will:
- Create the database
- Run migrations
- Seed sample tattoo data

### 4. Start the Phoenix server
```bash
mix phx.server
```

Or start in interactive mode:
```bash
iex -S mix phx.server
```

### 5. Visit the application
Open your browser and navigate to: [http://localhost:4000](http://localhost:4000)

## 📁 Project Structure

```
lib/
├── nomada/
│   ├── gallery/              # Gallery context
│   │   └── tattoo.ex         # Tattoo schema
│   ├── contact/              # Contact context
│   │   └── message.ex        # Message schema
│   ├── gallery.ex            # Gallery business logic
│   ├── contact.ex            # Contact business logic
│   ├── mailer.ex             # Email configuration
│   └── repo.ex               # Database repository
├── nomada_web/
│   ├── live/
│   │   └── home_live.ex      # Main single-page LiveView
│   ├── components/
│   │   └── ui/               # Reusable UI components
│   └── router.ex             # Routes configuration
priv/
├── repo/
│   ├── migrations/           # Database migrations
│   └── seeds.exs             # Sample data
└── static/
    └── images/               # Static image assets
```

## 💾 Database Schema

### `tattoos` table
| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| title | string | Tattoo title |
| description | text | Detailed description |
| category | string | Blackwork, Neo-Traditional, or Dot-Work |
| image_url | string | S3 or local image URL |
| file_size | integer | Image file size (optional) |
| content_type | string | MIME type (optional) |
| width/height | integer | Image dimensions (optional) |
| featured | boolean | Featured tattoo flag |
| display_order | integer | Sort order in gallery |
| published | boolean | Published status |
| inserted_at/updated_at | timestamp | Timestamps |

### `contact_messages` table
| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | string | Sender's name |
| email | string | Sender's email |
| message | text | Message content |
| status | string | new, read, or replied |
| ip_address | string | Sender's IP (optional) |
| user_agent | text | Browser info (optional) |
| inserted_at/updated_at | timestamp | Timestamps |

## ⚙️ Configuration

### Database
Update `config/dev.exs` with your PostgreSQL credentials:
```elixir
config :nomada, Nomada.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "nomada_dev"
```

### Email (Development)
By default, emails are captured locally. View them at:
```
http://localhost:4000/dev/mailbox
```

### Email (Production)
Configure a real email service in `config/runtime.exs`:
```elixir
config :nomada, Nomada.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,  # or Mailgun, etc.
  api_key: System.get_env("SENDGRID_API_KEY")
```

## 📝 Usage

### Adding Tattoos

#### Via IEx Console
```elixir
iex> Nomada.Gallery.create_tattoo(%{
  title: "Dragon Sleeve",
  description: "Full sleeve Japanese dragon",
  category: "Neo-Traditional",
  image_url: "https://your-s3-bucket.s3.amazonaws.com/tattoos/dragon.jpg",
  display_order: 1,
  published: true
})
```

#### Via Seeds (Development)
Edit `priv/repo/seeds.exs` and run:
```bash
mix run priv/repo/seeds.exs
```

### Viewing Contact Submissions

Access via IEx:
```elixir
iex> Nomada.Contact.list_messages()
```

Or query the database directly:
```bash
psql nomada_dev -c "SELECT * FROM contact_messages ORDER BY inserted_at DESC;"
```

## 🖼️ Image Management

### Current Setup (Local Files)
Place images in `priv/static/images/tattoo/`

### Naming Convention
Use descriptive, SEO-friendly names:
```
blackwork-geometric-mandala-001.jpg
neo-traditional-rose-skull-002.jpg
dot-work-sacred-geometry-003.jpg
```

### Future Setup (Phase 3: S3)
Images will be stored in AWS S3 with direct URLs:
```
https://your-bucket.s3.eu-north-1.amazonaws.com/tattoos/image.jpg
```

**Why no CloudFront initially?**
- Simpler setup
- Lower cost for small-medium traffic
- S3 is fast enough for most use cases
- Can add CloudFront CDN later if needed for global audience

## 🚢 Deployment

### Prerequisites
1. PostgreSQL database (RDS, Supabase, etc.)
2. Email service (SendGrid, Mailgun, etc.)
3. S3 bucket for images (Phase 3)

### Environment Variables
```bash
DATABASE_URL=ecto://user:pass@host/database
SECRET_KEY_BASE=generate_with_mix_phx_gen_secret
SENDGRID_API_KEY=your_api_key
AWS_ACCESS_KEY_ID=your_key  # Phase 3
AWS_SECRET_ACCESS_KEY=your_secret  # Phase 3
AWS_REGION=eu-north-1  # Phase 3
S3_BUCKET_NAME=your-bucket  # Phase 3
```

### Deployment Steps
```bash
# Run migrations
mix ecto.migrate

# Build assets
mix assets.deploy

# Start production server
MIX_ENV=prod mix phx.server
```

### Recommended Hosts
- **Fly.io** - Best for Phoenix, free tier available
- **Heroku** - Easy setup with buildpacks
- **Gigalixir** - Elixir-specific hosting
- **Render** - Simple deployment

## 🎯 For Developers Building Similar Apps

### Key Design Decisions

**1. Single-page vs Multi-page**
- Chose single-page for better UX and portfolio flow
- All navigation is smooth scrolling, no page reloads
- Simpler routing, easier to maintain

**2. LiveView vs SPA Framework**
- LiveView for real-time features without JavaScript complexity
- Server-side rendering for better SEO
- Built-in form handling and validation

**3. Image Storage Architecture**
- Started with local files for development
- Simplified to single `image_url` field
- Removed CloudFront complexity (can add later)
- Direct S3 URLs sufficient for 1000+ images with pagination

**4. Database Structure**
- Separate contexts: `Gallery` and `Contact`
- Simple schemas with only essential fields
- Easy to extend later (tags, comments, etc.)

### Scalability Considerations

**Current capacity**:
- Handles 1000+ images easily with pagination/lazy loading
- Suitable for 10k+ monthly visitors

**To scale further**:
- Add CloudFront CDN for global audience
- Implement image thumbnails for gallery grid
- Add database read replicas
- Enable query caching

### Adapting for Other Use Cases

This architecture works great for:
- **Photography portfolios**
- **Art galleries**
- **Product showcases**
- **Real estate listings**
- **Any image-heavy portfolio site**

Just update:
- Categories in `Tattoo` schema
- Validation rules in changeset
- UI text and styling

## 📚 Learn More

### Phoenix Framework
- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- LiveView docs: https://hexdocs.pm/phoenix_live_view/

### Elixir
- Official website: https://elixir-lang.org/
- Getting started: https://elixir-lang.org/getting-started/introduction.html

### Deployment
- Phoenix deployment guide: https://hexdocs.pm/phoenix/deployment.html
- Fly.io Phoenix guide: https://fly.io/docs/elixir/

## 🤝 Contributing

This is a personal portfolio project, but feel free to:
- Report bugs via issues
- Suggest improvements
- Fork and adapt for your own use

## 📄 License

MIT License - Feel free to use this as a template for your own portfolio!

## 🙏 Acknowledgments

Built with Phoenix LiveView, inspired by the need for uncensored tattoo art portfolios.

---

**Phase 3 Coming Soon**: AWS S3 integration, admin panel, and authentication!
