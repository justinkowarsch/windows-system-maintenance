# GitHub Repository Configuration

This directory contains automated configuration for the GitHub repository, including branch protection rules, security settings, and repository policies.

## Files

- **`repository-config.json`** - Complete repository configuration including branch protection rules
- **`setup-repository.ps1`** - PowerShell script to apply configuration via GitHub CLI
- **`workflows/ci.yml`** - GitHub Actions CI/CD pipeline

## Quick Setup

### Prerequisites

1. **Install GitHub CLI**:
   ```powershell
   winget install GitHub.cli
   ```

2. **Authenticate with GitHub**:
   ```powershell
   gh auth login
   ```

### Apply Repository Configuration

```powershell
# Dry run to see what would be applied
.\.github\setup-repository.ps1 -DryRun

# Apply all settings
.\.github\setup-repository.ps1

# Apply only repository settings (skip branch protection)
.\.github\setup-repository.ps1 -SkipBranchProtection
```

## Configuration Details

### Branch Protection (Master Branch)
- ✅ **Require pull request reviews** (1 approver required)
- ✅ **Require status checks** (CI/CD pipeline must pass)
- ✅ **Dismiss stale reviews** on new commits
- ✅ **Require conversation resolution** before merge
- ✅ **Enforce for administrators** (no exceptions)
- ✅ **Block force pushes** and deletions
- ✅ **Require branches to be up to date**

### Required Status Checks
- `CI/CD Pipeline / test` - Unit tests must pass
- `CI/CD Pipeline / security-scan` - Security scan must pass  
- `CI/CD Pipeline / build` - Build must succeed

### Repository Settings
- ✅ **Squash merge** enabled (clean history)
- ❌ **Merge commits** disabled (avoid noise)
- ✅ **Rebase merge** enabled (linear history)
- ✅ **Delete branch on merge** (clean up)
- ✅ **Auto-merge** when conditions met

### Security Features
- ✅ **Secret scanning** enabled
- ✅ **Secret scanning push protection** enabled
- ✅ **Vulnerability alerts** enabled
- ✅ **Dependency graph** enabled
- ✅ **Dependabot security updates** enabled

### Topics/Tags
- `powershell`
- `windows-11` 
- `system-maintenance`
- `automation`
- `gaming-workstation`
- `windows-optimization`
- `powershell-scripts`
- `system-administration`

## Manual Setup (if CLI fails)

If the automated script doesn't work, you can manually configure via GitHub web interface:

1. Go to **Settings** → **Branches**
2. Click **Add rule** for `master` branch
3. Enable all the protections listed above
4. Go to **Settings** → **Code security and analysis**
5. Enable all security features

## Troubleshooting

### Common Issues

**Authentication Error:**
```powershell
gh auth login
# Follow the prompts to authenticate
```

**Permission Error:**
- Ensure you're the repository owner or have admin access
- Check that your GitHub token has the required scopes

**API Rate Limiting:**
- Wait a few minutes and retry
- The script includes automatic retry logic

### Verification

After running the setup script, verify the configuration:

```powershell
# Check branch protection
gh api repos/justinkowarsch/windows-system-maintenance/branches/master/protection

# Check repository settings  
gh repo view justinkowarsch/windows-system-maintenance

# Test the protection by trying to push directly to master (should fail)
git push origin master  # This should be blocked!
```

## Contributing Workflow

With branch protection enabled, the workflow becomes:

1. **Create feature branch**: `git checkout -b feature/my-feature`
2. **Make changes and commit**: `git commit -m "Add feature"`
3. **Push branch**: `git push origin feature/my-feature`
4. **Create pull request** via GitHub web interface
5. **Wait for CI checks** to pass (tests, security scan, build)
6. **Get review approval** (1 required)
7. **Merge via GitHub** (squash merge recommended)

Direct pushes to `master` are now **blocked for everyone** (including repository owner)!