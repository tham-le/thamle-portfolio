# Setting Up My-Notes Repository to Deploy to Portfolio

This guide explains how to configure your `my-notes` repository to automatically build with Quartz and deploy to your portfolio.

## Overview

The workflow is:
1. **my-notes repo** → Write markdown notes in Obsidian
2. **Quartz** → Builds notes into static HTML
3. **GitHub Actions** → Copies built files to `thamle-portfolio/static/notes/`
4. **Portfolio CI** → Hugo copies `static/notes/` → `public/notes/` during build
5. **Firebase** → Serves the notes at https://thamle.live/notes/

---

## Step 1: Set Up Quartz Configuration

In your `my-notes` repository, create or update `quartz.config.ts`:

```typescript
import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

const config: QuartzConfig = {
  configuration: {
    pageTitle: "Tham Le's Notes",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "plausible",
    },
    locale: "en-US",
    baseUrl: "thamle.live/notes",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "created",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
      typography: {
        header: "Schibsted Grotesk",
        body: "Source Sans Pro",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#faf8f8",
          lightgray: "#e5e5e5",
          gray: "#b8b8b8",
          darkgray: "#4e4e4e",
          dark: "#2b2b2b",
          secondary: "#284b63",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
        darkMode: {
          light: "#161618",
          lightgray: "#393639",
          gray: "#646464",
          darkgray: "#d4d4d4",
          dark: "#ebebec",
          secondary: "#7b97aa",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}

export default config
```

---

## Step 2: Verify Your Notes Structure

Make sure your notes are in the correct location (Quartz reads from the `content/` directory by default):

```
my-notes/
├── content/                    # Your markdown notes go here
│   ├── index.md               # Main landing page
│   ├── Architecture/
│   │   ├── README.md          # Architecture overview
│   │   └── design-patterns.md
│   ├── Concurrency/
│   │   ├── README.md
│   │   └── threads-vs-processes.md
│   ├── Fundamentals/
│   │   └── README.md
│   └── ...
├── quartz.config.ts           # Configuration (above)
├── package.json               # Node dependencies
└── .github/
    └── workflows/
        └── deploy-notes.yml   # Deployment workflow (Step 3)
```

**Important**: Make sure your markdown files are NOT in ignored folders:
- ❌ `private/` (ignored)
- ❌ `templates/` (ignored)
- ❌ `.obsidian/` (ignored)
- ✅ `content/` or root directory (processed)

---

## Step 3: Create GitHub Actions Workflow

Create `.github/workflows/deploy-notes.yml` in your `my-notes` repository:

```yaml
name: Deploy Notes to Portfolio

on:
  push:
    branches:
      - main
  workflow_dispatch:  # Allow manual triggering

jobs:
  deploy-notes:
    runs-on: ubuntu-latest

    steps:
      - name: 📥 Checkout Notes Repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Fetch all history for proper date handling

      - name: 🔧 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: 📦 Install Dependencies
        run: |
          npm ci

      - name: 🏗️ Build Notes with Quartz
        run: |
          npx quartz build
          echo "✓ Quartz build completed"
          echo "📊 Build statistics:"
          echo "- Total files: $(find public -type f | wc -l)"
          echo "- HTML files: $(find public -name "*.html" | wc -l)"
          ls -la public/

      - name: 📥 Checkout Portfolio Repository
        uses: actions/checkout@v4
        with:
          repository: tham-le/thamle-portfolio
          token: ${{ secrets.PORTFOLIO_PAT }}
          path: portfolio-repo
          fetch-depth: 1

      - name: 🗑️ Clean Old Notes
        run: |
          if [ -d "portfolio-repo/static/notes" ]; then
            echo "Removing old notes..."
            rm -rf portfolio-repo/static/notes
          fi
          mkdir -p portfolio-repo/static/notes

      - name: 📋 Copy Built Notes
        run: |
          cp -r public/* portfolio-repo/static/notes/
          echo "✓ Notes copied to portfolio/static/notes/"

          # Count files
          FILE_COUNT=$(find portfolio-repo/static/notes -type f | wc -l)
          HTML_COUNT=$(find portfolio-repo/static/notes -name "*.html" | wc -l)
          echo "📊 Copied $FILE_COUNT files ($HTML_COUNT HTML files)"

      - name: 🔍 Verify Deployment
        run: |
          echo "Verifying deployment structure..."
          ls -la portfolio-repo/static/notes/

          if [ ! -f "portfolio-repo/static/notes/index.html" ]; then
            echo "⚠️ Warning: index.html not found in notes directory"
            exit 1
          fi

          HTML_COUNT=$(find portfolio-repo/static/notes -name "*.html" | wc -l)
          if [ "$HTML_COUNT" -lt 2 ]; then
            echo "⚠️ Warning: Only $HTML_COUNT HTML files found. Expected at least 2."
            echo "Make sure your notes repository has markdown files in the content/ directory."
            exit 1
          fi

          echo "✓ Deployment structure verified ($HTML_COUNT HTML files)"

      - name: 📝 Commit and Push to Portfolio
        run: |
          cd portfolio-repo

          # Configure git
          git config user.name "Notes Deployment Bot"
          git config user.email "github-actions[bot]@users.noreply.github.com"

          # Check if there are changes
          if [ -n "$(git status --porcelain)" ]; then
            echo "Changes detected, committing..."
            git add static/notes/
            git commit -m "🔄 Update notes from obsidian vault

            Auto-deployed from notes repository
            Commit: ${{ github.sha }}
            Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"

            git push
            echo "✓ Changes pushed to portfolio repository"
          else
            echo "ℹ️ No changes to commit"
          fi

      - name: 📊 Deployment Summary
        if: success()
        run: |
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "✅ Notes Successfully Deployed to Portfolio"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo ""
          echo "📁 Repository: tham-le/thamle-portfolio"
          echo "📍 Path: static/notes/"
          echo "🌐 Will be live at: https://thamle.live/notes/"
          echo ""
          echo "Next: Portfolio repo will auto-deploy to Firebase"
          echo "      Hugo will copy static/notes/ → public/notes/"
          echo ""

      - name: ❌ Deployment Failed
        if: failure()
        run: |
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo "❌ Notes Deployment Failed"
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo ""
          echo "Please check the logs above for details."
          echo "Common issues:"
          echo "  - PORTFOLIO_PAT secret not set or invalid"
          echo "  - Quartz build failed (check quartz.config.ts)"
          echo "  - No markdown files in content/ directory"
          echo "  - Portfolio repository not accessible"
          echo ""
```

---

## Step 4: Set Up GitHub Secrets

In your `my-notes` repository on GitHub:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Create a secret named `PORTFOLIO_PAT`:
   - **Name**: `PORTFOLIO_PAT`
   - **Value**: A GitHub Personal Access Token with `repo` scope

### To create the token:
1. Go to GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Give it a name: "Notes to Portfolio Deployment"
4. Select scope: **repo** (all repo permissions)
5. Click **Generate token**
6. Copy the token and add it as the `PORTFOLIO_PAT` secret

---

## Step 5: Create package.json

Create `package.json` in your `my-notes` repository:

```json
{
  "name": "my-notes",
  "version": "1.0.0",
  "description": "Personal notes built with Quartz",
  "scripts": {
    "build": "npx quartz build",
    "serve": "npx quartz serve",
    "test": "npx quartz build && echo 'Build successful'"
  },
  "keywords": ["quartz", "obsidian", "notes"],
  "author": "Tham Le",
  "dependencies": {}
}
```

---

## Step 6: Create .gitignore

Create `.gitignore` in your `my-notes` repository:

```gitignore
# Quartz build output
public/
.quartz-cache/

# Node modules
node_modules/
package-lock.json

# Obsidian
.obsidian/

# Private notes (won't be published)
private/
templates/

# OS files
.DS_Store
Thumbs.db
*.swp

# Editor
.vscode/
.idea/

# Logs
*.log
npm-debug.log*
```

---

## Step 7: Test Locally Before Deploying

Before pushing to GitHub, test the build locally:

```bash
# In your my-notes repository
cd my-notes

# Build with Quartz
npx quartz build

# Check the output
ls -la public/
find public/ -name "*.html"

# You should see multiple HTML files, not just index.html
# If you only see index.html, 404.html, and tags/index.html,
# it means Quartz isn't finding your markdown files
```

### Troubleshooting: Only index.html is generated

If only `index.html` is being created:

1. **Check your content directory structure**:
   ```bash
   find content/ -name "*.md"
   # Should show all your markdown files
   ```

2. **Make sure files aren't in ignored folders**:
   ```bash
   # These won't be processed:
   private/*.md
   templates/*.md
   .obsidian/*.md
   ```

3. **Check file names are valid**:
   - Files should end in `.md`
   - Avoid special characters in filenames
   - Use kebab-case or underscores: `design-patterns.md` ✓

4. **Check quartz.config.ts**:
   ```bash
   cat quartz.config.ts | grep ignorePatterns
   # Make sure your notes aren't in ignored folders
   ```

---

## Step 8: Deploy

Once everything is set up:

```bash
# In your my-notes repository
git add .
git commit -m "Set up Quartz deployment to portfolio"
git push origin main
```

The GitHub Action will:
1. ✅ Build your notes with Quartz
2. ✅ Copy to `thamle-portfolio/static/notes/`
3. ✅ Commit and push to portfolio repo
4. ✅ Portfolio CI will build with Hugo and deploy to Firebase

---

## Verification Checklist

After deployment, verify:

- [ ] GitHub Action completed successfully in `my-notes` repo
- [ ] New commit appears in `thamle-portfolio` repo with "Update notes from obsidian vault"
- [ ] Portfolio CI/CD runs and deploys to Firebase
- [ ] Notes are accessible at https://thamle.live/notes/
- [ ] Individual note pages load (not just the index)
- [ ] Links between notes work correctly

---

## Common Issues and Solutions

### Issue: Only index.html is deployed

**Solution**: Your markdown files aren't being found by Quartz.
- Check they're in `content/` directory
- Ensure they're not in ignored folders (`private/`, `templates/`, `.obsidian/`)
- Verify files end in `.md`

### Issue: Links between notes are broken

**Solution**: Use Obsidian-style wikilinks in your markdown:
```markdown
[[Other Note]]  ✓ Correct
[Other Note](other-note.md)  ✗ Won't work with Quartz
```

### Issue: "PORTFOLIO_PAT secret not set"

**Solution**: Add the GitHub Personal Access Token as a secret in your my-notes repository settings.

### Issue: Images aren't showing

**Solution**: Place images in the `content/` directory alongside your notes, or in a `static/` folder in the notes repo.

---

## Testing the Full Workflow

Create a test note to verify everything works:

**`content/test-note.md`**:
```markdown
---
title: Test Note
date: 2025-01-06
tags:
  - test
---

# Test Note

This is a test note to verify the deployment workflow.

## Features to Test

- [ ] Note builds with Quartz
- [ ] Deploys to portfolio
- [ ] Accessible at https://thamle.live/notes/test-note
- [ ] Links work: [[index]]
- [ ] Images load (if any)

If you can read this on your portfolio site, the deployment is working! 🎉
```

Push this to your repo and verify it appears on your site.

---

## Maintenance

### Updating Notes

Just push to your `my-notes` repository:
```bash
git add .
git commit -m "Add new note about X"
git push
```

The GitHub Action will automatically deploy to your portfolio.

### Rebuilding All Notes

Trigger a manual deployment:
1. Go to your `my-notes` repo on GitHub
2. Click **Actions** → **Deploy Notes to Portfolio**
3. Click **Run workflow** → **Run workflow**

---

## Summary

The complete flow:
1. Write notes in Obsidian (in `my-notes/content/`)
2. Push to GitHub
3. GitHub Action builds with Quartz → `public/`
4. Copies `public/*` → `thamle-portfolio/static/notes/`
5. Portfolio CI runs Hugo → copies `static/notes/` → `public/notes/`
6. Firebase deploys `public/`
7. Notes visible at https://thamle.live/notes/ ✅

All CI fixes are in place - just need content in the right place!
