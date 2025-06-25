#!/bin/bash

# Local script to simulate the writeups sync process for testing
# Usage: ./sync-writeups-local.sh /path/to/external-writeups

set -e

# Check if external writeups path is provided
if [ -z "$1" ]; then
    echo "Please provide the path to external writeups repository"
    echo "Usage: ./sync-writeups-local.sh /path/to/external-writeups"
    exit 1
fi

EXTERNAL_REPO="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_DIR="$(dirname "$SCRIPT_DIR")"

if [ ! -d "$EXTERNAL_REPO" ]; then
    echo "Error: External writeups directory not found at $EXTERNAL_REPO"
    exit 1
fi

echo "🔄 Starting local writeups sync process"
echo "- External repo: $EXTERNAL_REPO"
echo "- Portfolio dir: $PORTFOLIO_DIR"

# Create directories if they don't exist
mkdir -p "$PORTFOLIO_DIR/ctf_app/assets/writeups"
mkdir -p "$PORTFOLIO_DIR/ctf_site/assets/writeups"

# Remove existing synced content (keep format guide and preserve redirection pages)
find "$PORTFOLIO_DIR/ctf_app/assets/writeups" -name "*.md" -not -name "ctf-writeup-format.md" -delete 2>/dev/null || true
find "$PORTFOLIO_DIR/ctf_app/assets/writeups" -type d -not -name "writeups" -exec rm -rf {} + 2>/dev/null || true

# For the ctf_site, just remove the writeups content but keep the redirection pages
find "$PORTFOLIO_DIR/ctf_site/assets/writeups" -name "*.md" -delete 2>/dev/null || true
find "$PORTFOLIO_DIR/ctf_site/assets/writeups" -type d -not -name "writeups" -not -name "assets" -not -name "images" -exec rm -rf {} + 2>/dev/null || true

# Ensure redirection directories exist
mkdir -p "$PORTFOLIO_DIR/ctf_site/web"
mkdir -p "$PORTFOLIO_DIR/ctf_site/crypto"
mkdir -p "$PORTFOLIO_DIR/ctf_site/forensics"
mkdir -p "$PORTFOLIO_DIR/ctf_site/pwn"
mkdir -p "$PORTFOLIO_DIR/ctf_site/rev"
mkdir -p "$PORTFOLIO_DIR/ctf_site/misc"
mkdir -p "$PORTFOLIO_DIR/ctf_site/osint"

echo "🔄 Syncing writeups from external repository..."

# Process each CTF event directory
for ctf_dir in "$EXTERNAL_REPO"/*/; do
  if [ -d "$ctf_dir" ] && [ "$(basename "$ctf_dir")" != ".git" ]; then
    ctf_name=$(basename "$ctf_dir")
    
    # Skip if it's just the README
    if [ "$ctf_name" = "README.md" ]; then
      continue
    fi
    
    echo "🏆 Processing CTF: $ctf_name"
    event_path="$PORTFOLIO_DIR/ctf_app/assets/writeups/$ctf_name"
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
          *crypto*|*cipher*|*rsa*|*aes*|*hash*|*encrypt*|kitty*) category="crypto" ;;
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
          
          # Check for images directory and copy images if they exist
          if [ -d "$challenge_dir/images" ]; then
            # Create image directories
            mkdir -p "$event_path/$category/images"
            mkdir -p "$PORTFOLIO_DIR/ctf_site/assets/images/writeups/$ctf_name/$category/$challenge_name"
            
            # Copy images to both locations
            cp -r "$challenge_dir/images/"* "$event_path/$category/images/"
            cp -r "$challenge_dir/images/"* "$PORTFOLIO_DIR/ctf_site/assets/images/writeups/$ctf_name/$category/$challenge_name/"
            
            # Update image paths in the writeup
            sed -i "s|!\[.*\](images/|![](/assets/images/writeups/$ctf_name/$category/$challenge_name/|g" "$event_path/$category/$new_filename"
            echo "  📷 Copied images and updated paths"
          fi
        fi
      fi
    done
    
    # Generate event index
    echo "# $ctf_name" > "$event_path/README.md"
    echo "" >> "$event_path/README.md"
    echo "CTF writeups for $ctf_name challenges." >> "$event_path/README.md"
    echo "" >> "$event_path/README.md"
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
done

# Generate main index
echo "# CTF Writeups Collection" > "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "> Automatically synced from External CTF-Writeups Repository" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "## 🏆 CTF Events" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"

# List all CTF events
for event_dir in "$PORTFOLIO_DIR/ctf_app/assets/writeups"/*/; do
  if [ -d "$event_dir" ]; then
    event=$(basename "$event_dir")
    if [ -f "$event_dir/README.md" ]; then
      echo "- [$event](./$event/)" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
    fi
  fi
done

echo "" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "## 📊 Statistics" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"

# Add statistics
total_writeups=$(find "$PORTFOLIO_DIR/ctf_app/assets/writeups" -mindepth 1 -maxdepth 3 -name "*.md" -not -name "README.md" -not -name "index.md" -not -name "ctf-writeup-format.md" | wc -l)
total_ctfs=$(find "$PORTFOLIO_DIR/ctf_app/assets/writeups" -mindepth 1 -maxdepth 1 -type d | wc -l)

echo "- **Total CTF Events:** $total_ctfs" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "- **Total Writeups:** $total_writeups" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"
echo "- **Last Updated:** $(date -u '+%Y-%m-%d %H:%M UTC')" >> "$PORTFOLIO_DIR/ctf_app/assets/writeups/index.md"

echo ""
echo "📊 Sync Summary:"
echo "- CTF Events: $total_ctfs"
echo "- Total Writeups: $total_writeups"

# Copy writeups to the simpler site as well
if [ -d "$PORTFOLIO_DIR/ctf_app/assets/writeups" ]; then
  echo "📦 Copying writeups to simple CTF site..."
  cp -r "$PORTFOLIO_DIR/ctf_app/assets/writeups"/* "$PORTFOLIO_DIR/ctf_site/assets/writeups/"
  echo "✅ Writeups copied to ctf_site/assets/writeups/"
  
  # Ensure category redirection index.html files exist
  for category in web crypto forensics pwn rev misc osint; do
    if [ ! -f "$PORTFOLIO_DIR/ctf_site/$category/index.html" ]; then
      mkdir -p "$PORTFOLIO_DIR/ctf_site/$category"
      cat > "$PORTFOLIO_DIR/ctf_site/$category/index.html" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="0;url=/">
    <title>Redirecting...</title>
</head>
<body>
    <p>Redirecting to home page...</p>
    <script>
        window.location.href = '/';
    </script>
</body>
</html>
EOF
      echo "✅ Restored redirection page for $category"
    fi
  done
fi

echo "✅ Sync completed successfully!"
