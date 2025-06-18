#!/bin/bash

# Portfolio Repository Setup Script
# This script helps set up the GitHub repository for automatic CTF writeup deployment

echo "🚀 Setting up Tham Le Portfolio Repository..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    git branch -M main
fi

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p .github/workflows
mkdir -p assets/writeups
mkdir -p public
mkdir -p ctf_app/lib/models
mkdir -p ctf_app/lib/services

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << 'EOF'
# Build artifacts
build/
.dart_tool/
.packages

# IDE
.vscode/
.idea/
*.iml

# Firebase
.firebase/
firebase-debug.log
firebase-debug.*.log

# Environment
.env
.env.local

# OS
.DS_Store
Thumbs.db

# Node
node_modules/
npm-debug.log*

# Temporary files
*.tmp
*.temp
EOF
fi

# Check for required files
echo "🔍 Checking required files..."

required_files=(
    "public/index.html"
    "firebase.json"
    ".github/workflows/deploy-ctf.yml"
    "ctf_app/pubspec.yaml"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo "⚠️  Missing required files:"
    for file in "${missing_files[@]}"; do
        echo "   - $file"
    done
    echo "Please ensure these files exist before proceeding."
else
    echo "✅ All required files present!"
fi

# Check for Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo "📦 Firebase CLI not found. Install with:"
    echo "   npm install -g firebase-tools"
else
    echo "✅ Firebase CLI found!"
fi

# Check for Flutter (for CTF app)
if ! command -v flutter &> /dev/null; then
    echo "📦 Flutter not found. Install from: https://flutter.dev/docs/get-started/install"
else
    echo "✅ Flutter found!"
fi

# Instructions for GitHub setup
echo ""
echo "🔧 Next steps:"
echo "1. Push this repository to GitHub:"
echo "   git add ."
echo "   git commit -m 'Initial portfolio setup'"
echo "   git remote add origin https://github.com/tham-le/thamle-portfolio.git"
echo "   git push -u origin main"
echo ""
echo "2. Set up GitHub Secrets (in repository Settings > Secrets and variables > Actions):"
echo "   - FIREBASE_TOKEN (get with: firebase login:ci)"
echo "   - FIREBASE_PROJECT_ID (your Firebase project ID)"
echo "   - FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO (Firebase service account JSON)"
echo ""
echo "3. Configure Firebase hosting:"
echo "   firebase init hosting"
echo "   firebase target:apply hosting main your-main-site"
echo "   firebase target:apply hosting ctf-writeups your-ctf-site"
echo ""
echo "4. Set up custom domains in Firebase Console:"
echo "   - Main site: thamle.live"
echo "   - CTF site: ctf.thamle.live"
echo ""
echo "📖 See SETUP-GUIDE.md for detailed instructions!"

# Add some sample writeup if assets/writeups is empty
if [ ! -f "assets/writeups/sample.md" ] && [ -z "$(ls -A assets/writeups 2>/dev/null)" ]; then
    echo "📝 Creating sample CTF writeup..."
    cat > assets/writeups/sample-web-challenge.md << 'EOF'
# Sample Web Challenge

**Category:** Web  
**Difficulty:** Easy  
**Points:** 100

## Challenge Description

This is a sample CTF writeup to demonstrate the structure. Replace this with your actual writeups.

## Solution

1. **Reconnaissance**: Analyzed the target application
2. **Vulnerability Discovery**: Found XSS vulnerability
3. **Exploitation**: Crafted payload to bypass filters
4. **Flag Retrieval**: Retrieved flag from admin session

## Flag

`CTF{sample_flag_here}`

## Tools Used

- Burp Suite
- Browser Developer Tools
- Custom Python script

## Lessons Learned

- Always check for client-side validation bypasses
- Inspect JavaScript for hidden functionality
- Use different payload encodings to bypass filters
EOF
fi

echo ""
echo "🎉 Repository setup complete!"
echo "Your portfolio is ready for deployment to Firebase!"
