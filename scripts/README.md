# Portfolio Scripts

This directory contains all the automation scripts for the portfolio.

## Scripts Overview

### 🚀 Main Scripts

- **`sync-all.sh`** - Master script that runs all sync operations
  - Loads environment variables from `.env`
  - Syncs projects from GitHub API
  - Updates CTF writeups submodule
  - Processes CTF writeups

### 📂 Individual Sync Scripts

- **`sync-projects.sh`** - Syncs GitHub repositories to project pages
  - Fetches repository data from GitHub API
  - References images directly from GitHub
  - Creates Hugo-compatible markdown files
  - Categorizes projects automatically

- **`sync-writeups.sh`** - Processes CTF writeups from submodule
  - Organizes writeups by CTF event
  - Copies images from repositories
  - Creates individual challenge pages
  - Generates event overview pages

### ⚙️ Setup Scripts

- **`setup.sh`** - Initial portfolio setup
  - Installs dependencies
  - Sets up environment
  - Initializes submodules

- **`test-sync.sh`** - Testing script for development
  - Tests sync operations
  - Validates content generation

## Usage

### Quick Start
```bash
# Run full sync
./scripts/sync-all.sh

# Sync only projects
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

## Workflow Integration

These scripts are used by the GitHub Actions workflow (`.github/workflows/sync-and-deploy.yml`) for automated deployment. 