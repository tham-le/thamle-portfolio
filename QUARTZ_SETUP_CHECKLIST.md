# Quartz Notes Integration - Setup Checklist

Use this checklist to track your setup progress.

## 📋 Pre-Setup

- [ ] Node.js 18+ installed (`node --version`)
- [ ] npm installed (`npm --version`)
- [ ] Git configured
- [ ] Firebase CLI installed (`firebase --version`)
- [ ] Both repositories cloned locally
- [ ] Portfolio repo builds successfully (`make build`)

## 🔧 Initial Setup

### In Portfolio Repository

- [ ] Read `README-QUARTZ-SETUP.md`
- [ ] Read `NOTES_DEPLOYMENT.md` (at least skim it)
- [ ] Note the location of template files
- [ ] Verify `firebase.json` has notes rewrite rules
- [ ] Verify `content/notes/_index.md` is updated
- [ ] Verify `Makefile` has notes commands

### In Notes Repository

- [ ] Run `./scripts/setup-quartz-integration.sh /path/to/notes` from portfolio
  - OR manually copy template files
- [ ] Verify `quartz.config.ts` exists in notes repo
- [ ] Verify `deploy-to-portfolio.sh` exists and is executable
- [ ] Verify `.github/workflows/deploy-notes.yml` exists
- [ ] Update paths in `deploy-to-portfolio.sh` if needed
- [ ] Run `npx quartz create` and choose "Empty Quartz"
- [ ] Create `.gitignore` for notes repo (ignore `public/` and `node_modules/`)

## 🧪 Local Testing

### Test Quartz Build

- [ ] Run `npx quartz build` in notes repo
- [ ] Verify `public/` directory created
- [ ] Verify `public/index.html` exists
- [ ] Run `npx quartz serve`
- [ ] Visit `http://localhost:8080`
- [ ] Verify notes render correctly
- [ ] Test wikilinks work [[Like This]]

### Test Manual Deployment

- [ ] Run `./deploy-to-portfolio.sh` in notes repo
- [ ] Verify success message shown
- [ ] Check portfolio repo: `ls -la public/notes/`
- [ ] Verify files copied correctly
- [ ] In portfolio: run `make notes-check`
- [ ] In portfolio: run `firebase serve`
- [ ] Visit `http://localhost:5000/notes/`
- [ ] Verify notes display correctly
- [ ] Check that styles load
- [ ] Test navigation works
- [ ] Test search works (if enabled)

## 🤖 GitHub Actions Setup (Optional)

### Create Personal Access Token

- [ ] Go to GitHub Settings → Developer settings → Personal access tokens
- [ ] Generate new token (classic)
- [ ] Name: `PORTFOLIO_DEPLOY_TOKEN`
- [ ] Scopes: ✅ `repo`, ✅ `workflow`
- [ ] Generate and copy token
- [ ] Store token securely (you won't see it again!)

### Configure Notes Repository

- [ ] Go to notes repo → Settings → Secrets and variables → Actions
- [ ] Add new repository secret
- [ ] Name: `PORTFOLIO_PAT`
- [ ] Value: Paste your token
- [ ] Save secret

### Test Automated Deployment

- [ ] Make a small change in notes repo
- [ ] Commit and push to main branch
- [ ] Go to Actions tab in notes repo
- [ ] Watch "Deploy Notes to Portfolio" workflow run
- [ ] Verify workflow completes successfully
- [ ] Check portfolio repo for new commit
- [ ] Verify notes updated in portfolio

## 🚀 Production Deployment

### First Deployment

- [ ] In notes repo: create/update some notes
- [ ] Mark notes with appropriate frontmatter
- [ ] Test locally: `npx quartz build && npx quartz serve`
- [ ] Verify everything looks good
- [ ] Run `./deploy-to-portfolio.sh`
- [ ] In portfolio: `make build`
- [ ] In portfolio: `firebase serve` (test locally)
- [ ] Test all routes work
- [ ] In portfolio: `firebase deploy`
- [ ] Visit `https://thamle.live/notes/`
- [ ] Verify notes are live!

### Verify Production

- [ ] Visit `https://thamle.live/notes/`
- [ ] Check notes load correctly
- [ ] Test wikilinks work
- [ ] Check styles render properly
- [ ] Test search functionality
- [ ] Test on mobile
- [ ] Check browser console for errors

## 📝 Documentation

- [ ] Add note to portfolio README about notes section
- [ ] Document your note-taking workflow
- [ ] Create example notes with proper frontmatter
- [ ] Document any custom Quartz configurations
- [ ] Note any gotchas or special considerations

## 🔄 Regular Workflow Verification

### Daily Use

- [ ] Write notes in Obsidian as usual
- [ ] Use wikilinks naturally
- [ ] Add frontmatter to new notes
- [ ] Commit and push to notes repo
- [ ] (If using GitHub Actions) Verify auto-deployment works
- [ ] (If manual) Run deploy script when ready
- [ ] Verify notes appear on site

### Troubleshooting

- [ ] Know how to check GitHub Actions logs
- [ ] Know how to run `make notes-check`
- [ ] Know how to test locally with `firebase serve`
- [ ] Have `NOTES_DEPLOYMENT.md` bookmarked
- [ ] Know how to regenerate GitHub token if expired

## 🎯 Success Metrics

You're fully set up when you can:

- [ ] Write a note in Obsidian
- [ ] Push to notes repo
- [ ] See it automatically deploy (or deploy manually)
- [ ] View it live at `thamle.live/notes/`
- [ ] Wikilinks work correctly
- [ ] Search works
- [ ] Mobile experience is good
- [ ] Can repeat this workflow easily

## 🛠️ Optional Enhancements

Consider adding:

- [ ] Custom Quartz theme matching portfolio colors
- [ ] Portfolio homepage link to notes section
- [ ] Notes section link back to portfolio
- [ ] RSS feed for notes
- [ ] Analytics for notes section
- [ ] Comments system (if desired)
- [ ] Newsletter integration
- [ ] Social sharing buttons

## 📅 Maintenance

Set reminders to:

- [ ] Check GitHub token expiration (every 6-12 months)
- [ ] Update Quartz when new version releases
- [ ] Review and update documentation quarterly
- [ ] Clean up old draft notes
- [ ] Optimize images in notes
- [ ] Check for broken wikilinks

## 🐛 Known Issues to Watch

- [ ] Hugo's `hugo` command clears `public/` - always deploy notes after Hugo
- [ ] Wikilinks are case-sensitive - match exact filenames
- [ ] Large images slow down site - optimize before committing
- [ ] GitHub Actions can fail silently - check logs regularly
- [ ] Firebase cache can cause stale content - hard refresh if needed

---

## Completion

- [ ] All critical items checked
- [ ] Notes deployed and live
- [ ] Workflow documented
- [ ] Team/yourself onboarded
- [ ] Backup plan in place
- [ ] Ready for regular use! 🎉

**Setup completed on:** ________________

**Notes:**

_______________________________________________

_______________________________________________

_______________________________________________

---

**Quick Help:**

- Documentation: `NOTES_DEPLOYMENT.md`
- Quick start: `README-QUARTZ-SETUP.md`
- Setup script: `./scripts/setup-quartz-integration.sh`
- Check status: `make notes-check`

**Common Commands:**

```bash
# In notes repo
npx quartz build          # Build
npx quartz serve          # Preview
./deploy-to-portfolio.sh  # Deploy

# In portfolio repo
make notes-check          # Check status
make build                # Build Hugo
make deploy               # Deploy all
```

Good luck! 🚀
