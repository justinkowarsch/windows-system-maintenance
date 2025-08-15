# Configuration.Tests.ps1
# Unit tests for configuration system validation

Describe "Configuration System" {
    Context "Default Configuration Loading" {
        It "Should load default configuration file" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $defaultConfigPath | Should -Exist
        }
        
        It "Should have valid JSON structure" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            { Get-Content $defaultConfigPath | ConvertFrom-Json } | Should -Not -Throw
        }
        
        It "Should contain required configuration sections" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            
            $config.Notifications | Should Not BeNullOrEmpty
            $config.FeatureFlags | Should Not BeNullOrEmpty
            $config.Logging | Should Not BeNullOrEmpty
            $config.SafetyLimits | Should Not BeNullOrEmpty
            $config.SmartScheduling | Should Not BeNullOrEmpty
        }
    }
    
    Context "Feature Flags Validation" {
        BeforeAll {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
        }
        
        It "Should have EnableRegistryBackup flag" {
            $config.FeatureFlags.EnableRegistryBackup | Should -BeOfType [bool]
        }
        
        It "Should have EnableProgressIndicators flag" {
            $config.FeatureFlags.EnableProgressIndicators | Should -BeOfType [bool]
        }
        
        It "Should have EnableRetryLogic flag" {
            $config.FeatureFlags.EnableRetryLogic | Should -BeOfType [bool]
        }
        
        It "Should have EnableSafetyChecks flag" {
            $config.FeatureFlags.EnableSafetyChecks | Should -BeOfType [bool]
        }
        
        It "Should have EnablePerformanceMonitoring flag" {
            $config.FeatureFlags.EnablePerformanceMonitoring | Should -BeOfType [bool]
        }
    }
    
    Context "Safety Limits Validation" {
        BeforeAll {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
        }
        
        It "Should have valid RetryDelaySeconds" {
            $config.SafetyLimits.RetryDelaySeconds | Should -BeOfType [int]
            $config.SafetyLimits.RetryDelaySeconds | Should -BeGreaterThan 0
        }
        
        It "Should have valid MaxCleanupSizeMB" {
            $config.SafetyLimits.MaxCleanupSizeMB | Should -BeOfType [int]
            $config.SafetyLimits.MaxCleanupSizeMB | Should -BeGreaterThan 0
        }
        
        It "Should have valid MaxRetryAttempts" {
            $config.SafetyLimits.MaxRetryAttempts | Should -BeOfType [int]
            $config.SafetyLimits.MaxRetryAttempts | Should -BeGreaterThan 0
            $config.SafetyLimits.MaxRetryAttempts | Should -BeLessOrEqual 10
        }
    }
    
    Context "Smart Scheduling Validation" {
        BeforeAll {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
        }
        
        It "Should have valid CPU usage threshold" {
            $config.SmartScheduling.MaxCpuUsageThreshold | Should -BeOfType [int]
            $config.SmartScheduling.MaxCpuUsageThreshold | Should -BeGreaterThan 0
            $config.SmartScheduling.MaxCpuUsageThreshold | Should -BeLessOrEqual 100
        }
        
        It "Should have valid memory usage threshold" {
            $config.SmartScheduling.MaxMemoryUsageThreshold | Should -BeOfType [int]
            $config.SmartScheduling.MaxMemoryUsageThreshold | Should -BeGreaterThan 0
            $config.SmartScheduling.MaxMemoryUsageThreshold | Should -BeLessOrEqual 100
        }
    }
}

Describe "Configuration Schema Validation" {
    Context "JSON Schema File" {
        It "Should have configuration schema file" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            $schemaPath | Should -Exist
        }
        
        It "Should have valid schema JSON structure" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            { Get-Content $schemaPath | ConvertFrom-Json } | Should -Not -Throw
        }
        
        It "Should define schema properties" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            $schema = Get-Content $schemaPath | ConvertFrom-Json
            
            $schema.properties | Should -Not -BeNullOrEmpty
            $schema.properties.Notifications | Should -Not -BeNullOrEmpty
            $schema.properties.FeatureFlags | Should -Not -BeNullOrEmpty
        }
    }
}