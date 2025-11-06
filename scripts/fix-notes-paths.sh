#!/bin/bash
set -e

echo "🔧 Fixing Quartz HTML base paths..."

NOTES_DIR="static/notes"

if [ ! -d "$NOTES_DIR" ]; then
  echo "⚠️  $NOTES_DIR directory not found, skipping base tag injection"
  exit 0
fi

# Count HTML files
HTML_COUNT=$(find "$NOTES_DIR" -name "*.html" | wc -l)
echo "📄 Found $HTML_COUNT HTML files in $NOTES_DIR"

if [ "$HTML_COUNT" -eq 0 ]; then
  echo "⚠️  No HTML files found, skipping"
  exit 0
fi

# Add base tag to all HTML files that don't already have one
FIXED=0
for html_file in $(find "$NOTES_DIR" -name "*.html"); do
  # Check if file already has a base tag
  if grep -q '<base href=' "$html_file"; then
    continue
  fi

  # Check if file has a <head> tag
  if ! grep -q '<head>' "$html_file"; then
    echo "⚠️  Skipping $html_file - no <head> tag found"
    continue
  fi

  # Add base tag after opening <head> tag
  sed -i 's|<head>|<head>\n  <base href="/notes/">|' "$html_file"
  FIXED=$((FIXED + 1))
done

echo "✅ Fixed $FIXED HTML files with base tag"
echo "   Assets will now load from /notes/ subdirectory"
