# Tham Le Portfolio

Personal portfolio website built with Hugo, focusing on learning through building and documenting the process.

## Philosophy

This portfolio represents genuine learning and growth rather than marketing speak. It automatically syncs content from GitHub repositories and documents real problems solved through code.

## Features

- **Dynamic Content**: Projects auto-synced from GitHub API
- **CTF Documentation**: Security challenge writeups from submodule
- **Learning Focus**: Honest documentation of what was learned
- **Clean Design**: Hugo Stack theme with minimal customization

## Setup

1. **Clone the repository**
   ```bash
   git clone --recursive https://github.com/tham-le/thamle-portfolio.git
   cd thamle-portfolio
   ```

2. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env and add your GitHub token
   ```

3. **Sync content**
   ```bash
   ./sync-all.sh
   ```

4. **Run locally**
   ```bash
   hugo server
   ```

## Content Structure

- **Projects**: Automatically generated from GitHub repositories
- **CTF Writeups**: Synced from CTF-Writeups submodule
- **Notes**: Manual blog posts about learning and insights

## Environment Variables

Required in `.env` file:
- `GITHUB_TOKEN`: Personal access token for GitHub API
- `GITHUB_USERNAME`: Your GitHub username (default: tham-le)

## Deployment

The site deploys automatically to Firebase Hosting via GitHub Actions when changes are pushed to main.

## Content Philosophy

- Document actual learning, not achievements
- Show real code and real problems
- Explain thought process and failures
- Keep descriptions honest and concise

## Local Development

```bash
# Start Hugo development server
hugo server --buildDrafts --buildFuture

# Sync content without building
./sync-all.sh

# Test sync functionality
./test-sync.sh
```

## License

Content: CC BY-NC-SA 4.0  
Code: MIT License
