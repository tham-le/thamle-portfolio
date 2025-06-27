#!/bin/bash

# Tham Le Portfolio - Quick Start Script
# Professional portfolio setup and development helper

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

log_header() {
    echo -e "${PURPLE}$1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display help
show_help() {
    log_header "🚀 Tham Le Portfolio - Quick Start"
    echo ""
    echo "Usage: ./quick-start.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup     - Initial setup and dependency installation"
    echo "  sync      - Sync content from GitHub and CTF writeups"
    echo "  dev       - Start development server"
    echo "  build     - Build production site"
    echo "  deploy    - Deploy to production"
    echo "  test      - Run tests and quality checks"
    echo "  clean     - Clean build artifacts"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./quick-start.sh setup    # First time setup"
    echo "  ./quick-start.sh dev      # Start development"
    echo "  ./quick-start.sh sync     # Update content"
    echo ""
}

# Function to check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    local missing_deps=()
    
    if ! command_exists hugo; then
        missing_deps+=("hugo")
    fi
    
    if ! command_exists jq; then
        missing_deps+=("jq")
    fi
    
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi
    
    if ! command_exists git; then
        missing_deps+=("git")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_info "Installing missing dependencies..."
        
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y "${missing_deps[@]}"
        elif command_exists brew; then
            brew install "${missing_deps[@]}"
        else
            log_error "Please install the missing dependencies manually"
            exit 1
        fi
    fi
    
    log_success "All requirements satisfied"
}

# Function to setup the project
setup_project() {
    log_header "🔧 Setting up Tham Le Portfolio"
    
    check_requirements
    
    log_info "Making scripts executable..."
    chmod +x sync-projects.sh
    chmod +x sync-writeups.sh
    
    log_info "Creating necessary directories..."
    mkdir -p content/{projects,ctf,blog}
    mkdir -p static/images/{projects,ctf}
    mkdir -p public
    
    log_info "Initializing Git submodules..."
    git submodule update --init --recursive || log_warning "No submodules to update"
    
    log_success "Project setup completed!"
    log_info "Next steps:"
    echo "  1. Run './quick-start.sh sync' to fetch latest content"
    echo "  2. Run './quick-start.sh dev' to start development server"
}

# Function to sync content
sync_content() {
    log_header "🔄 Syncing Content"
    
    log_info "Syncing GitHub projects..."
    if [[ -x "./sync-projects.sh" ]]; then
        ./sync-projects.sh
    else
        log_error "sync-projects.sh not found or not executable"
        exit 1
    fi
    
    log_info "Syncing CTF writeups..."
    if [[ -x "./sync-writeups.sh" ]]; then
        ./sync-writeups.sh
    else
        log_warning "sync-writeups.sh not found, skipping CTF sync"
    fi
    
    log_success "Content sync completed!"
}

# Function to start development server
start_dev_server() {
    log_header "🖥️  Starting Development Server"
    
    check_requirements
    
    # Check if Hugo is available
    if ! command_exists hugo; then
        log_error "Hugo is not installed. Run './quick-start.sh setup' first."
        exit 1
    fi
    
    log_info "Starting Hugo development server..."
    log_info "Server will be available at: http://localhost:1313"
    log_info "Press Ctrl+C to stop the server"
    echo ""
    
    # Start Hugo with development flags
    hugo server \
        --buildDrafts \
        --buildFuture \
        --disableFastRender \
        --ignoreCache \
        --port 1313 \
        --bind 0.0.0.0 \
        --baseURL "http://localhost:1313"
}

# Function to build production site
build_production() {
    log_header "🏗️  Building Production Site"
    
    check_requirements
    
    log_info "Cleaning previous build..."
    rm -rf public/*
    
    log_info "Building Hugo site for production..."
    hugo --minify --gc --enableGitInfo
    
    log_info "Optimizing images..."
    if command_exists optipng; then
        find public -name "*.png" -exec optipng -o2 {} \; 2>/dev/null || true
    fi
    
    if command_exists jpegoptim; then
        find public -name "*.jpg" -o -name "*.jpeg" | xargs jpegoptim --max=85 --strip-all 2>/dev/null || true
    fi
    
    log_success "Production build completed!"
    log_info "Built files are in the 'public' directory"
    
    # Show build statistics
    if [[ -d "public" ]]; then
        local file_count=$(find public -type f | wc -l)
        local size=$(du -sh public | cut -f1)
        echo ""
        echo "📊 Build Statistics:"
        echo "   Files: $file_count"
        echo "   Size:  $size"
    fi
}

# Function to run tests
run_tests() {
    log_header "🧪 Running Tests and Quality Checks"
    
    log_info "Building site for testing..."
    hugo --destination public-test
    
    log_info "Checking for broken links..."
    if command_exists htmlproofer; then
        htmlproofer public-test --check-html --check-opengraph --check-favicon --check-img-http
    else
        log_warning "htmlproofer not installed, skipping link checks"
    fi
    
    log_info "Validating HTML..."
    if command_exists html5validator; then
        html5validator --root public-test
    else
        log_warning "html5validator not installed, skipping HTML validation"
    fi
    
    log_info "Checking for security issues..."
    grep -r -i "api[_-]key\|password\|secret" public-test/ && {
        log_error "Potential sensitive data found!"
        exit 1
    } || log_success "No sensitive data detected"
    
    log_success "All tests passed!"
    rm -rf public-test
}

# Function to deploy
deploy_site() {
    log_header "🚀 Deploying to Production"
    
    log_info "This will trigger the GitHub Actions deployment pipeline"
    log_info "Make sure all changes are committed and pushed to the main branch"
    
    if [[ -n "$(git status --porcelain)" ]]; then
        log_warning "You have uncommitted changes. Commit them first:"
        git status --short
        exit 1
    fi
    
    log_info "Pushing to main branch..."
    git push origin main
    
    log_success "Deployment triggered!"
    log_info "Check GitHub Actions for deployment status:"
    echo "   https://github.com/tham-le/thamle-portfolio/actions"
    echo ""
    log_info "Site will be available at:"
    echo "   🌐 https://thamle.live"
}

# Function to clean build artifacts
clean_build() {
    log_header "🧹 Cleaning Build Artifacts"
    
    log_info "Removing build directories..."
    rm -rf public/
    rm -rf public-test/
    rm -rf resources/
    
    log_info "Clearing Hugo cache..."
    hugo mod clean
    
    log_success "Cleanup completed!"
}

# Function to show project status
show_status() {
    log_header "📊 Portfolio Status"
    
    echo ""
    echo "🏗️  Project Structure:"
    echo "   Content:"
    echo "     - Projects: $(find content/projects -name '*.md' -not -name '_index.md' 2>/dev/null | wc -l) items"
    echo "     - CTF Writeups: $(find content/ctf -name '*.md' -not -name '_index.md' 2>/dev/null | wc -l) items"
    echo "     - Blog Posts: $(find content/blog -name '*.md' -not -name '_index.md' 2>/dev/null | wc -l) items"
    
    echo ""
    echo "🔧 Dependencies:"
    command_exists hugo && echo "   ✅ Hugo $(hugo version | cut -d' ' -f2)" || echo "   ❌ Hugo (missing)"
    command_exists jq && echo "   ✅ jq" || echo "   ❌ jq (missing)"
    command_exists curl && echo "   ✅ curl" || echo "   ❌ curl (missing)"
    command_exists git && echo "   ✅ Git $(git --version | cut -d' ' -f3)" || echo "   ❌ Git (missing)"
    
    echo ""
    echo "📈 Recent Activity:"
    if [[ -d ".git" ]]; then
        echo "   Last commit: $(git log -1 --format='%cr - %s')"
        echo "   Branch: $(git branch --show-current)"
    fi
    
    echo ""
    echo "🌐 URLs:"
    echo "   Production: https://thamle.live"
    echo "   Repository: https://github.com/tham-le/thamle-portfolio"
    echo "   Local Dev:  http://localhost:1313 (when running)"
}

# Main execution
main() {
    case "${1:-help}" in
        setup)
            setup_project
            ;;
        sync)
            sync_content
            ;;
        dev|serve)
            start_dev_server
            ;;
        build)
            build_production
            ;;
        test)
            run_tests
            ;;
        deploy)
            deploy_site
            ;;
        clean)
            clean_build
            ;;
        status)
            show_status
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
