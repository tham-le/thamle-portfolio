#!/bin/bash

# GitHub Projects Sync Script
# Automatically syncs repositories from GitHub and creates Hugo content

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

# Load environment variables from .env file if it exists
# Handle both running from scripts/ directory and root directory
if [[ -f .env ]]; then
    source .env
elif [[ -f ../.env ]]; then
    source ../.env
fi

# Configuration
GITHUB_USERNAME="${GITHUB_USERNAME:-tham-le}"
PROJECTS_DIR="../content/projects"
IMAGES_DIR="../static/images/projects"
GITHUB_API="https://api.github.com"

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

# Function to generate gallery HTML for project
generate_gallery_html() {
    local images_json="$1"
    local project_name="$2"
    local main_image=$(echo "$images_json" | jq -r '.main')
    local all_images=$(echo "$images_json" | jq -r '.all[]')
    local image_count=$(echo "$images_json" | jq -r '.all | length')
    
    # Don't show gallery if no images or only empty/null images
    if [ "$image_count" -eq 0 ] || [ -z "$main_image" ] || [ "$main_image" = "null" ]; then
        echo ""
        return
    fi
    
    # For single image, just show it normally (no carousel needed)
    if [ "$image_count" -eq 1 ]; then
        echo ""
        echo "## Project Image"
        echo ""
        local filename=$(basename "$main_image")
        local name="${filename%.*}"
        local title=$(echo "$name" | sed 's/[-_]/ /g' | sed 's/\b\w/\u&/g')
        echo "<div class=\"single-project-image\">"
        echo "<img src=\"$main_image\" alt=\"$title\" title=\"$title\" loading=\"lazy\" style=\"max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 4px 16px rgba(0,0,0,0.1);\" />"
        echo "</div>"
        return
    fi
    
    # For multiple images, use shortcode
    echo ""
    echo "## Project Gallery"
    echo ""
    
    local carousel_id="${project_name// /-}"
    carousel_id="${carousel_id,,}"  # Convert to lowercase
    
    # Create comma-separated list of images
    local images_list=""
    while IFS= read -r image_url; do
        if [ -n "$image_url" ] && [ "$image_url" != "null" ] && [[ "$image_url" == https://* ]]; then
            if [ -n "$images_list" ]; then
                images_list="$images_list,$image_url"
            else
                images_list="$image_url"
            fi
        fi
    done <<< "$all_images"
    
    # Generate shortcode call
    echo "{{< project-carousel images=\"$images_list\" id=\"$carousel_id\" title=\"$project_name Gallery\" >}}"
}

# Function to download image from GitHub repository (now just gets URL)
download_repo_image() {
    local repo_name="$1"
    local images_data=$(get_repo_images "$repo_name")
    echo "$images_data" | jq -r '.main'
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
        curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$api_url" | jq -r 'keys | @json'
    else
        curl -s -H "Accept: application/vnd.github.v3+json" "$api_url" | jq -r 'keys | @json'
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

# Function to create project content file
create_project_content() {
    local repo_data="$1"
    local readme_content="$2"
    
    # Extract data from JSON
    local name=$(echo "$repo_data" | jq -r '.name')
    local description=$(echo "$repo_data" | jq -r '.description // "No description available"')
    local html_url=$(echo "$repo_data" | jq -r '.html_url')
    local created_at=$(echo "$repo_data" | jq -r '.created_at')
    local updated_at=$(echo "$repo_data" | jq -r '.updated_at')
    local language=$(echo "$repo_data" | jq -r '.language // "Unknown"')
    local stargazers_count=$(echo "$repo_data" | jq -r '.stargazers_count')
    local forks_count=$(echo "$repo_data" | jq -r '.forks_count')
    local homepage=$(echo "$repo_data" | jq -r '.homepage // ""')
    
    # Get languages
    local languages=$(get_languages "$name")
    
    # Determine category
    local category=$(determine_category "$name" "$description" "$languages")
    
    # Get all images for gallery (now returns GitHub URLs)
    local images_data=$(get_repo_images "$name")
    local main_image=$(echo "$images_data" | jq -r '.main')
    local gallery_html=$(generate_gallery_html "$images_data" "$name")
    
    # Create content file
    local content_file="${PROJECTS_DIR}/${name}.md"
    
    cat > "$content_file" << EOF
---
title: "$name"
date: $created_at
lastmod: $updated_at
description: "$description"$(if [ -n "$main_image" ] && [[ "$main_image" == https://* ]]; then echo "
image: \"$main_image\""; fi)
categories:
    - "Projects"
    - "$category"
tags:
$(echo "$languages" | jq -r '.[] | "    - \"" + . + "\""')
    - "GitHub"
links:
    - title: "GitHub Repository"
      description: "View source code and documentation"
      website: "$html_url"
      image: "https://github.githubassets.com/favicons/favicon.svg"$(if [ -n "$homepage" ] && [ "$homepage" != "null" ]; then echo "
    - title: \"Live Demo\"
      description: \"View the live application\"
      website: \"$homepage\"
      image: \"/favicon.ico\""; fi)
weight: 1
stats:
    stars: $stargazers_count
    forks: $forks_count
    language: "$language"
---

## Overview

$description

$(if [ -n "$readme_content" ]; then
    echo "## Project Details"
    echo ""
    echo "$readme_content" | head -50  # Limit README content
else
    echo "## Repository Information"
    echo ""
    echo "- **Primary Language**: $language"
    echo "- **Created**: $(date -d "$created_at" '+%B %d, %Y')"
    echo "- **Last Updated**: $(date -d "$updated_at" '+%B %d, %Y')"
    echo "- **Stars**: $stargazers_count"
    echo "- **Forks**: $forks_count"
fi)$gallery_html

## Technologies Used

$(echo "$languages" | jq -r '.[] | "- " + .')

## Links

- [📂 **View Source Code**]($html_url) - Complete project repository
$(if [ -n "$homepage" ] && [ "$homepage" != "null" ]; then echo "- [🚀 **Live Demo**]($homepage) - See the project in action"; fi)
- [📊 **Project Stats**]($html_url/pulse) - Development activity and statistics

---

*This project is part of my software engineering portfolio. Feel free to explore the code and reach out if you have any questions!*
EOF

    log_success "Created project content: $content_file"
}

# Function to sync specific repositories
sync_repositories() {
    log_info "Fetching repositories from GitHub..."
    
    # Get list of public repositories with authentication
    local repos_data
    if [ -n "$AUTH_HEADER" ]; then
        repos_data=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" \
            "${GITHUB_API}/users/${GITHUB_USERNAME}/repos?type=public&sort=updated&per_page=50")
    else
        repos_data=$(curl -s -H "Accept: application/vnd.github.v3+json" \
            "${GITHUB_API}/users/${GITHUB_USERNAME}/repos?type=public&sort=updated&per_page=50")
    fi
    
    # Check if API call was successful
    if ! echo "$repos_data" | jq -e '.[0]' >/dev/null 2>&1; then
        log_error "Failed to fetch repositories from GitHub API"
        if echo "$repos_data" | jq -e '.message' >/dev/null 2>&1; then
            local error_msg=$(echo "$repos_data" | jq -r '.message')
            log_error "GitHub API Error: $error_msg"
        fi
        exit 1
    fi
    
    local total_repos=$(echo "$repos_data" | jq -r '. | length')
    log_info "Found $total_repos repositories"
    
    # Filter out forked repositories and process each repo
    echo "$repos_data" | jq -c '.[] | select(.fork == false)' | while read -r repo; do
        local name=$(echo "$repo" | jq -r '.name')
        local description=$(echo "$repo" | jq -r '.description // "No description available"')
        
        log_info "Processing repository: $name"
        
        # Get full repository data
        local full_repo_data=$(get_repo_data "$name")
        
        # Check if repo data was retrieved successfully
        if ! echo "$full_repo_data" | jq -e '.name' >/dev/null 2>&1; then
            log_warning "Failed to get data for repository: $name"
            continue
        fi
        
        # Get README content
        local readme_content=$(get_repo_readme "$name")
        
        # Create content file (images are handled inside the function now)
        create_project_content "$full_repo_data" "$readme_content"
        
        log_success "Synced: $name"
    done
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
description: "Things I've built while learning"
date: $(date -Iseconds)
draft: false
---

# Projects

These are things I've built while learning different technologies and solving problems. Each project taught me something new about programming, system design, or problem-solving.

The projects are automatically synced from my GitHub repositories, so you're seeing the actual code I write and maintain.

## Learning Areas

**Systems Programming** - Working with C/C++, memory management, and performance optimization

**Web Development** - Full-stack applications, APIs, and user interfaces

**Security & CTF** - Tools and solutions for cybersecurity challenges

**Graphics & Visualization** - Mathematical rendering and interactive applications

---

*Projects are loaded dynamically from GitHub. If you don't see any below, the sync might be running or there could be an API issue.*
EOF

    log_success "Created new projects index with $total_projects projects"
}

# Main execution
main() {
    log_info "Starting GitHub projects sync..."
    
    # Create directories if they don't exist
    mkdir -p "$PROJECTS_DIR"
    
    # Check dependencies
    check_dependencies
    
    # Sync repositories
    sync_repositories
    
    # Update index
    update_projects_index
    
    log_success "GitHub projects sync completed successfully!"
    log_info "Generated content files in: $PROJECTS_DIR"
    log_info "Images referenced directly from GitHub repositories"
}

# Run main function
main "$@"
