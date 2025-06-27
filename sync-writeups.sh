#!/bin/bash

# CTF Writeups Sync Script
# Note: temp-analysis directory is no longer used - CTF writeups are managed via submodules
# This script is kept for compatibility but exits early

set -e

# Load environment variables from .env file if it exists
if [[ -f .env ]]; then
    source .env
fi

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_info "CTF writeups sync script called"
log_info "temp-analysis directory is no longer used - CTF writeups are managed via submodules"
log_success "CTF writeups sync completed (no action needed)"

exit 0
