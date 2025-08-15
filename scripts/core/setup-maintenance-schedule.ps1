# Windows 11 Maintenance Scheduler Setup
# Creates scheduled tasks for automated system maintenance
# Author: Claude Code Assistant
# Version: 1.0

param(
    [switch]$Install,
    [switch]$Remove,
    [switch]$Status
)

$ScriptPath = Join-Path $env:USERPROFILE "system-maintenance.ps1"
$TaskPrefix = "SystemMaintenance"

function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-MaintenanceTasks {
    Write-Host "Installing maintenance scheduled tasks..." -ForegroundColor Green
    
    if (-not (Test-Path $ScriptPath)) {
        Write-Host "ERROR: Maintenance script not found at $ScriptPath" -ForegroundColor Red
        return $false
    }
    
    try {
        # Daily Quick Cleanup (7 AM)
        Write-Host "Creating daily quick cleanup task..." -ForegroundColor Yellow
        $action1 = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-WindowStyle Hidden -File `"$ScriptPath`" -QuickClean"
        $trigger1 = New-ScheduledTaskTrigger -Daily -At 7AM
        $settings1 = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        $principal1 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Highest
        
        Register-ScheduledTask -TaskName "$TaskPrefix-DailyCleanup" -Action $action1 -Trigger $trigger1 -Settings $settings1 -Principal $principal1 -Description "Daily system cleanup - temp files, cache, recycle bin" -Force
        
        # Weekly Full Maintenance (Sunday 2 AM)
        Write-Host "Creating weekly full maintenance task..." -ForegroundColor Yellow
        $action2 = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-WindowStyle Hidden -File `"$ScriptPath`" -FullMaintenance"
        $trigger2 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Sunday -At 2AM
        $settings2 = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 2) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        $principal2 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Highest
        
        Register-ScheduledTask -TaskName "$TaskPrefix-WeeklyFull" -Action $action2 -Trigger $trigger2 -Settings $settings2 -Principal $principal2 -Description "Weekly full system maintenance - antivirus, optimization, cleanup" -Force
        
        # Gaming Optimization (When plugged in, on startup)
        Write-Host "Creating gaming optimization task..." -ForegroundColor Yellow
        $action3 = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-WindowStyle Hidden -File `"$ScriptPath`" -GameOptimize"
        $trigger3 = New-ScheduledTaskTrigger -AtStartup
        $settings3 = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 15) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Delay (New-TimeSpan -Minutes 2)
        $principal3 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Highest
        
        Register-ScheduledTask -TaskName "$TaskPrefix-GameOptimize" -Action $action3 -Trigger $trigger3 -Settings $settings3 -Principal $principal3 -Description "Gaming optimizations on startup" -Force
        
        # Development Environment Cleanup (Monday 6 AM)
        Write-Host "Creating development cleanup task..." -ForegroundColor Yellow
        $action4 = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-WindowStyle Hidden -File `"$ScriptPath`" -DevOptimize"
        $trigger4 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Monday -At 6AM
        $settings4 = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        $principal4 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Highest
        
        Register-ScheduledTask -TaskName "$TaskPrefix-DevCleanup" -Action $action4 -Trigger $trigger4 -Settings $settings4 -Principal $principal4 -Description "Weekly development environment cleanup" -Force
        
        # Monthly System Report (First Sunday 3 AM)
        Write-Host "Creating monthly system report task..." -ForegroundColor Yellow
        $action5 = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-WindowStyle Hidden -File `"$ScriptPath`" -Report"
        $trigger5 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Sunday -At 3AM
        $settings5 = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 15) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        $principal5 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Highest
        
        Register-ScheduledTask -TaskName "$TaskPrefix-MonthlyReport" -Action $action5 -Trigger $trigger5 -Settings $settings5 -Principal $principal5 -Description "Monthly system health report generation" -Force
        
        Write-Host "All maintenance tasks installed successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "ERROR installing tasks: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Remove-MaintenanceTasks {
    Write-Host "Removing maintenance scheduled tasks..." -ForegroundColor Yellow
    
    $taskNames = @(
        "$TaskPrefix-DailyCleanup",
        "$TaskPrefix-WeeklyFull",
        "$TaskPrefix-GameOptimize",
        "$TaskPrefix-DevCleanup",
        "$TaskPrefix-MonthlyReport"
    )
    
    foreach ($taskName in $taskNames) {
        try {
            $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
            if ($task) {
                Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
                Write-Host "Removed task: $taskName" -ForegroundColor Green
            } else {
                Write-Host "Task not found: $taskName" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "Error removing task $taskName`: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Show-TaskStatus {
    Write-Host "Maintenance Scheduled Tasks Status" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan
    
    $taskNames = @(
        "$TaskPrefix-DailyCleanup",
        "$TaskPrefix-WeeklyFull", 
        "$TaskPrefix-GameOptimize",
        "$TaskPrefix-DevCleanup",
        "$TaskPrefix-MonthlyReport"
    )
    
    foreach ($taskName in $taskNames) {
        try {
            $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
            if ($task) {
                $lastRun = (Get-ScheduledTaskInfo -TaskName $taskName).LastRunTime
                $nextRun = (Get-ScheduledTaskInfo -TaskName $taskName).NextRunTime
                $state = $task.State
                
                Write-Host "Task: $taskName" -ForegroundColor Green
                Write-Host "  State: $state" -ForegroundColor $(if($state -eq "Ready") {"Green"} else {"Yellow"})
                Write-Host "  Last Run: $lastRun" -ForegroundColor Gray
                Write-Host "  Next Run: $nextRun" -ForegroundColor Gray
                Write-Host "  Description: $($task.Description)" -ForegroundColor Gray
                Write-Host ""
            } else {
                Write-Host "Task: $taskName - NOT INSTALLED" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Error checking task $taskName`: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Show maintenance script status
    Write-Host "Maintenance Script Status" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    if (Test-Path $ScriptPath) {
        $scriptInfo = Get-Item $ScriptPath
        Write-Host "Script: $ScriptPath" -ForegroundColor Green
        Write-Host "  Size: $([math]::Round($scriptInfo.Length/1KB,2)) KB" -ForegroundColor Gray
        Write-Host "  Modified: $($scriptInfo.LastWriteTime)" -ForegroundColor Gray
    } else {
        Write-Host "Script: $ScriptPath - NOT FOUND" -ForegroundColor Red
    }
}

function Show-Help {
    Write-Host "Windows 11 Maintenance Scheduler Setup" -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\setup-maintenance-schedule.ps1 [OPTIONS]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "OPTIONS:" -ForegroundColor Green
    Write-Host "  -Install    Install all maintenance scheduled tasks"
    Write-Host "  -Remove     Remove all maintenance scheduled tasks"
    Write-Host "  -Status     Show status of all maintenance tasks"
    Write-Host ""
    Write-Host "SCHEDULED TASKS:" -ForegroundColor Green
    Write-Host "  Daily Cleanup        - 7:00 AM daily (quick cleanup)"
    Write-Host "  Weekly Full          - 2:00 AM Sundays (full maintenance)"
    Write-Host "  Gaming Optimize      - On startup (gaming optimizations)"
    Write-Host "  Dev Cleanup          - 6:00 AM Mondays (development cleanup)"
    Write-Host "  Monthly Report       - 3:00 AM first Sunday (system report)"
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Green
    Write-Host "  .\setup-maintenance-schedule.ps1 -Install"
    Write-Host "  .\setup-maintenance-schedule.ps1 -Status"
    Write-Host "  .\setup-maintenance-schedule.ps1 -Remove"
    Write-Host ""
    Write-Host "NOTE: Run as Administrator for best results" -ForegroundColor Magenta
}

# Main execution
Write-Host "Windows 11 Maintenance Scheduler Setup v1.0" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

if (-not (Test-AdminRights)) {
    Write-Host "WARNING: Not running as Administrator. Some operations may fail." -ForegroundColor Yellow
}

if ($Install) {
    $success = Install-MaintenanceTasks
    if ($success) {
        Show-TaskStatus
        Write-Host ""
        Write-Host "SETUP COMPLETE!" -ForegroundColor Green
        Write-Host "Your system will now be automatically maintained according to the schedule." -ForegroundColor Green
        Write-Host "Check logs in: C:\Users\jkowa\maintenance-logs" -ForegroundColor Cyan
        Write-Host "Check reports in: C:\Users\jkowa\system-reports" -ForegroundColor Cyan
    }
}
elseif ($Remove) {
    Remove-MaintenanceTasks
    Write-Host "All maintenance tasks have been removed." -ForegroundColor Green
}
elseif ($Status) {
    Show-TaskStatus
}
else {
    Show-Help
}
# SIG # Begin signature block
# MIIFxQYJKoZIhvcNAQcCoIIFtjCCBbICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCABKNJiOL0brZKR
# hQ3TIZQd3jVy7VCNIrLBUlai0UMDkqCCAyowggMmMIICDqADAgECAhBSjxQ1GoOZ
# jkPbWbupTzYSMA0GCSqGSIb3DQEBCwUAMCsxKTAnBgNVBAMMIExvY2FsIFBvd2Vy
# U2hlbGwgU2NyaXB0cyAtIGprb3dhMB4XDTI1MDgxNTAyMTc0N1oXDTI2MDgxNTAy
# Mzc0N1owKzEpMCcGA1UEAwwgTG9jYWwgUG93ZXJTaGVsbCBTY3JpcHRzIC0gamtv
# d2EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCRibbGzT8f+jH9DmvP
# uUHbAPHVyPvqTZ7Q6Z2ypQZv8m0rzUwkzpNEcLr0+4hxj1E+IdGfAqMNV8yoyESf
# 3SDGQUQ1HeqgBB08PL1vYb0p9yGTN9LQ2MdinrWVo2CALrgjR+vNtpt0UwrujNJr
# iE4AVE3lE654k6xKr1b5pMVV7RdnKdVzvH7FHznbWMud8cE3jjrmtLkp/hOk9EJN
# LfujnOkYAID3Fug4C8mIcjWuulrI+KMRGI65aVL+sPK85WCh1Bj9smBJCx6jQNEC
# QWF9F4rHglQOiRqXNm+/zt9a9az1fDoUo3r7hATe24xlrz6ER4NiKJy4W9ENOeLN
# x2z5AgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcD
# AzAdBgNVHQ4EFgQU9ThRWAnMgJpoHlqZKRggB46120gwDQYJKoZIhvcNAQELBQAD
# ggEBAGM29VQ2//VtGpmYoC0vO1B81K/u/ppGiqegBSQLPRbAkno++zbzHkVtjcvz
# 0B5e6dZbU41LTh34wowOe6k1L/w6+TUMf3osHp/2dwFaT/ybQ8wPi56Mm4zuuXVD
# 0zl3rVEAU2zsWPrT54H3W0L3tJS+JIjHdykfDGT76PCajYcu7pLekBlPDdoN1XRg
# /qpOqSrICUZzRKby0PbdrovnB8Ua4if+Mtev3R/A8bQ+gk2vwXygtczcwxS3Q0n8
# NMzkCo7gmUL0fD/Le9OXDUEf8u7LtZ3dai4H33MmyB6iLNmTIQ7MM9CvjtWh13ej
# h1nMtg/LV/+bvpFR9mQd6NY0mA4xggHxMIIB7QIBATA/MCsxKTAnBgNVBAMMIExv
# Y2FsIFBvd2VyU2hlbGwgU2NyaXB0cyAtIGprb3dhAhBSjxQ1GoOZjkPbWbupTzYS
# MA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwLwYJKoZIhvcNAQkEMSIEILva/vvnmpvEqZNnF78mT1bmwXdqB0/v2Fiv
# eoCX9jLxMA0GCSqGSIb3DQEBAQUABIIBAHVbWveus3oQpaJywvHW6wGbTzTUvHob
# MbGT+oRFSN/62zUvmDolzjZ5i9bFhJXQ8NiMbIefjezrUlnT+L+fVAyadCGI7fRA
# bUJjGsp+sb17QTphfmCnDrIg3RfPn1uApZE1ZHTripzwI60tOPaTt6XjjWNKg3tN
# g9kphAJSAN0z1NDzcpfIcOivkeP2ZRZ151XQtM+wCPVjGz3AgaX/oPRpTyTvaFmg
# XAPdUtxRyofQyt7/WhX5vbE1QWIlAhoMS0oZGBUrW5EeP0I56PrS9JcFokxM9lwH
# N9YKqe1nNaOS8MttdyefQiJaz8Opnh3EG5rebssL5n6OU0QNs56txF8=
# SIG # End signature block
