# Bloatware Nuker Script for jkowa
# Removes HP and Xbox bloatware safely
# Run as Administrator for best results

Write-Host "🔥 BLOATWARE NUKER 🔥" -ForegroundColor Red
Write-Host "Targeting: HP Trash + Xbox Trash + Microsoft Annoyances + COPILOT" -ForegroundColor Yellow
Write-Host ""

# HP Bloatware - ALL OF IT!
$hpApps = @(
    "AD2F1837.HPPCHardwareDiagnosticsWindows",
    "AD2F1837.HPPrinterControl", 
    "AD2F1837.HPPrivacySettings",
    "AD2F1837.HPSupportAssistant",
    "AD2F1837.HPSystemEventUtility",
    "AD2F1837.myHP"
)

# Xbox Bloatware - Don't need for Fortnite
$xboxApps = @(
    "Microsoft.XboxGameCallableUI",
    "Microsoft.XboxGamingOverlay", 
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay"
)

# Microsoft Annoyances + Copilot
$microsoftAnnoyances = @(
    "Microsoft.BingWeather",
    "Microsoft.BingSearch",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.GetHelp",
    "Microsoft.Copilot"
)

# HP Services to Disable
$hpServices = @(
    "HPAppHelperCap",
    "HPDiagsCap",
    "HPNetworkCap", 
    "HPOmenCap",
    "HPPrintScanDoctorService",
    "HPSysInfoCap",
    "HpTouchpointAnalyticsService"
)

Write-Host "🗑️ NUKING HP BLOATWARE..." -ForegroundColor Red
foreach ($app in $hpApps) {
    try {
        $package = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
        if ($package) {
            Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
            Write-Host "✅ NUKED: $app" -ForegroundColor Green
        } else {
            Write-Host "⚪ Not found: $app" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Failed to nuke: $app - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎮 NUKING XBOX BLOATWARE..." -ForegroundColor Red
foreach ($app in $xboxApps) {
    try {
        $package = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
        if ($package) {
            Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
            Write-Host "✅ NUKED: $app" -ForegroundColor Green
        } else {
            Write-Host "⚪ Not found: $app" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Failed to nuke: $app - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🚫 NUKING MICROSOFT ANNOYANCES + COPILOT..." -ForegroundColor Red
foreach ($app in $microsoftAnnoyances) {
    try {
        $package = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
        if ($package) {
            Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
            Write-Host "✅ NUKED: $app" -ForegroundColor Green
        } else {
            Write-Host "⚪ Not found: $app" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Failed to nuke: $app - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🛑 DISABLING HP SERVICES..." -ForegroundColor Red
foreach ($service in $hpServices) {
    try {
        $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($svc) {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction Stop
            Write-Host "✅ DISABLED: $service" -ForegroundColor Green
        } else {
            Write-Host "⚪ Not found: $service" -ForegroundColor Gray
        }
    } catch {
        Write-Host "❌ Failed to disable: $service - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 BLOATWARE NUKING COMPLETE!" -ForegroundColor Green
Write-Host "💡 Your system is now cleaner for coding, Fortnite, Unity, and LLM work!" -ForegroundColor Cyan
Write-Host "🔄 Restart recommended to complete cleanup" -ForegroundColor Yellow

# Show remaining bloatware
Write-Host ""
Write-Host "🔍 Checking for remaining HP/Xbox apps..." -ForegroundColor Cyan
$remaining = Get-AppxPackage | Where-Object { $_.Name -like "*HP*" -or $_.Name -like "*Xbox*" }
if ($remaining) {
    Write-Host "⚠️ Some apps may require manual removal:" -ForegroundColor Yellow
    $remaining | Select-Object Name | Format-Table -AutoSize
} else {
    Write-Host "🎯 All targeted bloatware successfully removed!" -ForegroundColor Green
}