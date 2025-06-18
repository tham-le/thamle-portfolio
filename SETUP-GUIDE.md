# GitHub Repository Setup Guide

This guide will help you set up your portfolio repository for automatic deployment of CTF writeups.

## Repository Structure

Your repository should have this structure:

```
thamle-portfolio/
├── .github/
│   └── workflows/
│       ├── deploy-main-site.yml    # Deploy main portfolio
│       ├── deploy-ctf.yml          # Deploy CTF writeups app
│       └── sync-writeups.yml       # Sync from CTF-Writeups repo
├── public/                         # Main portfolio static files
│   ├── index.html
│   ├── ThamLE_resume.pdf
│   └── favicon.ico
├── ctf_app/                        # Flutter CTF writeups app
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
├── assets/
│   └── writeups/                   # CTF writeup markdown files
├── firebase.json                   # Firebase hosting config
└── README.md
```

## Required GitHub Secrets

You need to set up these secrets in your GitHub repository settings:

### 1. Firebase Deployment

- `FIREBASE_TOKEN`: Get this by running `firebase login:ci`
- `FIREBASE_PROJECT_ID`: Your Firebase project ID
- `FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO`: Firebase service account JSON

### 2. Cross-Repository Access (Optional)

- `PERSONAL_ACCESS_TOKEN`: GitHub personal access token with repo access
  - Only needed if you want to sync from a separate CTF-Writeups repository

## Setting Up Firebase

1. Install Firebase CLI:

   ```bash
   npm install -g firebase-tools
   ```

2. Login and initialize:

   ```bash
   firebase login
   firebase init
   ```

3. Configure hosting targets:

   ```bash
   firebase target:apply hosting main thamle-portfolio-main
   firebase target:apply hosting ctf-writeups thamle-portfolio-ctf
   ```

4. Get deployment token:

   ```bash
   firebase login:ci
   ```

## Deployment Workflow

### Main Portfolio Site

- Deploys to `thamle.live`
- Triggers on changes to `public/` directory
- Manual deployment via GitHub Actions

### CTF Writeups Site

- Deploys to `ctf.thamle.live`
- Triggers on:
  - Changes to `ctf_app/` or `assets/writeups/`
  - New writeups in external CTF-Writeups repository
  - Every 6 hours (scheduled sync)
  - Manual trigger

## Adding New CTF Writeups

### Method 1: Direct to Portfolio Repository

1. Add markdown file to `assets/writeups/`
2. Commit and push to main branch
3. Automatic deployment triggered

### Method 2: External CTF-Writeups Repository

1. Create separate repository: `tham-le/CTF-Writeups`
2. Add writeups as markdown files
3. Repository webhook triggers sync and deployment

## Subdomain Setup

Configure your DNS to point subdomains to Firebase:

1. In Firebase Console > Hosting
2. Add custom domain: `ctf.thamle.live`
3. Follow DNS verification steps
4. Add CNAME record: `ctf.thamle.live` → `your-project.web.app`

## Local Development

### Test main portfolio

```bash
cd public
python -m http.server 8000
# Visit http://localhost:8000
```

### Test CTF app

```bash
cd ctf_app
flutter pub get
flutter run -d web-server --web-port 8080
# Visit http://localhost:8080
```

## Repository Commands

### Initialize repository

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/tham-le/thamle-portfolio.git
git push -u origin main
```

### Enable GitHub Actions

- Go to repository Settings > Actions > General
- Allow all actions and reusable workflows
- Save

### Monitor deployments

- Check Actions tab for deployment status
- Firebase Console > Hosting for live sites
- Firebase CLI: `firebase hosting:sites:list`

## Troubleshooting

### Common Issues

1. **Firebase token expired**
   - Run `firebase login:ci` again
   - Update `FIREBASE_TOKEN` secret

2. **Permission denied errors**
   - Check `PERSONAL_ACCESS_TOKEN` has correct permissions
   - Verify repository access

3. **Build failures**
   - Check Flutter version in workflow
   - Verify pubspec.yaml dependencies

4. **Deployment timeouts**
   - Increase timeout in workflow
   - Check Firebase project quotas

### Debug Commands

```bash
# Check Firebase projects
firebase projects:list

# Test local deployment
firebase serve --only hosting:main
firebase serve --only hosting:ctf-writeups

# Check GitHub Actions logs
# Go to repository > Actions > Select failed workflow
```
