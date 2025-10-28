#!/bin/bash

#############################################################################
# Quick Setup Script for Quartz Notes Integration
#############################################################################
# This script helps set up the Quartz configuration in your notes repository
#
# Usage:
#   ./setup-quartz-integration.sh /path/to/notes-repo
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check arguments
if [ -z "$1" ]; then
    print_error "Please provide the path to your notes repository"
    echo "Usage: $0 /path/to/notes-repo"
    exit 1
fi

NOTES_REPO="$1"
PORTFOLIO_REPO="$(pwd)"

# Verify we're in portfolio repo
if [ ! -f "$PORTFOLIO_REPO/hugo.toml" ]; then
    print_error "This script must be run from the portfolio repository root"
    exit 1
fi

# Verify notes repo exists
if [ ! -d "$NOTES_REPO" ]; then
    print_error "Notes repository not found at: $NOTES_REPO"
    exit 1
fi

print_step "Setting up Quartz integration..."
echo ""
echo "Portfolio repo: $PORTFOLIO_REPO"
echo "Notes repo: $NOTES_REPO"
echo ""

# Copy template files
print_step "Copying configuration files to notes repository..."

if [ -f "$PORTFOLIO_REPO/quartz.config.ts.template" ]; then
    cp "$PORTFOLIO_REPO/quartz.config.ts.template" "$NOTES_REPO/quartz.config.ts"
    print_success "Copied quartz.config.ts"
else
    print_error "quartz.config.ts.template not found"
    exit 1
fi

if [ -f "$PORTFOLIO_REPO/deploy-to-portfolio.sh.template" ]; then
    cp "$PORTFOLIO_REPO/deploy-to-portfolio.sh.template" "$NOTES_REPO/deploy-to-portfolio.sh"
    chmod +x "$NOTES_REPO/deploy-to-portfolio.sh"
    
    # Update the default path in deploy script
    sed -i "s|PORTFOLIO_PATH=\"\${1:-../thamle-portfolio}\"|PORTFOLIO_PATH=\"\${1:-$PORTFOLIO_REPO}\"|g" "$NOTES_REPO/deploy-to-portfolio.sh"
    
    print_success "Copied deploy-to-portfolio.sh (made executable)"
else
    print_error "deploy-to-portfolio.sh.template not found"
    exit 1
fi

if [ -f "$PORTFOLIO_REPO/.github/workflows/deploy-notes.yml.template" ]; then
    mkdir -p "$NOTES_REPO/.github/workflows"
    cp "$PORTFOLIO_REPO/.github/workflows/deploy-notes.yml.template" "$NOTES_REPO/.github/workflows/deploy-notes.yml"
    print_success "Copied GitHub Actions workflow"
else
    print_error ".github/workflows/deploy-notes.yml.template not found"
fi

# Create .gitignore if needed
if [ ! -f "$NOTES_REPO/.gitignore" ]; then
    print_step "Creating .gitignore..."
    cat > "$NOTES_REPO/.gitignore" << 'EOF'
# Quartz build output
public/

# Node modules
node_modules/
package-lock.json

# OS files
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
EOF
    print_success "Created .gitignore"
fi

# Create package.json if needed
if [ ! -f "$NOTES_REPO/package.json" ]; then
    print_step "Creating package.json..."
    cat > "$NOTES_REPO/package.json" << 'EOF'
{
  "name": "obsidian-notes-quartz",
  "version": "1.0.0",
  "description": "Obsidian notes built with Quartz",
  "scripts": {
    "build": "npx quartz build",
    "serve": "npx quartz serve",
    "deploy": "./deploy-to-portfolio.sh"
  },
  "keywords": ["quartz", "obsidian", "notes"],
  "author": "Tham Le"
}
EOF
    print_success "Created package.json"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. Install Quartz in your notes repository:"
echo "   cd $NOTES_REPO"
echo "   npx quartz create"
echo "   (Choose 'Empty Quartz' when prompted)"
echo ""
echo "2. Test the build:"
echo "   npm run build"
echo ""
echo "3. Deploy to portfolio:"
echo "   npm run deploy"
echo ""
echo "4. Set up GitHub Actions (optional):"
echo "   - Create a GitHub Personal Access Token"
echo "   - Add it as PORTFOLIO_PAT secret in your notes repo"
echo ""
echo "5. Read the full documentation:"
echo "   less $PORTFOLIO_REPO/NOTES_DEPLOYMENT.md"
echo ""
echo -e "${BLUE}Tip:${NC} Test locally first with 'npm run serve' in your notes repo"
echo ""
