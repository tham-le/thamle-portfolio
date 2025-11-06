#!/bin/bash
set -e

echo "=================================================="
echo "Setting up notes.thamle.live subdomain"
echo "=================================================="
echo ""

# Step 1: Check if Firebase CLI is installed
echo "Step 1: Checking Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found."
    echo "   Install it with: npm install -g firebase-tools"
    echo ""
    read -p "Do you want to install it now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g firebase-tools
    else
        echo "Please install Firebase CLI and run this script again."
        exit 1
    fi
fi
echo "✅ Firebase CLI is installed"
echo ""

# Step 2: Login to Firebase
echo "Step 2: Logging in to Firebase..."
firebase login
echo ""

# Step 3: List current sites
echo "Step 3: Listing current Firebase Hosting sites..."
echo ""
firebase hosting:sites:list
echo ""

# Step 4: Ask if they want to create the new site
echo "Step 4: Creating new site for notes subdomain..."
echo ""
read -p "Enter the site ID for notes (default: notes-thamle): " SITE_ID
SITE_ID=${SITE_ID:-notes-thamle}
echo ""
echo "Creating site with ID: $SITE_ID"

firebase hosting:sites:create "$SITE_ID"
echo ""
echo "✅ Site created!"
echo ""

# Step 5: Update configuration files
echo "Step 5: Updating configuration files..."
echo ""

# Check if backup exists
if [ ! -f "firebase.json.backup" ]; then
    echo "Creating backup of firebase.json..."
    cp firebase.json firebase.json.backup
    echo "✅ Backup created: firebase.json.backup"
fi

# Update firebase.json
echo "Replacing firebase.json with multi-site configuration..."
if [ -f "firebase.json.subdomain" ]; then
    # Update the site ID in the template
    sed "s/notes-thamle/$SITE_ID/g" firebase.json.subdomain > firebase.json.tmp
    mv firebase.json.tmp firebase.json
    echo "✅ firebase.json updated"
else
    echo "❌ firebase.json.subdomain template not found"
    exit 1
fi

# Update workflow
echo "Replacing workflow with multi-site deployment..."
if [ -f ".github/workflows/sync-and-deploy.yml.subdomain" ]; then
    cp .github/workflows/sync-and-deploy.yml .github/workflows/sync-and-deploy.yml.backup
    sed "s/notes-thamle/$SITE_ID/g" .github/workflows/sync-and-deploy.yml.subdomain > .github/workflows/sync-and-deploy.yml
    echo "✅ Workflow updated"
else
    echo "❌ Workflow template not found"
    exit 1
fi

echo ""
echo "=================================================="
echo "✅ Configuration files updated!"
echo "=================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Add custom domain in Firebase Console:"
echo "   - Go to https://console.firebase.google.com/"
echo "   - Select your project"
echo "   - Go to Hosting > $SITE_ID site"
echo "   - Click 'Add custom domain'"
echo "   - Enter: notes.thamle.live"
echo "   - Follow the DNS instructions provided"
echo ""
echo "2. Update DNS records with your domain provider:"
echo "   - Add the A or CNAME records shown in Firebase Console"
echo "   - Wait for DNS propagation (up to 48 hours, usually 1-2 hours)"
echo ""
echo "3. Update my-notes repository:"
echo "   - Change baseUrl in quartz.config.ts to: \"notes.thamle.live\""
echo "   - Rebuild and redeploy: npx quartz build && git push"
echo ""
echo "4. Commit and push these changes:"
echo "   git add firebase.json .github/workflows/sync-and-deploy.yml"
echo "   git commit -m 'feat: Set up notes.thamle.live subdomain'"
echo "   git push origin main"
echo ""
echo "5. Test the deployment:"
echo "   - Check https://$SITE_ID.web.app (should work immediately)"
echo "   - Check https://notes.thamle.live (after DNS propagation)"
echo ""
echo "=================================================="
