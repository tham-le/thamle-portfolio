#!/bin/bash

# CTF Writeups Sync Script
# Processes CTF writeups from content/ctf-external submodule
# Organizes by event with images and creates Hugo-compatible content

set -e

# Load environment variables from .env file if it exists
if [[ -f .env ]]; then
    source .env
fi

# Configuration
SOURCE_DIR="content/ctf-external"
CONTENT_DIR="content/ctf"
IMAGES_DIR="static/images/ctf"

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

# Function to create slug from text
create_slug() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to copy images for CTF event
copy_ctf_images() {
    local event_dir="$1"
    local event_slug="$2"
    local dest_images_dir="${IMAGES_DIR}/${event_slug}"
    
    mkdir -p "$dest_images_dir"
    
    # Copy event-level images (like rank.png, team_mvp.png, etc.)
    if [[ -d "$event_dir" ]]; then
        find "$event_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) | while read -r img; do
            if [[ -f "$img" ]]; then
                local filename=$(basename "$img")
                cp "$img" "$dest_images_dir/$filename"
                log_success "Copied event image: $filename"
            fi
        done
        
        # Copy challenge images from subdirectories
        find "$event_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) | while read -r img; do
            if [[ -f "$img" ]]; then
                local rel_path=$(realpath --relative-to="$event_dir" "$img")
                local challenge_dir=$(dirname "$rel_path")
                local filename=$(basename "$img")
                
                # Create challenge-specific filename to avoid conflicts
                local challenge_slug=$(create_slug "$challenge_dir")
                local dest_filename="${challenge_slug}-${filename}"
                
                cp "$img" "$dest_images_dir/$dest_filename"
                log_success "Copied challenge image: $dest_filename"
            fi
        done
    fi
}

# Function to process individual challenge
process_challenge() {
    local event="$1"
    local event_slug="$2"
    local category="$3"
    local challenge_name="$4"
    local writeup_file="$5"
    
    local challenge_slug=$(create_slug "$challenge_name")
    local output_file="${CONTENT_DIR}/${event_slug}/${challenge_slug}.md"
    
    # Create event directory
    mkdir -p "${CONTENT_DIR}/${event_slug}"
    
    # Read the original writeup
    local content=""
    if [[ -f "$writeup_file" ]]; then
        content=$(cat "$writeup_file")
    else
        log_warning "Writeup file not found: $writeup_file"
        return
    fi
    
    # Extract frontmatter and content
    local frontmatter=""
    local body=""
    
    if echo "$content" | head -1 | grep -q "^---[[:space:]]*$"; then
        # Has frontmatter
        frontmatter=$(echo "$content" | awk '/^---$/{if(NR==1){p=1}else if(p){exit}} p')
        body=$(echo "$content" | awk '/^---$/{if(NR==1){p=1; next}else if(p){p=0; next}} !p')
    else
        # No frontmatter
        body="$content"
    fi
    
    # Look for actual images related to this challenge
    local challenge_image=""
    local challenge_dir=$(dirname "$writeup_file")
    
    # Check for common image names in the challenge directory
    local image_candidates=(
        "${challenge_dir}/screenshot.png"
        "${challenge_dir}/image.png"
        "${challenge_dir}/solve.png"
        "${challenge_dir}/flag.png"
        "${challenge_dir}/${challenge_slug}.png"
        "${challenge_dir}/${challenge_name}.png"
    )
    
    for img_path in "${image_candidates[@]}"; do
        if [[ -f "$img_path" ]]; then
            # Copy the image to the static directory
            local dest_images_dir="${IMAGES_DIR}/${event_slug}"
            mkdir -p "$dest_images_dir"
            local img_filename="${challenge_slug}-$(basename "$img_path")"
            cp "$img_path" "$dest_images_dir/$img_filename"
            challenge_image="/images/ctf/${event_slug}/$img_filename"
            log_success "Found and copied challenge image: $img_filename"
            break
        fi
    done
    
    # Also check for any image in the challenge directory
    if [[ -z "$challenge_image" ]]; then
        local first_image=$(find "$challenge_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) | head -1)
        if [[ -n "$first_image" && -f "$first_image" ]]; then
            local dest_images_dir="${IMAGES_DIR}/${event_slug}"
            mkdir -p "$dest_images_dir"
            local img_filename="${challenge_slug}-$(basename "$first_image")"
            cp "$first_image" "$dest_images_dir/$img_filename"
            challenge_image="/images/ctf/${event_slug}/$img_filename"
            log_success "Found and copied challenge image: $img_filename"
        fi
    fi
    
    # Create challenge page with conditional image field
    cat > "$output_file" << EOF
---
title: "$challenge_name"
date: $(date -Iseconds)
description: "$challenge_name writeup from $event CTF - $category challenge"$(if [[ -n "$challenge_image" ]]; then echo "
image: \"$challenge_image\""; fi)
categories:
    - "CTF Writeups"
    - "$category"
tags:
    - "CTF"
    - "$event"
    - "$category"
    - "Cybersecurity"
event: "$event"
challenge: "$challenge_name"
category: "$category"
weight: 1
---

# $challenge_name

**Event:** $event | **Category:** $category

---

$body

---

**Navigation:**
- [← Back to $event Overview](/ctf/$event_slug/)
- [View All CTF Writeups](/ctf/)
EOF

    log_success "Created challenge page: $challenge_slug"
}

# Function to create event overview page
create_event_overview() {
    local event="$1"
    local event_slug="$2"
    local event_dir="$3"
    local challenges=("${@:4}")
    
    local output_file="${CONTENT_DIR}/${event_slug}/_index.md"
    local challenge_count=${#challenges[@]}
    
    # Count categories
    local categories=()
    for challenge in "${challenges[@]}"; do
        local category=$(echo "$challenge" | cut -d'|' -f2)
        if [[ ! " ${categories[@]} " =~ " ${category} " ]]; then
            categories+=("$category")
        fi
    done
    local category_count=${#categories[@]}
    
    # Create challenge links
    local challenge_links=""
    for challenge in "${challenges[@]}"; do
        local name=$(echo "$challenge" | cut -d'|' -f1)
        local category=$(echo "$challenge" | cut -d'|' -f2)
        local slug=$(create_slug "$name")
        challenge_links+="- **[$name](/ctf/${event_slug}/${slug}/)** - $category"$'\n'
    done
    
    # Check for event images
    local event_image="/images/ctf/${event_slug}/rank.png"
    if [[ ! -f "static${event_image}" ]]; then
        event_image="/images/ctf/${event_slug}/event-banner.png"
        if [[ ! -f "static${event_image}" ]]; then
            event_image=""
        fi
    fi
    
    cat > "$output_file" << EOF
---
title: "$event CTF Writeups"
date: $(date -Iseconds)
description: "Complete writeups from $event CTF competition - $challenge_count challenges solved across $category_count categories"
categories:
    - "CTF Writeups"
    - "Cybersecurity"
tags:
    - "CTF"
    - "$event"
    - "Cybersecurity"
event: "$event"
challenges_solved: $challenge_count
categories_covered: $category_count
$(if [[ -n "$event_image" ]]; then echo "image: \"$event_image\""; fi)
weight: 1
---

# $event CTF Competition

## Event Summary

**🏆 Event:** $event  
**✅ Challenges Solved:** $challenge_count  
**🎯 Categories:** $category_count  
**📅 Date:** $(date '+%B %Y')

$(if [[ -f "${IMAGES_DIR}/${event_slug}/rank.png" ]]; then
echo "## Competition Results"
echo ""
echo "![Competition Ranking](/images/ctf/${event_slug}/rank.png)"
echo ""
fi)

## Challenge List

$challenge_links

## Categories Solved

$(for category in "${categories[@]}"; do
    local count=$(printf '%s\n' "${challenges[@]}" | grep -c "|$category|" || echo "0")
    echo "- **$category** ($count challenges)"
done)

---

## Reflection

Successfully completed **$challenge_count challenges** across **$category_count categories** in the $event competition. Each challenge provided valuable learning opportunities and practical cybersecurity experience.

**[View more CTF writeups](/ctf) | [About me](/about)**
EOF

    log_success "Created event overview: $event"
}

# Main processing function
process_ctf_writeups() {
    log_info "Processing CTF writeups from $SOURCE_DIR..."
    
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_error "Source directory $SOURCE_DIR does not exist"
        log_info "Make sure the CTF writeups submodule is properly initialized"
        return 1
    fi
    
    # Create output directories
    mkdir -p "$CONTENT_DIR"
    mkdir -p "$IMAGES_DIR"
    
    # Process each CTF event directory
    for event_dir in "$SOURCE_DIR"/*; do
        if [[ -d "$event_dir" && "$(basename "$event_dir")" != ".git" && "$(basename "$event_dir")" != ".github" ]]; then
            local event_name=$(basename "$event_dir")
            local event_slug=$(create_slug "$event_name")
            
            log_info "Processing event: $event_name"
            
            # Copy images for this event
            copy_ctf_images "$event_dir" "$event_slug"
            
            # Find all writeup files in this event
            local challenges=()
            
            while IFS= read -r -d '' writeup_file; do
                # Extract path components
                local rel_path=$(realpath --relative-to="$event_dir" "$writeup_file")
                local path_parts=(${rel_path//\// })
                
                if [[ ${#path_parts[@]} -ge 2 ]]; then
                    local category_raw="${path_parts[0]}"
                    local challenge_name="${path_parts[-2]}"  # Second to last part (challenge directory)
                    
                    # Clean up category name
                    local category=""
                    case "$category_raw" in
                        *"Web"*|*"web"*) category="Web Exploitation" ;;
                        *"Crypto"*|*"crypto"*) category="Cryptography" ;;
                        *"Forensics"*|*"forensics"*) category="Digital Forensics" ;;
                        *"Binary"*|*"binary"*|*"Reverse"*|*"reverse"*|*"pwn"*|*"PWN"*) category="Binary Exploitation" ;;
                        *"OSINT"*|*"osint"*|*"Intelligence"*) category="OSINT" ;;
                        *"Misc"*|*"misc"*) category="Miscellaneous" ;;
                        *"Stego"*|*"stego"*) category="Steganography" ;;
                        *) category="General" ;;
                    esac
                    
                    # Clean up challenge name
                    challenge_name=$(echo "$challenge_name" | tr '_' ' ')
                    
                    # Process the challenge
                    process_challenge "$event_name" "$event_slug" "$category" "$challenge_name" "$writeup_file"
                    
                    # Add to challenges list for overview
                    challenges+=("$challenge_name|$category")
                fi
            done < <(find "$event_dir" \( -name "writeup.md" -o -name "README.md" \) -type f -print0)
            
            # Create event overview page
            if [[ ${#challenges[@]} -gt 0 ]]; then
                create_event_overview "$event_name" "$event_slug" "$event_dir" "${challenges[@]}"
            fi
        fi
    done
}

# Update main CTF index
update_main_ctf_index() {
    local index_file="${CONTENT_DIR}/_index.md"
    local total_events=$(find "$CONTENT_DIR" -name "_index.md" -not -path "$index_file" | wc -l)
    local total_challenges=0
    
    # Count total challenges
    for event_index in "$CONTENT_DIR"/*/_index.md; do
        if [[ -f "$event_index" ]]; then
            local count=$(grep "challenges_solved:" "$event_index" | head -1 | sed 's/.*challenges_solved: *//' | sed 's/ .*//' || echo "0")
            total_challenges=$((total_challenges + count))
        fi
    done
    
    # Update main index if it exists
    if [[ -f "$index_file" ]]; then
        sed -i "s/featuring \*\*[0-9]* events\*\*/featuring **$total_events events**/" "$index_file" 2>/dev/null || true
        sed -i "s/\*\*[0-9]*+ challenges\*\*/\*\*$total_challenges+ challenges\*\*/" "$index_file" 2>/dev/null || true
        log_success "Updated main CTF index: $total_events events, $total_challenges challenges"
    fi
}

# Main execution
main() {
    log_info "Starting CTF writeups sync..."
    
    # Process CTF writeups
    if process_ctf_writeups; then
        log_success "CTF writeups processed successfully"
    else
        log_error "Failed to process CTF writeups"
        exit 1
    fi
    
    # Update main index
    update_main_ctf_index
    
    log_success "CTF writeups sync completed!"
    log_info "Generated content in: $CONTENT_DIR"
    log_info "Organized images in: $IMAGES_DIR"
}

# Run main function
main "$@"
