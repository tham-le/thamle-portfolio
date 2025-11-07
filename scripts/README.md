# Portfolio Scripts

This directory contains all the automation scripts for the portfolio.

## Scripts Overview

### 🚀 Main Scripts

- **`sync-all.sh`** - Master script that runs all sync operations
  - Loads environment variables from `.env`
  - Syncs featured projects from GitHub API
  - Updates CTF writeups submodule
  - Processes CTF writeups

### 📂 Individual Sync Scripts

- **`sync-projects.sh`** - Syncs selected GitHub repositories to project pages
  - Uses `projects-config.json` for selective project sync
  - Fetches repository data from GitHub API
  - References images directly from GitHub
  - Creates Hugo-compatible markdown files
  - Escapes README content to prevent markdown issues
  - Categorizes projects automatically

- **`sync-writeups.sh`** - Processes CTF writeups from submodule
  - Organizes writeups by CTF event
  - Copies images from repositories
  - Creates individual challenge pages
  - Generates event overview pages

### 🛠️ Utility Scripts

- **`generate-ctf-indexes.sh`** - Generates index files for CTF sections
  - Creates `_index.md` files for Hugo navigation
  - Used by CI workflow

- **`prepare_hugo.py`** - Prepares Hugo for local development
  - Generates local index files needed for the CTF section
  - Run before starting Hugo server locally

## Project Configuration

### Featured Projects Selection

Create `projects-config.json` in the project root to specify which projects to sync:

```json
{
  "featured_projects": [
    {
      "name": "fractol",
      "priority": 1,
      "description": "Mathematical fractal visualization with multi-threading"
    },
    {
      "name": "miniRT",
      "priority": 2,
      "description": "3D ray tracer rendering realistic scenes"
    }
  ],
  "settings": {
    "max_readme_lines": 30,
    "escape_code_blocks": true,
    "include_gallery": true,
    "auto_categorize": true
  }
}
```

### Configuration Options

- **`featured_projects`**: Array of projects to sync
  - `name`: GitHub repository name
  - `priority`: Display order (lower = higher priority)
  - `description`: Override for generic GitHub descriptions

- **`settings`**: Sync behavior configuration
  - `max_readme_lines`: Maximum README lines to include (default: 30)
  - `escape_code_blocks`: Prevent README code blocks from breaking markdown (default: true)
  - `include_gallery`: Generate image galleries for projects (default: true)
  - `auto_categorize`: Automatically categorize projects (default: true)

## Usage

### Quick Start
```bash
# Run full sync
./scripts/sync-all.sh

# Sync only featured projects
./scripts/sync-projects.sh

# Sync only CTF writeups
./scripts/sync-writeups.sh
```

### Environment Setup
Create a `.env` file in the project root:
```bash
GITHUB_TOKEN=your_github_token_here
GITHUB_USERNAME=tham-le
```

### Dependencies
- `curl` - API requests
- `jq` - JSON processing
- `git` - Repository operations

## Features

### README Processing
- **Code Block Escaping**: Prevents README code blocks from breaking Hugo markdown structure
- **Content Truncation**: Limits README content to prevent overly long project pages
- **Smart Formatting**: Preserves markdown structure while fixing common issues

### Image Handling
- **Direct GitHub References**: Images referenced directly from GitHub raw URLs
- **Multi-Directory Search**: Searches common image directories (image, images, assets, etc.)
- **Carousel Generation**: Automatically creates image carousels for projects with multiple images
- **Branch Detection**: Automatically detects and uses correct default branch (main/master)

### Project Curation
- **Quality Over Quantity**: Only sync significant projects specified in config
- **Custom Descriptions**: Override generic GitHub descriptions with meaningful ones
- **Priority Ordering**: Control display order through priority settings
- **Category Assignment**: Automatic categorization based on languages and descriptions

## Workflow Integration

These scripts are used by the GitHub Actions workflow (`.github/workflows/sync-and-deploy.yml`) for automated deployment. 