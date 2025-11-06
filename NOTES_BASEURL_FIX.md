# Fix for Notes Styling Issue

## The Problem

The browser is loading assets from the wrong location:
- ❌ Trying: `https://thamle.live/index.css`
- ✅ Should be: `https://thamle.live/notes/index.css`

This happens because Quartz is generating relative paths (`./index.css`) without a `<base>` tag.

## Solution: Update my-notes Repository

### Step 1: Update quartz.config.ts in my-notes repo

Change the `baseUrl` to include the protocol:

**Before:**
```typescript
baseUrl: "thamle.live/notes",
```

**After:**
```typescript
baseUrl: "thamle.live",
```

Wait, actually try this instead - add a pathPrefix:

**Better solution - use the full URL with protocol:**
```typescript
configuration: {
  pageTitle: "Tham Le's Notes",
  enableSPA: true,
  enablePopovers: true,
  analytics: {
    provider: "plausible",
  },
  locale: "en-US",
  baseUrl: "thamle.live",  // Changed from "thamle.live/notes"
  pathPrefix: "/notes",      // Add this line!
  ignorePatterns: ["private", "templates", ".obsidian"],
  // ... rest of config
```

### Step 2: Rebuild in my-notes repo

```bash
cd my-notes
npx quartz build
```

### Step 3: Check the output

After building, check `public/index.html` and verify it has either:

**Option A: Absolute paths**
```html
<link href="/notes/index.css" ...>
<script src="/notes/prescript.js">
```

**Option B: Base tag with relative paths**
```html
<head>
  <base href="/notes/">
  <link href="./index.css" ...>
```

### Step 4: Push to trigger deployment

```bash
git add .
git commit -m "fix: Update Quartz baseUrl to fix asset paths"
git push
```

The GitHub Action will rebuild and deploy, and the styling should work!

---

## Alternative Quick Fix (If Quartz doesn't support pathPrefix)

If Quartz doesn't have a `pathPrefix` option, you can manually add a `<base>` tag.

Create a file in your notes repo at `quartz/components/Head.tsx` or modify the existing one to include:

```html
<base href="/notes/" />
```

This tells the browser to resolve all relative URLs from `/notes/` instead of `/`.

---

## Why This Happened

Quartz generated HTML with relative paths designed to work at the root (`/`) but your notes are deployed at a subdirectory (`/notes/`). Without a `<base>` tag or absolute paths, the browser resolves `./index.css` relative to the current location incorrectly.

---

## Verification

After the fix is deployed, check:
1. View page source of https://thamle.live/notes/
2. Look for either:
   - `<base href="/notes/">` in the `<head>`
   - OR `<link href="/notes/index.css">` (absolute path)

Either way will fix the issue!
