#!/bin/bash

# Script to manage featured articles configuration
# Usage: ./update-featured.sh [list|toggle|rebuild]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_ROOT/config/featured-articles.json"

show_help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  list     - Show current featured articles"
    echo "  toggle   - Toggle featured status of an article"
    echo "  rebuild  - Rebuild the site after changes"
    echo "  help     - Show this help message"
    echo ""
    echo "Configuration file: $CONFIG_FILE"
}

list_featured() {
    echo "📋 Current Featured Articles Configuration:"
    echo "=========================================="
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Configuration file not found: $CONFIG_FILE"
        return 1
    fi
    
    # Extract title and description
    local title=$(jq -r '.title' "$CONFIG_FILE")
    local description=$(jq -r '.description' "$CONFIG_FILE")
    
    echo "Title: $title"
    echo "Description: $description"
    echo ""
    
    echo "Articles:"
    jq -r '.articles[] | "\(.emoji) \(.title) - Featured: \(.featured) (\(.category))"' "$CONFIG_FILE"
    
    echo ""
    echo "Settings:"
    jq -r '.settings | "Max Featured: \(.max_featured), Show Category: \(.show_category), Show Emoji: \(.show_emoji)"' "$CONFIG_FILE"
}

toggle_featured() {
    echo "🔄 Toggle Featured Status"
    echo "========================"
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "❌ Configuration file not found: $CONFIG_FILE"
        return 1
    fi
    
    echo "Available articles:"
    jq -r '.articles[] | "\(.title) - Currently: \(.featured)"' "$CONFIG_FILE" | nl -w2 -s'. '
    
    echo ""
    read -p "Enter the number of the article to toggle: " selection
    
    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
        echo "❌ Invalid selection. Please enter a number."
        return 1
    fi
    
    # Convert to 0-based index
    local index=$((selection - 1))
    
    # Toggle the featured status
    local temp_file=$(mktemp)
    jq ".articles[$index].featured = (.articles[$index].featured | not)" "$CONFIG_FILE" > "$temp_file"
    
    if [[ $? -eq 0 ]]; then
        mv "$temp_file" "$CONFIG_FILE"
        echo "✅ Successfully toggled featured status!"
        
        # Show the updated status
        local title=$(jq -r ".articles[$index].title" "$CONFIG_FILE")
        local featured=$(jq -r ".articles[$index].featured" "$CONFIG_FILE")
        echo "📝 $title is now: Featured = $featured"
    else
        echo "❌ Failed to update configuration"
        rm -f "$temp_file"
        return 1
    fi
}

rebuild_site() {
    echo "🔨 Rebuilding Site"
    echo "=================="
    
    if command -v hugo >/dev/null 2>&1; then
        cd "$PROJECT_ROOT"
        echo "Building site..."
        hugo --minify
        echo "✅ Site rebuilt successfully!"
    else
        echo "❌ Hugo not found. Please install Hugo to rebuild the site."
        return 1
    fi
}

# Main script logic
case "${1:-help}" in
    list)
        list_featured
        ;;
    toggle)
        toggle_featured
        ;;
    rebuild)
        rebuild_site
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 