# Windows 11 Maintenance Scheduler Setup
# Creates scheduled tasks for automated system maintenance
# Author: Claude Code Assistant
# Version: 1.0

param(
    [switch]$Install,
    [switch]$Remove,
    [switch]$Status
)

$ScriptPath = Join-Path $PSScriptRoot "system-maintenance.ps1"
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

# SIG # Begin signature block
# MIIcKQYJKoZIhvcNAQcCoIIcGjCCHBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCALlbTTHTFeeju3
# aPuLWB1GesV3W7JC5nnYoR2a5AMD6KCCFmQwggMmMIICDqADAgECAhBSjxQ1GoOZ
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
# h1nMtg/LV/+bvpFR9mQd6NY0mA4wggWNMIIEdaADAgECAhAOmxiO+dAt5+/bUOII
# QBhaMA0GCSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdp
# Q2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0Rp
# Z2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBaFw0zMTEx
# MDkyMzU5NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMx
# GTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRy
# dXN0ZWQgUm9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL/m
# kHNo3rvkXUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4
# FutWxpdtHauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZanMy
# lNEQRBAu34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq8
# 68nPzaw0QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL2pNe
# 3I6PgNq2kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMq
# bpEBfCFM1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3JFxG
# j2T3wWmIdph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3cAORF
# JYm2mkQZK37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhE
# lRp2Yn72gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0vias
# tkF13nqsX40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LW
# RV+dIPyhHsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIBNjAPBgNV
# HRMBAf8EBTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwPTzAfBgNV
# HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMCAYYweQYI
# KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDov
# L2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDAR
# BgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0NcVec4X6Cj
# dBs9thbX979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnovLbc47/T/
# gLn4offyct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65ZyoUi0mcud
# T6cGAxN3J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFWjuyk1T3o
# sdz9HNj0d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPFmCLBsln1
# VWvPJ6tsds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9ztwGpn1eq
# XijiuZQwgga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqGSIb3DQEB
# CwUAMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQg
# Um9vdCBHNDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkxCzAJBgNV
# BAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNl
# cnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBD
# QTEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphBcr48RsAc
# rHXbo0ZodLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6pvF4uGjwj
# qNjfEvUi6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHeHYNnQxqX
# mRinvuNgxVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEdgkFiDNYi
# OTx4OtiFcMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjUjsZvkgFk
# riK9tUKJm/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bRVFLeGkuA
# hHiGPMvSGmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeSLsJygoLP
# p66bkDX1ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIVNSaz7BX8
# VtYGqLt9MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL6s36czwz
# sucuoKs7Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2ZdSoQbU2rM
# kpLiQ6bGRinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFUeEY0qVjP
# KOWug/G6X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB
# /wIBADAdBgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0jBBgwFoAU
# 7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoG
# CCsGAQUFBwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuZGlnaWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDig
# NqA0hjJodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9v
# dEc0LmNybDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZI
# hvcNAQELBQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/T8ObXAZz
# 8OjuhUxjaaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQE7jU/kXj
# jytJgnn0hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9rEVKChHyf
# pzee5kH0F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y1IsA0QF8
# dTXqvcnTmpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gxdEkMx1NK
# U4uHQcKfZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3ty9qIijan
# rUR3anzEwlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcytL5TTLL4
# ZaoBdqbhOhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEBYTptMSbh
# dhGQDpOXgpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud/v4+7RWs
# WCiKi9EOLLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiSuEtQvLsN
# z3Qbp7wGWqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZPubdcMIIG
# 7TCCBNWgAwIBAgIQCoDvGEuN8QWC0cR2p5V0aDANBgkqhkiG9w0BAQsFADBpMQsw
# CQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERp
# Z2lDZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIw
# MjUgQ0ExMB4XDTI1MDYwNDAwMDAwMFoXDTM2MDkwMzIzNTk1OVowYzELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2Vy
# dCBTSEEyNTYgUlNBNDA5NiBUaW1lc3RhbXAgUmVzcG9uZGVyIDIwMjUgMTCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANBGrC0Sxp7Q6q5gVrMrV7pvUf+G
# cAoB38o3zBlCMGMyqJnfFNZx+wvA69HFTBdwbHwBSOeLpvPnZ8ZN+vo8dE2/pPvO
# x/Vj8TchTySA2R4QKpVD7dvNZh6wW2R6kSu9RJt/4QhguSssp3qome7MrxVyfQO9
# sMx6ZAWjFDYOzDi8SOhPUWlLnh00Cll8pjrUcCV3K3E0zz09ldQ//nBZZREr4h/G
# I6Dxb2UoyrN0ijtUDVHRXdmncOOMA3CoB/iUSROUINDT98oksouTMYFOnHoRh6+8
# 6Ltc5zjPKHW5KqCvpSduSwhwUmotuQhcg9tw2YD3w6ySSSu+3qU8DD+nigNJFmt6
# LAHvH3KSuNLoZLc1Hf2JNMVL4Q1OpbybpMe46YceNA0LfNsnqcnpJeItK/DhKbPx
# TTuGoX7wJNdoRORVbPR1VVnDuSeHVZlc4seAO+6d2sC26/PQPdP51ho1zBp+xUIZ
# kpSFA8vWdoUoHLWnqWU3dCCyFG1roSrgHjSHlq8xymLnjCbSLZ49kPmk8iyyizND
# IXj//cOgrY7rlRyTlaCCfw7aSUROwnu7zER6EaJ+AliL7ojTdS5PWPsWeupWs7Np
# ChUk555K096V1hE0yZIXe+giAwW00aHzrDchIc2bQhpp0IoKRR7YufAkprxMiXAJ
# Q1XCmnCfgPf8+3mnAgMBAAGjggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQW
# BBTkO/zyMe39/dfzkXFjGVBDz2GM6DAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW
# 9i/USezLTjAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgw
# gZUGCCsGAQUFBwEBBIGIMIGFMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wXQYIKwYBBQUHMAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1
# Q0ExLmNydDBfBgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAy
# NUNBMS5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqG
# SIb3DQEBCwUAA4ICAQBlKq3xHCcEua5gQezRCESeY0ByIfjk9iJP2zWLpQq1b4UR
# GnwWBdEZD9gBq9fNaNmFj6Eh8/YmRDfxT7C0k8FUFqNh+tshgb4O6Lgjg8K8elC4
# +oWCqnU/ML9lFfim8/9yJmZSe2F8AQ/UdKFOtj7YMTmqPO9mzskgiC3QYIUP2S3H
# QvHG1FDu+WUqW4daIqToXFE/JQ/EABgfZXLWU0ziTN6R3ygQBHMUBaB5bdrPbF6M
# RYs03h4obEMnxYOX8VBRKe1uNnzQVTeLni2nHkX/QqvXnNb+YkDFkxUGtMTaiLR9
# wjxUxu2hECZpqyU1d0IbX6Wq8/gVutDojBIFeRlqAcuEVT0cKsb+zJNEsuEB7O7/
# cuvTQasnM9AWcIQfVjnzrvwiCZ85EE8LUkqRhoS3Y50OHgaY7T/lwd6UArb+BOVA
# kg2oOvol/DJgddJ35XTxfUlQ+8Hggt8l2Yv7roancJIFcbojBcxlRcGG0LIhp6Gv
# ReQGgMgYxQbV1S3CrWqZzBt1R9xJgKf47CdxVRd/ndUlQ05oxYy2zRWVFjF7mcr4
# C34Mj3ocCVccAvlKV9jEnstrniLvUxxVZE/rptb7IRE2lskKPIJgbaP5t2nGj/UL
# Li49xTcBZU8atufk+EMF/cWuiC7POGT75qaL6vdCvHlshtjdNXOCIUjsarfNZzGC
# BRswggUXAgEBMD8wKzEpMCcGA1UEAwwgTG9jYWwgUG93ZXJTaGVsbCBTY3JpcHRz
# IC0gamtvd2ECEFKPFDUag5mOQ9tZu6lPNhIwDQYJYIZIAWUDBAIBBQCggYQwGAYK
# KwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
# BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg
# CM/OHdoRmeWx8JGuKrU9uzwZp+tknn0tjvCtPmjBNm0wDQYJKoZIhvcNAQEBBQAE
# ggEAGeJegTxcquCde+8yIYFFJaPnC1H90KWVNxPnQW0UWaDH8igGDvyE6N/yhHL5
# O2cvFhRt8nclzSoI69hU7jw+p9mMU3L/iVgRaUaqwQ6jG2EnaPZoKQLnAYGD9u6V
# mETO3dqZ4hxHmxGQDRPZugsAu7amVVLYOnXtq9/nuPQmKSw0z6el7N8gBazKemAM
# HRoKqZ4pMTtuAsz74wYNzou0lE395SKzH8KdIlN+gQrdMVjHjKppUPNCk4ZOK6dn
# YPcBr34Y+Y6tUpDEsphxzHMVFPmgnYJOlOkPNydF0eHBEId1/NIIUiTtX+d9aPq0
# flTHOUOXj9QexR2wVCmruTIgvaGCAyYwggMiBgkqhkiG9w0BCQYxggMTMIIDDwIB
# ATB9MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8G
# A1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBT
# SEEyNTYgMjAyNSBDQTECEAqA7xhLjfEFgtHEdqeVdGgwDQYJYIZIAWUDBAIBBQCg
# aTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNTA4
# MTUxMzM2NTBaMC8GCSqGSIb3DQEJBDEiBCDBovsTHwOnvEokApMjwOijgtcL2Qca
# 2BVbpgZMFmhHoDANBgkqhkiG9w0BAQEFAASCAgBIxxzvFmxgWJ739yM0Uuo3NAg+
# SKBlbfwoNQc+JmM5dVWyWoUo+wyeD+jiHJYmC7Tl2oC7hyFPR63sTlxBwmxEFufG
# GhYwUvEBBUOPAeusg1xmoKTGEOcQdrRvN2eIv0x3Xat5Zds8aAjCc8OtlpWiezp9
# uFtZoxqapu3a5DeLHoMPwXSlRd98x5eqLybckM9MbFQCZB22DgxjVpjVThUyhMp0
# hvWHrAR7Y8m8+5qbyU7OMXv8MSAXGkUCTvcY3ycU4+i4+9cYxIGEc+gQTSI/xA8r
# ZG0KY9yKdVD0mR6HZbEIlT/TTYtdFyP8FKrp0kvJEkZA6siVkUoppFze10RZQTjg
# FZbdlrC/g1KkTa0I0N93o+Y7xZwKBHtMcnFYI3fAHjXhqKopGpYLUKoWeSmS/VYb
# GLA9/k9shbluXfJF7nt4cOay2pt/qtSTbgx1MLm2W33Mi5I3E71Lxxtq2xilg8kv
# 6CNH5BvbWMoQNCv33cztc10igrmEwI+mqhpL6HDOXJ2LW25M1IhfaiRG8irYKIad
# PBmBERdVh5XiuJCdMHx5mRskgfR71nR83CAqtUSHs7QOq77BeKioGkhPZYTzpwPA
# 4XCg5gJ8NOLoFXS2P24F8Z9RtPy7z/bp9H6hAyNZ/ihGKBnwWr2dhqg9nyFGLzz/
# PK0HxQ593zp2qXD9lg==
# SIG # End signature block
