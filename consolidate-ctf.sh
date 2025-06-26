#!/bin/bash

# Improved CTF Writeup Consolidation Script

echo "🔄 Consolidating CTF writeups by event..."

# Define source and destination directories
SOURCE_DIR="external-writeups"
DEST_DIR="content/ctf"

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Source directory '$SOURCE_DIR' not found. Make sure the submodule is initialized."
    exit 1
fi

# Update the submodule to the latest commit
git submodule update --remote --merge

# Function to extract title from markdown file
extract_title() {
    local file="$1"
    local fallback_title="$2"
    
    if [ ! -f "$file" ] || [ ! -s "$file" ]; then
        echo "$fallback_title"
        return
    fi
    
    # Try to extract title from frontmatter
    local title=$(grep -m1 "^title:" "$file" | sed 's/title: *["'\'']*\([^"'\'']*\)["'\'']*$/\1/')
    
    # If no frontmatter title, try to extract from first # heading
    if [ -z "$title" ]; then
        title=$(grep -m1 "^# " "$file" | sed 's/^# *//')
    fi
    
    # If still no title, use fallback
    if [ -z "$title" ]; then
        title="$fallback_title"
    fi
    
    echo "$title"
}

# Function to extract content from markdown file
extract_content() {
    local file="$1"
    
    if [ ! -f "$file" ] || [ ! -s "$file" ]; then
        echo "*No content available for this challenge.*"
        return
    fi
    
    # Check if file has frontmatter
    if head -1 "$file" | grep -q "^---"; then
        # Skip frontmatter (everything between first --- and second ---)
        sed -n '/^---$/,/^---$/!p' "$file" | sed '1,/^---$/d'
    else
        # No frontmatter, use entire content
        cat "$file"
    fi
}

# Function to consolidate writeups for an event
consolidate_event() {
    local event_dir="$1"
    local event_name=$(basename "$event_dir")
    local consolidated_file="$DEST_DIR/${event_name}.md"
    
    echo "📝 Consolidating $event_name..."
    
    # Clean up event name for display
    local display_name=$(echo "$event_name" | sed 's/-/ /g' | sed 's/\b\w/\U&/g')
    
    # Create the consolidated markdown file
    cat > "$consolidated_file" << EOF
---
title: "$display_name CTF Writeups"
description: "My solutions and writeups for $display_name challenges"
date: $(date +%Y-%m-%d)
categories:
    - "CTF"
    - "Cybersecurity"
tags:
    - "CTF"
    - "$event_name"
draft: false
---

# $display_name CTF Writeups

This page contains all my writeups for the $display_name competition.

EOF

    local challenge_count=0
    
    # Find all writeup files in the event directory
    find "$event_dir" -name "*.md" -type f | sort | while read writeup_file; do
        # Skip _index.md files
        if [[ $(basename "$writeup_file") == "_index.md" ]]; then
            continue
        fi
        
        # Get the challenge info from the directory structure
        local challenge_dir=$(dirname "$writeup_file")
        local relative_path=$(echo "$challenge_dir" | sed "s|^$event_dir/*||")
        
        # Extract meaningful challenge name and category
        local challenge_name=""
        local category_name=""
        
        if [[ "$relative_path" == *"/"* ]]; then
            # Has subdirectory structure like "web/challenge-name"
            category_name=$(echo "$relative_path" | cut -d'/' -f1 | sed 's/_/ /g' | sed 's/-/ /g')
            challenge_name=$(echo "$relative_path" | cut -d'/' -f2- | sed 's/_/ /g' | sed 's/-/ /g')
        else
            # Single level directory
            challenge_name=$(echo "$relative_path" | sed 's/_/ /g' | sed 's/-/ /g')
            category_name="General"
        fi
        
        # Extract title from the markdown file
        local extracted_title=$(extract_title "$writeup_file" "$challenge_name")
        
        # Use extracted title if it's more meaningful
        if [[ ${#extracted_title} -gt ${#challenge_name} ]] && [[ "$extracted_title" != "$challenge_name" ]]; then
            challenge_name="$extracted_title"
        fi
        
        # Create section header
        if [[ -n "$category_name" && "$category_name" != "General" ]]; then
            echo "## $category_name: $challenge_name" >> "$consolidated_file"
        else
            echo "## $challenge_name" >> "$consolidated_file"
        fi
        
        echo "" >> "$consolidated_file"
        
        # Extract and add the content
        extract_content "$writeup_file" >> "$consolidated_file"
        
        echo "" >> "$consolidated_file"
        echo "---" >> "$consolidated_file"
        echo "" >> "$consolidated_file"
        
        challenge_count=$((challenge_count + 1))
    done
    
    echo "✅ Consolidated $event_name with $challenge_count challenges"
}

# Clean up old content but preserve _index.md
find "$DEST_DIR" -name "*.md" -not -name "_index.md" -delete 2>/dev/null || true
mkdir -p "$DEST_DIR"

# Recreate the main index if it doesn't exist
if [ ! -f "$DEST_DIR/_index.md" ]; then
    cat > "$DEST_DIR/_index.md" << 'EOF'
---
title: "CTF Writeups"
description: "Cybersecurity challenge solutions and learning experiences"
date: 2025-06-26
draft: false
---

# CTF Writeups

Welcome to my collection of Capture The Flag (CTF) writeups. This section is automatically updated with my latest solutions from various competitions. Each writeup documents my approach to solving the challenge, including the tools and techniques I used.

Below is a list of CTF events I have participated in. Click on any event to see the writeups for the challenges I've solved.
EOF
fi

# Process external writeups
if [ -d "$SOURCE_DIR" ]; then
    find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -not -name ".*" | while read event_dir; do
        consolidate_event "$event_dir"
    done
fi

# Process existing CTF content directories
find "$DEST_DIR" -mindepth 1 -maxdepth 1 -type d -not -name ".*" | while read event_dir; do
    consolidate_event "$event_dir"
done

echo '🎉 CTF writeup consolidation complete!'
