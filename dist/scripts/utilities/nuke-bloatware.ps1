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
# SIG # Begin signature block
# MIIcKQYJKoZIhvcNAQcCoIIcGjCCHBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCttS5PwGHn3yNk
# Wu4xECzAc+S2EpK29zJxbT1GCsYmv6CCFmQwggMmMIICDqADAgECAhBSjxQ1GoOZ
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
# tQtRIVaAuWKkzdsrvKZNdanJy30tJrQ1xT5Wq5ymx2owDQYJKoZIhvcNAQEBBQAE
# ggEAbOHw/BGXr1NZ3T4HS5sKZR8vWGKW22FJZWFpmS+AjSu2JGU6Zl+TLvhP72hd
# JWctVi7CDTq/FtH4Rt+ZfZ6Wgrr81u/nIdixAyCKVM9W9Y0GOE5mmJmW0E6PDfQP
# EK8Fq6LZd3v5h1p9LzjWBDBBT05l8OS/nuitAt8lZ9RSReq/boOEQAtbXWK/fXEx
# 4XouEEgHNchXj0GUAJ7YIvpjM8rJZw/FMh1OqxmES4usolFPiKmsRKjT+b2CTKPi
# FVdLD+P1w8Fsp6ZJs0w9Y9P3TIGNiK71RZIPdPMWE2ArXKWPI7A/YjkVeR62RqI0
# kBGs+GhTipnkK61QRSpVonf3uKGCAyYwggMiBgkqhkiG9w0BCQYxggMTMIIDDwIB
# ATB9MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8G
# A1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBT
# SEEyNTYgMjAyNSBDQTECEAqA7xhLjfEFgtHEdqeVdGgwDQYJYIZIAWUDBAIBBQCg
# aTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNTA4
# MTUxMzM2NTFaMC8GCSqGSIb3DQEJBDEiBCAEbp1UpdNkRgek8x0ihN5OeMeUeRr9
# 2kuQcWV+bj+DsjANBgkqhkiG9w0BAQEFAASCAgDAFKn/fJDesL08ba+ZQyjUznc9
# WOBVQVKAckpzEq3sxO3VMu9PHL97ybKZQBg647JTGegBVhowcjGK3nZfOos0jFNO
# r8nEACynhFlcd6rXhbKNd0MVxPAH+/GDlK8ClsHHDvhc76SWYZ8xMkO/kdE5GyCW
# S5wm+OfdzIUSroxew2OwHp2QN5Xods7n7iq8/N2/0BKpRDRHXfsRxn11D/k9nQYF
# NA7qTQ4drbtxRvHBbTxokubV42gUfjWK057pWA0Omykxk5F0nK7LbCqJ56vykUAm
# Bnhchmti51G+OuuPtTn02P2JTI2WbwlUKhZkayokvuh5bf1cz8J1mozfkbRI/jCZ
# cAyp5gqPovHJUNWOs2Hh7hGS2JZImZPzRv9WwLYLaWlC4l9EMwBpaI6qHu46iPfe
# ALYuNuXoTj3EyN/PqeQ+zpmPxqfKfkXcRGwSN8/mIHRKwjx/RcewLWxo8njtbTQZ
# Oqo5EvbgvFAgL7hHPPeuDT5t/Lz/Kzt1nGsqyeWqhen2TH8IJW7FiXyWmxHVObzO
# xi3ZyzWDykDW4fdp/Tfv/g62E1LY8f7iudxgLhYcaLMNslXSWNXuY/KHgl9dCVBH
# VKQ+SYZiwlwwfouogX1aot/k9P6WdRk9mQBC300rUQxKs2Bx1jsQDoNhLRBbUOcH
# iK7y3jyhTaQCKoXRkg==
# SIG # End signature block
