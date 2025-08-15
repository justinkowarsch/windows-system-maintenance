# Configuration.Simple.Tests.ps1
# Simple unit tests for configuration system (Pester v3.4.0 compatible)

Describe "Configuration System" {
    Context "Default Configuration Loading" {
        It "Should load default configuration file" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $defaultConfigPath | Should Exist
        }
        
        It "Should have valid JSON structure" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            { Get-Content $defaultConfigPath | ConvertFrom-Json } | Should Not Throw
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
        It "Should have EnableRegistryBackup flag" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            $config.FeatureFlags.EnableRegistryBackup | Should BeOfType [bool]
        }
        
        It "Should have EnableProgressIndicators flag" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            $config.FeatureFlags.EnableProgressIndicators | Should BeOfType [bool]
        }
        
        It "Should have EnableRetryLogic flag" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            $config.FeatureFlags.EnableRetryLogic | Should BeOfType [bool]
        }
    }
    
    Context "Safety Limits Validation" {
        It "Should have valid RetryDelaySeconds" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            [int]$config.SafetyLimits.RetryDelaySeconds | Should BeGreaterThan 0
        }
        
        It "Should have valid MaxCleanupSizeMB" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            [int]$config.SafetyLimits.MaxCleanupSizeMB | Should BeGreaterThan 0
        }
        
        It "Should have valid MaxRetryAttempts" {
            $defaultConfigPath = "$PSScriptRoot\..\..\config\maintenance-config.default.json"
            $config = Get-Content $defaultConfigPath | ConvertFrom-Json
            [int]$config.SafetyLimits.MaxRetryAttempts | Should BeGreaterThan 0
            [int]$config.SafetyLimits.MaxRetryAttempts | Should BeLessThan 11
        }
    }
}

Describe "Configuration Schema Validation" {
    Context "JSON Schema File" {
        It "Should have configuration schema file" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            $schemaPath | Should Exist
        }
        
        It "Should have valid schema JSON structure" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            { Get-Content $schemaPath | ConvertFrom-Json } | Should Not Throw
        }
        
        It "Should define schema properties" {
            $schemaPath = "$PSScriptRoot\..\..\config\maintenance-config.schema.json"
            $schema = Get-Content $schemaPath | ConvertFrom-Json
            
            $schema.properties | Should Not BeNullOrEmpty
            $schema.properties.Notifications | Should Not BeNullOrEmpty
            $schema.properties.FeatureFlags | Should Not BeNullOrEmpty
        }
    }
}