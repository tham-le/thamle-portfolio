#!/bin/bash

# Quick local sync script to copy writeups to ctf_site
echo "🚀 Quick writeups sync..."

# Clean and recreate directories
rm -rf ctf_site/assets/writeups/*
mkdir -p ctf_site/assets/writeups
mkdir -p ctf_site/assets/images/ctf

# Enhanced Python script to copy and organize writeups + READMEs
python3 << 'EOF'
import os
import shutil
import json
from pathlib import Path

def sync_writeups():
    external_repo = "external-writeups"
    target_dir = "ctf_site/assets/writeups"
    
    writeups_data = []
    events_data = []
    
    # First, scan for CTF events (directories in external repo)
    for item in os.listdir(external_repo):
        event_path = os.path.join(external_repo, item)
        if os.path.isdir(event_path) and not item.startswith('.'):
            event_name = item
            
            # Look for event README
            event_readme_path = os.path.join(event_path, 'README.md')
            event_description = ""
            
            if os.path.exists(event_readme_path):
                try:
                    with open(event_readme_path, 'r', encoding='utf-8') as f:
                        event_description = f.read()
                    
                    # Copy event README to target
                    target_event_dir = os.path.join(target_dir, event_name)
                    os.makedirs(target_event_dir, exist_ok=True)
                    shutil.copy2(event_readme_path, os.path.join(target_event_dir, 'README.md'))
                    print(f"✅ Copied event README: {event_name}/README.md")
                except Exception as e:
                    print(f"⚠️ Error reading {event_readme_path}: {e}")
            
            # Add event data
            event_data = {
                'name': event_name,
                'description': event_description,
                'readme_path': f"{event_name}/README.md" if os.path.exists(event_readme_path) else None,
                'writeups': []
            }
            
            # Now scan for writeups in this event
            for root, dirs, files in os.walk(event_path):
                # Skip hidden directories and git
                dirs[:] = [d for d in dirs if not d.startswith('.')]
                
                for file in files:
                    if not file.endswith('.md'):
                        continue
                        
                    filepath = os.path.join(root, file)
                    rel_path = os.path.relpath(filepath, event_path)
                    
                    # Skip the main event README (we handled it above)
                    if rel_path == 'README.md':
                        continue
                        
                    path_parts = rel_path.split(os.sep)
                    
                    # Parse structure: Look for standard categories
                    category = 'misc'  # default
                    challenge = file.replace('.md', '').replace('wu', 'writeup')
                    
                    # Determine category and challenge from path
                    if len(path_parts) >= 2:
                        first_part = path_parts[0].lower().replace('_', '').replace(' ', '').replace('-', '')
                        
                        # Map category names
                        category_map = {
                            'webexploitation': 'web',
                            'web': 'web',
                            'binaryexploitation': 'pwn',
                            'binary': 'pwn',
                            'pwn': 'pwn',
                            'opensourceintelligence': 'osint',
                            'osint': 'osint',
                            'reverseengineering': 'rev',
                            'reverse': 'rev',
                            'rev': 'rev',
                            'digitalforensics': 'forensics',
                            'forensics': 'forensics',
                            'cryptography': 'crypto',
                            'crypto': 'crypto',
                            'miscellaneous': 'misc',
                            'misc': 'misc'
                        }
                        
                        # Check if first part is a category
                        if first_part in category_map:
                            category = category_map[first_part]
                            if len(path_parts) == 2:  # Category/writeup.md
                                challenge = file.replace('.md', '')
                            else:  # Category/Challenge/writeup.md
                                challenge = path_parts[1]
                        else:
                            # Check if it's a direct challenge folder
                            challenge = path_parts[0]
                            # Try to infer category from challenge name or content
                            challenge_lower = challenge.lower()
                            if 'web' in challenge_lower or 'sql' in challenge_lower:
                                category = 'web'
                            elif 'crypto' in challenge_lower or 'cipher' in challenge_lower:
                                category = 'crypto'
                            elif 'pwn' in challenge_lower or 'binary' in challenge_lower or 'overflow' in challenge_lower:
                                category = 'pwn'
                            elif 'forensic' in challenge_lower or 'memory' in challenge_lower:
                                category = 'forensics'
                            elif 'osint' in challenge_lower or 'bobby' in challenge_lower:
                                category = 'osint'
                            elif 'rev' in challenge_lower or 'reverse' in challenge_lower:
                                category = 'rev'
                        
                        # Create target directory structure
                        target_path = os.path.join(target_dir, event_name, category, challenge)
                        os.makedirs(target_path, exist_ok=True)
                        
                        # Copy the writeup file
                        target_file = os.path.join(target_path, 'writeup.md')
                        shutil.copy2(filepath, target_file)
                        
                        # Copy any images in the same directory
                        source_dir = os.path.dirname(filepath)
                        for img_file in os.listdir(source_dir):
                            if img_file.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.svg')):
                                img_source = os.path.join(source_dir, img_file)
                                img_target = os.path.join(target_path, img_file)
                                shutil.copy2(img_source, img_target)
                                print(f"🖼️ Copied image: {event_name}/{category}/{challenge}/{img_file}")
                        
                        # Read and parse writeup for metadata
                        try:
                            with open(filepath, 'r', encoding='utf-8') as f:
                                content = f.read()
                            
                            # Parse frontmatter if exists
                            title = challenge
                            description = ""
                            difficulty = "Medium"
                            
                            if content.startswith('---'):
                                # Extract frontmatter
                                parts = content.split('---', 2)
                                if len(parts) >= 3:
                                    frontmatter = parts[1]
                                    content_body = parts[2]
                                    
                                    # Parse frontmatter
                                    for line in frontmatter.split('\n'):
                                        if line.startswith('title:'):
                                            title = line.split(':', 1)[1].strip().strip('"\'')
                                        elif line.startswith('difficulty:'):
                                            difficulty = line.split(':', 1)[1].strip().strip('"\'')
                                        elif line.startswith('category:'):
                                            front_category = line.split(':', 1)[1].strip().strip('"\'')
                                            if front_category in ['web', 'crypto', 'pwn', 'forensics', 'osint', 'rev', 'misc']:
                                                category = front_category
                                else:
                                    content_body = content
                            else:
                                content_body = content
                            
                            # Look for title in content if not found in frontmatter
                            if title == challenge:
                                lines = content_body.split('\n')
                                for line in lines[:10]:
                                    if line.startswith('# '):
                                        title = line[2:].strip()
                                        break
                                    elif line.startswith('## ') and 'writeup' in line.lower():
                                        title = line[3:].strip()
                                        break
                            
                            # Look for description (first substantial paragraph)
                            lines = content_body.split('\n')
                            for i, line in enumerate(lines[:30]):
                                stripped = line.strip()
                                if (stripped and 
                                    not stripped.startswith('#') and 
                                    not stripped.startswith('|') and 
                                    not stripped.startswith('```') and
                                    not stripped.startswith('---') and
                                    not stripped.lower().startswith('challenge') and
                                    len(stripped) > 30):
                                    description = stripped[:200] + ("..." if len(stripped) > 200 else "")
                                    break
                            
                            # Clean up title
                            title = title.replace('writeup', '').replace('Writeup', '').replace('Write-up', '').strip()
                            if not title:
                                title = challenge
                            
                            writeup_data = {
                                'title': title,
                                'ctf_event': event_name,
                                'category': category,
                                'challenge': challenge,
                                'description': description,
                                'difficulty': difficulty,
                                'path': f"{event_name}/{category}/{challenge}/writeup.md",
                                'date': '2025-01-01'  # Default date
                            }
                            
                            writeups_data.append(writeup_data)
                            event_data['writeups'].append(writeup_data)
                            print(f"✅ Synced: {event_name}/{category}/{challenge}")
                            
                        except Exception as e:
                            print(f"⚠️ Error processing {filepath}: {e}")
            
            events_data.append(event_data)
    
    # Save writeups index
    index_data = {
        'writeups': writeups_data,
        'events': events_data,
        'last_updated': '2025-06-25',
        'total_count': len(writeups_data),
        'events_count': len(events_data)
    }
    
    with open(os.path.join(target_dir, 'index.json'), 'w') as f:
        json.dump(index_data, f, indent=2)
    
    print(f"\n🎉 Synced {len(writeups_data)} writeups from {len(events_data)} events!")
    
    # Summary by event
    print("\n📊 Summary:")
    for event in events_data:
        categories = set(w['category'] for w in event['writeups'])
        readme_note = " (with README)" if event['readme_path'] else ""
        print(f"  🏆 {event['name']}: {len(event['writeups'])} writeups in {len(categories)} categories{readme_note}")

sync_writeups()
EOF

echo "✅ Enhanced sync completed!"
