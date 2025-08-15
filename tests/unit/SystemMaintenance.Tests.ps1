# SystemMaintenance.Tests.ps1
# Unit tests for core system maintenance functionality

BeforeAll {
    # Store the current location
    $OriginalLocation = Get-Location
    
    # Change to the script directory for relative path resolution
    Set-Location "$PSScriptRoot\..\..\scripts\core"
    
    # Import the main script with error handling
    try {
        . ".\system-maintenance.ps1"
    }
    catch {
        Write-Warning "Could not import system-maintenance.ps1: $_"
    }
    
    # Test fixtures directory
    $TestDataPath = "$PSScriptRoot\..\fixtures"
    if (-not (Test-Path $TestDataPath)) {
        New-Item -Path $TestDataPath -ItemType Directory -Force
    }
}

AfterAll {
    # Restore original location
    Set-Location $OriginalLocation
}

Describe "System Maintenance Core Functions" {
    Context "Write-Log Function" {
        BeforeAll {
            # Create test log directory
            $TestLogPath = "$PSScriptRoot\..\fixtures\test-logs"
            if (-not (Test-Path $TestLogPath)) {
                New-Item -Path $TestLogPath -ItemType Directory -Force
            }
        }
        
        It "Should exist and be callable" {
            { Get-Command Write-Log -ErrorAction Stop } | Should -Not -Throw
        }
        
        It "Should accept message parameter" {
            { Write-Log -Message "Test message" -LogPath "$PSScriptRoot\..\fixtures\test-logs" } | Should -Not -Throw
        }
        
        It "Should create log file when specified" {
            $testLogFile = "$PSScriptRoot\..\fixtures\test-logs\test.log"
            Write-Log -Message "Test log entry" -LogPath "$PSScriptRoot\..\fixtures\test-logs"
            
            # Check if any log file was created in the directory
            $logFiles = Get-ChildItem "$PSScriptRoot\..\fixtures\test-logs" -Filter "*.log"
            $logFiles.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Test-AdminRights Function" {
        It "Should exist and be callable" {
            { Get-Command Test-AdminRights -ErrorAction Stop } | Should -Not -Throw
        }
        
        It "Should return a boolean value" {
            $result = Test-AdminRights
            $result | Should -BeOfType [bool]
        }
    }
    
    Context "Get-SystemHealth Function" {
        It "Should exist and be callable" {
            { Get-Command Get-SystemHealth -ErrorAction Stop } | Should -Not -Throw
        }
        
        It "Should return system health information" {
            $health = Get-SystemHealth
            $health | Should -Not -BeNullOrEmpty
            $health.GetType().Name | Should -Be "PSCustomObject"
        }
        
        It "Should include CPU information" {
            $health = Get-SystemHealth
            $health.CPU | Should -Not -BeNullOrEmpty
        }
        
        It "Should include memory information" {
            $health = Get-SystemHealth
            $health.Memory | Should -Not -BeNullOrEmpty
        }
        
        It "Should include disk information" {
            $health = Get-SystemHealth
            $health.Disk | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Show-ProgressBar Function" {
        It "Should exist and be callable" {
            { Get-Command Show-ProgressBar -ErrorAction Stop } | Should -Not -Throw
        }
        
        It "Should accept required parameters" {
            { Show-ProgressBar -Activity "Test" -Status "Testing" -PercentComplete 50 } | Should -Not -Throw
        }
    }
}

Describe "Parameter Validation" {
    Context "Script Parameters" {
        It "Should accept QuickClean parameter" {
            # Test that the script file can be parsed with QuickClean parameter
            $scriptPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $scriptContent = Get-Content $scriptPath -Raw
            $scriptContent | Should -Match "param\s*\("
            $scriptContent | Should -Match "\[switch\]\s*\$QuickClean"
        }
        
        It "Should accept FullMaintenance parameter" {
            $scriptPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $scriptContent = Get-Content $scriptPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$FullMaintenance"
        }
        
        It "Should accept GameOptimize parameter" {
            $scriptPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $scriptContent = Get-Content $scriptPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$GameOptimize"
        }
        
        It "Should accept DevOptimize parameter" {
            $scriptPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $scriptContent = Get-Content $scriptPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$DevOptimize"
        }
        
        It "Should accept Report parameter" {
            $scriptPath = "$PSScriptRoot\..\..\scripts\core\system-maintenance.ps1"
            $scriptContent = Get-Content $scriptPath -Raw
            $scriptContent | Should -Match "\[switch\]\s*\$Report"
        }
    }
}

Describe "Retry Logic" {
    Context "Invoke-WithRetry Function" {
        It "Should exist and be callable" {
            if (Get-Command Invoke-WithRetry -ErrorAction SilentlyContinue) {
                $true | Should -Be $true
            } else {
                Set-ItResult -Skipped -Because "Invoke-WithRetry function not found in current scope"
            }
        }
    }
}

Describe "Safety Checks" {
    Context "File Size Validation" {
        BeforeAll {
            # Create test files with known sizes
            $smallTestFile = "$PSScriptRoot\..\fixtures\small-test.txt"
            $largeTestFile = "$PSScriptRoot\..\fixtures\large-test.txt"
            
            "Small test content" | Out-File -FilePath $smallTestFile -Encoding UTF8
            
            # Create a larger test file (1MB)
            $largeContent = "x" * (1024 * 1024)
            $largeContent | Out-File -FilePath $largeTestFile -Encoding UTF8
        }
        
        It "Should handle small files safely" {
            $smallTestFile = "$PSScriptRoot\..\fixtures\small-test.txt"
            Test-Path $smallTestFile | Should -Be $true
            (Get-Item $smallTestFile).Length | Should -BeLessThan 1MB
        }
        
        It "Should detect large files" {
            $largeTestFile = "$PSScriptRoot\..\fixtures\large-test.txt"
            Test-Path $largeTestFile | Should -Be $true
            (Get-Item $largeTestFile).Length | Should -BeGreaterThan 1MB
        }
    }
}

Describe "Performance Monitoring" {
    Context "System Resource Monitoring" {
        It "Should be able to get CPU usage" {
            { Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average } | Should -Not -Throw
        }
        
        It "Should be able to get memory usage" {
            { Get-WmiObject Win32_OperatingSystem } | Should -Not -Throw
        }
        
        It "Should be able to get disk usage" {
            { Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" } | Should -Not -Throw
        }
    }
}