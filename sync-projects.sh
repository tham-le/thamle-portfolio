#!/bin/bash

# GitHub Projects Sync Script
# Automatically syncs repositories from GitHub and creates Hugo content

set -e

# Load environment variables from .env file if it exists
if [[ -f .env ]]; then
    source .env
fi

# Configuration
GITHUB_USERNAME="${GITHUB_USERNAME:-tham-le}"
PROJECTS_DIR="content/projects"
IMAGES_DIR="static/images/projects"
GITHUB_API="https://api.github.com"

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    log_warning "GITHUB_TOKEN not set in .env file. API rate limits may apply."
    log_warning "Create a .env file with: GITHUB_TOKEN=your_github_token_here"
    AUTH_HEADER=""
else
    AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
fi

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

# Function to download all images from GitHub repository
download_repo_images() {
    local repo_name="$1"
    local project_image_dir="${IMAGES_DIR}/${repo_name}"
    
    mkdir -p "$project_image_dir"
    
    # Common image patterns to look for
    local image_patterns=("*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.webp")
    local image_directories=("" "images" "assets" "docs" "screenshots" "demo" "renders" "examples" "gallery")
    
    local api_url="${GITHUB_API}/repos/${GITHUB_USERNAME}/${repo_name}/contents"
    local images_found=()
    local main_image=""
    
    log_info "Searching for images in repository: $repo_name" >&2
    
    # Search in each directory
    for dir in "${image_directories[@]}"; do
        local search_url="$api_url"
        if [ -n "$dir" ]; then
            search_url="$api_url/$dir"
        fi
        
        # Use authentication if available
        local dir_contents
        if [ -n "$AUTH_HEADER" ]; then
            dir_contents=$(curl -s -H "Accept: application/vnd.github.v3+json" -H "$AUTH_HEADER" "$search_url" 2>/dev/null)
        else
            dir_contents=$(curl -s -H "Accept: application/vnd.github.v3+json" "$search_url" 2>/dev/null)
        fi
        
        # Check if we got valid JSON array
        if echo "$dir_contents" | jq -e 'type == "array"' >/dev/null 2>&1; then
            # Find all image files
            local image_files=$(echo "$dir_contents" | jq -r '.[] | select(.type == "file" and (.name | test("\\.(png|jpg|jpeg|gif|svg|webp)$"; "i"))) | .name')
            
            while IFS= read -r image_file; do
                if [ -n "$image_file" ]; then
                    local download_url=$(echo "$dir_contents" | jq -r --arg name "$image_file" '.[] | select(.name == $name) | .download_url')
                    local extension="${image_file##*.}"
                    local base_name="${image_file%.*}"
                    local output_file="${project_image_dir}/${base_name}.${extension}"
                    
                    if curl -s -L "$download_url" -o "$output_file"; then
                        log_success "Downloaded: $dir/$image_file" >&2
                        images_found+=("/images/projects/${repo_name}/${base_name}.${extension}")
                        
                        # Set main image (prefer screenshot, demo, preview, then first image)
                        if [ -z "$main_image" ] || [[ "$base_name" =~ ^(screenshot|demo|preview|cover|banner)$ ]]; then
                            main_image="/images/projects/${repo_name}/${base_name}.${extension}"
                        fi
                    fi
                fi
            done <<< "$image_files"
        fi
    done
    
    # If no images found, create placeholder
    if [ ${#images_found[@]} -eq 0 ]; then
        create_project_placeholder "$repo_name"
        main_image="/images/projects/${repo_name}.svg"
        images_found=("$main_image")
    fi
    
    # Return main image and all images (JSON format)
    jq -n --arg main "$main_image" --argjson all "$(printf '%s\n' "${images_found[@]}" | jq -R . | jq -s .)" '{main: $main, all: $all}'
}

# Function to generate gallery HTML for project
generate_gallery_html() {
    local images_json="$1"
    local main_image=$(echo "$images_json" | jq -r '.main')
    local all_images=$(echo "$images_json" | jq -r '.all[]')
    
    if [ $(echo "$images_json" | jq -r '.all | length') -le 1 ]; then
        # Single image - no gallery needed
        echo ""
        return
    fi
    
    echo ""
    echo "## Gallery"
    echo ""
    
    # Generate gallery HTML
    while IFS= read -r image_path; do
        if [ -n "$image_path" ] && [ "$image_path" != "null" ]; then
            local filename=$(basename "$image_path")
            local name="${filename%.*}"
            # Convert filename to readable title
            local title=$(echo "$name" | sed 's/[-_]/ /g' | sed 's/\b\w/\u&/g')
            echo "<img src=\"$image_path\" alt=\"$title\" class=\"gallery-image\" title=\"$title\" />"
        fi
    done <<< "$all_images"
}

# Function to download image from GitHub repository (updated)
download_repo_image() {
    local repo_name="$1"
    local images_data=$(download_repo_images "$repo_name")
    echo "$images_data" | jq -r '.main'
}

# Function to create project placeholder SVG
create_project_placeholder() {
    local repo_name="$1"
    local image_dir="${IMAGES_DIR}"
    local output_file="${image_dir}/${repo_name}.svg"
    
    mkdir -p "$image_dir"
    
    # Create a simple SVG placeholder
    cat > "$output_file" << EOF
<svg width="400" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" fill="#f8f9fa"/>
  <rect x="20" y="20" width="360" height="160" fill="#e9ecef" stroke="#dee2e6" stroke-width="2"/>
  <text x="200" y="90" font-family="Arial, sans-serif" font-size="18" font-weight="bold" text-anchor="middle" fill="#495057">$repo_name</text>
  <text x="200" y="120" font-family="Arial, sans-serif" font-size="14" text-anchor="middle" fill="#6c757d">GitHub Project</text>
  <circle cx="50" cy="50" r="8" fill="#28a745"/>
  <circle cx="70" cy="50" r="8" fill="#ffc107"/>
  <circle cx="90" cy="50" r="8" fill="#dc3545"/>
</svg>
EOF
    
    log_info "Created placeholder image for $repo_name" >&2
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
    
    # Get all images for gallery
    local images_data=$(download_repo_images "$name")
    local main_image=$(echo "$images_data" | jq -r '.main')
    local gallery_html=$(generate_gallery_html "$images_data")
    
    # Create content file
    local content_file="${PROJECTS_DIR}/${name}.md"
    
    cat > "$content_file" << EOF
---
title: "$name"
date: $created_at
lastmod: $updated_at
description: "$description"
image: "$main_image"
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

# Function to generate SVG placeholder if image doesn't exist
generate_svg_placeholder() {
    local repo_name="$1"
    local svg_file="${IMAGES_DIR}/${repo_name}.svg"
    
    if [ ! -f "$svg_file" ]; then
        local first_letter=$(echo "$repo_name" | cut -c1 | tr '[:lower:]' '[:upper:]')
        
        cat > "$svg_file" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">
  <defs>
    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#764ba2;stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="200" height="200" fill="url(#grad)" rx="20"/>
  <text x="100" y="120" font-family="Arial, sans-serif" font-size="80" font-weight="bold" text-anchor="middle" fill="white">$first_letter</text>
</svg>
EOF
        log_info "Generated SVG placeholder for $repo_name"
    fi
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
    
    cat > "$index_file" << EOF
---
title: "Projects Portfolio"
description: "Explore my software engineering projects - from web applications to system programming, showcasing diverse technical skills and innovative solutions."
date: $(date -Iseconds)
draft: false
---

# My Projects Portfolio

Welcome to my project showcase! This collection represents my journey as a software engineer, featuring **$total_projects** projects that demonstrate my expertise across multiple technologies and domains.

## Featured Highlights

🚀 **Full-Stack Applications** - Modern web applications built with Python, JavaScript, and contemporary frameworks  
🔧 **System Programming** - Low-level C/C++ projects showcasing performance optimization and system design  
🛡️ **Cybersecurity Tools** - Security-focused projects and vulnerability research demonstrations  
📱 **Cross-Platform Solutions** - Applications designed to work seamlessly across different platforms  

## Technical Stack Showcase

These projects collectively demonstrate my proficiency in:
- **Backend**: Python (Django, FastAPI), C++, Node.js
- **Frontend**: React, Vue.js, Three.js, modern CSS
- **Systems**: Linux/UNIX programming, networking, multithreading
- **DevOps**: Docker, CI/CD, cloud deployment
- **Security**: Secure coding practices, penetration testing, cryptography

## Project Categories

Each project is categorized and tagged for easy navigation. You can filter by:
- **Web Development** - Full-stack web applications
- **System Programming** - Low-level and performance-critical software
- **Cybersecurity** - Security tools and research projects
- **Graphics & Games** - Visual and interactive applications
- **Data Science** - Data analysis and visualization tools
- **Mobile Development** - Cross-platform mobile applications

---

## Repository Integration

All projects are automatically synced from my GitHub repositories, ensuring the latest updates and comprehensive documentation are always available.

**[🔗 View All Repositories on GitHub](https://github.com/tham-le)**

---

*Last updated: $(date '+%B %d, %Y at %H:%M')*
EOF

    log_success "Updated projects index with $total_projects projects"
}

# Main execution
main() {
    log_info "Starting GitHub projects sync..."
    
    # Create directories if they don't exist
    mkdir -p "$PROJECTS_DIR"
    mkdir -p "$IMAGES_DIR"
    
    # Check dependencies
    check_dependencies
    
    # Sync repositories
    sync_repositories
    
    # Update index
    update_projects_index
    
    log_success "GitHub projects sync completed successfully!"
    log_info "Generated content files in: $PROJECTS_DIR"
    log_info "Generated images in: $IMAGES_DIR"
}

# Run main function
main "$@"
