# Windows System Maintenance - Claude Code Instructions

*Professional PowerShell system maintenance suite with enterprise features*

## 🎯 Project Overview

This is a **production-grade Windows 11 system maintenance framework** designed for gaming/coding workstations. Features include enhanced retry logic, HP Service Guardian, smart scheduling, and comprehensive logging.

**Target System:** HP OMEN Gaming Laptop (RTX 4070, 32GB RAM, 1TB SSD)
**Version:** 2.0.0 (Semantic Versioning)

---

## 🚀 Development Commands

### Core Operations
```powershell
# Test maintenance functionality
.\scripts\core\system-maintenance.ps1 -QuickClean
.\scripts\core\system-maintenance.ps1 -Report

# HP Service Guardian
.\scripts\utilities\nuke-bloatware.ps1

# Scheduler management  
.\scripts\core\setup-maintenance-schedule.ps1 -Status
```

### Development Workflow
```powershell
# Run tests (Pester framework)
Invoke-Pester -Path .\tests

# Build and validate
.\build\Build-Scripts.ps1
.\build\Sign-Scripts.ps1

# Check configuration
Get-Content .\config\maintenance-config.default.json | ConvertFrom-Json
```

---

## 📁 Architecture

### Directory Structure
- **`scripts/core/`** - Main maintenance scripts (system-maintenance.ps1, scheduler)
- **`scripts/utilities/`** - Supporting tools (bloatware removal, HP monitoring) 
- **`scripts/profile/`** - PowerShell profile management
- **`config/`** - Configuration templates and defaults
- **`data/`** - Runtime data (logs, reports, backups) - gitignored
- **`docs/`** - Professional documentation
- **`tests/`** - Pester unit and integration tests
- **`build/`** - Build, signing, and packaging scripts

### Key Components
1. **Enhanced Retry Logic** - 3-attempt cleanup with progressive delays
2. **HP Service Guardian** - Automatic bloatware service monitoring
3. **Smart Scheduling** - Usage-aware maintenance timing
4. **Comprehensive Logging** - File-based logs with audit trails
5. **Safety Systems** - Registry backup and rollback capabilities

---

## 🔧 Configuration System

### Configuration Files
- **Default Config**: `config/maintenance-config.default.json` (version controlled)
- **User Config**: `$env:LOCALAPPDATA\WindowsSystemMaintenance\config.json` (personal)

### Feature Flags
- `EnableProgressIndicators`: Real-time progress bars
- `EnablePerformanceMonitoring`: Before/after system health checks
- `EnableRetryLogic`: Enhanced retry with individual file cleanup
- `EnableSafetyChecks`: File size limits and validation
- `EnableRegistryBackup`: Registry operation safety

---

## 🧪 Testing

### Test Categories
```powershell
# Unit tests
Invoke-Pester -Path .\tests\unit\

# Integration tests  
Invoke-Pester -Path .\tests\integration\

# Specific test suites
Invoke-Pester -Path .\tests\unit\SystemMaintenance.Tests.ps1
Invoke-Pester -Path .\tests\unit\HPServiceGuardian.Tests.ps1
```

### Test Coverage
- System requirement validation
- Configuration loading and validation
- Retry logic with simulated failures
- HP service detection and management
- Logging system functionality
- Safety checks and file validation

---

## 🛡️ Security & Safety

### Code Signing
- Scripts are digitally signed with local certificates
- Signature validation before execution
- Certificate management in build pipeline

### Safety Features
- **Registry Backup**: Automatic backup before registry changes
- **Rollback System**: Full rollback capability for all changes
- **Safety Limits**: Configurable file size and operation limits
- **Dependency Validation**: System requirements checked before execution

### Security Validation
```powershell
# Verify signatures
Get-AuthenticodeSignature .\scripts\core\*.ps1

# Check certificates
Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert

# Validate permissions
Test-Path $env:TEMP -PathType Container
```

---

## 📊 Monitoring & Logging

### Log Locations
- **Maintenance Logs**: `data\logs\maintenance-*.log`
- **System Reports**: `data\reports\system-health-*.json`
- **Operation History**: `data\logs\cleanup-history.json`

### Health Monitoring
```powershell
# View recent operations
Get-Content "data\logs\maintenance-*.log" | Select-Object -Last 20

# System health trends
.\scripts\core\system-maintenance.ps1 -Report

# HP Service status
Get-Service | Where-Object { $_.Name -like "*HP*" } | Select-Object Name, Status, StartType
```

---

## 🚀 Performance Optimizations

### Gaming Workstation Tuning
- **RTX 4070 Optimization**: GPU-aware cleanup and optimization
- **32GB RAM Management**: Memory-efficient operations for high-RAM systems  
- **SSD Optimization**: TRIM-based operations, avoids defragmentation
- **Gaming Mode Integration**: Windows Game Mode and power plan optimization

### Development Environment
- **Node.js Cache Management**: Automated npm, yarn cache cleanup
- **Browser Cache Cleanup**: Chrome, Edge, Firefox development cache management
- **Docker Integration**: Container and image cleanup (if installed)
- **.NET Cleanup**: Temporary file and cache management

---

## 📋 Common Tasks

### Maintenance Operations
```powershell
# Quick cleanup (most common)
.\scripts\core\system-maintenance.ps1 -QuickClean

# Full maintenance (weekly)
.\scripts\core\system-maintenance.ps1 -FullMaintenance

# Gaming optimization
.\scripts\core\system-maintenance.ps1 -GameOptimize

# Development cleanup
.\scripts\core\system-maintenance.ps1 -DevOptimize
```

### Troubleshooting
```powershell
# System health check
.\scripts\core\system-maintenance.ps1 -Report

# HP bloatware scan
.\scripts\utilities\nuke-bloatware.ps1

# Check scheduled tasks
.\scripts\core\setup-maintenance-schedule.ps1 -Status

# View error logs
Get-Content "data\logs\maintenance-*.log" | Where-Object { $_ -like "*ERROR*" }
```

---

## 🔄 Integration

### PowerShell Profile Integration
The system integrates with PowerShell 7 profile at:
`C:\Users\jkowa\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

**Profile Aliases:**
- `qc` → Quick-Clean
- `fm` → Full-Maintenance  
- `go` → Game-Optimize
- `dev` → Dev-Optimize
- `sr` → System-Report
- `hpchk` → HP Service Guardian

### Scheduled Task Integration
```powershell
# Install automated scheduling
.\scripts\core\setup-maintenance-schedule.ps1 -Install

# Tasks created:
# - Daily Cleanup (7:00 AM)
# - Gaming Optimize (On startup)  
# - Dev Cleanup (Weekly Monday 6:00 AM)
# - Full Maintenance (Weekly Sunday 2:00 AM)
# - System Report (Monthly 3:00 AM)
```

---

## 🎯 Development Guidelines

### Code Standards
- **PowerShell 7.5.2** required (not legacy 5.1)
- **Error Handling**: Comprehensive try/catch with logging
- **Progress Indicators**: User feedback for long operations
- **Retry Logic**: Graceful failure handling with progressive delays
- **Configuration Driven**: Feature flags and configurable limits

### Contributing
1. **Branching**: Create feature branches for new functionality
2. **Testing**: Add Pester tests for new features
3. **Documentation**: Update relevant docs and changelog  
4. **Signing**: Ensure scripts are properly signed
5. **Validation**: Test on target system before merging

### Version Management
- **Semantic Versioning**: MAJOR.MINOR.PATCH
- **Automated Changelog**: Track features, fixes, security updates
- **Git Tags**: Tag releases with version numbers
- **Feature Tracking**: Maintain feature list in version.json

---

## 💡 Next Steps / Roadmap

### Phase 5: Advanced Monitoring
- **Performance Metrics**: Historical performance tracking
- **Predictive Maintenance**: AI-based maintenance scheduling
- **Alert System**: Proactive issue detection
- **Dashboard**: Web-based system health dashboard

### Phase 6: Multi-System Support
- **Configuration Profiles**: Different configs for different machine types
- **Remote Management**: Network-based maintenance for multiple systems
- **Backup Integration**: Cloud backup integration
- **Deployment Tools**: Automated deployment to new systems

---

*This maintenance system represents a professional-grade solution for Windows 11 gaming/coding workstations, with enterprise reliability and zero-downtime operations.*