#!/usr/bin/env python3
"""
Scans the content/ctf directory and creates the necessary _index.md files
for Hugo to build the section and taxonomy list pages correctly.

This script should be run before building the Hugo site.
The generated _index.md files should be ignored by Git.
"""

import os
from pathlib import Path

def get_folder_info(path, ctf_base_path):
    """Generate a title and description from a folder path."""
    folder_name = path.name.replace('_', ' ').replace('-', ' ')
    title = folder_name.title()
    
    # Check if it's an event folder (e.g., content/ctf/IrisCTF)
    if path.parent == ctf_base_path:
        description = f"Writeups for challenges from the {title} event."
    # It's a category folder (e.g., content/ctf/IrisCTF/Forensics)
    else:
        parent_name = path.parent.name.replace('_', ' ').replace('-', ' ').title()
        description = f"{title} challenges from the {parent_name} event."
        
    return title, description

def create_hugo_index(path, ctf_base_path):
    """Create an _index.md file in the given path."""
    index_file = path / '_index.md'
    title, description = get_folder_info(path, ctf_base_path)
    
    content = f"""---
title: "{title}"
description: "{description}"
---
"""
    try:
        with open(index_file, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Created index for: {path.relative_to(ctf_base_path)}")
    except IOError as e:
        print(f"Error creating file {index_file}: {e}")


def main():
    """Main function to scan directories and create index files."""
    base_path = Path(__file__).parent.parent
    ctf_path = base_path / 'content' / 'ctf'

    if not ctf_path.is_dir():
        print(f"Error: Directory not found at {ctf_path}")
        return

    print("Starting Hugo preparation for CTF content...")

    # First, create an index for the top-level ctf directory itself
    create_hugo_index(ctf_path, ctf_path)

    # Iterate through all subdirectories of content/ctf
    for path in ctf_path.rglob('*'):
        if path.is_dir() and not path.name.startswith('.'):
            # Check if directory contains markdown files or other directories
            has_content = any(p.is_dir() for p in path.iterdir()) or \
                          any(p.suffix == '.md' for p in path.iterdir())

            if has_content:
                create_hugo_index(path, ctf_path)

    print("Preparation complete.")

if __name__ == '__main__':
    main() 