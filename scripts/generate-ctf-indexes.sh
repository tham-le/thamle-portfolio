#!/bin/bash
# Generate _index.md files for CTF section from README.md files in the submodule
# This script should be run before building the Hugo site

set -e

CTF_DIR="content/ctf"

echo "Generating _index.md files for CTF section..."

# Generate main CTF _index.md
cat > "${CTF_DIR}/_index.md" << 'EOF'
---
title: "CTF Writeups"
description: "Capture The Flag competition writeups and cybersecurity challenge solutions"
layout: "list"
---

# CTF Writeups

Collection of my Capture The Flag (CTF) competition writeups organized by event. Each writeup documents my approach to solving various cybersecurity challenges.
EOF

echo "Created ${CTF_DIR}/_index.md"

# Generate _index.md for each CTF event directory
for event_dir in "${CTF_DIR}"/*/; do
  if [ -d "${event_dir}" ]; then
    event_name=$(basename "${event_dir}")
    readme_file="${event_dir}README.md"
    index_file="${event_dir}_index.md"

    if [ -f "${readme_file}" ]; then
      echo "Processing ${event_name}..."

      # Convert event name to lowercase and replace underscores with dashes for image path
      image_slug=$(echo "${event_name}" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
      image_path="/images/ctf/${image_slug}/event-banner.svg"

      # Create _index.md with frontmatter and content from README
      {
        echo "---"
        echo "title: \"${event_name}\""
        echo "description: \"CTF Event: ${event_name}\""
        echo "image: \"${image_path}\""
        echo "---"
        echo ""
        # Skip the first line (title) of README and include the rest
        tail -n +2 "${readme_file}"
      } > "${index_file}"

      echo "  Created ${index_file}"

      # Generate _index.md for category directories within this event
      for cat_dir in "${event_dir}"*/; do
        if [ -d "${cat_dir}" ]; then
          cat_name=$(basename "${cat_dir}")
          cat_index="${cat_dir}_index.md"

          # Create simple _index.md for category
          {
            echo "---"
            echo "title: \"${cat_name}\""
            echo "---"
          } > "${cat_index}"

          echo "    Created ${cat_index}"
        fi
      done
    fi
  fi
done

echo "Done! Generated all _index.md files for CTF section."
