#!/bin/bash

# Test script for GitHub project sync
# Usage: ./test-sync.sh [repo-name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    log_warning "GITHUB_TOKEN not set. You may hit rate limits."
    echo "To set your token:"
    echo "export GITHUB_TOKEN=your_github_token_here"
    echo ""
fi

# Test API access
log_info "Testing GitHub API access..."
if [ -n "$GITHUB_TOKEN" ]; then
    RATE_LIMIT=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit | jq -r '.rate.remaining')
    log_success "API access OK. Rate limit remaining: $RATE_LIMIT"
else
    RATE_LIMIT=$(curl -s https://api.github.com/rate_limit | jq -r '.rate.remaining')
    log_warning "Using unauthenticated API. Rate limit remaining: $RATE_LIMIT"
fi

# Run sync
if [ $# -eq 1 ]; then
    log_info "Testing sync for specific repository: $1"
    # Create a test function to sync just one repo
    export GITHUB_USERNAME="tham-le"
    source sync-projects.sh
    
    REPO_DATA=$(get_repo_data "$1")
    if echo "$REPO_DATA" | jq -e '.name' >/dev/null 2>&1; then
        README_CONTENT=$(get_repo_readme "$1")
        create_project_content "$REPO_DATA" "$README_CONTENT"
        log_success "Successfully synced: $1"
        
        # Show what was created
        if [ -f "content/projects/$1.md" ]; then
            log_info "Created content file: content/projects/$1.md"
        fi
        
        if [ -d "static/images/projects/$1" ]; then
            IMAGE_COUNT=$(find "static/images/projects/$1" -type f | wc -l)
            log_info "Downloaded $IMAGE_COUNT images to: static/images/projects/$1/"
        fi
    else
        log_error "Repository not found: $1"
        exit 1
    fi
else
    log_info "Running full project sync..."
    ./sync-projects.sh
fi

log_success "Test completed successfully!" 