# 🚀 Git Submodule Setup for CTF Writeups

## Overview

This portfolio now uses Git submodules to manage external CTF writeups, providing a cleaner and more professional approach than cloning repositories in CI/CD workflows.

## 📁 Structure

```
thamle-portfolio/
├── external-writeups/          # Git submodule → tham-le/CTF-Writeups
│   ├── IrisCTF/
│   │   ├── Web_Exploitation/
│   │   ├── Cryptography/
│   │   ├── Forensics/
│   │   ├── Open-Source_Intelligence/
│   │   └── Binary_Exploitation/
│   ├── HeroCTF_v6/
│   ├── CyberApocalypse2025/
│   └── ... (other CTF events)
├── ctf_site/                   # Deployed to ctf.thamle.live
│   └── assets/writeups/        # Processed writeups
├── ctf_app/                    # Flutter app - deployed to ctf-flutter-app.web.app
│   └── assets/writeups/        # Processed writeups (Dart)
```

## 🔧 Local Development

### Initial Setup

```bash
# Clone with submodules
git clone --recursive https://github.com/tham-le/thamle-portfolio.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### Update External Writeups

```bash
# Update submodule to latest commits
git submodule update --remote --merge

# Test sync locally
./scripts/sync-writeups-submodule.sh
```

### Committing Submodule Updates

```bash
# Add submodule changes
git add external-writeups

# Commit with descriptive message
git commit -m "Update external writeups submodule"

# Push (triggers auto-deployment)
git push
```

## 🤖 Automated Workflow

The GitHub Actions workflow (`.github/workflows/sync-writeups.yml`) automatically:

1. **Updates submodule** to latest commits
2. **Discovers writeups** using intelligent parsing:
   - Supports both `writeup.md` and `wu.md` files
   - Handles various category naming conventions
   - Extracts metadata from YAML frontmatter
3. **Processes images** and updates paths
4. **Generates statistics** for recruiter appeal
5. **Deploys to Firebase** hosting

## 📊 Supported CTF Structure

The system handles multiple formats:

### Format 1: Directory Structure (Current)

```
IrisCTF/
├── Web_Exploitation/
│   └── Political/
│       ├── writeup.md
│       └── images/
└── Cryptography/
    └── KittyCrypt/
        └── wu.md
```

### Format 2: Filename Pattern (Future)

```
IrisCTF-web-political-writeup.md
IrisCTF-crypto-kittycrypt-wu.md
```

## 🎯 Benefits of Submodule Approach

1. **Version Control**: Track exact commits of external writeups
2. **Cleaner CI/CD**: No repository cloning in workflows
3. **Local Development**: Easy testing and development
4. **Professional**: Industry-standard Git practice
5. **Reliable**: Consistent builds and deployments

## 🧪 Testing

```bash
# Test submodule setup
./scripts/test-submodule-sync.sh

# Test full sync process
./scripts/sync-writeups-submodule.sh
```

## 🚀 Deployment

The portfolio automatically deploys to:

- **CTF Site**: <https://ctf.thamle.live/> (HTML/JS)
- **Flutter App**: <https://ctf-flutter-app.web.app/> (Dart/Flutter)

## 🛠️ Troubleshooting

### Submodule Issues

```bash
# Reset submodule
git submodule deinit external-writeups
git submodule update --init

# Force update
git submodule update --remote --force
```

### Sync Issues

```bash
# Check submodule status
git submodule status

# Verify external writeups structure
find external-writeups -name "*.md" | head -10
```

---

This setup showcases professional Git workflow practices and clean architecture principles that recruiters value! 🌟
