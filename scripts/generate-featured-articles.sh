#!/bin/bash

# Featured Articles Generator Script
# Reads config/featured-articles.json and generates the featured section for homepage

set -e

# Configuration
CONFIG_FILE="../config/featured-articles.json"
HOMEPAGE_FILE="../content/_index.md"
TEMP_FILE="/tmp/homepage_temp.md"

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

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    log_error "jq is required but not installed. Please install jq first."
    log_info "Ubuntu/Debian: sudo apt-get install jq"
    log_info "macOS: brew install jq"
    exit 1
fi

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    log_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Check if homepage file exists
if [[ ! -f "$HOMEPAGE_FILE" ]]; then
    log_error "Homepage file not found: $HOMEPAGE_FILE"
    exit 1
fi

# Function to generate featured articles section
generate_featured_section() {
    local config_file="$1"
    
    # Read configuration
    local title=$(jq -r '.title' "$config_file")
    local description=$(jq -r '.description' "$config_file")
    local show_emoji=$(jq -r '.settings.show_emoji' "$config_file")
    local show_category=$(jq -r '.settings.show_category' "$config_file")
    local max_featured=$(jq -r '.settings.max_featured' "$config_file")
    
    # Start featured section
    echo '<div class="featured-articles">'
    echo ""
    echo "## $title"
    echo ""
    
    # Add description if provided
    if [[ "$description" != "null" && -n "$description" ]]; then
        echo "*$description*"
        echo ""
    fi
    
    # Generate featured articles
    local count=0
    while IFS= read -r article; do
        if [[ $count -ge $max_featured ]]; then
            break
        fi
        
        local article_title=$(echo "$article" | jq -r '.title')
        local emoji=$(echo "$article" | jq -r '.emoji')
        local url=$(echo "$article" | jq -r '.url')
        local article_description=$(echo "$article" | jq -r '.description')
        local category=$(echo "$article" | jq -r '.category')
        
        # Build the title with optional emoji
        local display_title="$article_title"
        if [[ "$show_emoji" == "true" && "$emoji" != "null" ]]; then
            display_title="$emoji **[$article_title]($url)**"
        else
            display_title="**[$article_title]($url)**"
        fi
        
        echo "### $display_title"
        echo "$article_description"
        
        # Add category if enabled
        if [[ "$show_category" == "true" && "$category" != "null" ]]; then
            echo ""
            echo "*Category: $category*"
        fi
        
        echo ""
        ((count++))
    done < <(jq -c '.articles[] | select(.featured == true)' "$config_file")
    
    echo '</div>'
}

# Function to update homepage with new featured section
update_homepage() {
    local homepage_file="$1"
    local featured_section="$2"
    
    # Create temporary file
    local in_featured_section=false
    local featured_section_found=false
    
    while IFS= read -r line; do
        if [[ "$line" == '<div class="featured-articles">' ]]; then
            in_featured_section=true
            featured_section_found=true
            echo "$featured_section"
            continue
        elif [[ "$line" == '</div>' && "$in_featured_section" == true ]]; then
            in_featured_section=false
            continue
        elif [[ "$in_featured_section" == false ]]; then
            echo "$line"
        fi
    done < "$homepage_file" > "$TEMP_FILE"
    
    # If no featured section was found, add it after the intro
    if [[ "$featured_section_found" == false ]]; then
        log_info "No existing featured section found, adding new one..."
        
        # Find the first "---" after the frontmatter and add featured section
        local line_count=0
        local frontmatter_ended=false
        
        while IFS= read -r line; do
            ((line_count++))
            echo "$line"
            
            if [[ $line_count -gt 1 && "$line" == "---" && "$frontmatter_ended" == false ]]; then
                frontmatter_ended=true
                continue
            fi
            
            # Add featured section after the intro (look for first "---" after intro)
            if [[ "$frontmatter_ended" == true && "$line" == "---" ]]; then
                echo ""
                echo "$featured_section"
                echo ""
                echo "---"
                # Skip the "---" line we just processed
                continue
            fi
        done < "$homepage_file" > "$TEMP_FILE"
    fi
    
    # Replace original file
    mv "$TEMP_FILE" "$homepage_file"
}

# Main execution
main() {
    log_info "Generating featured articles from configuration..."
    
    # Validate JSON
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        log_error "Invalid JSON in configuration file: $CONFIG_FILE"
        exit 1
    fi
    
    # Generate featured section
    log_info "Reading configuration from: $CONFIG_FILE"
    local featured_section=$(generate_featured_section "$CONFIG_FILE")
    
    # Update homepage
    log_info "Updating homepage: $HOMEPAGE_FILE"
    update_homepage "$HOMEPAGE_FILE" "$featured_section"
    
    # Show summary
    local featured_count=$(jq '[.articles[] | select(.featured == true)] | length' "$CONFIG_FILE")
    local total_count=$(jq '.articles | length' "$CONFIG_FILE")
    
    log_success "Featured articles section updated!"
    log_info "Featured: $featured_count articles (out of $total_count total)"
    log_info "Homepage updated: $HOMEPAGE_FILE"
}

# Run main function
main "$@" 