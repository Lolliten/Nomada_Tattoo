# Image Assets

## Required Images

### Logo
- `nomada-logo.jpg` - Main Nomada logo (gas mask design)
  - Place in: `priv/static/images/`
  - Used in: Hero section and navigation

### Tattoo Portfolio Images
Place your tattoo portfolio images in: `priv/static/images/tattoo/`

Example images referenced in the code:
- `tattoo-1.jpg` - Geometric/Mandala designs
- `tattoo-2.jpg` - Realistic portraits
- `tattoo-3.jpg` - Traditional/Japanese designs

You can add as many images as needed. The current implementation uses placeholder images.

## Future: S3 + CloudFront Integration

When implementing backend (TODO):
- Images will be uploaded to Amazon S3
- Delivered via CloudFront CDN
- Only metadata (URLs) stored in PostgreSQL
- Requires ExAws library configuration
