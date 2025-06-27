#!/usr/bin/env python3
"""
Scans the content/ctf directory and creates _index.md files for Hugo.

This script intelligently uses README.md files as the content for section
pages and automatically links to a 'banner' image if one is present.
"""

import os
from pathlib import Path

def strip_frontmatter(content: str) -> str:
    """Removes Hugo frontmatter from a string if it exists."""
    content = content.lstrip()
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) > 2:
            return parts[2].lstrip()
    return content

def get_folder_info(path: Path, ctf_base_path: Path) -> tuple[str, str]:
    """Generates a title and description from a folder path."""
    folder_name = path.name.replace('_', ' ').replace('-', ' ').title()
    
    if path == ctf_base_path:
        return "CTF Writeups", "A collection of solutions and notes from various Capture The Flag competitions."
    
    if path.parent == ctf_base_path:
        return folder_name, f"Writeups for challenges from the {folder_name} event."
    else:
        parent_name = path.parent.name.replace('_', ' ').replace('-', ' ').title()
        return folder_name, f"{folder_name} challenges from the {parent_name} event."

def create_hugo_index(path: Path, ctf_base_path: Path):
    """
    Creates an _index.md file, using a local README.md for its content
    and a banner.* image for its frontmatter image.
    """
    if not (any(p.is_dir() for p in path.iterdir()) or any(p.suffix == '.md' for p in path.iterdir())):
        return

    index_file = path / '_index.md'
    readme_path = path / 'README.md'
    
    title, description = get_folder_info(path, ctf_base_path)
    body_content = ""
    
    frontmatter = {
        "title": title,
        "description": description
    }

    if readme_path.exists():
        with open(readme_path, 'r', encoding='utf-8') as f:
            readme_content = f.read()
            body_content = strip_frontmatter(readme_content)

    banner_options = ['banner.png', 'banner.jpg', 'banner.jpeg', 'banner.svg', 'banner.gif']
    for banner in banner_options:
        if (path / banner).exists():
            frontmatter['image'] = banner
            break

    # Build the final file content
    fm_lines = ["---"]
    for key, value in frontmatter.items():
        fm_lines.append(f'{key}: "{value}"')
    fm_lines.append("---")
    
    final_content = "\n".join(fm_lines) + "\n\n" + body_content

    try:
        with open(index_file, 'w', encoding='utf-8') as f:
            f.write(final_content)
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

    # Process all directories, starting from the root
    for dirpath, _, _ in os.walk(ctf_path):
        current_path = Path(dirpath)
        if ".git" in current_path.parts:
            continue
        create_hugo_index(current_path, ctf_path)

    print("Preparation complete.")

if __name__ == '__main__':
    main() 