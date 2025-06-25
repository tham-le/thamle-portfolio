#!/bin/bash

# 🧪 Local Submodule-Based CTF Writeups Sync Test
# Tests the sync process using the Git submodule

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_DIR="$(dirname "$SCRIPT_DIR")"
EXTERNAL_REPO="$PORTFOLIO_DIR/external-writeups"

echo "🚀 Starting submodule-based writeups sync test"
echo "- Portfolio dir: $PORTFOLIO_DIR"
echo "- External repo: $EXTERNAL_REPO"

# Verify submodule exists
if [ ! -d "$EXTERNAL_REPO" ]; then
    echo "❌ Error: Submodule not found at $EXTERNAL_REPO"
    echo "Make sure you've run: git submodule update --init --recursive"
    exit 1
fi

# Update submodule to latest
echo "🔄 Updating submodule to latest..."
cd "$PORTFOLIO_DIR"
git submodule update --remote --merge

# Clean and recreate directories
echo "🧹 Cleaning previous sync..."
rm -rf ctf_site/assets/writeups/*
rm -rf ctf_app/assets/writeups/*
mkdir -p ctf_site/assets/writeups
mkdir -p ctf_app/assets/writeups
mkdir -p ctf_site/assets/images/ctf

# Discover writeups
echo "🔍 Discovering writeups in submodule..."

# Test discovery function
python3 << 'PYTHON_SCRIPT'
import os
import yaml
import json
from pathlib import Path

def discover_writeups(external_repo):
    """Discover all writeups in the external repository"""
    writeups = []
    
    for root, dirs, files in os.walk(external_repo):
        for file in files:
            if file.lower().endswith(('.md', '.markdown')) and file.lower() not in ['readme.md']:
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, external_repo)
                
                # Parse CTF event and category from path
                path_parts = rel_path.split(os.sep)
                if len(path_parts) >= 3:
                    ctf_event = path_parts[0]
                    category_raw = path_parts[1]
                    challenge_name = path_parts[2] if len(path_parts) > 3 else os.path.splitext(file)[0]
                    
                    # Normalize category
                    category_map = {
                        'Web_Exploitation': 'web',
                        'web_exploitation': 'web', 
                        'web': 'web',
                        'Cryptography': 'crypto',
                        'cryptography': 'crypto',
                        'crypto': 'crypto',
                        'Binary_Exploitation': 'pwn',
                        'binary_exploitation': 'pwn',
                        'pwn': 'pwn',
                        'Reverse_Engineering': 'rev',
                        'reverse_engineering': 'rev',
                        'rev': 'rev',
                        'Forensics': 'forensics',
                        'forensics': 'forensics',
                        'Open-Source_Intelligence': 'osint',
                        'open_source_intelligence': 'osint',
                        'osint': 'osint',
                        'Miscellaneous': 'misc',
                        'miscellaneous': 'misc',
                        'misc': 'misc'
                    }
                    
                    category = category_map.get(category_raw, category_raw.lower())
                    
                    writeups.append({
                        'ctf_event': ctf_event,
                        'category': category,
                        'challenge_name': challenge_name,
                        'filename': file,
                        'source_path': filepath,
                        'relative_path': rel_path
                    })
    
    return writeups

# Test discovery
external_repo = "external-writeups"
writeups = discover_writeups(external_repo)

print(f"🎯 Found {len(writeups)} writeups:")
for writeup in writeups[:10]:  # Show first 10
    print(f"  📝 {writeup['ctf_event']}/{writeup['category']}/{writeup['challenge_name']}")

# Group by CTF event
events = {}
for writeup in writeups:
    event = writeup['ctf_event']
    if event not in events:
        events[event] = []
    events[event].append(writeup)

print(f"\n📊 CTF Events discovered:")
for event, event_writeups in events.items():
    categories = set(w['category'] for w in event_writeups)
    print(f"  🏆 {event}: {len(event_writeups)} writeups in {len(categories)} categories")
    print(f"     Categories: {', '.join(sorted(categories))}")

PYTHON_SCRIPT

echo "✅ Submodule sync test completed successfully!"
echo "🌟 Next steps:"
echo "   1. Commit the submodule setup"
echo "   2. Push to trigger the GitHub Actions workflow"
echo "   3. Check deployment at https://ctf.thamle.live/"
