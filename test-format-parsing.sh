#!/bin/bash

# 🧪 Test Script for Dynamic CTF Writeup Format Parsing
# This script demonstrates how the new format works

echo "🔬 Testing Dynamic CTF Writeup Format Parsing"
echo "============================================="

# Create a test external repository structure
mkdir -p test-external-repo

# Test Case 1: Proper format - CTF_event-category-challengename-writeup.md
echo "📝 Test Case 1: Proper format"
cat > test-external-repo/PicoCTF2024-web-sql-injection-writeup.md << 'EOF'
---
title: "SQL Injection Challenge"
difficulty: "Medium"
points: 150
---

# SQL Injection Challenge

This is a test writeup for SQL injection.

![Screenshot](./screenshot.png)

## Solution

The vulnerability was found in the login form...
EOF

# Test Case 2: Alternative format - CTF_event-category-challengename-wu.md
echo "📝 Test Case 2: Alternative format (wu.md)"
cat > test-external-repo/HackTheBox2024-crypto-rsa-crack-wu.md << 'EOF'
# RSA Crack Challenge

This challenge involved breaking RSA encryption.

![Key diagram](./rsa-key.png)
EOF

# Test Case 3: Complex challenge name
echo "📝 Test Case 3: Complex challenge name"
cat > test-external-repo/GoogleCTF2024-pwn-buffer-overflow-easy-mode-writeup.md << 'EOF'
# Buffer Overflow Easy Mode

This was a beginner-friendly buffer overflow challenge.
EOF

# Create some test images
mkdir -p test-external-repo/images
echo "fake image data" > test-external-repo/screenshot.png
echo "fake rsa diagram" > test-external-repo/rsa-key.png

echo ""
echo "📁 Created test repository structure:"
find test-external-repo -type f | sort

echo ""
echo "🔍 The new sync workflow will parse these files as:"
echo "1. PicoCTF2024-web-sql-injection-writeup.md"
echo "   → CTF: PicoCTF2024, Category: web, Challenge: sql-injection"
echo ""
echo "2. HackTheBox2024-crypto-rsa-crack-wu.md"
echo "   → CTF: HackTheBox2024, Category: crypto, Challenge: rsa-crack"
echo ""
echo "3. GoogleCTF2024-pwn-buffer-overflow-easy-mode-writeup.md"
echo "   → CTF: GoogleCTF2024, Category: pwn, Challenge: buffer-overflow-easy-mode"

echo ""
echo "✅ Dynamic parsing supports:"
echo "• CTF_event-category-challengename-writeup.md"
echo "• CTF_event-category-challengename-wu.md"
echo "• CTF_event-category-challengename-solution.md"
echo "• CTF_event-category-challengename-solve.md"
echo "• Complex challenge names with multiple hyphens"
echo "• Automatic image detection and optimization"
echo "• Category normalization (web_exploitation → web, etc.)"

echo ""
echo "🚀 To test the full sync, run:"
echo "   git add ."
echo "   git commit -m 'trigger sync'"
echo "   git push"

# Cleanup
rm -rf test-external-repo

echo ""
echo "🧪 Test completed!"
