# CTF Writeups - Dynamic Site

A dynamic CTF writeups website that loads content in real-time from an external GitHub repository.

## 🚀 Quick Start

```bash
# Deploy the site
./deploy-dynamic.sh

# Upload contents of deploy/ directory to your web server
```

## 📁 Structure

```text
ctf_site/
├── index.html               # Main entry point
├── index-dynamic.html       # Dynamic version (same content)
├── css/style.css            # Responsive styling
├── js/
│   ├── dynamic-router.js    # Client-side routing
│   ├── writeup-loader.js    # GitHub API integration
│   └── markdown-renderer.js # Markdown parsing
├── deploy-dynamic.sh        # Deployment script
└── deploy/                  # Generated deployment files
```

## 🔧 How It Works

1. **Content Source**: <https://github.com/tham-le/CTF-Writeups>
2. **Auto-Updates**: GitHub workflow updates index.json when new writeups are added
3. **Dynamic Loading**: Site fetches and renders markdown files in real-time
4. **SEO-Friendly**: Hash-based routing with proper meta tags

## 📝 Adding New Writeups

1. Add markdown file to external repository: `EventName/category/challenge/writeup.md`
2. Push to GitHub - index updates automatically
3. Site reflects changes immediately - no redeployment needed

## 🌐 URL Structure

- Home: `#/`
- Events: `#/events/event-slug`
- Writeups: `#/writeups/writeup-slug`
- Categories: `#/categories/category-name`

## ✨ Features

- ✅ No hardcoded HTML - all content from GitHub
- ✅ Real-time markdown parsing with syntax highlighting
- ✅ Mobile responsive design
- ✅ SEO optimized with proper meta tags
- ✅ Auto-updates when repository changes
- ✅ Works on any web server (no backend required)
