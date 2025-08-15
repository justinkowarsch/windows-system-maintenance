# setup-repository.ps1
# PowerShell script to configure GitHub repository settings and branch protection

param(
    [string]$Repository = "justinkowarsch/windows-system-maintenance",
    [string]$ConfigFile = ".github/repository-config.json",
    [switch]$DryRun,
    [switch]$SkipBranchProtection
)

# Ensure we're in the correct directory
$ScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$RepoRoot = Split-Path $ScriptRoot -Parent
Set-Location $RepoRoot

Write-Host "=== GitHub Repository Configuration Setup ===" -ForegroundColor Green
Write-Host "Repository: $Repository" -ForegroundColor Cyan
Write-Host "Config File: $ConfigFile" -ForegroundColor Cyan

# Check if GitHub CLI is installed
$ghVersion = gh version 2>$null
if (-not $ghVersion) {
    Write-Error "GitHub CLI (gh) is not installed. Please install it first:"
    Write-Host "winget install GitHub.cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "GitHub CLI detected: $($ghVersion[0])" -ForegroundColor Green

# Check authentication
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Not authenticated with GitHub. Please run: gh auth login"
        exit 1
    }
    Write-Host "✅ GitHub authentication verified" -ForegroundColor Green
}
catch {
    Write-Error "Failed to check GitHub authentication: $_"
    exit 1
}

# Load configuration
if (-not (Test-Path $ConfigFile)) {
    Write-Error "Configuration file not found: $ConfigFile"
    exit 1
}

try {
    $config = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    Write-Host "✅ Configuration loaded successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to parse configuration file: $_"
    exit 1
}

function Set-RepositorySettings {
    param($RepoConfig)
    
    Write-Host "`n--- Repository Settings ---" -ForegroundColor Yellow
    
    $settings = @()
    
    # Basic repository settings
    if ($RepoConfig.description) {
        $settings += "--description `"$($RepoConfig.description)`""
    }
    
    if ($RepoConfig.homepage) {
        $settings += "--homepage `"$($RepoConfig.homepage)`""
    }
    
    # Merge settings
    if ($RepoConfig.allow_squash_merge -eq $false) {
        $settings += "--enable-squash-merge=false"
    }
    
    if ($RepoConfig.allow_merge_commit -eq $false) {
        $settings += "--enable-merge-commit=false"
    }
    
    if ($RepoConfig.allow_rebase_merge -eq $false) {
        $settings += "--enable-rebase-merge=false"
    }
    
    if ($RepoConfig.delete_branch_on_merge -eq $true) {
        $settings += "--delete-branch-on-merge"
    }
    
    if ($settings.Count -gt 0) {
        $cmd = "gh repo edit $Repository " + ($settings -join " ")
        
        if ($DryRun) {
            Write-Host "DRY RUN: $cmd" -ForegroundColor Magenta
        } else {
            Write-Host "Applying repository settings..." -ForegroundColor Cyan
            Invoke-Expression $cmd
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Repository settings updated" -ForegroundColor Green
            } else {
                Write-Warning "Failed to update repository settings"
            }
        }
    }
    
    # Set repository topics
    if ($RepoConfig.topics -and $RepoConfig.topics.Count -gt 0) {
        $topicsString = ($RepoConfig.topics -join ",")
        $cmd = "gh repo edit $Repository --add-topic `"$topicsString`""
        
        if ($DryRun) {
            Write-Host "DRY RUN: $cmd" -ForegroundColor Magenta
        } else {
            Write-Host "Setting repository topics..." -ForegroundColor Cyan
            Invoke-Expression $cmd
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Repository topics updated" -ForegroundColor Green
            } else {
                Write-Warning "Failed to update repository topics"
            }
        }
    }
}

function Set-BranchProtection {
    param($BranchConfig, $BranchName)
    
    Write-Host "`n--- Branch Protection: $BranchName ---" -ForegroundColor Yellow
    
    # Build the branch protection command
    $protectionArgs = @()
    
    # Required status checks
    if ($BranchConfig.required_status_checks) {
        if ($BranchConfig.required_status_checks.strict) {
            $protectionArgs += "--require-status-checks"
        }
        
        if ($BranchConfig.required_status_checks.contexts) {
            foreach ($context in $BranchConfig.required_status_checks.contexts) {
                $protectionArgs += "--required-status-checks `"$context`""
            }
        }
    }
    
    # Pull request reviews
    if ($BranchConfig.required_pull_request_reviews) {
        $reviews = $BranchConfig.required_pull_request_reviews
        
        if ($reviews.required_approving_review_count) {
            $protectionArgs += "--require-pull-request-reviews"
            $protectionArgs += "--required-approving-review-count $($reviews.required_approving_review_count)"
        }
        
        if ($reviews.dismiss_stale_reviews) {
            $protectionArgs += "--dismiss-stale-reviews"
        }
        
        if ($reviews.require_last_push_approval) {
            $protectionArgs += "--require-last-push-approval"
        }
    }
    
    # Admin enforcement
    if ($BranchConfig.enforce_admins) {
        $protectionArgs += "--enforce-admins"
    }
    
    # Conversation resolution
    if ($BranchConfig.required_conversation_resolution) {
        $protectionArgs += "--require-conversation-resolution"
    }
    
    # Force push and deletion restrictions
    if ($BranchConfig.allow_force_pushes -eq $false) {
        $protectionArgs += "--block-force-push"
    }
    
    if ($BranchConfig.allow_deletions -eq $false) {
        $protectionArgs += "--block-deletions"
    }
    
    # Build the complete command
    $cmd = "gh api repos/$Repository/branches/$BranchName/protection --method PUT --input -"
    
    # Create the JSON payload for the API
    $protectionPayload = @{
        required_status_checks = if ($BranchConfig.required_status_checks) { $BranchConfig.required_status_checks } else { $null }
        enforce_admins = $BranchConfig.enforce_admins
        required_pull_request_reviews = if ($BranchConfig.required_pull_request_reviews) { $BranchConfig.required_pull_request_reviews } else { $null }
        restrictions = $BranchConfig.restrictions
        allow_force_pushes = if ($BranchConfig.PSObject.Properties.Name -contains "allow_force_pushes") { $BranchConfig.allow_force_pushes } else { $false }
        allow_deletions = if ($BranchConfig.PSObject.Properties.Name -contains "allow_deletions") { $BranchConfig.allow_deletions } else { $false }
        block_creations = if ($BranchConfig.PSObject.Properties.Name -contains "block_creations") { $BranchConfig.block_creations } else { $false }
        required_conversation_resolution = if ($BranchConfig.PSObject.Properties.Name -contains "required_conversation_resolution") { $BranchConfig.required_conversation_resolution } else { $true }
        lock_branch = if ($BranchConfig.PSObject.Properties.Name -contains "lock_branch") { $BranchConfig.lock_branch } else { $false }
        allow_fork_syncing = if ($BranchConfig.PSObject.Properties.Name -contains "allow_fork_syncing") { $BranchConfig.allow_fork_syncing } else { $true }
    }
    
    $jsonPayload = $protectionPayload | ConvertTo-Json -Depth 10
    
    if ($DryRun) {
        Write-Host "DRY RUN: Branch protection for $BranchName" -ForegroundColor Magenta
        Write-Host "Payload:" -ForegroundColor Gray
        Write-Host $jsonPayload -ForegroundColor Gray
    } else {
        Write-Host "Applying branch protection for $BranchName..." -ForegroundColor Cyan
        
        try {
            $jsonPayload | gh api repos/$Repository/branches/$BranchName/protection --method PUT --input -
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Branch protection applied to $BranchName" -ForegroundColor Green
            } else {
                Write-Warning "Failed to apply branch protection to $BranchName"
            }
        }
        catch {
            Write-Warning "Error applying branch protection to $BranchName : $_"
        }
    }
}

function Enable-SecurityFeatures {
    param($SecurityConfig)
    
    Write-Host "`n--- Security Features ---" -ForegroundColor Yellow
    
    if ($SecurityConfig.vulnerability_alerts) {
        $cmd = "gh api repos/$Repository/vulnerability-alerts --method PUT"
        
        if ($DryRun) {
            Write-Host "DRY RUN: $cmd" -ForegroundColor Magenta
        } else {
            Write-Host "Enabling vulnerability alerts..." -ForegroundColor Cyan
            Invoke-Expression $cmd
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Vulnerability alerts enabled" -ForegroundColor Green
            }
        }
    }
    
    # Enable security features via API calls
    $securityFeatures = @(
        @{ name = "secret_scanning"; endpoint = "secret-scanning" },
        @{ name = "secret_scanning_push_protection"; endpoint = "secret-scanning/push-protection" }
    )
    
    foreach ($feature in $securityFeatures) {
        if ($SecurityConfig.security_and_analysis.($feature.name).status -eq "enabled") {
            $cmd = "gh api repos/$Repository/$($feature.endpoint) --method PUT"
            
            if ($DryRun) {
                Write-Host "DRY RUN: $cmd" -ForegroundColor Magenta
            } else {
                Write-Host "Enabling $($feature.name)..." -ForegroundColor Cyan
                Invoke-Expression $cmd 2>$null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✅ $($feature.name) enabled" -ForegroundColor Green
                }
            }
        }
    }
}

# Main execution
try {
    # Apply repository settings
    if ($config.repository) {
        Set-RepositorySettings -RepoConfig $config.repository
    }
    
    # Apply branch protection
    if ($config.branch_protection -and -not $SkipBranchProtection) {
        foreach ($branch in $config.branch_protection.PSObject.Properties) {
            Set-BranchProtection -BranchConfig $branch.Value -BranchName $branch.Name
        }
    }
    
    # Enable security features
    if ($config.security) {
        Enable-SecurityFeatures -SecurityConfig $config.security
    }
    
    Write-Host "`n🎉 Repository configuration completed successfully!" -ForegroundColor Green
    
    if ($DryRun) {
        Write-Host "`n📝 This was a dry run. Re-run without -DryRun to apply changes." -ForegroundColor Yellow
    }
    
} catch {
    Write-Error "Configuration failed: $_"
    exit 1
}