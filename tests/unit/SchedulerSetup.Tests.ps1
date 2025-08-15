# SchedulerSetup.Tests.ps1
# Unit tests for maintenance scheduler functionality

BeforeAll {
    # Store the current location
    $OriginalLocation = Get-Location
    
    # Change to the script directory for relative path resolution
    Set-Location "$PSScriptRoot\..\..\scripts\core"
    
    # Import the scheduler script
    try {
        . ".\setup-maintenance-schedule.ps1"
    }
    catch {
        Write-Warning "Could not import setup-maintenance-schedule.ps1: $_"
    }
}

AfterAll {
    # Restore original location
    Set-Location $OriginalLocation
}

Describe "Maintenance Scheduler Setup" {
    Context "Script Structure and Parameters" {
        It "Should have the scheduler script file" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $schedulerPath | Should -Exist
        }
        
        It "Should define Install parameter" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$Install"
        }
        
        It "Should define Remove parameter" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$Remove"
        }
        
        It "Should define Status parameter" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$Status"
        }
    }
    
    Context "Path Resolution" {
        It "Should correctly resolve script path using PSScriptRoot" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should use PSScriptRoot, not USERPROFILE
            $scriptContent | Should -Match '\$PSScriptRoot'
            $scriptContent | Should -Not -Match 'Join-Path \$env:USERPROFILE'
        }
        
        It "Should point to the correct maintenance script location" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should reference system-maintenance.ps1 in the same directory
            $scriptContent | Should -Match 'system-maintenance\.ps1'
        }
        
        It "Should resolve to an existing maintenance script" {
            # The path should resolve to the actual system-maintenance.ps1 file
            $expectedPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $expectedPath | Should -Exist
        }
    }
    
    Context "Function Definitions" {
        It "Should define Test-AdminRights function" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "function Test-AdminRights"
        }
        
        It "Should define Install-MaintenanceTasks function" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "function Install-MaintenanceTasks"
        }
        
        It "Should define Remove-MaintenanceTasks function" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "function Remove-MaintenanceTasks"
        }
        
        It "Should define Show-TaskStatus function" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match "function Show-TaskStatus"
        }
    }
    
    Context "Task Configuration" {
        It "Should define TaskPrefix variable" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            $scriptContent | Should -Match '\$TaskPrefix\s*=\s*"SystemMaintenance"'
        }
        
        It "Should reference multiple maintenance tasks" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should reference different types of maintenance tasks
            $scriptContent | Should -Match "DailyCleanup"
            $scriptContent | Should -Match "WeeklyFull"
            $scriptContent | Should -Match "GameOptimize"
        }
    }
}

Describe "Scheduled Task Management" {
    Context "Admin Rights Check" {
        It "Should have Test-AdminRights function that returns boolean" {
            if (Get-Command Test-AdminRights -ErrorAction SilentlyContinue) {
                $result = Test-AdminRights
                $result | Should -BeOfType [bool]
            } else {
                Set-ItResult -Skipped -Because "Test-AdminRights function not available in current scope"
            }
        }
    }
    
    Context "Task Installation Logic" {
        It "Should check for script existence before creating tasks" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should validate script exists before proceeding
            $scriptContent | Should -Match "Test-Path.*\$ScriptPath"
        }
        
        It "Should use PowerShell.exe for task execution" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should use PowerShell.exe in task actions
            $scriptContent | Should -Match "PowerShell\.exe"
        }
        
        It "Should include proper task settings" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should configure task settings like execution time limits
            $scriptContent | Should -Match "New-ScheduledTaskSettingsSet"
            $scriptContent | Should -Match "ExecutionTimeLimit"
        }
    }
}

Describe "Error Handling and Validation" {
    Context "Script Validation" {
        It "Should handle missing maintenance script gracefully" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should include error handling for missing script
            $scriptContent | Should -Match "ERROR.*script.*not found"
        }
        
        It "Should include try-catch blocks for error handling" {
            $schedulerPath = "$PSScriptRoot\..\..\scripts\core\setup-maintenance-schedule.ps1"
            $scriptContent = Get-Content $schedulerPath -Raw
            
            # Should have proper error handling
            $scriptContent | Should -Match "try\s*\{"
            $scriptContent | Should -Match "catch\s*\{"
        }
    }
}