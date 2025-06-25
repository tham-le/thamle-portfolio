#!/bin/bash

# Test script to verify external CTF repository sync
echo "🧪 Testing External CTF Repository Sync"
echo "========================================"

# Check if external repo exists
if [ ! -d "external-ctf-repo" ]; then
    echo "📥 Cloning external CTF repository..."
    git clone https://github.com/tham-le/CTF-Writeups.git external-ctf-repo
fi

echo ""
echo "📁 Current External Repository Structure:"
echo "----------------------------------------"
find external-ctf-repo -type f -name "*.md" | head -20

echo ""
echo "🎯 Filename Format Analysis:"
echo "----------------------------"
find external-ctf-repo -name "*.md" -exec basename {} \; | grep -E ".*-.*-.*" | head -10

echo ""
echo "🗂️ Directory Structure Analysis:"
echo "--------------------------------"
find external-ctf-repo -type d -mindepth 1 -maxdepth 3 | head -15

echo ""
echo "📊 Statistics:"
echo "-------------"
echo "Total .md files: $(find external-ctf-repo -name "*.md" | wc -l)"
echo "Potential CTF events: $(find external-ctf-repo -maxdepth 1 -type d | tail -n +2 | wc -l)"
echo "Files with format pattern: $(find external-ctf-repo -name "*.md" -exec basename {} \; | grep -E ".*-.*-.*writeup|.*-.*-.*wu" | wc -l)"

echo ""
echo "✅ Test completed. Review the structure above to ensure sync workflow compatibility."
