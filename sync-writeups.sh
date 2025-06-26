#!/bin/bash

# Simple CTF Writeup Sync Script

echo "🔄 Syncing CTF writeups..."

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

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Use rsync to copy the contents, preserving the structure
rsync -av --delete --exclude=".git" --exclude="*.pyc" --exclude="__pycache__" "$SOURCE_DIR/" "$DEST_DIR/"

# Create _index.md files for any directories that don't have them
find "$DEST_DIR" -type d -not -path "*/.git*" | while read dir; do
    if [ ! -f "$dir/_index.md" ] && [ "$dir" != "$DEST_DIR" ]; then
        event_name=$(basename "$dir")
        cat > "$dir/_index.md" << EOF
---
title: "$event_name CTF"
description: "CTF writeups for $event_name"
date: $(date +%Y-%m-%d)
categories:
    - "CTF"
tags:
    - "CTF"
    - "$event_name"
draft: false
---

# $event_name CTF Writeups

This section contains my writeups for the $event_name competition.
EOF
        echo "✅ Created index for $event_name"
    fi
done

echo '🎉 Sync complete!'
