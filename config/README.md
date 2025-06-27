# Portfolio Configuration Files

This directory contains all configuration files for the portfolio website. All settings are centralized here for easy management.

## Configuration Files

### 1. `featured-articles.json`
Controls the featured articles section on the homepage. **The featured section is now dynamically generated** from this configuration file.

**Structure:**
```json
{
  "title": "Section title",
  "description": "Optional section description",
  "articles": [
    {
      "title": "Article title",
      "emoji": "🎯",
      "url": "/path/to/article/",
      "description": "Article description",
      "category": "Category name",
      "featured": true/false
    }
  ],
  "settings": {
    "max_featured": 4,
    "show_category": true,
    "show_emoji": true,
    "layout": "grid"
  }
}
```

**Settings:**
- `max_featured`: Maximum number of featured articles to display
- `show_category`: Whether to show category labels
- `show_emoji`: Whether to show emojis in titles
- `layout`: Layout style (currently supports "grid")

**Dynamic Generation:**
The featured section is automatically generated from this JSON file when Hugo builds the site. No manual editing of `_index.md` is required.

**Usage:**
```bash
# View current configuration
./scripts/update-featured.sh list

# Toggle featured status of articles
./scripts/update-featured.sh toggle

# Rebuild site after changes
./scripts/update-featured.sh rebuild
```

### 2. `projects-config.json`
Controls which projects are synced and displayed in the projects section.

**Structure:**
```json
{
  "featured_projects": [
    {
      "name": "repository-name",
      "owner": "github-username",
      "custom_description": "Optional custom description",
      "priority": 1,
      "featured": true
    }
  ],
  "settings": {
    "max_readme_lines": 30,
    "escape_code_blocks": true,
    "sync_images": true
  }
}
```

**Settings:**
- `max_readme_lines`: Maximum lines from README to include
- `escape_code_blocks`: Whether to escape code blocks in README
- `sync_images`: Whether to sync project images

**Usage:**
```bash
# Sync projects from GitHub
cd scripts
./sync-projects.sh
```

## Management Scripts

### Featured Articles Management
```bash
# View current featured articles configuration
./scripts/update-featured.sh list

# Interactively toggle featured status
./scripts/update-featured.sh toggle

# Rebuild site after configuration changes
./scripts/update-featured.sh rebuild

# Edit configuration directly
nano config/featured-articles.json
```

### Projects Management
```bash
# Sync projects from GitHub
./scripts/sync-projects.sh

# Edit projects config
nano config/projects-config.json
```

### CTF Writeups Management
```bash
# Sync CTF writeups
./scripts/sync-writeups.sh
```

### Complete Site Sync
```bash
# Run all sync operations
./scripts/sync-all.sh
```

## Configuration Examples

### Adding a New Featured Article
1. Edit `config/featured-articles.json`
2. Add new article to the `articles` array:
```json
{
  "title": "New Project",
  "emoji": "🚀",
  "url": "/projects/new-project/",
  "description": "Description of the new project",
  "category": "Web Development",
  "featured": true
}
```
3. The featured section will automatically update on next Hugo build

### Toggling Featured Status
```bash
# Use interactive script
./scripts/update-featured.sh toggle

# Or edit JSON directly
nano config/featured-articles.json
```

### Adding a New Project
1. Edit `config/projects-config.json`
2. Add new project to `featured_projects`:
```json
{
  "name": "new-repo",
  "owner": "your-username",
  "custom_description": "Custom description override",
  "priority": 5,
  "featured": true
}
```
3. Run `./scripts/sync-projects.sh`

### Changing Featured Articles Limit
1. Edit `config/featured-articles.json`
2. Change `settings.max_featured` to desired number
3. Featured section will automatically respect the new limit

## File Organization

```
config/
├── README.md                 # This documentation
├── featured-articles.json    # Homepage featured articles
└── projects-config.json      # GitHub projects to sync

scripts/
├── update-featured.sh            # Manage featured articles
├── sync-projects.sh              # Sync GitHub projects
├── sync-writeups.sh              # Sync CTF writeups
└── sync-all.sh                   # Run all sync operations
```

## Best Practices

1. **Always validate JSON** before committing changes
2. **Use the interactive scripts** for safer configuration changes
3. **Keep descriptions concise** (2-3 sentences max)
4. **Use consistent emoji themes** for visual coherence
5. **Order by priority** in featured articles
6. **Backup configs** before major changes

## Troubleshooting

### JSON Validation Error
```bash
# Check JSON syntax
jq empty config/featured-articles.json
jq empty config/projects-config.json

# Or use the management script
./scripts/update-featured.sh list
```

### Script Permissions
```bash
# Make scripts executable
chmod +x scripts/*.sh
```

### Missing Dependencies
```bash
# Install jq (required for JSON processing)
sudo apt-get install jq
```

### Featured Section Not Updating
1. Check JSON syntax: `jq empty config/featured-articles.json`
2. Verify Hugo can read the file: `hugo server -D`
3. Clear Hugo cache: `rm -rf resources/_gen`

## Integration with Hugo

The configuration system integrates with Hugo's build process:

1. **Configuration**: JSON files define content structure
2. **Dynamic Generation**: Hugo reads JSON and generates HTML
3. **Build**: Hugo processes updated content
4. **Deploy**: Generated site includes latest config

**Key Features:**
- **No hardcoded content** in markdown files
- **Dynamic featured section** generated from JSON
- **Easy configuration management** with interactive scripts
- **Automatic updates** on Hugo build

All changes to the configuration files are automatically reflected in the website when Hugo rebuilds the site. 