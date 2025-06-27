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
    
    # For multiple images, generate carousel HTML directly
    echo ""
    echo "## Project Gallery"
    echo ""
    
    local carousel_id="${project_name// /-}"
    carousel_id="${carousel_id,,}"  # Convert to lowercase
    
    echo "<div class=\"project-carousel\" id=\"carousel-$carousel_id\">"
    echo "    <div class=\"carousel-container\">"
    echo "        <div class=\"carousel-slides\">"
    
    # Generate slides
    local slide_index=0
    while IFS= read -r image_url; do
        if [ -n "$image_url" ] && [ "$image_url" != "null" ] && [[ "$image_url" == https://* ]]; then
            local filename=$(basename "$image_url")
            local name="${filename%.*}"
            local title=$(echo "$name" | sed 's/[-_]/ /g' | sed 's/\b\w/\u&/g')
            local active_class=""
            if [ $slide_index -eq 0 ]; then
                active_class=" active"
            fi
            
            echo "            <div class=\"carousel-slide$active_class\" data-slide=\"$slide_index\">"
            echo "                <img src=\"$image_url\" alt=\"$title\" title=\"$title\" loading=\"lazy\" class=\"carousel-image\" />"
            echo "                <div class=\"carousel-caption\">"
            echo "                    <span class=\"image-title\">$title</span>"
            echo "                    <span class=\"image-counter\">$((slide_index + 1)) / $image_count</span>"
            echo "                </div>"
            echo "            </div>"
            
            slide_index=$((slide_index + 1))
        fi
    done <<< "$all_images"
    
    echo "        </div>"
    echo ""
    echo "        <!-- Navigation Controls -->"
    echo "        <button class=\"carousel-btn carousel-prev\" onclick=\"changeSlide('$carousel_id', -1)\">"
    echo "            <svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\">"
    echo "                <polyline points=\"15,18 9,12 15,6\"></polyline>"
    echo "            </svg>"
    echo "        </button>"
    echo "        <button class=\"carousel-btn carousel-next\" onclick=\"changeSlide('$carousel_id', 1)\">"
    echo "            <svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\">"
    echo "                <polyline points=\"9,18 15,12 9,6\"></polyline>"
    echo "            </svg>"
    echo "        </button>"
    echo ""
    echo "        <!-- Dots Indicator -->"
    echo "        <div class=\"carousel-dots\">"
    
    # Generate dots
    local dot_index=0
    while IFS= read -r image_url; do
        if [ -n "$image_url" ] && [ "$image_url" != "null" ] && [[ "$image_url" == https://* ]]; then
            local active_class=""
            if [ $dot_index -eq 0 ]; then
                active_class=" active"
            fi
            echo "            <button class=\"carousel-dot$active_class\" onclick=\"goToSlide('$carousel_id', $dot_index)\" data-slide=\"$dot_index\"></button>"
            dot_index=$((dot_index + 1))
        fi
    done <<< "$all_images"
    
    echo "        </div>"
    echo "    </div>"
    echo "</div>"
    
    # Add the CSS and JavaScript if this is the first carousel
    echo ""
    echo "<style>"
    echo ".project-carousel {"
    echo "    position: relative;"
    echo "    width: 100%;"
    echo "    max-width: 800px;"
    echo "    margin: 2rem auto;"
    echo "    border-radius: 12px;"
    echo "    overflow: hidden;"
    echo "    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);"
    echo "    background: var(--card-background);"
    echo "}"
    echo ""
    echo ".carousel-container {"
    echo "    position: relative;"
    echo "    width: 100%;"
    echo "}"
    echo ""
    echo ".carousel-slides {"
    echo "    position: relative;"
    echo "    width: 100%;"
    echo "    height: 400px;"
    echo "    overflow: hidden;"
    echo "}"
    echo ""
    echo ".carousel-slide {"
    echo "    position: absolute;"
    echo "    top: 0;"
    echo "    left: 0;"
    echo "    width: 100%;"
    echo "    height: 100%;"
    echo "    opacity: 0;"
    echo "    transition: opacity 0.5s ease-in-out;"
    echo "    display: flex;"
    echo "    flex-direction: column;"
    echo "}"
    echo ""
    echo ".carousel-slide.active {"
    echo "    opacity: 1;"
    echo "}"
    echo ""
    echo ".carousel-image {"
    echo "    width: 100%;"
    echo "    height: 100%;"
    echo "    object-fit: contain;"
    echo "    background: var(--body-background);"
    echo "}"
    echo ""
    echo ".carousel-caption {"
    echo "    position: absolute;"
    echo "    bottom: 0;"
    echo "    left: 0;"
    echo "    right: 0;"
    echo "    background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));"
    echo "    color: white;"
    echo "    padding: 1rem;"
    echo "    display: flex;"
    echo "    justify-content: space-between;"
    echo "    align-items: center;"
    echo "}"
    echo ""
    echo ".image-title {"
    echo "    font-weight: 600;"
    echo "    font-size: 1.1rem;"
    echo "}"
    echo ""
    echo ".image-counter {"
    echo "    font-size: 0.9rem;"
    echo "    opacity: 0.8;"
    echo "}"
    echo ""
    echo ".carousel-btn {"
    echo "    position: absolute;"
    echo "    top: 50%;"
    echo "    transform: translateY(-50%);"
    echo "    background: rgba(0, 0, 0, 0.5);"
    echo "    color: white;"
    echo "    border: none;"
    echo "    width: 48px;"
    echo "    height: 48px;"
    echo "    border-radius: 50%;"
    echo "    cursor: pointer;"
    echo "    display: flex;"
    echo "    align-items: center;"
    echo "    justify-content: center;"
    echo "    transition: all 0.3s ease;"
    echo "    z-index: 2;"
    echo "}"
    echo ""
    echo ".carousel-btn:hover {"
    echo "    background: rgba(0, 0, 0, 0.7);"
    echo "    transform: translateY(-50%) scale(1.1);"
    echo "}"
    echo ""
    echo ".carousel-prev {"
    echo "    left: 1rem;"
    echo "}"
    echo ""
    echo ".carousel-next {"
    echo "    right: 1rem;"
    echo "}"
    echo ""
    echo ".carousel-dots {"
    echo "    position: absolute;"
    echo "    bottom: 1rem;"
    echo "    left: 50%;"
    echo "    transform: translateX(-50%);"
    echo "    display: flex;"
    echo "    gap: 0.5rem;"
    echo "    z-index: 2;"
    echo "}"
    echo ""
    echo ".carousel-dot {"
    echo "    width: 12px;"
    echo "    height: 12px;"
    echo "    border-radius: 50%;"
    echo "    border: 2px solid white;"
    echo "    background: transparent;"
    echo "    cursor: pointer;"
    echo "    transition: all 0.3s ease;"
    echo "}"
    echo ""
    echo ".carousel-dot.active,"
    echo ".carousel-dot:hover {"
    echo "    background: white;"
    echo "}"
    echo ""
    echo "@media (max-width: 768px) {"
    echo "    .carousel-slides {"
    echo "        height: 300px;"
    echo "    }"
    echo "    "
    echo "    .carousel-btn {"
    echo "        width: 40px;"
    echo "        height: 40px;"
    echo "    }"
    echo "    "
    echo "    .carousel-prev {"
    echo "        left: 0.5rem;"
    echo "    }"
    echo "    "
    echo "    .carousel-next {"
    echo "        right: 0.5rem;"
    echo "    }"
    echo "    "
    echo "    .carousel-caption {"
    echo "        padding: 0.5rem;"
    echo "    }"
    echo "    "
    echo "    .image-title {"
    echo "        font-size: 1rem;"
    echo "    }"
    echo "}"
    echo "</style>"
    echo ""
    echo "<script>"
    echo "const carousels = window.carousels || {};"
    echo "window.carousels = carousels;"
    echo ""
    echo "function initCarousel(carouselId) {"
    echo "    if (carousels[carouselId]) return;"
    echo "    "
    echo "    carousels[carouselId] = {"
    echo "        currentSlide: 0,"
    echo "        totalSlides: document.querySelectorAll(\`#carousel-\${carouselId} .carousel-slide\`).length,"
    echo "        autoPlay: true,"
    echo "        autoPlayInterval: null"
    echo "    };"
    echo "    "
    echo "    startAutoPlay(carouselId);"
    echo "    "
    echo "    const carousel = document.getElementById(\`carousel-\${carouselId}\`);"
    echo "    if (carousel) {"
    echo "        carousel.addEventListener('mouseenter', () => stopAutoPlay(carouselId));"
    echo "        carousel.addEventListener('mouseleave', () => startAutoPlay(carouselId));"
    echo "    }"
    echo "}"
    echo ""
    echo "function changeSlide(carouselId, direction) {"
    echo "    const carousel = carousels[carouselId];"
    echo "    if (!carousel) {"
    echo "        initCarousel(carouselId);"
    echo "        return;"
    echo "    }"
    echo "    "
    echo "    const newSlide = (carousel.currentSlide + direction + carousel.totalSlides) % carousel.totalSlides;"
    echo "    goToSlide(carouselId, newSlide);"
    echo "}"
    echo ""
    echo "function goToSlide(carouselId, slideIndex) {"
    echo "    const carousel = carousels[carouselId];"
    echo "    if (!carousel) {"
    echo "        initCarousel(carouselId);"
    echo "        return;"
    echo "    }"
    echo "    "
    echo "    carousel.currentSlide = slideIndex;"
    echo "    "
    echo "    const slides = document.querySelectorAll(\`#carousel-\${carouselId} .carousel-slide\`);"
    echo "    const dots = document.querySelectorAll(\`#carousel-\${carouselId} .carousel-dot\`);"
    echo "    "
    echo "    slides.forEach((slide, index) => {"
    echo "        slide.classList.toggle('active', index === slideIndex);"
    echo "    });"
    echo "    "
    echo "    dots.forEach((dot, index) => {"
    echo "        dot.classList.toggle('active', index === slideIndex);"
    echo "    });"
    echo "    "
    echo "    stopAutoPlay(carouselId);"
    echo "    startAutoPlay(carouselId);"
    echo "}"
    echo ""
    echo "function startAutoPlay(carouselId) {"
    echo "    const carousel = carousels[carouselId];"
    echo "    if (!carousel || !carousel.autoPlay) return;"
    echo "    "
    echo "    carousel.autoPlayInterval = setInterval(() => {"
    echo "        changeSlide(carouselId, 1);"
    echo "    }, 4000);"
    echo "}"
    echo ""
    echo "function stopAutoPlay(carouselId) {"
    echo "    const carousel = carousels[carouselId];"
    echo "    if (!carousel || !carousel.autoPlayInterval) return;"
    echo "    "
    echo "    clearInterval(carousel.autoPlayInterval);"
    echo "    carousel.autoPlayInterval = null;"
    echo "}"
    echo ""
    echo "document.addEventListener('DOMContentLoaded', function() {"
    echo "    initCarousel('$carousel_id');"
    echo "});"
    echo "</script>"
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
