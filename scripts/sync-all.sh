#!/bin/bash

# Master Sync Script
# Loads environment variables and syncs both projects and CTF writeups

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load environment variables from .env file
if [[ -f .env ]]; then
    log_info "Loading environment variables from .env file..."
    source .env
    log_success "Environment variables loaded"
else
    log_error ".env file not found!"
    log_info "Please create a .env file with your GitHub token:"
    echo "GITHUB_TOKEN=your_github_token_here"
    echo "GITHUB_USERNAME=tham-le"
    exit 1
fi

# Verify GitHub token is set
if [ -z "$GITHUB_TOKEN" ]; then
    log_error "GITHUB_TOKEN not set in .env file"
    log_info "Add your GitHub token to .env file: GITHUB_TOKEN=your_token_here"
    exit 1
fi

log_info "Starting full portfolio sync..."

# Sync projects from GitHub API
log_info "Syncing projects from GitHub..."
if ./scripts/sync-projects.sh; then
    log_success "Projects synced successfully"
else
    log_error "Project sync failed"
    exit 1
fi

# Update CTF writeups submodule
log_info "Updating CTF writeups submodule..."
if git submodule update --remote content/ctf-external; then
    log_success "CTF writeups submodule updated"
else
    log_warning "CTF writeups submodule update failed or no changes"
fi

# Sync CTF writeups
log_info "Processing CTF writeups..."
if ./scripts/sync-writeups.sh; then
    log_success "CTF writeups processed successfully"
else
    log_error "CTF writeups processing failed"
    exit 1
fi

log_success "Full portfolio sync completed!"
log_info "You can now run 'hugo server' to preview your site" 