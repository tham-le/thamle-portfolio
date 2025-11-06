# Setup Notes Subdomain (notes.thamle.live)

## Overview
Moving Quartz notes from `thamle.live/notes/` to `notes.thamle.live` subdomain.

**Benefits:**
- No path conversion needed - Quartz works out of the box
- Independent deployment from main portfolio
- Cleaner separation of concerns
- Simpler maintenance

---

## Step 1: Create Firebase Hosting Site

You need to create a new site in your Firebase project for the subdomain.

### Option A: Using Firebase CLI (Recommended)

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# List your current sites
firebase hosting:sites:list

# Create new site for notes subdomain
firebase hosting:sites:create notes-thamle

# This creates a site that can be accessed at:
# - notes-thamle.web.app (default)
# - notes.thamle.live (after custom domain setup)
```

### Option B: Using Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (thamle-portfolio)
3. Go to **Hosting** in the left sidebar
4. Click **Add another site**
5. Enter site ID: `notes-thamle` (or similar)
6. Click **Add site**

---

## Step 2: Update Firebase Configuration

We'll use Firebase's multi-site hosting feature to deploy both sites from one repo.

**Update `firebase.json`:**

```json
{
  "hosting": [
    {
      "site": "thamle-portfolio",
      "public": "public",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ],
      "cleanUrls": true,
      "trailingSlash": false,
      "headers": [
        {
          "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "**/*.@(css|js)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        }
      ]
    },
    {
      "site": "notes-thamle",
      "public": "static/notes",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ],
      "cleanUrls": true,
      "trailingSlash": false,
      "headers": [
        {
          "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "**/*.@(css|js)",
          "headers": [{"key": "Cache-Control", "value": "max-age=31536000"}]
        },
        {
          "source": "index.html",
          "headers": [{"key": "Cache-Control", "value": "public, max-age=300, must-revalidate"}]
        },
        {
          "source": "**/*.html",
          "headers": [{"key": "Cache-Control", "value": "public, max-age=3600, must-revalidate"}]
        }
      ]
    }
  ]
}
```

---

## Step 3: Configure Custom Domain in Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Hosting**
4. Find the **notes-thamle** site
5. Click **Add custom domain**
6. Enter: `notes.thamle.live`
7. Firebase will provide DNS records to add

---

## Step 4: Update DNS Records

Add these DNS records to your domain provider (where you manage thamle.live):

**Type: A Record**
- Name/Host: `notes`
- Value: Firebase will provide IP addresses (likely same as main site)
- TTL: 3600 or Auto

**OR Type: CNAME Record** (if Firebase provides CNAME instead)
- Name/Host: `notes`
- Value: (Firebase will provide, e.g., `notes-thamle.web.app`)
- TTL: 3600 or Auto

**Note:** DNS propagation can take up to 48 hours but usually completes within 1-2 hours.

---

## Step 5: Update CI/CD Workflow

The workflow needs to deploy to both sites. Update `.github/workflows/sync-and-deploy.yml`:

```yaml
- name: Deploy to Firebase
  uses: FirebaseExtended/action-hosting-deploy@v0
  with:
    repoToken: '${{ secrets.GITHUB_TOKEN }}'
    firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO }}'
    projectId: '${{ secrets.FIREBASE_PROJECT_ID }}'
    channelId: live
    target: thamle-portfolio  # Main site

- name: Deploy Notes to Subdomain
  uses: FirebaseExtended/action-hosting-deploy@v0
  with:
    repoToken: '${{ secrets.GITHUB_TOKEN }}'
    firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO }}'
    projectId: '${{ secrets.FIREBASE_PROJECT_ID }}'
    channelId: live
    target: notes-thamle  # Notes subdomain
```

---

## Step 6: Update my-notes Repository

In your `my-notes` repository, update the Quartz config:

**Update `quartz.config.ts`:**

```typescript
baseUrl: "notes.thamle.live",  // Changed from "thamle.live/notes"
```

Then rebuild and deploy:

```bash
npx quartz build
git add .
git commit -m "feat: Update baseUrl for subdomain deployment"
git push
```

---

## Step 7: Remove Path Fixing Script (Optional)

Since Quartz will now work correctly with the subdomain, you can:

1. Remove or simplify `scripts/fix-notes-paths.sh`
2. Remove the script step from CI workflow
3. Keep it as backup if you want to maintain both deployments temporarily

---

## Testing

1. **Test default Firebase URL first:**
   - `https://notes-thamle.web.app`

2. **After DNS propagation, test custom domain:**
   - `https://notes.thamle.live`

3. **Verify:**
   - CSS/JS loads correctly ✅
   - Navigation works (links stay within notes.thamle.live) ✅
   - All pages accessible ✅

---

## Rollback Plan

If something goes wrong:
1. Keep the current `/notes/` setup working
2. Test subdomain separately
3. Switch DNS only when subdomain is confirmed working
4. Can easily revert DNS records if needed

---

## Questions?

- **Do I need a separate Firebase project?** No, use multi-site hosting in same project
- **Will this cost more?** No, still within free tier unless you exceed bandwidth
- **Can I have both /notes/ and subdomain?** Yes, temporarily during migration
- **What about the main portfolio?** Unchanged, still at thamle.live

