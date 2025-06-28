#!/bin/bash

# GitHub Projects Sync Script
# Automatically syncs selected repositories from GitHub and creates Hugo content

set -e

# Make script path-independent by defining paths relative to the project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(realpath "${SCRIPT_DIR}/..")"

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

# Load environment variables from .env file in the project root
if [[ -f "${PROJECT_ROOT}/.env" ]]; then
    source "${PROJECT_ROOT}/.env"
fi

# Configuration
GITHUB_USERNAME="${GITHUB_USERNAME:-tham-le}"
PROJECTS_DIR="${PROJECT_ROOT}/content/projects"
IMAGES_DIR="${PROJECT_ROOT}/static/images/projects"
GITHUB_API="https://api.github.com"
PROJECTS_CONFIG="${PROJECT_ROOT}/config/projects-config.json"

# Check for projects config file
if [[ ! -f "$PROJECTS_CONFIG" ]]; then
    log_error "projects-config.json not found at '${PROJECTS_CONFIG}'. Please ensure the file exists."
    exit 1
fi

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    log_warning "GITHUB_TOKEN not set in .env file. API rate limits may apply."
    log_warning "Create a .env file with: GITHUB_TOKEN=your_github_token_here"
    AUTH_HEADER=""
else
    AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command_exists curl; then
        log_error "curl is required but not installed."
        exit 1
    fi
    
    if ! command_exists jq; then
        log_error "jq is required but not installed. Please install jq."
        exit 1
    fi
    
    log_success "All dependencies are available."
}

# Function to escape markdown content to prevent code block issues
escape_readme_content() {
    local content="$1"
    local max_lines="${2:-30}"
    
    # Take only the first N lines to prevent overly long content
    local trimmed_content=$(echo "$content" | head -n "$max_lines")
    
    # Escape code blocks by adding proper indentation
    # This prevents README code blocks from breaking the Hugo markdown structure
    echo "$trimmed_content" | sed 's/^```/    ```/g'
}

# Function to get repository data from GitHub API
get_repo_data() {
    local repo_name="$1"
    local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}"
    
    if [ -n "$AUTH_HEADER" ]; then
        curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url"
    else
        curl -s -H "Accept: application/vnd.github.v3+json" "$api_url"
    fi
}

# Function to get repository README
get_repo_readme() {
    local repo_name="$1"
    local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}/readme"
    
    local readme_data
    if [ -n "$AUTH_HEADER" ]; then
        readme_data=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url")
    else
        readme_data=$(curl -s -H "Accept: application/vnd.github.v3+json" "$api_url")
    fi
    
    if echo "$readme_data" | jq -e '.content' >/dev/null 2>&1; then
        echo "$readme_data" | jq -r '.content' | base64 -d
    else
        echo ""
    fi
}

# Function to get programming language data
get_languages() {
    local repo_name="$1"
    local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}/languages"
    
    if [ -n "$AUTH_HEADER" ]; then
        curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url" | jq -r 'keys | .[]'
    else
        curl -s -H "Accept: application/vnd.github.v3+json" "$api_url" | jq -r 'keys | .[]'
    fi
}

# Function to determine category based on repository data
determine_category() {
    local repo_name="$1"
    local description="$2"
    local languages="$3"
    
    # Convert to lowercase for easier matching
    local desc_lower=$(echo "$description" | tr '[:upper:]' '[:lower:]')
    local name_lower=$(echo "$repo_name" | tr '[:upper:]' '[:lower:]')
    
    # Category determination logic
    if [[ "$desc_lower" == *"web"* ]] || [[ "$desc_lower" == *"react"* ]] || [[ "$desc_lower" == *"vue"* ]] || [[ "$desc_lower" == *"django"* ]] || [[ "$languages" == *"JavaScript"* ]] || [[ "$languages" == *"TypeScript"* ]]; then
        echo "Web Development"
    elif [[ "$desc_lower" == *"security"* ]] || [[ "$desc_lower" == *"ctf"* ]] || [[ "$name_lower" == *"security"* ]] || [[ "$name_lower" == *"ctf"* ]] || [[ "$name_lower" == *"darkly"* ]]; then
        echo "Cybersecurity"
    elif [[ "$desc_lower" == *"mobile"* ]] || [[ "$desc_lower" == *"android"* ]] || [[ "$desc_lower" == *"ios"* ]] || [[ "$languages" == *"Swift"* ]] || [[ "$languages" == *"Kotlin"* ]]; then
        echo "Mobile Development"
    elif [[ "$desc_lower" == *"data"* ]] || [[ "$desc_lower" == *"science"* ]] || [[ "$desc_lower" == *"analysis"* ]] || [[ "$languages" == *"Python"* ]]; then
        echo "Data Science"
    elif [[ "$desc_lower" == *"game"* ]] || [[ "$desc_lower" == *"graphics"* ]] || [[ "$desc_lower" == *"3d"* ]] || [[ "$name_lower" == *"rt"* ]] || [[ "$name_lower" == *"fractol"* ]]; then
        echo "Graphics & Games"
    elif [[ "$desc_lower" == *"system"* ]] || [[ "$desc_lower" == *"kernel"* ]] || [[ "$languages" == *"C"* ]] || [[ "$languages" == *"C++"* ]]; then
        echo "System Programming"
    elif [[ "$desc_lower" == *"script"* ]] || [[ "$desc_lower" == *"automation"* ]] || [[ "$desc_lower" == *"tool"* ]]; then
        echo "Scripts & Tools"
    else
        echo "Other"
    fi
}

# Function to get default branch for repository
get_default_branch() {
    local repo_name="$1"
    local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}"
    
    local repo_info
    if [ -n "$AUTH_HEADER" ]; then
        repo_info=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url")
    else
        repo_info=$(curl -s -H "Accept: application/vnd.github.v3+json" "$api_url")
    fi
    
    if echo "$repo_info" | jq -e '.default_branch' >/dev/null 2>&1; then
        echo "$repo_info" | jq -r '.default_branch'
    else
        echo "main"  # fallback
    fi
}

# Function to get all images from GitHub repository (reference only, no download)
get_repo_images() {
    local repo_name="$1"
    
    # Get the default branch for this repository
    local default_branch=$(get_default_branch "$repo_name")
    
    # Search in multiple common image directories
    local search_dirs=("image" "images" "assets" "screenshots" "docs" "media" "pics")
    local images_found=()
    local main_image=""
    
    log_info "Finding images in repository: $repo_name (branch: $default_branch)" >&2
    
    for dir in "${search_dirs[@]}"; do
        local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}/contents/${dir}"
        
        # Use authentication if available
        local dir_contents
        if [ -n "$AUTH_HEADER" ]; then
            dir_contents=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url" 2>/dev/null)
        else
            dir_contents=$(curl -s -H "Accept: application/vnd.github.v3+json" "$api_url" 2>/dev/null)
        fi
        
        # Check if we got valid JSON array (directory exists and has contents)
        if echo "$dir_contents" | jq -e 'type == "array"' >/dev/null 2>&1; then
            log_info "Checking directory: $dir" >&2
            
            # Find all image files and create GitHub raw URLs
            local image_files=$(echo "$dir_contents" | jq -r '.[] | select(.type == "file" and (.name | test("\\.(png|jpg|jpeg|gif|svg|webp|bmp)$"; "i"))) | .name')
            
            while IFS= read -r image_file; do
                if [ -n "$image_file" ]; then
                    local extension="${image_file##*.}"
                    local base_name="${image_file%.*}"
                    # Create GitHub raw URL for direct reference with correct branch
                    local github_raw_url="https://raw.githubusercontent.com/${GITHUB_USERNAME}/${repo_name}/${default_branch}/${dir}/${image_file}"
                    
                    log_success "Found image: $dir/$image_file" >&2
                    images_found+=("$github_raw_url")
                    
                    # Set main image (prefer screenshot, demo, preview, then first image)
                    if [ -z "$main_image" ] || [[ "$base_name" =~ ^(screenshot|demo|preview|cover|banner)$ ]]; then
                        main_image="$github_raw_url"
                    fi
                fi
            done <<< "$image_files"
        fi
    done
    
    # If no images found, don't use placeholder - leave empty
    if [ ${#images_found[@]} -eq 0 ]; then
        main_image=""
        log_info "No images found for $repo_name - will skip image display" >&2
    fi
    
    # Return main image and all images (JSON format)
    jq -n --arg main "$main_image" --argjson all "$(printf '%s\n' "${images_found[@]}" | jq -R . | jq -s .)" '{main: $main, all: $all}'
}

# Function to generate the complete Hugo content file for a project
generate_hugo_content() {
    local repo_name="$1"
    local repo_data="$2"
    local project_config="$3"
    local main_image="$4"
    # Capture the rest of the arguments as the array of all image URLs
    shift 4
    local all_image_urls=("$@")

    # Extract data from JSON
    local project_name=$(echo "$repo_data" | jq -r '.name')
    local description=$(echo "$repo_data" | jq -r '.description // "No description available"')
    local html_url=$(echo "$repo_data" | jq -r '.html_url')
    local creation_date=$(echo "$repo_data" | jq -r '.created_at')
    local last_mod_date=$(echo "$repo_data" | jq -r '.updated_at')
    local homepage=$(echo "$repo_data" | jq -r '.homepage // ""')
    local languages=$(get_languages "$repo_name")
    
    local project_file="${PROJECTS_DIR}/${project_name}.md"

    # --- Front Matter Generation ---
    {
        echo "---"
        echo "title: \"${project_name}\""
        echo "date: ${creation_date}"
        echo "lastmod: ${last_mod_date}"
        echo "description: \"${description}\""
        echo "image: \"${main_image}\""

        # Add carousel section only if there are images
        if [ ${#all_image_urls[@]} -gt 0 ]; then
            local carousel_id="${project_name// /-}"
            carousel_id="${carousel_id,,}"
            echo "showFeatureImage: false"
            echo "carousel:"
            echo "  id: \"${carousel_id}\""
            echo "  title: \"${project_name} Gallery\""
            echo "  images:"
            for img in "${all_image_urls[@]}"; do
                echo "    - \"${img}\""
            done
        else
            echo "showFeatureImage: true"
        fi
        
        # Add links
        echo "links:"
        echo "  - title: \"GitHub Repository\""
        echo "    description: \"View source code and documentation\""
        echo "    website: \"${html_url}\""
        echo "    image: \"https://github.githubassets.com/favicons/favicon.svg\""
        if [ -n "$homepage" ] && [ "$homepage" != "null" ]; then 
            echo "  - title: \"Live Demo\""
            echo "    description: \"View the live application\""
            echo "    website: \"${homepage}\""
            echo "    image: \"${homepage}/favicon.ico\""
        fi

        # Add categories and tags
        echo "categories:"
        echo "  - \"Projects\""
        local category=$(determine_category "$repo_name" "$description" "$languages")
        echo "  - \"${category}\""
        echo "tags:"
        for lang in $languages; do
            echo "    - \"${lang}\""
        done
        echo "    - \"GitHub\""

        # Add other metadata
        echo "weight: 1"
        echo "stats:"
        echo "    stars: $(echo "$repo_data" | jq -r '.stargazers_count')"
        echo "    forks: $(echo "$repo_data" | jq -r '.forks_count')"
        echo "    language: $(echo "$repo_data" | jq -r '.language // "Unknown"')"
        echo "---"
        echo ""
    } > "$project_file"

    # --- README Content ---
    readme_content=$(get_repo_readme "$repo_name")
    if [ -n "$readme_content" ]; then
        # Remove the shortcode from the old README content before appending
        readme_content=$(echo "$readme_content" | sed '/{{< project-carousel.*>}}/d')
        echo "$readme_content" >> "$project_file"
    fi
}

# Function to sync selected repositories from config
sync_repositories() {
    log_info "Loading project configuration from: $PROJECTS_CONFIG"
    
    # Read featured projects from config
    local featured_projects=$(jq -r '.featured_projects[] | @base64' "$PROJECTS_CONFIG")
    local total_projects=$(jq -r '.featured_projects | length' "$PROJECTS_CONFIG")
    
    log_info "Found $total_projects featured projects in configuration"
    
    # Process each featured project
    while IFS= read -r project_data; do
        local project=$(echo "$project_data" | base64 -d)
        local name=$(echo "$project" | jq -r '.name')
        local priority=$(echo "$project" | jq -r '.priority')
        local config_description=$(echo "$project" | jq -r '.description')
        
        log_info "Processing featured project: $name (priority: $priority)"
        
        # Get full repository data from GitHub
        local full_repo_data=$(get_repo_data "$name")
        
        # Check if repo data was retrieved successfully
        if ! echo "$full_repo_data" | jq -e '.name' >/dev/null 2>&1; then
            log_warning "Failed to get data for repository: $name"
            continue
        fi
        
        # Get README content
        local readme_content=$(get_repo_readme "$name")
        
        # Create content file with config description
        create_project_content "$full_repo_data" "$readme_content" "$config_description"
        
        log_success "Synced featured project: $name"
    done <<< "$featured_projects"
}

# Function to update projects index
update_projects_index() {
    local index_file="${PROJECTS_DIR}/_index.md"
    local total_projects=$(find "$PROJECTS_DIR" -name "*.md" -not -name "_index.md" | wc -l)
    
    # Check if index file exists and has custom content
    if [ -f "$index_file" ]; then
        # Only update the project count if the file exists
        # This preserves manually crafted content while keeping count current
        log_info "Index file exists - preserving manual content, updating project count only"
        
        # Update the project count in existing file if it contains the pattern
        if grep -q "featuring \*\*[0-9]\+\*\* projects" "$index_file"; then
            sed -i "s/featuring \*\*[0-9]\+\*\* projects/featuring **$total_projects** projects/" "$index_file"
            log_success "Updated project count to $total_projects in existing index"
        else
            log_info "Manual index file doesn't contain project count pattern - leaving unchanged"
        fi
        return
    fi
    
    # Only create new index if none exists
    cat > "$index_file" << EOF
---
title: "Projects"
description: "Featured projects showcasing learning and growth"
date: $(date -Iseconds)
draft: false
---

# Featured Projects

These are carefully selected projects that represent key learning milestones and technical achievements. Each project demonstrates growth in different areas of software engineering.

The projects are curated to show progression from foundational concepts to advanced implementations, focusing on quality over quantity.

## Learning Areas

**Systems Programming** - Working with C/C++, memory management, and performance optimization

**Web Development** - Full-stack applications, APIs, and user interfaces

**Security & CTF** - Tools and solutions for cybersecurity challenges

**Graphics & Visualization** - Mathematical rendering and interactive applications

**DevOps & Infrastructure** - Containerization, deployment, and system architecture

---

*Projects are selectively synced based on significance and learning value.*
EOF

    log_success "Created new projects index with $total_projects featured projects"
}

# Main execution
main() {
    log_info "Starting GitHub project synchronization..."
    log_info "Reading projects from: ${YELLOW}${PROJECTS_CONFIG}${NC}"
    log_info "Outputting content to: ${YELLOW}${PROJECTS_DIR}${NC}"

    mkdir -p "$PROJECTS_DIR"

    # Read projects from JSON config and process them
    jq -c '.featured_projects[]' "$PROJECTS_CONFIG" | while read -r project_json; do
        repo_name=$(echo "$project_json" | jq -r '.name')
        
        log_info "Processing repository: ${YELLOW}${repo_name}${NC}"
        
        repo_data=$(get_repo_data "$repo_name")
        
        if [ -z "$repo_data" ] || echo "$repo_data" | jq -e '.message == "Not Found"' > /dev/null; then
            log_error "Repository not found or API error for ${repo_name}. Skipping."
            continue
        fi
        
        # --- Get all image URLs ---
        images_json=$(get_repo_images "$repo_name")
        main_image=$(echo "$images_json" | jq -r '.main')
        all_image_urls=($(echo "$images_json" | jq -r '.all[]'))

        # --- Generate Hugo Content ---
        generate_hugo_content "$repo_name" "$repo_data" "$project_json" "$main_image" "${all_image_urls[@]}"

        log_success "Successfully processed and created content for ${repo_name}"
    done

    log_info "Project synchronization complete."
    log_success "All configured projects have been updated."
}

# Run main function
main "$@"
