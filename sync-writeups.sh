#!/bin/bash

# CTF Writeups Sync Script
# Automatically organizes CTF writeups from temp-analysis directory
# Creates one comprehensive article per CTF event AND individual challenge pages

set -e

# Load environment variables from .env file if it exists
if [[ -f .env ]]; then
    source .env
fi

# Configuration
SOURCE_DIR="temp-analysis"
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

# Function to strip YAML frontmatter from content
strip_frontmatter() {
    local content="$1"
    
    # Check if content starts with ---
    if echo "$content" | head -1 | grep -q "^---[[:space:]]*$"; then
        # Find the end of frontmatter (second ---) and remove everything up to and including it
        echo "$content" | awk '
        BEGIN { in_frontmatter = 1; line_count = 0 }
        {
            line_count++
            if (line_count == 1 && /^---[[:space:]]*$/) {
                in_frontmatter = 1
                next
            }
            if (in_frontmatter && /^---[[:space:]]*$/) {
                in_frontmatter = 0
                next
            }
            if (!in_frontmatter) {
                print
            }
        }
        '
    else
        echo "$content"
    fi
}

# Function to copy images from CTF directories
copy_ctf_images() {
    local event="$1"
    local challenge="$2"
    local source_path="$3"
    local event_slug=$(create_slug "$event")
    local challenge_slug=$(create_slug "$challenge")
    
    local event_images_dir="${IMAGES_DIR}/${event_slug}"
    mkdir -p "$event_images_dir"
    
    local images_found=()
    local primary_image_path=""
    
    # Look for images in the challenge directory and parent directories
    if [[ -d "$source_path" ]]; then
        # Find common image formats in challenge directory
        while IFS= read -r -d '' image_file; do
            if [[ -f "$image_file" ]]; then
                local extension="${image_file##*.}"
                local base_name=$(basename "$image_file" ".$extension")
                local dest_image="${event_images_dir}/${challenge_slug}-${base_name}.${extension}"
                
                if cp "$image_file" "$dest_image" 2>/dev/null; then
                    images_found+=("/images/ctf/${event_slug}/${challenge_slug}-${base_name}.${extension}")
                    log_success "Copied image: ${challenge_slug}-${base_name}.${extension}" >&2
                    
                    # Set primary image (first one found)
                    if [[ -z "$primary_image_path" ]]; then
                        primary_image_path="/images/ctf/${event_slug}/${challenge_slug}-${base_name}.${extension}"
                    fi
                fi
            fi
        done < <(find "$source_path" -maxdepth 2 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -print0)
        
        # Also check parent directory for event-level images
        local parent_dir=$(dirname "$source_path")
        while IFS= read -r -d '' image_file; do
            if [[ -f "$image_file" ]]; then
                local extension="${image_file##*.}"
                local base_name=$(basename "$image_file" ".$extension")
                local dest_image="${event_images_dir}/${base_name}.${extension}"
                
                # Only copy if not already copied
                if [[ ! -f "$dest_image" ]] && cp "$image_file" "$dest_image" 2>/dev/null; then
                    log_success "Copied event image: ${base_name}.${extension}" >&2
                fi
            fi
        done < <(find "$parent_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) -print0)
    fi
    
    # If no images found, don't create placeholder - just return empty
    if [[ ${#images_found[@]} -eq 0 ]]; then
        echo ""
    elif [[ ${#images_found[@]} -eq 1 ]]; then
        echo "${images_found[0]}"
    else
        # Return all images as JSON array for carousel
        printf '%s\n' "${images_found[@]}" | jq -R . | jq -s .
    fi
}

# Function to determine category from directory name
determine_category() {
    local dir_name="$1"
    case "$dir_name" in
        *"Web"*|*"web"*) echo "Web Exploitation" ;;
        *"Crypto"*|*"crypto"*) echo "Cryptography" ;;
        *"Forensics"*|*"forensics"*) echo "Digital Forensics" ;;
        *"Binary"*|*"binary"*|*"Reverse"*|*"reverse"*|*"pwn"*|*"PWN"*) echo "Binary Exploitation" ;;
        *"OSINT"*|*"osint"*|*"Intelligence"*) echo "OSINT" ;;
        *"Misc"*|*"misc"*) echo "Miscellaneous" ;;
        *"Stego"*|*"stego"*) echo "Steganography" ;;
        *) echo "General" ;;
    esac
}

# Function to get difficulty based on event and challenge
determine_difficulty() {
    local event="$1"
    local challenge="$2"
    
    # Default difficulty mapping based on common CTF patterns
    case "$event" in
        *"University"*|*"Beginner"*) echo "Beginner" ;;
        *"HeroCTF"*|*"IrisCTF"*) echo "Intermediate" ;;
        *"CyberApocalypse"*|*"HTB"*) echo "Advanced" ;;
        *) echo "Intermediate" ;;
    esac
}

# Function to create event banner
create_event_banner() {
    local event_slug="$1"
    local event="$2"
    local event_images_dir="${IMAGES_DIR}/${event_slug}"
    local banner_file="${event_images_dir}/event-banner.svg"
    
    mkdir -p "$event_images_dir"
    
    if [[ ! -f "$banner_file" ]]; then
        cat > "$banner_file" << EOF
<svg width="800" height="300" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="eventGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1a2e;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#16213e;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0f3460;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Background -->
  <rect width="100%" height="100%" fill="url(#eventGrad)"/>
  
  <!-- Grid pattern -->
  <defs>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#ffffff" stroke-width="0.5" opacity="0.1"/>
    </pattern>
  </defs>
  <rect width="100%" height="100%" fill="url(#grid)"/>
  
  <!-- Main content -->
  <text x="400" y="120" font-family="Arial, sans-serif" font-size="36" font-weight="bold" text-anchor="middle" fill="#ffffff">$event</text>
  <text x="400" y="160" font-family="Arial, sans-serif" font-size="18" text-anchor="middle" fill="#00d4ff">CTF Competition Writeups</text>
  
  <!-- Decorative elements -->
  <circle cx="150" cy="80" r="3" fill="#00d4ff" opacity="0.8"/>
  <circle cx="650" cy="220" r="4" fill="#ff6b6b" opacity="0.6"/>
  <circle cx="100" cy="200" r="2" fill="#4ecdc4" opacity="0.7"/>
  
  <!-- Bottom bar -->
  <rect x="0" y="260" width="800" height="40" fill="#000000" opacity="0.3"/>
  <text x="400" y="285" font-family="Arial, sans-serif" font-size="14" text-anchor="middle" fill="#ffffff" opacity="0.8">Cybersecurity Challenge Solutions</text>
</svg>
EOF
        log_info "Created event banner for $event"
    fi
}

# Function to create individual challenge page
create_individual_challenge_page() {
    local event="$1"
    local challenge="$2"
    local category="$3"
    local difficulty="$4"
    local content="$5"
    local image_data="$6"
    local event_slug=$(create_slug "$event")
    local challenge_slug=$(create_slug "$challenge")
    
    # Create event directory (Hugo will use this for URL structure)
    local event_dir="${CONTENT_DIR}/${event_slug}"
    mkdir -p "$event_dir"
    
    local challenge_file="${event_dir}/${challenge_slug}.md"
    
    # Create image display
    local image_display=$(create_image_display "$image_data" "$challenge")
    
    # Create individual challenge page
    cat > "$challenge_file" << EOF
---
title: "$challenge"
date: $(date -Iseconds)
description: "$challenge writeup from $event CTF - $category challenge"
categories:
    - "CTF Writeups"
    - "$category"
tags:
    - "CTF"
    - "$event"
    - "$category"
    - "Cybersecurity"
event: "$event"
challenge: "$challenge"
category: "$category"
difficulty: "$difficulty"
image: "${image_data%% *}"
weight: 1
---

<div class="challenge-header">

# $challenge

<div class="challenge-meta">
<strong>Event:</strong> $event | <strong>Category:</strong> $category | <strong>Difficulty:</strong> $difficulty
</div>

</div>

$image_display

$content

---

<div class="challenge-nav">

**Navigation:**
- [← Back to $event Overview](/ctf/$event_slug/)
- [View All CTF Writeups](/ctf/)

</div>
EOF

    log_success "Created individual challenge page: $challenge_file"
}

# Function to scan and organize writeups
scan_writeups() {
    log_info "Scanning writeups from $SOURCE_DIR..."
    
    if [[ ! -d "$SOURCE_DIR" ]]; then
        log_error "Source directory $SOURCE_DIR does not exist"
        exit 1
    fi
    
    # Create main directories
    mkdir -p "$CONTENT_DIR"
    mkdir -p "$IMAGES_DIR"
    
    # Create temporary files to store event data
    local temp_dir=$(mktemp -d)
    local events_list="$temp_dir/events.txt"
    
    # First pass: collect all challenge data and write to temp files
    while IFS= read -r -d '' file; do
        # Extract path components
        local rel_path=$(realpath --relative-to="$SOURCE_DIR" "$file")
        local path_parts=(${rel_path//\// })
        
        if [[ ${#path_parts[@]} -ge 3 ]]; then
            local event="${path_parts[0]}"
            local category_raw="${path_parts[1]}"
            local challenge="${path_parts[2]%.*}"  # Remove extension
            
            # Clean up names
            event=$(echo "$event" | tr '_' ' ')
            category=$(determine_category "$category_raw")
            challenge=$(echo "$challenge" | tr '_' ' ')
            
            # Get the challenge directory path
            local challenge_dir=$(dirname "$file")
            
            log_info "Processing: $event > $category > $challenge"
            
            # Create event-specific temp file if it doesn't exist
            local event_slug=$(create_slug "$event")
            local event_file="$temp_dir/$event_slug.txt"
            
            # Add event to events list if not already there
            if ! grep -q "^$event$" "$events_list" 2>/dev/null; then
                echo "$event" >> "$events_list"
            fi
            
            # Collect challenge data
            collect_challenge_data_to_file "$event" "$category" "$challenge" "$file" "$challenge_dir" "$event_file"
        else
            log_warning "Skipping file with insufficient path depth: $file"
        fi
    done < <(find "$SOURCE_DIR" \( -name "*.md" -o -name "writeup.md" -o -name "README.md" \) -print0)
    
    # Second pass: create comprehensive articles for each event AND individual challenge pages
    if [[ -f "$events_list" ]]; then
        while IFS= read -r event; do
            if [[ -n "$event" ]]; then
                local event_slug=$(create_slug "$event")
                local event_file="$temp_dir/$event_slug.txt"
                if [[ -f "$event_file" ]]; then
                    create_event_article_from_file "$event" "$event_file"
                    create_individual_challenge_pages_from_file "$event" "$event_file"
                fi
            fi
        done < "$events_list"
    fi
    
    # Clean up temporary directory
    rm -rf "$temp_dir"
}

# Function to collect challenge data and write to file
collect_challenge_data_to_file() {
    local event="$1"
    local category="$2"
    local challenge="$3"
    local source_file="$4"
    local source_path="$5"
    local output_file="$6"
    
    local event_slug=$(create_slug "$event")
    local challenge_slug=$(create_slug "$challenge")
    local difficulty=$(determine_difficulty "$event" "$challenge")
    
    # Copy images for this challenge
    local image_data=$(copy_ctf_images "$event" "$challenge" "$source_path")
    
    # Read source content if exists
    local content=""
    if [[ -f "$source_file" ]]; then
        local raw_content=$(cat "$source_file")
        # Strip frontmatter from the content
        content=$(strip_frontmatter "$raw_content")
    else
        content="## Challenge Description

*Challenge details will be added here.*

## Solution

*Solution methodology will be documented here.*

## Flag

\`\`\`
FLAG{placeholder}
\`\`\`"
    fi
    
    # Write challenge data to file in structured format
    cat >> "$output_file" << EOF
CHALLENGE_START
CHALLENGE_NAME:$challenge
CATEGORY:$category
DIFFICULTY:$difficulty
IMAGE_DATA:$image_data
CONTENT_START
$content
CONTENT_END
CHALLENGE_END

EOF
    
    log_info "Collected data for $event > $category > $challenge"
}

# Function to create image carousel or single image
create_image_display() {
    local image_data="$1"
    local challenge_name="$2"
    
    if [[ -z "$image_data" ]]; then
        echo ""
        return
    fi
    
    # Check if it's a JSON array (multiple images)
    if [[ "$image_data" =~ ^\[.*\]$ ]]; then
        # Multiple images - create carousel
        local images=($(echo "$image_data" | jq -r '.[]'))
        if [[ ${#images[@]} -gt 1 ]]; then
            echo ""
            echo "{{< gallery >}}"
            for img in "${images[@]}"; do
                echo "{{< figure src=\"$img\" alt=\"$challenge_name\" >}}"
            done
            echo "{{< /gallery >}}"
            echo ""
        else
            # Single image in array
            local img=$(echo "$image_data" | jq -r '.[0]')
            echo ""
            echo "![${challenge_name}](${img})"
            echo ""
        fi
    else
        # Single image
        echo ""
        echo "![${challenge_name}](${image_data})"
        echo ""
    fi
}

# Function to create individual challenge pages from file data
create_individual_challenge_pages_from_file() {
    local event="$1"
    local data_file="$2"
    
    # Parse data file to create individual challenge pages
    local in_challenge=false
    local in_content=false
    local current_challenge=""
    local current_category=""
    local current_difficulty=""
    local current_image_data=""
    local current_content=""
    
    while IFS= read -r line; do
        if [[ "$line" == "CHALLENGE_START" ]]; then
            in_challenge=true
            current_challenge=""
            current_category=""
            current_difficulty=""
            current_image_data=""
            current_content=""
        elif [[ "$line" == "CHALLENGE_END" ]]; then
            if [[ $in_challenge == true ]]; then
                # Create individual challenge page
                create_individual_challenge_page "$event" "$current_challenge" "$current_category" "$current_difficulty" "$current_content" "$current_image_data"
            fi
            in_challenge=false
        elif [[ "$line" == "CONTENT_START" ]]; then
            in_content=true
        elif [[ "$line" == "CONTENT_END" ]]; then
            in_content=false
        elif [[ $in_content == true ]]; then
            current_content+="$line"$'\n'
        elif [[ $in_challenge == true ]]; then
            if [[ "$line" =~ ^CHALLENGE_NAME: ]]; then
                current_challenge="${line#CHALLENGE_NAME:}"
            elif [[ "$line" =~ ^CATEGORY: ]]; then
                current_category="${line#CATEGORY:}"
            elif [[ "$line" =~ ^DIFFICULTY: ]]; then
                current_difficulty="${line#DIFFICULTY:}"
            elif [[ "$line" =~ ^IMAGE_DATA: ]]; then
                current_image_data="${line#IMAGE_DATA:}"
            fi
        fi
    done < "$data_file"
}

# Function to create comprehensive event article from file data
create_event_article_from_file() {
    local event="$1"
    local data_file="$2"
    local event_slug=$(create_slug "$event")
    local output_file="${CONTENT_DIR}/${event_slug}.md"
    
    # Parse data file to extract information
    local challenge_count=0
    local categories=()
    local content_data=""
    local challenge_links=""
    
    # Read and parse the data file
    local in_challenge=false
    local in_content=false
    local current_challenge=""
    local current_category=""
    local current_difficulty=""
    local current_image_data=""
    local current_content=""
    
    while IFS= read -r line; do
        if [[ "$line" == "CHALLENGE_START" ]]; then
            in_challenge=true
            current_challenge=""
            current_category=""
            current_difficulty=""
            current_image_data=""
            current_content=""
        elif [[ "$line" == "CHALLENGE_END" ]]; then
            if [[ $in_challenge == true ]]; then
                challenge_count=$((challenge_count + 1))
                
                # Add category to list if not present
                if [[ ! " ${categories[@]} " =~ " ${current_category} " ]]; then
                    categories+=("$current_category")
                fi
                
                # Create challenge link
                local challenge_slug=$(create_slug "$current_challenge")
                challenge_links+="- **[$current_challenge](/ctf/${event_slug}/${challenge_slug}/)** - $current_category ($current_difficulty)
"
                
                # Create image display
                local image_display=$(create_image_display "$current_image_data" "$current_challenge")
                
                # Add content with better formatting and clickable link
                content_data+="
## [$current_challenge](/ctf/${event_slug}/${challenge_slug}/)

**Category:** $current_category | **Difficulty:** $current_difficulty

$image_display

${current_content:0:300}$(if [[ ${#current_content} -gt 300 ]]; then echo "...

[**→ Read full writeup**](/ctf/${event_slug}/${challenge_slug}/)"; fi)

---

"
            fi
            in_challenge=false
        elif [[ "$line" == "CONTENT_START" ]]; then
            in_content=true
        elif [[ "$line" == "CONTENT_END" ]]; then
            in_content=false
        elif [[ $in_content == true ]]; then
            current_content+="$line"$'\n'
        elif [[ $in_challenge == true ]]; then
            if [[ "$line" =~ ^CHALLENGE_NAME: ]]; then
                current_challenge="${line#CHALLENGE_NAME:}"
            elif [[ "$line" =~ ^CATEGORY: ]]; then
                current_category="${line#CATEGORY:}"
            elif [[ "$line" =~ ^DIFFICULTY: ]]; then
                current_difficulty="${line#DIFFICULTY:}"
            elif [[ "$line" =~ ^IMAGE_DATA: ]]; then
                current_image_data="${line#IMAGE_DATA:}"
            fi
        fi
    done < "$data_file"
    
    local category_count=${#categories[@]}
    
    # Create event banner
    create_event_banner "$event_slug" "$event"
    
    # Generate category summary
    local category_summary=""
    for category in "${categories[@]}"; do
        if [[ -n "$category" ]]; then
            local cat_count=$(grep -c "CATEGORY:$category" "$data_file" 2>/dev/null || echo "1")
            category_summary+="- **$category** ($cat_count challenges)
"
        fi
    done
    
    # Check for ranking/achievement images
    local achievement_section=""
    local event_images_dir="${IMAGES_DIR}/${event_slug}"
    if [[ -f "$event_images_dir/rank.png" ]]; then
        achievement_section+="
## Competition Results

![Competition Ranking](/images/ctf/${event_slug}/rank.png)

"
    elif [[ -f "$event_images_dir/team_mvp.png" ]]; then
        achievement_section+="
## Team Achievement

![Team MVP](/images/ctf/${event_slug}/team_mvp.png)

"
    fi
    
    # Create comprehensive event article with cleaner formatting
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
image: "/images/ctf/${event_slug}/event-banner.svg"
weight: 1
---

<div class="event-summary">

# $event CTF Competition

## Event Summary

**🏆 Event:** $event  
**✅ Challenges Solved:** $challenge_count  
**🎯 Categories:** $category_count  
**📅 Date:** $(date '+%B %Y')

## Categories Solved

$category_summary

</div>

$achievement_section

---

<div class="challenge-nav">

## Quick Navigation - Individual Challenge Pages

$challenge_links

</div>

---

# Challenge Previews

$content_data

---

## Reflection

Successfully completed **$challenge_count challenges** across **$category_count categories** in the $event competition. Each challenge provided valuable learning opportunities and practical cybersecurity experience.

**[View more CTF writeups](/ctf) | [About me](/about)**
EOF

    log_success "Created comprehensive event article: $output_file"
}

# Function to update main CTF index
update_main_index() {
    local total_events=$(find "$CONTENT_DIR" -name "*.md" -not -name "_index.md" -not -path "*/*/.*" 2>/dev/null | wc -l)
    local total_writeups=0
    
    # Count total challenges across all event files
    for event_file in "$CONTENT_DIR"/*.md; do
        if [[ -f "$event_file" && "$(basename "$event_file")" != "_index.md" ]]; then
            local challenges_in_file=$(grep -c "challenges_solved:" "$event_file" 2>/dev/null || echo "0")
            if [[ $challenges_in_file -gt 0 ]]; then
                local count=$(grep "challenges_solved:" "$event_file" | head -1 | sed 's/.*challenges_solved: *//' | sed 's/ .*//')
                total_writeups=$((total_writeups + count))
            fi
        fi
    done
    
    log_info "Updating main CTF index with $total_events events and $total_writeups total challenges"
    
    # Update the main index if it exists
    if [[ -f "${CONTENT_DIR}/_index.md" ]]; then
        sed -i "s/featuring \*\*[0-9]* events\*\*/featuring **$total_events events**/" "${CONTENT_DIR}/_index.md" 2>/dev/null || true
        sed -i "s/\*\*[0-9]*+ challenges\*\*/\*\*$total_writeups+ challenges\*\*/" "${CONTENT_DIR}/_index.md" 2>/dev/null || true
    fi
}

# Main execution
main() {
    log_info "Starting CTF writeups sync (Event + Individual Pages)..."
    
    # Scan and organize writeups
    scan_writeups
    
    # Update main index
    update_main_index
    
    log_success "CTF writeups sync completed successfully!"
    log_info "Event articles generated in: $CONTENT_DIR"
    log_info "Individual challenge pages created in subdirectories"
    log_info "Images organized in: $IMAGES_DIR"
}

# Run main function
main "$@"
