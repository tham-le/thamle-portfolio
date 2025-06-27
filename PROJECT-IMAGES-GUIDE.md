# Automated Project Gallery System

This system automatically downloads images from your GitHub repositories and creates galleries for your projects.

## How It Works

The `sync-projects.sh` script automatically:
1. **Scans repositories** for images in common directories (`images/`, `assets/`, `docs/`, `screenshots/`, `demo/`, `renders/`, `examples/`, `gallery/`)
2. **Downloads all images** found in these directories
3. **Creates galleries** automatically when multiple images are found
4. **Sets main image** (prefers `screenshot`, `demo`, `preview`, `cover`, `banner`)
5. **Generates placeholders** for projects without images

## Quick Start

### 1. Set Your GitHub Token (Recommended)

```bash
export GITHUB_TOKEN=your_github_token_here
```

This increases API rate limits and allows access to private repositories if needed.

### 2. Run the Sync

```bash
# Sync all projects
./sync-projects.sh

# Test with a specific repository
./test-sync.sh miniRT
```

### 3. Automatic Gallery Creation

When multiple images are found, the system automatically creates:

```html
## Gallery

<img src="/images/projects/miniRT/teapot.png" alt="Teapot" class="gallery-image" title="Teapot Scene" />
<img src="/images/projects/miniRT/cornell.png" alt="Cornell" class="gallery-image" title="Cornell Box" />
<img src="/images/projects/miniRT/dragon.png" alt="Dragon" class="gallery-image" title="Dragon Model" />
```

## Repository Structure for Best Results

Organize images in your repositories like this:

```
your-repository/
├── README.md
├── images/           # ← Preferred location
│   ├── screenshot.png
│   ├── demo.gif
│   └── gallery/
│       ├── scene1.png
│       └── scene2.png
├── assets/           # ← Alternative location
│   └── preview.jpg
└── docs/             # ← Documentation images
    └── diagram.svg
```

## Supported Image Formats

- PNG (.png)
- JPEG (.jpg, .jpeg)
- GIF (.gif)
- SVG (.svg)
- WebP (.webp)

## Image Priority

The system automatically selects the main project image based on filename priority:

1. **High priority**: `screenshot`, `demo`, `preview`, `cover`, `banner`
2. **Default**: First image found
3. **Fallback**: Generated SVG placeholder

## Manual Updates

### Via GitHub Actions

1. Go to your repository's **Actions** tab
2. Select **"Sync Projects from GitHub"**
3. Click **"Run workflow"**
4. Wait for completion

### Via Command Line

```bash
# Set your token
export GITHUB_TOKEN=your_token

# Run sync
./sync-projects.sh

# Test specific repo
./test-sync.sh repository-name
```

## Directory Structure Created

```
static/images/projects/
├── miniRT/
│   ├── teapot.png
│   ├── cornell.png
│   └── dragon.png
├── ft_transcendence/
│   └── screenshot.png
└── other-project/
    └── demo.jpg
```

## Gallery Features

The Stack theme automatically provides:
- **Lightbox**: Click images to view full size
- **Navigation**: Arrow keys or click to navigate
- **Responsive**: Works on mobile and desktop
- **Lazy Loading**: Images load as needed
- **Captions**: Automatic from filename

## Troubleshooting

### No Images Downloaded
- Check if images exist in your repository
- Verify they're in supported directories
- Ensure proper file extensions

### API Rate Limits
```bash
# Check your rate limit
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit

# Set token to increase limits
export GITHUB_TOKEN=your_token
```

### Gallery Not Working
- Images must have `gallery-image` class (automatically added)
- Check browser console for JavaScript errors
- Verify Hugo build completed successfully

## Performance Tips

1. **Optimize images** before pushing to GitHub (max 1200px width)
2. **Use WebP format** for better compression
3. **Organize images** in dedicated directories
4. **Use descriptive filenames** for better captions

## Example Repository Setup

For a ray tracing project like miniRT:

```
miniRT/
├── README.md
├── images/
│   ├── screenshot.png      # ← Main image
│   ├── teapot-scene.png
│   ├── cornell-box.png
│   ├── dragon-mesh.png
│   └── gallery/
│       ├── spheres.png
│       ├── reflections.png
│       └── lighting.png
└── src/
    └── ...
```

This creates an automatic gallery with 6+ images and uses `screenshot.png` as the main project image. 