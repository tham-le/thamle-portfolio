#!/bin/bash
set -e

echo "🔧 Fixing Quartz HTML paths for /notes/ subdirectory..."

NOTES_DIR="static/notes"

if [ ! -d "$NOTES_DIR" ]; then
  echo "⚠️  $NOTES_DIR directory not found, skipping"
  exit 0
fi

# Count HTML files
HTML_COUNT=$(find "$NOTES_DIR" -name "*.html" | wc -l)
echo "📄 Found $HTML_COUNT HTML files in $NOTES_DIR"

if [ "$HTML_COUNT" -eq 0 ]; then
  echo "⚠️  No HTML files found, skipping"
  exit 0
fi

# Fix paths in all HTML files
FIXED_BASE=0
FIXED_LINKS=0

for html_file in $(find "$NOTES_DIR" -name "*.html"); do
  MODIFIED=0

  # Add base tag for CSS/JS assets if not present
  if ! grep -q '<base href=' "$html_file"; then
    if grep -q '<head>' "$html_file"; then
      sed -i 's|<head>|<head>\n  <base href="/notes/">|' "$html_file"
      FIXED_BASE=$((FIXED_BASE + 1))
      MODIFIED=1
    fi
  fi

  # Fix relative links in href attributes for Quartz SPA navigation
  # Convert href="./ to href="/notes/
  if grep -q 'href="./' "$html_file"; then
    sed -i 's|href="\./|href="/notes/|g' "$html_file"
    FIXED_LINKS=$((FIXED_LINKS + 1))
    MODIFIED=1
  fi

  # Also fix href='./  (single quotes)
  if grep -q "href='./" "$html_file"; then
    sed -i "s|href='\\./|href='/notes/|g" "$html_file"
    MODIFIED=1
  fi
done

echo "✅ Fixed paths in HTML files:"
echo "   - Base tags added: $FIXED_BASE files"
echo "   - Link paths fixed: $FIXED_LINKS files"
echo "   Assets and navigation will now work from /notes/ subdirectory"
