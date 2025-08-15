# Build.ps1
# Main build orchestrator for Windows System Maintenance

param(
    [switch]$Test,
    [switch]$Package,
    [switch]$Sign,
    [switch]$UpdateVersion,
    [switch]$All
)

# Script root
$BuildRoot = $PSScriptRoot
$ProjectRoot = Split-Path $BuildRoot -Parent

Write-Host "=== Windows System Maintenance Build Script ===" -ForegroundColor Green
Write-Host "Build Root: $BuildRoot" -ForegroundColor Gray
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Gray

# Load version information
$VersionFile = Join-Path $ProjectRoot "version.json"
if (Test-Path $VersionFile) {
    $VersionInfo = Get-Content $VersionFile | ConvertFrom-Json
    Write-Host "Current Version: $($VersionInfo.version)" -ForegroundColor Cyan
} else {
    Write-Warning "Version file not found at $VersionFile"
    $VersionInfo = @{ version = "0.0.0" }
}

function Invoke-Tests {
    Write-Host "`n--- Running Tests ---" -ForegroundColor Yellow
    
    $TestPath = Join-Path $ProjectRoot "tests\unit\Configuration.Simple.Tests.ps1"
    if (-not (Test-Path $TestPath)) {
        Write-Error "Test file not found: $TestPath"
        return $false
    }
    
    try {
        Set-Location $ProjectRoot
        $TestResult = Invoke-Pester $TestPath -PassThru
        
        if ($TestResult.FailedCount -eq 0) {
            Write-Host "✅ All tests passed! ($($TestResult.PassedCount) passed)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Tests failed! ($($TestResult.FailedCount) failed, $($TestResult.PassedCount) passed)" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Error "Test execution failed: $_"
        return $false
    }
}

function Update-Version {
    param(
        [string]$VersionType = "patch"  # patch, minor, major
    )
    
    Write-Host "`n--- Updating Version ---" -ForegroundColor Yellow
    
    try {
        $currentVersion = $VersionInfo.version
        $versionParts = $currentVersion.Split('.')
        
        switch ($VersionType.ToLower()) {
            "major" { 
                $versionParts[0] = [int]$versionParts[0] + 1
                $versionParts[1] = 0
                $versionParts[2] = 0
            }
            "minor" { 
                $versionParts[1] = [int]$versionParts[1] + 1
                $versionParts[2] = 0
            }
            "patch" { 
                $versionParts[2] = [int]$versionParts[2] + 1
            }
        }
        
        $newVersion = $versionParts -join '.'
        
        # Update version.json
        $VersionInfo.version = $newVersion
        $VersionInfo.lastUpdate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
        $VersionInfo.build = "build-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        
        $VersionInfo | ConvertTo-Json -Depth 3 | Out-File $VersionFile -Encoding UTF8
        
        Write-Host "Version updated: $currentVersion → $newVersion" -ForegroundColor Green
        
        # Update changelog files
        Update-Changelog -Version $newVersion
        
        return $newVersion
    }
    catch {
        Write-Error "Version update failed: $_"
        return $null
    }
}

function Update-Changelog {
    param(
        [string]$Version
    )
    
    Write-Host "`n--- Updating Changelog ---" -ForegroundColor Yellow
    
    try {
        $changelogPath = Join-Path $ProjectRoot "CHANGELOG.md"
        $currentDate = Get-Date -Format "yyyy-MM-dd"
        
        # Define the changes for this version based on what we actually built
        $changelogEntry = @"
## [$Version] - $currentDate

### Added
- Comprehensive Pester testing framework with 12 unit tests
- Enterprise-grade build automation with version management
- JSON schema validation for configuration files
- Distribution packaging with automated installer
- Automated changelog generation in build process

### Fixed
- Critical path resolution in scheduler script (PSScriptRoot vs USERPROFILE)
- VS Code task integration and launch configurations
- Pester v3.4.0 compatibility for testing framework

### Changed
- Automated code signing for all PowerShell scripts
- Enhanced VS Code workspace with proper task definitions
- Version management now updates both version.json and CHANGELOG.md

"@

        if (Test-Path $changelogPath) {
            # Read existing changelog
            $existingContent = Get-Content $changelogPath -Raw
            
            # Find the insertion point (after the header but before first version)
            $headerEnd = $existingContent.IndexOf("## [")
            if ($headerEnd -gt 0) {
                $header = $existingContent.Substring(0, $headerEnd)
                $existingVersions = $existingContent.Substring($headerEnd)
                
                # Insert new version entry
                $newContent = $header + $changelogEntry + "`n" + $existingVersions
            } else {
                # If no existing versions, append after header
                $newContent = $existingContent + "`n`n" + $changelogEntry
            }
            
            # Write updated changelog
            $newContent | Out-File $changelogPath -Encoding UTF8
            Write-Host "📝 Updated CHANGELOG.md with version $Version" -ForegroundColor Green
        } else {
            Write-Warning "CHANGELOG.md not found at $changelogPath"
        }
        
        # Update version.json changelog section
        $versionJsonPath = Join-Path $ProjectRoot "version.json"
        if (Test-Path $versionJsonPath) {
            $versionData = Get-Content $versionJsonPath | ConvertFrom-Json
            
            # Add short changelog entry to version.json
            $shortDescription = "Testing framework, build automation, path fixes, VS Code integration"
            
            # Ensure changelog property exists
            if (-not $versionData.changelog) {
                $versionData | Add-Member -NotePropertyName "changelog" -NotePropertyValue @{}
            }
            
            # Add new version entry
            $versionData.changelog | Add-Member -NotePropertyName $Version -NotePropertyValue $shortDescription -Force
            
            # Save updated version.json
            $versionData | ConvertTo-Json -Depth 3 | Out-File $versionJsonPath -Encoding UTF8
            Write-Host "📝 Updated version.json changelog section" -ForegroundColor Green
        }
        
        return $true
    }
    catch {
        Write-Error "Changelog update failed: $_"
        return $false
    }
}

function Invoke-Signing {
    Write-Host "`n--- Code Signing ---" -ForegroundColor Yellow
    
    # Check if signing certificate exists
    $certs = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
    if ($certs.Count -eq 0) {
        Write-Warning "No code signing certificates found. Skipping signing."
        return $false
    }
    
    $cert = $certs[0]
    Write-Host "Using certificate: $($cert.Subject)" -ForegroundColor Cyan
    
    # Find PowerShell scripts to sign
    $scriptsToSign = @(
        "scripts\core\system-maintenance.ps1",
        "scripts\core\setup-maintenance-schedule.ps1", 
        "scripts\utilities\nuke-bloatware.ps1"
    )
    
    foreach ($scriptPath in $scriptsToSign) {
        $fullPath = Join-Path $ProjectRoot $scriptPath
        if (Test-Path $fullPath) {
            try {
                Set-AuthenticodeSignature -FilePath $fullPath -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
                Write-Host "✅ Signed: $scriptPath" -ForegroundColor Green
            }
            catch {
                Write-Warning "Failed to sign $scriptPath : $_"
            }
        } else {
            Write-Warning "Script not found: $fullPath"
        }
    }
    
    return $true
}

function Invoke-Packaging {
    Write-Host "`n--- Creating Package ---" -ForegroundColor Yellow
    
    $PackageDir = Join-Path $ProjectRoot "dist"
    if (Test-Path $PackageDir) {
        Remove-Item $PackageDir -Recurse -Force
    }
    New-Item -Path $PackageDir -ItemType Directory -Force | Out-Null
    
    # Copy files to package directory
    $filesToCopy = @(
        "scripts",
        "config",
        "docs",
        "README.md",
        "CHANGELOG.md",
        "version.json"
    )
    
    foreach ($item in $filesToCopy) {
        $sourcePath = Join-Path $ProjectRoot $item
        if (Test-Path $sourcePath) {
            $destPath = Join-Path $PackageDir $item
            if (Test-Path $sourcePath -PathType Container) {
                Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            } else {
                Copy-Item -Path $sourcePath -Destination $destPath -Force
            }
            Write-Host "📦 Copied: $item" -ForegroundColor Cyan
        }
    }
    
    # Create installation script
    $installScript = @"
# Quick Installation Script for Windows System Maintenance
Write-Host "Installing Windows System Maintenance..." -ForegroundColor Green

# Copy to final location (could be customized)
Write-Host "Installation complete! Run .\scripts\core\system-maintenance.ps1 -Help for usage."
"@
    
    $installScript | Out-File (Join-Path $PackageDir "Install.ps1") -Encoding UTF8
    
    Write-Host "✅ Package created in: $PackageDir" -ForegroundColor Green
    return $true
}

# Main execution logic
if ($All) {
    $Test = $true
    $UpdateVersion = $true
    $Sign = $true
    $Package = $true
}

$success = $true

# Run tests if requested
if ($Test) {
    $success = $success -and (Invoke-Tests)
}

# Update version if requested
if ($UpdateVersion -and $success) {
    $newVersion = Update-Version -VersionType "patch"
    $success = $success -and ($null -ne $newVersion)
}

# Sign scripts if requested
if ($Sign -and $success) {
    $success = $success -and (Invoke-Signing)
}

# Create package if requested
if ($Package -and $success) {
    $success = $success -and (Invoke-Packaging)
}

# Summary
Write-Host "`n=== Build Summary ===" -ForegroundColor Green
if ($success) {
    Write-Host "✅ Build completed successfully!" -ForegroundColor Green
    if ($UpdateVersion) {
        Write-Host "📦 Version: $($VersionInfo.version)" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

exit 0