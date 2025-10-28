# Quartz Notes Integration - Quick Start

This directory contains template files for integrating Quartz-based Obsidian notes into your Hugo portfolio.

## 🚀 Quick Setup

### Automatic Setup (Recommended)

Run the setup script from your portfolio repository:

```bash
cd /home/tham/42-tham/thamle-portfolio
./scripts/setup-quartz-integration.sh /path/to/your/notes-repo
```

This will:
- ✅ Copy all necessary configuration files to your notes repo
- ✅ Set up correct paths automatically
- ✅ Make scripts executable
- ✅ Create `.gitignore` and `package.json` if needed
- ✅ Provide next steps

### Manual Setup

If you prefer manual setup:

1. **Copy files to your notes repository:**
   ```bash
   # From portfolio repo root
   cp quartz.config.ts.template ~/path/to/notes/quartz.config.ts
   cp deploy-to-portfolio.sh.template ~/path/to/notes/deploy-to-portfolio.sh
   cp .github/workflows/deploy-notes.yml.template ~/path/to/notes/.github/workflows/deploy-notes.yml
   
   # Make deploy script executable
   chmod +x ~/path/to/notes/deploy-to-portfolio.sh
   ```

2. **Edit paths in `deploy-to-portfolio.sh`:**
   ```bash
   # Line 29: Update default portfolio path
   PORTFOLIO_PATH="${1:-/home/tham/42-tham/thamle-portfolio}"
   ```

3. **Initialize Quartz in notes repo:**
   ```bash
   cd ~/path/to/notes
   npx quartz create
   # Choose "Empty Quartz" option
   ```

4. **Test the setup:**
   ```bash
   # Build notes
   npx quartz build
   
   # Deploy to portfolio
   ./deploy-to-portfolio.sh
   
   # Deploy portfolio
   cd ~/path/to/portfolio
   make deploy
   ```

## 📁 Template Files

| File | Purpose | Goes To |
|------|---------|---------|
| `quartz.config.ts.template` | Quartz configuration | Notes repo root |
| `deploy-to-portfolio.sh.template` | Manual deploy script | Notes repo root |
| `.github/workflows/deploy-notes.yml.template` | Auto-deploy workflow | Notes repo `.github/workflows/` |

## 📚 Documentation

**Complete guide:** [`NOTES_DEPLOYMENT.md`](../NOTES_DEPLOYMENT.md)

Contents:
- 🏗️ Architecture overview
- 🚀 One-time setup instructions
- 🔄 Regular workflow
- 🛠️ Manual deployment
- ⚙️ GitHub Actions configuration
- 🐛 Troubleshooting guide
- 🔧 Advanced customization

## 🎯 Quick Reference

### After Setup

**In your notes repository:**
```bash
# Build notes locally
npx quartz build

# Preview locally
npx quartz serve

# Deploy to portfolio
./deploy-to-portfolio.sh
```

**In your portfolio repository:**
```bash
# Check notes status
make notes-check

# Build and deploy everything
make build
make deploy
```

### GitHub Actions Setup

1. Create Personal Access Token on GitHub
2. Add as `PORTFOLIO_PAT` secret in notes repository
3. Push to notes repo triggers automatic deployment

## ✅ Success Criteria

You're done when:
- [ ] `npx quartz build` works in notes repo
- [ ] Notes appear at `http://localhost:8080` with `npx quartz serve`
- [ ] `./deploy-to-portfolio.sh` copies notes to portfolio
- [ ] `firebase serve` shows notes at `http://localhost:5000/notes/`
- [ ] GitHub Actions workflow runs successfully (if configured)
- [ ] Notes are live at `https://thamle.live/notes/`

## 🆘 Need Help?

1. Read [`NOTES_DEPLOYMENT.md`](../NOTES_DEPLOYMENT.md) - comprehensive troubleshooting guide
2. Check Quartz docs: https://quartz.jzhao.xyz/
3. Verify paths in all scripts are correct
4. Test locally before deploying

## 🔗 Repository Links

- **Portfolio Repo**: [tham-le/thamle-portfolio](https://github.com/tham-le/thamle-portfolio) (Public)
- **Notes Repo**: `git@github.com:tham-le/my-notes.git` (Private)

---

**Important Notes:**

- ⚠️ Don't commit `public/notes/` to portfolio repo (it's built separately)
- ⚠️ Always build Hugo BEFORE deploying notes
- ⚠️ GitHub tokens expire - set reminders to renew
- ⚠️ Test locally with `firebase serve` before deploying

**Workflow Summary:**

```
Write in Obsidian → Push to notes repo → GitHub Actions builds →
Copies to portfolio → Deploy portfolio → Live at thamle.live/notes
```

---

Created: 2025-10-28  
Maintained by: Tham Le
