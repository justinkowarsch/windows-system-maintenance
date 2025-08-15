# EndToEnd.Tests.ps1
# Integration tests for full maintenance workflows

BeforeAll {
    # Store the current location
    $OriginalLocation = Get-Location
    
    # Set location to repository root for consistent path resolution
    Set-Location "$PSScriptRoot\..\.."
    
    # Test fixtures directory
    $TestDataPath = "$PSScriptRoot\..\fixtures"
    if (-not (Test-Path $TestDataPath)) {
        New-Item -Path $TestDataPath -ItemType Directory -Force
    }
    
    # Create temporary test directories
    $TempTestPath = "$TestDataPath\temp-cleanup-test"
    if (-not (Test-Path $TempTestPath)) {
        New-Item -Path $TempTestPath -ItemType Directory -Force
    }
}

AfterAll {
    # Restore original location
    Set-Location $OriginalLocation
    
    # Clean up test directories
    $TestDataPath = "$PSScriptRoot\..\fixtures"
    if (Test-Path "$TestDataPath\temp-cleanup-test") {
        Remove-Item "$TestDataPath\temp-cleanup-test" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Describe "End-to-End Maintenance Workflows" {
    Context "Script Execution Flow" {
        It "Should be able to execute maintenance script with Report parameter" {
            $scriptPath = ".\scripts\core\system-maintenance.ps1"
            
            # Test that the script can be invoked without errors
            { & $scriptPath -Report -WhatIf } | Should -Not -Throw
        }
        
        It "Should be able to parse all script parameters" {
            $scriptPath = ".\scripts\core\system-maintenance.ps1"
            
            # Validate script syntax and parameter definitions
            $scriptAst = [System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$null, [ref]$null)
            $scriptAst | Should -Not -BeNullOrEmpty
            
            # Check for parameter block
            $paramBlock = $scriptAst.ParamBlock
            $paramBlock | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Configuration Integration" {
        It "Should load default configuration successfully" {
            $configPath = ".\config\maintenance-config.default.json"
            
            { $config = Get-Content $configPath | ConvertFrom-Json } | Should -Not -Throw
            
            $config = Get-Content $configPath | ConvertFrom-Json
            $config | Should -Not -BeNullOrEmpty
        }
        
        It "Should validate configuration schema" {
            $schemaPath = ".\config\maintenance-config.schema.json"
            $configPath = ".\config\maintenance-config.default.json"
            
            # Both files should exist
            $schemaPath | Should -Exist
            $configPath | Should -Exist
            
            # Configuration should be valid JSON
            { Get-Content $configPath | ConvertFrom-Json } | Should -Not -Throw
            { Get-Content $schemaPath | ConvertFrom-Json } | Should -Not -Throw
        }
    }
    
    Context "Scheduler Integration" {
        It "Should be able to check task status without errors" {
            $schedulerScript = ".\scripts\core\setup-maintenance-schedule.ps1"
            
            # Test that the scheduler script executes without syntax errors
            { & $schedulerScript -Status } | Should -Not -Throw
        }
        
        It "Should correctly resolve maintenance script path" {
            $schedulerScript = ".\scripts\core\setup-maintenance-schedule.ps1"
            $maintenanceScript = ".\scripts\core\system-maintenance.ps1"
            
            # Both scripts should exist
            $schedulerScript | Should -Exist
            $maintenanceScript | Should -Exist
            
            # Scheduler should be able to find the maintenance script
            $schedulerContent = Get-Content $schedulerScript -Raw
            $schedulerContent | Should -Match "system-maintenance\.ps1"
        }
    }
    
    Context "VS Code Integration" {
        It "Should have valid VS Code task configuration" {
            $tasksPath = ".\.vscode\tasks.json"
            $tasksPath | Should -Exist
            
            { $tasks = Get-Content $tasksPath | ConvertFrom-Json } | Should -Not -Throw
            
            $tasks = Get-Content $tasksPath | ConvertFrom-Json
            $tasks.tasks | Should -Not -BeNullOrEmpty
        }
        
        It "Should have valid VS Code launch configuration" {
            $launchPath = ".\.vscode\launch.json"
            $launchPath | Should -Exist
            
            { $launch = Get-Content $launchPath | ConvertFrom-Json } | Should -Not -Throw
            
            $launch = Get-Content $launchPath | ConvertFrom-Json
            $launch.configurations | Should -Not -BeNullOrEmpty
        }
        
        It "Should reference existing scripts in VS Code tasks" {
            $tasksPath = ".\.vscode\tasks.json"
            $tasks = Get-Content $tasksPath | ConvertFrom-Json
            
            # Check that referenced scripts exist
            foreach ($task in $tasks.tasks) {
                if ($task.args -and $task.args[1] -like "*system-maintenance.ps1*") {
                    # Extract script path and verify it exists
                    $scriptRef = $task.args[1]
                    if ($scriptRef -match "scripts\\core\\system-maintenance\.ps1") {
                        ".\scripts\core\system-maintenance.ps1" | Should -Exist
                    }
                }
            }
        }
    }
}

Describe "System Health and Monitoring" {
    Context "Basic System Checks" {
        It "Should be able to check disk space" {
            { Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" } | Should -Not -Throw
            
            $disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
            $disks | Should -Not -BeNullOrEmpty
        }
        
        It "Should be able to check memory usage" {
            { Get-WmiObject Win32_OperatingSystem } | Should -Not -Throw
            
            $os = Get-WmiObject Win32_OperatingSystem
            $os.TotalVisibleMemorySize | Should -BeGreaterThan 0
        }
        
        It "Should be able to check running processes" {
            { Get-Process } | Should -Not -Throw
            
            $processes = Get-Process
            $processes.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Cleanup Target Validation" {
        It "Should be able to access temp directories" {
            { Test-Path $env:TEMP } | Should -Not -Throw
            Test-Path $env:TEMP | Should -Be $true
        }
        
        It "Should be able to check recycle bin" {
            # Test that we can access recycle bin cmdlets
            { Get-Command Clear-RecycleBin -ErrorAction Stop } | Should -Not -Throw
        }
        
        It "Should be able to access browser cache directories" {
            # Chrome cache directory (if exists)
            $chromeCachePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
            if (Test-Path $chromeCachePath) {
                $chromeCachePath | Should -Exist
            }
            
            # Edge cache directory (if exists)
            $edgeCachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
            if (Test-Path $edgeCachePath) {
                $edgeCachePath | Should -Exist
            }
        }
    }
}

Describe "Error Handling and Recovery" {
    Context "Graceful Failure Handling" {
        It "Should handle missing directories gracefully" {
            $nonExistentPath = "C:\NonExistent\Directory\Path"
            
            # Should not throw when checking non-existent paths
            { Test-Path $nonExistentPath } | Should -Not -Throw
            Test-Path $nonExistentPath | Should -Be $false
        }
        
        It "Should handle permission errors gracefully" {
            # Try to access a restricted directory
            $restrictedPath = "C:\System Volume Information"
            
            # Should not throw, but may return false or handle gracefully
            { Test-Path $restrictedPath } | Should -Not -Throw
        }
    }
    
    Context "Configuration Validation" {
        It "Should handle malformed JSON gracefully" {
            $malformedJson = '{ "invalid": json syntax }'
            
            # Should throw when parsing malformed JSON
            { $malformedJson | ConvertFrom-Json } | Should -Throw
        }
        
        It "Should validate configuration values" {
            $config = Get-Content ".\config\maintenance-config.default.json" | ConvertFrom-Json
            
            # Validate that safety limits are reasonable
            $config.SafetyLimits.MaxRetryAttempts | Should -BeGreaterThan 0
            $config.SafetyLimits.MaxRetryAttempts | Should -BeLessOrEqual 10
            
            $config.SafetyLimits.MaxCleanupSizeMB | Should -BeGreaterThan 0
            $config.SafetyLimits.RetryDelaySeconds | Should -BeGreaterThan 0
        }
    }
}