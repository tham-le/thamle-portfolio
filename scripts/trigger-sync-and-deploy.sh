#!/bin/bash

# 🚀 Trigger CTF Site Sync & Deploy
# This script triggers both sync and deployment workflows

set -e

echo "🔄 Triggering CTF writeups sync and deployment..."

# Update sync trigger to trigger the sync workflow
echo "📝 Triggering sync workflow..."
echo "Sync triggered on $(date)" > sync-trigger.md
git add sync-trigger.md
git commit -m "🔄 Trigger CTF writeups sync"

# The commit to sync-trigger.md will trigger the sync workflow
# After sync completes, we can trigger deployment

echo "✅ Sync workflow triggered!"
echo "ℹ️  Monitor progress at: https://github.com/tham-le/thamle-portfolio/actions"
echo ""
echo "📋 Next steps:"
echo "1. Wait for sync workflow to complete (updates content)"
echo "2. Manually trigger deploy workflow or push changes to ctf_site/"
echo "3. Check deployment at https://ctf.thamle.live/"
echo ""
echo "🚀 To trigger deployment after sync:"
echo "   gh workflow run 'deploy-ctf-site.yml'"
