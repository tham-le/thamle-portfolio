#!/bin/bash

# Test sync script
cd /home/tham/Obsidian/thamle-portfolio

# Remove existing synced content (keep format guide)
find assets/writeups -name "*.md" -not -name "CTF-WRITEUP-FORMAT.md" -delete 2>/dev/null || true
find assets/writeups -type d -not -name "writeups" -exec rm -rf {} + 2>/dev/null || true

echo "🔄 Syncing writeups from CTF-Writeups repository..."

# Process each CTF event directory
for ctf_dir in ctf-writeups-source/*/; do
  if [ -d "$ctf_dir" ]; then
    ctf_name=$(basename "$ctf_dir")
    
    if [ "$ctf_name" != ".git" ]; then
      echo "🏆 Processing CTF: $ctf_name"
      event_path="assets/writeups/$ctf_name"
      mkdir -p "$event_path"
      
      # Initialize category counters
      declare -A category_counts
      
      # Process each challenge directory
      for challenge_dir in "$ctf_dir"*/; do
        if [ -d "$challenge_dir" ]; then
          challenge_name=$(basename "$challenge_dir")
          
          # Determine category from challenge name
          category="misc"  # default
          case "$challenge_name" in
            *web*|*sql*|*xss*|*csrf*|*ssrf*|*http*|*server*) category="web" ;;
            *crypto*|*cipher*|*rsa*|*aes*|*hash*|*encrypt*|*kitty*) category="crypto" ;;
            *pwn*|*buffer*|*overflow*|*rop*|*shellcode*|*binary*) category="pwn" ;;
            *rev*|*reverse*|*disasm*|*assembly*) category="rev" ;;
            *forensic*|*steg*|*disk*|*memory*|*where*|*bobby*) category="forensics" ;;
            *osint*|*recon*|*intel*) category="osint" ;;
            *password*|*manager*|*auth*) category="web" ;;
          esac
          
          # Create category directory
          mkdir -p "$event_path/$category"
          
          # Find and copy writeup files (wu.md)
          if [ -f "$challenge_dir/wu.md" ]; then
            new_filename="${challenge_name}.md"
            cp "$challenge_dir/wu.md" "$event_path/$category/$new_filename"
            echo "  ✅ $category/$new_filename"
            
            # Count categories
            category_counts[$category]=$((${category_counts[$category]:-0} + 1))
          fi
        fi
      done
      
      # Generate event index
      echo "# $ctf_name" > "$event_path/README.md"
      echo "" >> "$event_path/README.md"
      echo "CTF writeups for $ctf_name challenges." >> "$event_path/README.md"
      echo "" >> "$event_path/README.md"
      echo "## Categories" >> "$event_path/README.md"
      echo "" >> "$event_path/README.md"
      
      # List categories with counts
      for category in crypto web pwn rev forensics osint misc; do
        if [ "${category_counts[$category]:-0}" -gt 0 ]; then
          echo "- **[$category](./$category/)** (${category_counts[$category]} challenges)" >> "$event_path/README.md"
        fi
      done
    fi
  fi
done

# Generate main index
echo "# CTF Writeups Collection" > assets/writeups/index.md
echo "" >> assets/writeups/index.md
echo "> Automatically synced from [CTF-Writeups Repository](https://github.com/tham-le/CTF-Writeups)" >> assets/writeups/index.md
echo "" >> assets/writeups/index.md
echo "## 🏆 CTF Events" >> assets/writeups/index.md
echo "" >> assets/writeups/index.md

# List all CTF events
for event_dir in assets/writeups/*/; do
  if [ -d "$event_dir" ]; then
    event=$(basename "$event_dir")
    if [ -f "$event_dir/README.md" ]; then
      echo "- [$event](./$event/)" >> assets/writeups/index.md
    fi
  fi
done

echo "" >> assets/writeups/index.md
echo "## 📊 Statistics" >> assets/writeups/index.md
echo "" >> assets/writeups/index.md

# Add statistics
total_writeups=$(find assets/writeups -name "*.md" -not -name "README.md" -not -name "index.md" -not -name "CTF-WRITEUP-FORMAT.md" | wc -l)
total_ctfs=$(find assets/writeups -type d -mindepth 1 -maxdepth 1 | wc -l)

echo "- **Total CTF Events:** $total_ctfs" >> assets/writeups/index.md
echo "- **Total Writeups:** $total_writeups" >> assets/writeups/index.md
echo "- **Last Updated:** $(date -u '+%Y-%m-%d %H:%M UTC')" >> assets/writeups/index.md

echo ""
echo "📊 Sync Summary:"
echo "- CTF Events: $total_ctfs"
echo "- Total Writeups: $total_writeups"
