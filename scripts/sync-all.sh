#!/bin/bash

# Master Sync Script
# Runs all sync operations in the correct order

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

log_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Function to check if script exists and is executable
check_script() {
    local script="$1"
    if [[ ! -f "$script" ]]; then
        log_error "Script not found: $script"
        return 1
    fi
    if [[ ! -x "$script" ]]; then
        log_warning "Script not executable: $script - making executable"
        chmod +x "$script"
    fi
    return 0
}

# Function to run script with error handling
run_script() {
    local script="$1"
    local description="$2"
    
    log_step "Running: $description"
    
    if check_script "$script"; then
        if "$script"; then
            log_success "Completed: $description"
            return 0
        else
            log_error "Failed: $description"
            return 1
        fi
    else
        return 1
    fi
}

# Main sync function
main() {
    log_info "Starting complete portfolio sync..."
    echo ""
    
    local start_time=$(date +%s)
    local failed_scripts=()
    
    # Step 1: Sync GitHub projects
    if run_script "./sync-projects.sh" "GitHub Projects Sync"; then
        echo ""
    else
        failed_scripts+=("sync-projects.sh")
    fi
    
    # Step 2: CTF writeups are handled via submodule - no sync needed
    log_info "CTF writeups are managed via git submodule - skipping sync"
    
    # Step 3: Generate featured articles
    if run_script "./generate-featured-articles.sh" "Featured Articles Generation"; then
        echo ""
    else
        failed_scripts+=("generate-featured-articles.sh")
    fi
    
    # Calculate duration
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Summary
    echo "=============================================="
    log_info "Portfolio Sync Summary"
    echo "=============================================="
    
    if [[ ${#failed_scripts[@]} -eq 0 ]]; then
        log_success "All sync operations completed successfully!"
        log_info "Duration: ${duration}s"
        echo ""
        log_info "Next steps:"
        echo "  1. Review generated content"
        echo "  2. Test with: hugo server -D"
        echo "  3. Build with: hugo --minify"
        echo "  4. Deploy when ready"
    else
        log_warning "Some operations failed:"
        for script in "${failed_scripts[@]}"; do
            echo "  - $script"
        done
        log_info "Duration: ${duration}s"
        echo ""
        log_info "Please check the errors above and re-run failed scripts individually"
    fi
    
    echo "=============================================="
}

# Show help
show_help() {
    echo "Portfolio Master Sync Script"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  --projects     Run only projects sync"
    echo "  --writeups     Run only writeups sync"
    echo "  --featured     Run only featured articles generation"
    echo ""
    echo "This script runs all sync operations in order:"
    echo "  1. GitHub projects sync (./sync-projects.sh)"
    echo "  2. CTF writeups (managed via git submodule)"
    echo "  3. Featured articles generation (./generate-featured-articles.sh)"
    echo ""
    echo "Configuration files:"
    echo "  - config/projects-config.json"
    echo "  - config/featured-articles.json"
    echo ""
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    --projects)
        run_script "./sync-projects.sh" "GitHub Projects Sync"
        exit $?
        ;;
    --writeups)
        log_info "CTF writeups are managed via git submodule in content/ctf/"
        log_info "To update: git submodule update --remote content/ctf"
        exit 0
        ;;
    --featured)
        run_script "./generate-featured-articles.sh" "Featured Articles Generation"
        exit $?
        ;;
    "")
        main
        ;;
    *)
        log_error "Unknown option: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 