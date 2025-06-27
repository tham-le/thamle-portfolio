#!/bin/bash

# Portfolio Setup Script
# Helps initialize the portfolio with proper configuration

set -e

echo "🚀 Setting up Tham Le Portfolio..."

# Check if .env exists
if [[ ! -f .env ]]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Edit .env file and add your GitHub token!"
    echo "   1. Get your token from: https://github.com/settings/tokens"
    echo "   2. Edit .env file: nano .env"
    echo "   3. Replace 'your_github_token_here' with your actual token"
    echo ""
else
    echo "✅ .env file already exists"
fi

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x sync-all.sh
chmod +x sync-projects.sh
chmod +x sync-writeups.sh
chmod +x test-sync.sh
echo "✅ Scripts are now executable"

# Check dependencies
echo "🔍 Checking dependencies..."
missing_deps=()

if ! command -v hugo &> /dev/null; then
    missing_deps+=("hugo")
fi

if ! command -v jq &> /dev/null; then
    missing_deps+=("jq")
fi

if ! command -v curl &> /dev/null; then
    missing_deps+=("curl")
fi

if [ ${#missing_deps[@]} -eq 0 ]; then
    echo "✅ All dependencies are installed"
else
    echo "❌ Missing dependencies: ${missing_deps[*]}"
    echo "   Please install them before proceeding"
    echo ""
    echo "   Ubuntu/Debian: sudo apt install jq curl"
    echo "   Hugo: https://gohugo.io/installation/"
    exit 1
fi

echo ""
echo "🎉 Portfolio setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your GitHub token"
echo "2. Run: ./sync-all.sh"
echo "3. Run: hugo server"
echo "4. Open: http://localhost:1313" 