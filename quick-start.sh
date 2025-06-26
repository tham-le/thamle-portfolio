#!/bin/bash

# Portfolio Quick Start Script

echo "🚀 Starting Hugo Portfolio"
echo "=========================="

# Check if Hugo is installed
if ! command -v hugo &> /dev/null; then
    echo "📦 Installing Hugo..."
    if command -v snap &> /dev/null; then
        sudo snap install hugo --channel=extended
    elif command -v apt &> /dev/null; then
        sudo apt update && sudo apt install hugo
    else
        echo "❌ Please install Hugo manually: https://gohugo.io/installation/"
        exit 1
    fi
fi

# Initialize submodules
git submodule update --init --recursive

# Sync writeups
if [ -f "./sync-writeups.sh" ]; then
    ./sync-writeups.sh
fi

# Start Hugo server
echo "🌐 Starting server at http://localhost:1313"
hugo server --buildDrafts --navigateToChanged
