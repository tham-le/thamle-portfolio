#!/bin/bash

# CTF Writeup Consolidation Script

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

# Function to consolidate writeups for an event
consolidate_event() {
    local event_dir="$1"
    local event_name=$(basename "$event_dir")
    local consolidated_file="$DEST_DIR/${event_name}.md"
    
    echo "📝 Consolidating $event_name..."
    
    # Create the consolidated markdown file
    cat > "$consolidated_file" << EOF
---
title: "$event_name CTF Writeups"
description: "My solutions and writeups for $event_name challenges"
date: $(date +%Y-%m-%d)
categories:
    - "CTF"
    - "Cybersecurity"
tags:
    - "CTF"
    - "$event_name"
draft: false
---

# $event_name CTF Writeups

This page contains all my writeups for the $event_name competition.

EOF

    # Find all writeup files in the event directory
    find "$event_dir" -name "*.md" -type f | while read writeup_file; do
        # Get the challenge name from the directory structure
        challenge_path=$(dirname "$writeup_file")
        challenge_name=$(basename "$challenge_path")
        category_path=$(dirname "$challenge_path")
        category_name=$(basename "$category_path")
        
        echo "  📋 Adding challenge: $category_name/$challenge_name"
        
        # Add challenge section to consolidated file
        cat >> "$consolidated_file" << EOF

## $category_name - $challenge_name

EOF
        
        # Add the writeup content (skip frontmatter if present)
        if grep -q "^---" "$writeup_file"; then
            # Skip YAML frontmatter
            sed '1,/^---$/d; /^---$/,$d' "$writeup_file" >> "$consolidated_file"
        else
            # No frontmatter, add content directly
            cat "$writeup_file" >> "$consolidated_file"
        fi
        
        echo "" >> "$consolidated_file"
    done
    
    echo "✅ Consolidated $event_name with $(find "$event_dir" -name "*.md" -type f | wc -l) challenges"
}

# Clean up old content
rm -rf "$DEST_DIR"/*.md
mkdir -p "$DEST_DIR"

# Recreate the main index
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

# Process external writeups
if [ -d "$SOURCE_DIR" ]; then
    find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -not -name ".*" | while read event_dir; do
        consolidate_event "$event_dir"
    done
fi

# Process existing CTF content (like picoctf-2024)
if [ -d "$DEST_DIR/picoctf-2024" ]; then
    consolidate_event "$DEST_DIR/picoctf-2024"
fi

# Process existing processed content
if [ -d "$DEST_DIR/processed" ]; then
    find "$DEST_DIR/processed" -mindepth 1 -maxdepth 1 -type d | while read event_dir; do
        consolidate_event "$event_dir"
    done
    # Remove the processed directory after consolidation
    rm -rf "$DEST_DIR/processed"
fi

echo '🎉 CTF writeup consolidation complete!'
