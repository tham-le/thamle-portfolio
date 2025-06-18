# Portfolio & CTF Writeups Deployment Summary

## ✅ What's Been Set Up

### 1. Repository Structure

- ✅ Created proper directory structure for dual-site deployment
- ✅ Set up GitHub Actions workflows for automated deployment
- ✅ Added Firebase configuration for hosting both sites

### 2. Main Portfolio Site (thamle.live)

- ✅ Enhanced `public/index.html` with prominent CTF writeups button
- ✅ Added custom styling for the CTF button with gradient and hover effects
- ✅ Created workflow for automatic deployment of main site

### 3. CTF Writeups Site (ctf.thamle.live)  

- ✅ Set up Flutter web application for CTF writeups
- ✅ Created automated sync from external CTF-Writeups repository
- ✅ Added sample writeup to demonstrate structure
- ✅ Configured deployment workflow with multiple triggers

### 4. Automation & CI/CD

- ✅ GitHub Actions for automatic deployment
- ✅ Scheduled sync every 6 hours from external repository
- ✅ Manual trigger options for immediate deployment
- ✅ Cross-repository webhook support

## 🔧 Required Setup Steps

### 1. GitHub Repository

```bash
# Initialize and push to GitHub
git add .
git commit -m "Portfolio with automated CTF writeup deployment"
git remote add origin https://github.com/tham-le/thamle-portfolio.git
git push -u origin main
```

### 2. GitHub Secrets Configuration

In your repository Settings > Secrets and variables > Actions, add:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `FIREBASE_TOKEN` | Firebase CLI token | Run `firebase login:ci` |
| `FIREBASE_PROJECT_ID` | Your Firebase project ID | From Firebase Console |
| `FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO` | Service account JSON | Firebase Console > Project Settings > Service Accounts |
| `PERSONAL_ACCESS_TOKEN` | GitHub PAT (optional) | GitHub Settings > Developer settings > Personal access tokens |

### 3. Firebase Hosting Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Set up hosting targets
firebase target:apply hosting main thamle-portfolio-main
firebase target:apply hosting ctf-writeups thamle-portfolio-ctf

# Deploy manually (first time)
firebase deploy
```

### 4. Custom Domain Configuration

In Firebase Console > Hosting:

1. Add custom domain: `thamle.live` (main site)
2. Add custom domain: `ctf.thamle.live` (CTF site)
3. Configure DNS records as instructed by Firebase

## 🎯 How It Works

### Adding New CTF Writeups

**Method 1: Direct to this repository**

1. Add markdown file to `assets/writeups/`
2. Commit and push to main branch
3. Automatic deployment to `ctf.thamle.live`

**Method 2: External CTF-Writeups repository**

1. Create separate repository: `tham-le/CTF-Writeups`
2. Add writeups as markdown files
3. This repository automatically syncs every 6 hours
4. Manual sync available via GitHub Actions

### Deployment Triggers

- **Main site**: Changes to `public/` directory
- **CTF site**: Changes to `ctf_app/`, `assets/writeups/`, or external repository
- **Manual**: GitHub Actions > Run workflow
- **Scheduled**: Every 6 hours for CTF content sync

## 🚀 Features Added

### Enhanced Portfolio Button

- Prominent "🏴‍☠️ Explore My CTF Write-ups" button
- Custom gradient styling (red theme for security/hacking)
- Smooth hover animations and shadow effects
- Responsive design

### Automated Workflows

- Cross-repository synchronization
- Build and deployment automation
- Error handling and retry logic
- Status notifications

## 📁 File Structure Created

```
/home/tham/Obsidian/thamle-portfolio/
├── .github/workflows/
│   ├── deploy-main-site.yml      # Main portfolio deployment
│   ├── deploy-ctf.yml            # CTF writeups deployment  
│   └── sync-writeups.yml         # Sync from external repo
├── assets/writeups/
│   └── web-password-manager-traversal.md  # Sample writeup
├── SETUP-GUIDE.md                # Detailed setup instructions
├── setup-repo.sh                 # Automated setup script
└── README.md                     # Updated project documentation
```

## 🔍 Testing the Setup

### Local Development

```bash
# Test main portfolio
cd public && python -m http.server 8000

# Test CTF app (if Flutter is installed)
cd ctf_app && flutter run -d web-server --web-port 8080
```

### Production Testing

1. Push changes to GitHub
2. Monitor GitHub Actions for deployment status
3. Visit `thamle.live` and `ctf.thamle.live`
4. Test the CTF writeups button functionality

## 🎉 Next Steps

1. **Push to GitHub**: Use the commands above to create your repository
2. **Configure Secrets**: Add the required GitHub secrets
3. **Set up Firebase**: Follow the Firebase setup steps
4. **Test Deployment**: Make a small change and verify automatic deployment
5. **Add CTF Content**: Start adding your actual CTF writeups!

Your portfolio is now ready for automated deployment with a dedicated CTF writeups section that updates automatically whenever you add new content!
