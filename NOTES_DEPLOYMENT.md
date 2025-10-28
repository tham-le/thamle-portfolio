# Obsidian Notes Deployment Guide

This document explains how to deploy your Obsidian notes (built with Quartz) to your Hugo portfolio at `thamle.live/notes/`.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Your Workflow                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  📝 Obsidian Vault (Private Repo)                           │
│  ├─ Write notes with wikilinks [[Like This]]                │
│  ├─ Mark notes for publishing (frontmatter)                 │
│  └─ Push to GitHub                                          │
│           ↓                                                  │
│  🤖 GitHub Actions (Auto Deploy)                            │
│  ├─ Build with Quartz                                       │
│  ├─ Copy to Portfolio Repo                                  │
│  └─ Commit to thamle-portfolio                              │
│           ↓                                                  │
│  🌐 Portfolio Repo (Public)                                 │
│  ├─ Hugo builds main site → public/                         │
│  ├─ Quartz notes at → public/notes/                         │
│  └─ Firebase Deploy → thamle.live                           │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## 📋 Table of Contents

1. [One-Time Setup](#one-time-setup)
2. [Regular Workflow](#regular-workflow)
3. [Manual Deployment](#manual-deployment)
4. [GitHub Actions Setup](#github-actions-setup)
5. [Troubleshooting](#troubleshooting)
6. [Advanced Configuration](#advanced-configuration)

---

## 🚀 One-Time Setup

### Prerequisites

- Node.js 18+ installed
- npm or yarn
- Git
- Firebase CLI (for portfolio deployment)
- Both repositories cloned locally

### Step 1: Install Quartz in Your Notes Repository

```bash
# Navigate to your private notes repository
cd ~/path/to/my-notes

# Install Quartz
npm install -g quartz

# Or use npx (no global install needed)
# This will be used in scripts

# Initialize Quartz in your repo
npx quartz create
# Choose "Empty Quartz" option when prompted
```

### Step 2: Copy Configuration Files

Copy these files from your portfolio repo to your notes repo:

```bash
# From portfolio repo root, copy templates to notes repo
cp quartz.config.ts.template ~/path/to/my-notes/quartz.config.ts
cp deploy-to-portfolio.sh.template ~/path/to/my-notes/deploy-to-portfolio.sh
cp .github/workflows/deploy-notes.yml.template ~/path/to/my-notes/.github/workflows/deploy-notes.yml

# Make deploy script executable
chmod +x ~/path/to/my-notes/deploy-to-portfolio.sh
```

### Step 3: Configure Paths in Deploy Script

Edit `deploy-to-portfolio.sh` in your notes repo:

```bash
# Line 29: Update the default portfolio path
PORTFOLIO_PATH="${1:-/home/tham/42-tham/thamle-portfolio}"
```

Or always pass the path when running:

```bash
./deploy-to-portfolio.sh /home/tham/42-tham/thamle-portfolio
```

### Step 4: Configure Quartz

The `quartz.config.ts` is already configured with:
- Base URL: `thamle.live/notes`
- Wikilink support enabled
- Proper ignoring of `.obsidian` folder
- Syntax highlighting
- Table of contents
- Search functionality

**Optional**: Customize colors, fonts, or plugins in `quartz.config.ts`.

### Step 5: Mark Notes for Publishing

In your Obsidian notes, add frontmatter to control what gets published:

```yaml
---
title: "WTF is a File Descriptor?"
date: 2025-01-15
draft: false  # Set to true to hide from build
tags:
  - unix
  - system-programming
---
```

Notes marked as `draft: true` will be filtered out by Quartz.

### Step 6: Test Local Build

```bash
cd ~/path/to/my-notes

# Build with Quartz
npx quartz build

# Verify output
ls -la public/

# Test local preview
npx quartz serve
# Visit http://localhost:8080
```

---

## 🔄 Regular Workflow

### Daily Note-Taking

1. **Write in Obsidian** as usual
   - Use wikilinks: `[[Related Note]]`
   - Use tags: `#unix #networking`
   - Add frontmatter to control publishing

2. **Commit and push** to your notes repo
   ```bash
   git add .
   git commit -m "Add notes on TCP handshake"
   git push origin main
   ```

3. **Automatic deployment** (if GitHub Actions configured)
   - GitHub Actions builds with Quartz
   - Copies to portfolio repo automatically
   - You just need to deploy the portfolio repo

4. **Deploy portfolio** (if not using portfolio auto-deploy)
   ```bash
   cd ~/path/to/thamle-portfolio
   make deploy
   # or
   firebase deploy
   ```

---

## 🛠️ Manual Deployment

If you want to deploy notes manually instead of using GitHub Actions:

```bash
# In your notes repository
cd ~/path/to/my-notes

# Run the deploy script
./deploy-to-portfolio.sh

# Output will show:
# ✓ Building with Quartz
# ✓ Copying to portfolio
# ✓ Deployment successful

# Then deploy the portfolio
cd ~/path/to/thamle-portfolio
make deploy
```

### Deploy Script Options

```bash
# Use default path (set in script)
./deploy-to-portfolio.sh

# Specify custom portfolio path
./deploy-to-portfolio.sh /custom/path/to/portfolio

# Check what would happen (dry run)
# Edit script to add: set -n
```

---

## ⚙️ GitHub Actions Setup

### Step 1: Create Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Name it: `PORTFOLIO_DEPLOY_TOKEN`
4. Select scopes:
   - ✅ `repo` (full control)
   - ✅ `workflow` (update workflows)
5. Generate and **copy the token** (you won't see it again!)

### Step 2: Add Secret to Notes Repository

1. Go to your **notes repository** on GitHub
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `PORTFOLIO_PAT`
5. Value: Paste your personal access token
6. Click "Add secret"

### Step 3: Enable Actions

The workflow file is already in `.github/workflows/deploy-notes.yml`.

**Verify it's enabled:**
1. Go to your notes repo → Actions tab
2. You should see "Deploy Notes to Portfolio" workflow
3. If disabled, enable it

### Step 4: Test the Workflow

```bash
# Make a small change to trigger deployment
cd ~/path/to/my-notes
echo "Test" >> README.md
git add README.md
git commit -m "Test auto-deployment"
git push origin main

# Watch the action
# Go to: https://github.com/tham-le/my-notes/actions
```

### Workflow Behavior

- **Triggers on**: Push to `main` branch
- **Manual trigger**: Can run from Actions tab
- **What it does**:
  1. Builds notes with Quartz
  2. Clones portfolio repo
  3. Copies notes to `public/notes/`
  4. Commits and pushes to portfolio repo
  5. Shows deployment summary

---

## 🐛 Troubleshooting

### Notes Not Showing Up

**Check 1: Are notes built?**
```bash
cd ~/path/to/thamle-portfolio
make notes-check
```

**Check 2: Is index.html present?**
```bash
ls -la public/notes/index.html
```

**Check 3: Hugo build not deleting notes?**

Make sure Hugo's `publishDir` is set correctly in `hugo.toml` and doesn't clean `public/notes/` on build.

**Solution**: Build Hugo, THEN deploy notes:
```bash
cd ~/path/to/thamle-portfolio
make build

cd ~/path/to/my-notes
./deploy-to-portfolio.sh

cd ~/path/to/thamle-portfolio
firebase deploy
```

### Wikilinks Not Working

**Check Quartz config:**
```typescript
// In quartz.config.ts
Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
```

**Check file names:**
- Wikilinks are case-sensitive
- Use exact file names: `[[File Name]]` for `File Name.md`

### GitHub Actions Failing

**Error: "Repository not found"**
- Check `PORTFOLIO_PAT` secret is set correctly
- Verify token has `repo` scope
- Make sure token hasn't expired

**Error: "Permission denied"**
- Token needs write access to portfolio repo
- Re-create token with correct scopes

**Error: "Quartz build failed"**
- Check `quartz.config.ts` for syntax errors
- Test locally first: `npx quartz build`
- Check workflow logs for specific error

### Firebase Hosting Issues

**404 on `/notes/` path:**

Check `firebase.json` has the rewrite rule:
```json
"rewrites": [
  {
    "source": "/notes/**",
    "destination": "/notes/index.html"
  }
]
```

**Styles not loading:**

Check that Quartz assets are copied:
```bash
ls -la public/notes/static/
```

### Path Issues

**Script can't find portfolio:**

Edit `deploy-to-portfolio.sh`:
```bash
# Use absolute path
PORTFOLIO_PATH="/home/tham/42-tham/thamle-portfolio"
```

Or pass path explicitly:
```bash
./deploy-to-portfolio.sh /absolute/path/to/portfolio
```

---

## 🔧 Advanced Configuration

### Customize Quartz Theme

Edit `quartz.config.ts` in your notes repo:

```typescript
theme: {
  colors: {
    lightMode: {
      light: "#faf8f8",
      secondary: "#284b63",  // Change these
      tertiary: "#84a59d",   // to match your brand
    },
  },
},
```

### Add Custom Plugins

Quartz supports many plugins. Add to `quartz.config.ts`:

```typescript
transformers: [
  Plugin.FrontMatter(),
  Plugin.TableOfContents(),
  Plugin.Latex({ renderEngine: "katex" }),  // Math support
  // Add more plugins here
],
```

### Filter Notes by Tag

Only publish notes with specific tags:

```typescript
// In quartz.config.ts
filters: [
  Plugin.RemoveDrafts(),
  // Add custom filter here
],
```

### Custom Domain for Notes

If you want notes on a subdomain (e.g., `notes.thamle.live`):

1. Update `quartz.config.ts`:
   ```typescript
   baseUrl: "notes.thamle.live"
   ```

2. Update `firebase.json` to serve from root for that domain

3. Configure DNS with CNAME record

### Automatic Portfolio Deployment

Add this to your **portfolio repository** as `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
      
      - name: Build
        run: hugo --minify
      
      - name: Deploy to Firebase
        uses: w9jds/firebase-action@master
        with:
          args: deploy --only hosting
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

Then both repos deploy automatically on push!

---

## 📚 Additional Resources

### Quartz Documentation
- [Official Docs](https://quartz.jzhao.xyz/)
- [Configuration Guide](https://quartz.jzhao.xyz/configuration)
- [Plugin List](https://quartz.jzhao.xyz/plugins)

### Obsidian Resources
- [Wikilinks Guide](https://help.obsidian.md/Linking+notes+and+files/Internal+links)
- [Frontmatter](https://help.obsidian.md/Editing+and+formatting/Properties)

### Firebase Hosting
- [Rewrites Documentation](https://firebase.google.com/docs/hosting/full-config#rewrites)
- [Firebase CLI](https://firebase.google.com/docs/cli)

---

## 🎯 Quick Reference

### Common Commands

```bash
# Notes Repository
npx quartz build              # Build notes
npx quartz serve              # Local preview
./deploy-to-portfolio.sh      # Deploy to portfolio

# Portfolio Repository  
make build                    # Build Hugo site
make serve                    # Local Hugo server
make notes-check              # Check notes status
make deploy                   # Deploy to Firebase
firebase serve                # Test Firebase locally
```

### File Locations

```
Notes Repo (Private):
├── content/              # Your markdown notes
├── quartz.config.ts      # Quartz configuration
├── deploy-to-portfolio.sh  # Deploy script
└── .github/
    └── workflows/
        └── deploy-notes.yml

Portfolio Repo (Public):
├── content/notes/_index.md   # Hugo notes index
├── public/notes/             # Built Quartz notes (gitignored)
├── firebase.json             # Firebase config
└── Makefile                  # Build commands
```

---

## 🆘 Getting Help

If you encounter issues:

1. **Check the logs**: GitHub Actions logs are very detailed
2. **Test locally**: Always test `npx quartz build` before pushing
3. **Verify paths**: Double-check repository paths in scripts
4. **Check permissions**: Ensure scripts are executable (`chmod +x`)
5. **Review configs**: Syntax errors in configs cause silent failures

**Common gotchas:**
- Hugo rebuilds can delete `public/` - deploy notes after Hugo build
- Wikilinks are case-sensitive
- GitHub tokens expire - set reminders to renew
- Firebase requires `firebase login` on new machines

---

## ✅ Success Checklist

After setup, verify:

- [ ] `npx quartz build` works in notes repo
- [ ] `./deploy-to-portfolio.sh` succeeds
- [ ] `public/notes/index.html` exists in portfolio
- [ ] `firebase serve` shows notes at `/notes/`
- [ ] GitHub Actions workflow runs successfully
- [ ] Wikilinks work when deployed
- [ ] Styles load correctly
- [ ] Search functionality works

---

**Version**: 1.0  
**Last Updated**: 2025-10-28  
**Maintained by**: Tham Le

For questions or improvements, open an issue in the portfolio repository.
