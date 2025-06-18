#!/bin/bash

# Script to format CTF writeups from CTF-Writeups repo to standard format
# Usage: ./format-writeups.sh

echo "🔄 Formatting CTF writeups for portfolio platform..."

# Create temp directory
TEMP_DIR="/tmp/ctf-format"
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

# Clone the CTF-Writeups repository
echo "📥 Cloning CTF-Writeups repository..."
git clone https://github.com/tham-le/CTF-Writeups.git $TEMP_DIR/source

# Find all writeup files
writeups=($(find $TEMP_DIR/source -name "wu.md" -type f))

echo "📝 Found ${#writeups[@]} writeup files to format"

# Process each writeup
for writeup in "${writeups[@]}"; do
    echo "Processing: $writeup"
    
    # Extract metadata from path
    # Example: /tmp/ctf-format/source/2025/IrisCTF/sqlate/wu.md
    year=$(echo $writeup | cut -d'/' -f6)
    ctf_name=$(echo $writeup | cut -d'/' -f7)
    challenge=$(echo $writeup | cut -d'/' -f8)
    
    # Create formatted filename
    formatted_name="2025-irisctf-$(echo $challenge | tr '[:upper:]' '[:lower:]')-writeup.md"
    
    # Read original content
    content=$(cat "$writeup")
    
    # Create new formatted file
    cat > "$TEMP_DIR/$formatted_name" << EOF
---
title: "$challenge"
date: "$year-01-15"
ctf: "$ctf_name CTF $year"
category: "Web"
difficulty: "Easy"
points: 50
tags: ["ctf", "$(echo $challenge | tr '[:upper:]' '[:lower:]')"]
author: "Tham Le"
solved: true
---

$content

## Tools Used

- Manual analysis
- Browser Developer Tools

## Lessons Learned

- Always check for common vulnerabilities in web applications
- Systematic approach to challenge solving is key

---

*Writeup by Tham Le - IrisCTF 2025*
EOF

    echo "✅ Formatted: $formatted_name"
done

echo ""
echo "🎯 Formatted writeups saved in: $TEMP_DIR"
echo "📋 Files created:"
ls -la $TEMP_DIR/*.md 2>/dev/null || echo "No files created"

echo ""
echo "🔄 To copy to your portfolio:"
echo "cp $TEMP_DIR/*.md /home/tham/Obsidian/thamle-portfolio/assets/writeups/"
echo "cd /home/tham/Obsidian/thamle-portfolio && git add assets/writeups/ && git commit -m 'Add formatted CTF writeups' && git push"
