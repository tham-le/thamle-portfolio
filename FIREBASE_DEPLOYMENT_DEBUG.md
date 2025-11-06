# Firebase Deployment Debugging

## Current Issue

The entire site (https://thamle.live) is returning **403 Forbidden** "Access denied", which indicates the Firebase deployment failed or is misconfigured.

## Diagnosis Steps

### 1. Check GitHub Actions Workflow

Go to: https://github.com/tham-le/thamle-portfolio/actions

Look at the most recent "Sync, Build, and Deploy Portfolio" workflow run and check:

#### Hugo Build Step ✅
```
Start building sites …
Pages: 140
Static files: 236  ← This includes your notes!
Total in 280 ms
✅ Hugo build successful!
```

#### Firebase Deploy Step ❓
Look for a step named "Deploy to Firebase" - check if it:
- ✅ Completed successfully
- ❌ Failed with an error
- ⚠️ Was skipped

**Common Firebase deployment errors:**
```
Error: HTTP Error: 403, The caller does not have permission
→ FIREBASE_SERVICE_ACCOUNT secret is invalid or expired

Error: Project ID not found
→ FIREBASE_PROJECT_ID secret is missing or incorrect

Error: Failed to get Firebase project
→ Firebase project doesn't exist or is disabled
```

### 2. Verify Firebase Secrets

In your GitHub repository, check: **Settings** → **Secrets and variables** → **Actions**

Required secrets:
- `FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO` - Firebase service account JSON
- `FIREBASE_PROJECT_ID` - Your Firebase project ID (should be: `thamle-portfolio`)
- `GITHUB_TOKEN` - Automatically provided by GitHub

### 3. Check Firebase Console

Go to: https://console.firebase.google.com/

1. **Select your project**: `thamle-portfolio`
2. **Check Hosting status**:
   - Go to **Hosting** in left menu
   - Check if site is deployed
   - Look at deployment history
   - Check if latest deployment succeeded

3. **Verify domain**:
   - Click on your site
   - Check if `thamle.live` is properly connected
   - Look for any error messages

### 4. Test Local Build

To verify the build is correct locally:

```bash
# In thamle-portfolio repository
hugo --minify

# Check if notes were copied
ls -la public/notes/
find public/notes -name "*.html" | wc -l
# Should show 206 HTML files

# Check main pages
ls -la public/
# Should see index.html, about/, projects/, etc.
```

If local build works but deployment fails, it's a Firebase credentials/permissions issue.

### 5. Manual Firebase Deploy (if needed)

If GitHub Actions deployment is broken, you can deploy manually:

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Set project
firebase use thamle-portfolio

# Deploy
firebase deploy --only hosting
```

## Most Likely Causes

### Cause 1: Firebase Service Account Expired/Invalid ⚠️

**Symptoms**:
- Hugo builds successfully
- Firebase deploy step fails with 403 error
- Entire site shows "Access denied"

**Solution**:
1. Go to https://console.firebase.google.com/
2. Select `thamle-portfolio` project
3. Go to **Project Settings** → **Service accounts**
4. Click **Generate new private key**
5. Copy the entire JSON content
6. Go to GitHub → Your repo → **Settings** → **Secrets** → **Actions**
7. Update `FIREBASE_SERVICE_ACCOUNT_THAMLE_PORTFOLIO` with the new JSON

### Cause 2: Firebase Hosting Disabled

**Symptoms**:
- Site was working, now returns 403
- Firebase console shows hosting is paused/disabled

**Solution**:
1. Go to Firebase Console
2. Check Hosting section
3. Re-enable if disabled

### Cause 3: Deployment Hasn't Run Yet

**Symptoms**:
- Notes are in `static/notes/` in Git
- Hugo build shows 236 static files
- But site still shows old content or 403

**Solution**:
- Wait for GitHub Actions workflow to complete
- Check workflow status at: https://github.com/thamle/thamle-portfolio/actions
- Manually trigger if needed: Actions → Sync, Build, and Deploy → Run workflow

## Quick Check Command

Run this to see what the live site returns:

```bash
# Check main site
curl -I https://thamle.live/

# Check notes
curl -I https://thamle.live/notes/

# Check a specific note
curl -I https://thamle.live/notes/Architecture/README
```

**Expected (working)**:
```
HTTP/2 200
content-type: text/html
```

**Current (broken)**:
```
HTTP/2 403
content-type: text/plain
```

## Next Steps

1. **Check the Firebase deployment step** in GitHub Actions logs
2. **Look for the specific error message**
3. **Share the error** so we can fix it

The notes are ready (206 HTML files), Hugo is building correctly (236 static files), but Firebase deployment is failing.

---

## Confirmation Checklist

- [ ] Hugo build completed successfully (236 static files)
- [ ] Firebase deployment step completed without errors
- [ ] Firebase console shows successful deployment
- [ ] `https://thamle.live/` returns 200 OK (not 403)
- [ ] `https://thamle.live/notes/` returns 200 OK
- [ ] Notes are accessible and navigable

Once all checked, your notes will be live! 🎉
