#!/usr/bin/env python3
"""
Generate index.json for the CTF writeups repository
This creates the structure expected by the dynamic CTF site
"""

import os
import json
import re
from pathlib import Path
from datetime import datetime

def extract_frontmatter(content):
    """Extract frontmatter from markdown content"""
    frontmatter = {}
    
    if content.startswith('---\n'):
        end_marker = content.find('\n---\n', 4)
        if end_marker != -1:
            frontmatter_content = content[4:end_marker]
            for line in frontmatter_content.strip().split('\n'):
                if ':' in line:
                    key, value = line.split(':', 1)
                    frontmatter[key.strip()] = value.strip().strip('"\'')
    
    return frontmatter

def create_slug(text):
    """Create URL-friendly slug from text"""
    return re.sub(r'[^a-zA-Z0-9-]', '-', text.lower()).strip('-')

def scan_writeups():
    """Scan the repository for writeups and organize by events"""
    base_path = Path(__file__).parent
    events = {}
    
    # Scan all directories (each represents an event/CTF)
    for event_dir in base_path.iterdir():
        if not event_dir.is_dir() or event_dir.name.startswith('.'):
            continue
            
        event_name = event_dir.name.replace('_', ' ').replace('-', ' ')
        events[event_name] = {
            'name': event_name,
            'slug': create_slug(event_name),
            'writeups': [],
            'date': None
        }
        
        # Look for README.md in event directory
        readme_path = event_dir / 'README.md'
        if readme_path.exists():
            events[event_name]['readme_path'] = str(readme_path.relative_to(base_path))
        
        # Recursively find all writeup.md files
        for writeup_file in event_dir.rglob('writeup.md'):
            try:
                with open(writeup_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                frontmatter = extract_frontmatter(content)
                
                # Determine category from path
                path_parts = writeup_file.parts
                category = 'misc'  # default
                if len(path_parts) > 2:
                    potential_category = path_parts[-2].lower()
                    if potential_category in ['web', 'crypto', 'forensics', 'pwn', 'osint', 'rev', 'misc']:
                        category = potential_category
                
                # Extract challenge name from path
                challenge_name = path_parts[-2] if len(path_parts) > 2 else 'Unknown'
                
                writeup = {
                    'title': frontmatter.get('title', challenge_name),
                    'category': frontmatter.get('category', category),
                    'difficulty': frontmatter.get('difficulty', 'Unknown'),
                    'description': frontmatter.get('description', ''),
                    'path': str(writeup_file.relative_to(base_path)),
                    'challenge': challenge_name
                }
                
                events[event_name]['writeups'].append(writeup)
                
                # Update event date if found in frontmatter
                if frontmatter.get('date') and not events[event_name]['date']:
                    events[event_name]['date'] = frontmatter.get('date')
                    
            except Exception as e:
                print(f"Error processing {writeup_file}: {e}")
                continue
    
    # Convert to list and sort
    events_list = []
    for event in events.values():
        if event['writeups']:  # Only include events with writeups
            # Sort writeups by category and title
            event['writeups'].sort(key=lambda x: (x['category'], x['title']))
            events_list.append(event)
    
    # Sort events by name
    events_list.sort(key=lambda x: x['name'])
    
    return events_list

def main():
    """Generate the index.json file"""
    events = scan_writeups()
    
    index_data = {
        'generated_at': datetime.now().isoformat(),
        'events': events,
        'total_events': len(events),
        'total_writeups': sum(len(event['writeups']) for event in events)
    }
    
    # Write to index.json
    output_path = Path(__file__).parent / 'index.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(index_data, f, indent=2, ensure_ascii=False)
    
    print(f"Generated index.json with {len(events)} events and {index_data['total_writeups']} writeups")

if __name__ == '__main__':
    main()
