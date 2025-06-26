# Tham Le Portfolio

Modern portfolio website built with Hugo, featuring CTF writeups and project showcase.
**Live at: [thamle.live](https://thamle.live)**

## 🚀 Quick Start

```bash
./quick-start.sh    # Install Hugo, sync content, start server
```

## 📁 Simple Structure

```
thamle-portfolio/
├── hugo.toml              # Site config
├── content/
│   ├── _index.md         # Homepage (short about)
│   ├── about/_index.md   # Full about page
│   ├── projects/         # Projects showcase  
│   ├── ctf/              # Manual CTF writeups
│   └── ctf-external/     # Auto-synced writeups (submodule)
├── layouts/              # Custom templates
├── static/               # Static files
└── quick-start.sh        # One-command setup
```

## 🔄 Content Management

```bash
# Sync CTF writeups from external repo
./sync-writeups.sh

# Start development server  
hugo server --buildDrafts

# Build for production
hugo --minify
```

## 🚀 Deployment

Automatically deploys to **Firebase Hosting** at [thamle.live](https://thamle.live) when you push to main branch.

```bash
git add .
git commit -m "Update portfolio"
git push origin main    # Auto-deploys to Firebase
```

## 🏗️ Architecture

- **Homepage**: Short introduction with links to detailed about page
- **About Page**: Complete professional bio, skills, experience
- **Projects**: Software engineering projects showcase
- **CTF**: Cybersecurity writeups (manual + auto-synced)
- **Firebase**: Hosting at custom domain thamle.live

Built with Hugo + Stack theme for performance and SEO.
