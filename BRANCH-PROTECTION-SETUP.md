# 🛡️ Branch Protection Setup Guide

## Required Branch Protection Rules

To protect your repository from unauthorized deployments, set up these branch protection rules in GitHub:

### Main Branch Protection (`main`)

1. Go to: `Settings` → `Branches` → `Add rule`
2. Branch name pattern: `main`
3. Enable these protections:

**Restrict pushes that create files:**
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: `1`
  - ✅ Dismiss stale PR approvals when new commits are pushed
  - ✅ Require review from code owners

**Status Checks:**
- ✅ **Require status checks to pass before merging**
- ✅ Require branches to be up to date before merging
- Required status checks:
  - `🔒 Security & Dependencies Audit`
  - `🎯 Code Quality & Linting`
  - `🏗️ Build & Integration Tests`
  - `📚 Documentation & Standards`

**Additional Restrictions:**
- ✅ **Restrict pushes that create files**
- ✅ **Require linear history**
- ✅ **Include administrators** (applies rules to repo admins too)

### Test Branch Protection (`test-for-ctf-page`)

1. Branch name pattern: `test-for-ctf-page`
2. Enable:
- ✅ **Require a pull request before merging**
- ✅ **Require status checks to pass before merging**
- Same required status checks as main branch

## Security Benefits

✅ **No unauthorized deployments**: PRs cannot deploy directly to Firebase
✅ **Code quality enforcement**: All code must pass CI/CD checks
✅ **Security scanning**: Malicious code detection before merge
✅ **Review requirement**: Human approval needed for all changes
✅ **Build validation**: Ensures changes don't break the site

## GitHub CLI Setup (Optional)

```bash
# Enable branch protection via CLI
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["🔒 Security & Dependencies Audit","🎯 Code Quality & Linting","🏗️ Build & Integration Tests","📚 Documentation & Standards"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null
```

## How It Works

1. **Pull Request Created** → CI/CD pipeline runs (no deployment)
2. **All Checks Pass** → PR can be approved and merged
3. **Merge to Main** → Deployment workflows trigger safely
4. **Deploy to Firebase** → Only from main branch with proper checks

This ensures that strangers cannot deploy anything to your live sites through pull requests!
