#!/bin/bash

# Deploy Dynamic CTF Site
# This script deploys the dynamic version of the CTF site that fetches content from GitHub

echo "🚀 Deploying Dynamic CTF Site..."

# Set up the deployment directory
DEPLOY_DIR="deploy"
mkdir -p "$DEPLOY_DIR"

echo "📁 Copying dynamic site files..."

# Copy the main HTML file
cp index.html "$DEPLOY_DIR/index.html"

# Copy CSS and JavaScript
cp -r css/ "$DEPLOY_DIR/"
cp -r js/ "$DEPLOY_DIR/"

# Copy SEO files
cp robots.txt "$DEPLOY_DIR/" 2>/dev/null || echo "robots.txt not found, skipping"
cp .htaccess "$DEPLOY_DIR/" 2>/dev/null || echo ".htaccess not found, skipping"

# Generate a simple sitemap for the dynamic site
cat > "$DEPLOY_DIR/sitemap.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://ctf.thamle.live/</loc>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://ctf.thamle.live/#/categories</loc>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
EOF

echo "📝 Creating deployment README..."

cat > "$DEPLOY_DIR/README.md" << 'EOF'
# CTF Writeups Site - Dynamic Version

This is the dynamic version of the CTF writeups site that fetches content in real-time from the external GitHub repository.

## Features

- **Dynamic Content Loading**: Fetches writeups from https://github.com/tham-le/CTF-Writeups
- **Real-time Markdown Parsing**: Converts markdown to HTML on-the-fly
- **SEO-Friendly Routing**: Uses hash-based routing with proper meta tags
- **Mobile Responsive**: Works on all device sizes
- **Syntax Highlighting**: Code blocks are highlighted using Prism.js

## Architecture

- `index.html`: Main entry point (copied from index-dynamic.html)
- `js/dynamic-router.js`: Handles routing and page rendering
- `js/writeup-loader.js`: Fetches content from GitHub API
- `js/markdown-renderer.js`: Renders markdown content with syntax highlighting
- `css/style.css`: Styling for the site

## Content Source

The site dynamically loads content from:
- Repository: https://github.com/tham-le/CTF-Writeups
- Index: https://raw.githubusercontent.com/tham-le/CTF-Writeups/main/index.json
- Writeups: Individual markdown files fetched via GitHub's raw content API

## URLs

- Home: `#/`
- Event: `#/events/{event-slug}`
- Writeup: `#/writeups/{writeup-slug}`
- Categories: `#/categories`
- Category: `#/categories/{category}`

## Deployment

Simply upload the contents of this directory to any web server. No server-side processing required.
EOF

echo "✅ Dynamic site deployed to $DEPLOY_DIR/"
echo ""
echo "📂 Deployed files:"
ls -la "$DEPLOY_DIR/"
echo ""
echo "🌐 To test locally: open $DEPLOY_DIR/index.html in your browser"
echo "☁️  To deploy: upload the contents of $DEPLOY_DIR/ to your web server"
