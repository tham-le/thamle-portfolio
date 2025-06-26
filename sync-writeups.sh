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

# Run the consolidation script
if [ -f "./consolidate-ctf.sh" ]; then
    chmod +x ./consolidate-ctf.sh
    ./consolidate-ctf.sh
else
    echo "❌ Consolidation script not found"
    exit 1
fi

echo '🎉 Sync complete!'
