# Windows System Maintenance

> Professional-grade PowerShell system maintenance scripts for Windows 11 gaming/coding workstations

[![PowerShell](https://img.shields.io/badge/PowerShell-7.5.2-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-11-blue.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI/CD Pipeline](https://github.com/justinkowarsch/windows-system-maintenance/actions/workflows/ci.yml/badge.svg)](https://github.com/justinkowarsch/windows-system-maintenance/actions/workflows/ci.yml)
[![Security Rating](https://img.shields.io/badge/Security-A+-green.svg)](#-security--safety)
[![GitHub release](https://img.shields.io/github/v/release/justinkowarsch/windows-system-maintenance)](https://github.com/justinkowarsch/windows-system-maintenance/releases)
[![GitHub issues](https://img.shields.io/github/issues/justinkowarsch/windows-system-maintenance)](https://github.com/justinkowarsch/windows-system-maintenance/issues)
[![GitHub stars](https://img.shields.io/github/stars/justinkowarsch/windows-system-maintenance)](https://github.com/justinkowarsch/windows-system-maintenance/stargazers)

## ✨ Features

### Core Maintenance

- **🔄 Enhanced Retry Logic**: 3-attempt cleanup with progressive delays and individual file processing
- **🛡️ HP Service Guardian**: Automatic monitoring and disabling of HP bloatware services
- **📊 Smart Scheduling**: Usage-aware maintenance timing with Windows integration
- **📝 Comprehensive Logging**: Detailed operation logs with full audit trails
- **🔒 Safety Systems**: Registry backup, rollback capabilities, and safety checks
- **⚡ Performance Optimized**: Designed for gaming/coding workstations with RTX 4070 + 32GB RAM

### 🚀 NEW: Enterprise Development Features

- **🔐 Branch Protection**: Master branch protected - PR workflow required
- **🤖 Automated CI/CD**: GitHub Actions with testing, security scanning, and releases
- **🔍 Security Scanning**: PowerShell Script Analyzer with zero-tolerance policy
- **🧪 Comprehensive Testing**: 12 Pester unit tests with automatic validation
- **📦 Automated Releases**: Semantic versioning with automated changelog generation
- **✍️ Code Signing**: All scripts digitally signed for security

## 🚀 Quick Start

### Installation

```powershell
# Clone the repository
git clone https://github.com/justinkowarsch/windows-system-maintenance.git
cd windows-system-maintenance

# Verify installation
.\build\Build.ps1 -Test    # Run tests to verify setup
```

**Alternative: Download from GitHub**

1. Visit [https://github.com/justinkowarsch/windows-system-maintenance](https://github.com/justinkowarsch/windows-system-maintenance)
2. Click **"Code" → "Download ZIP"**
3. Extract to your preferred location

### Daily Usage

```powershell
qc          # Quick cleanup with HP monitoring
fm          # Full maintenance
hpchk       # HP Service Guardian check
nordfix     # NordVPN network reset
Show-Health # System status
```

## 📁 Project Structure

```text
├── scripts/
│   ├── core/           # Main maintenance scripts
│   ├── utilities/      # Supporting utilities
│   └── profile/        # PowerShell profile management
├── config/             # Configuration files and templates
├── tools/              # Installation and migration tools
├── data/               # Runtime data (logs, reports, backups)
├── docs/               # Documentation
├── tests/              # Pester tests
└── build/              # Build and signing scripts
```

## 🔧 Configuration

The system uses a JSON configuration file with intelligent defaults:

- **Default config**: `config/maintenance-config.default.json` (version controlled)
- **User config**: `$env:LOCALAPPDATA\WindowsSystemMaintenance\config.json` (personal settings)
- **CI/CD config**: `.github/workflows/ci.yml` (automated testing pipeline)
- **Repository security**: `.github/repository-config.json` (branch protection rules)

## 🧪 Testing

### Local Testing

```powershell
# Run all tests via build system
.\build\Build.ps1 -Test

# Run tests directly
Invoke-Pester -Path .\tests\unit\Configuration.Simple.Tests.ps1
```

### Automated Testing

- **✅ Continuous Integration**: Tests run automatically on every push/PR
- **✅ Security Scanning**: PowerShell Script Analyzer validates all scripts
- **✅ Build Validation**: Automated packaging and signing verification
- **✅ Status Checks**: All tests must pass before PR can be merged

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Configuration Reference](docs/CONFIGURATION.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [API Documentation](docs/API.md)

## 🎯 System Requirements

- **OS**: Windows 11 (Build 22000+)
- **PowerShell**: 7.5.2 or higher
- **RAM**: 4GB minimum (optimized for 32GB)
- **Disk**: 1GB free space minimum

## 🛡️ Security & Safety

### Code Security

- **✅ Digital Signatures**: All scripts signed with local certificates
- **✅ Security Scanning**: PowerShell Script Analyzer in CI pipeline
- **✅ Secret Protection**: GitHub secret scanning with push protection
- **✅ Dependency Monitoring**: Automated vulnerability alerts and updates

### Operational Safety

- **✅ Registry Backup**: Automatic backup before registry changes
- **✅ Rollback System**: Comprehensive rollback for all operations
- **✅ Safety Limits**: File size and operation limits
- **✅ No Elevation**: Standard operations don't require admin rights

### Repository Security

- **🔐 Branch Protection**: Master branch locked, PR workflow required
- **👥 Code Reviews**: 1 approval required for all changes
- **🤖 Status Checks**: CI must pass (tests + security + build)
- **🔍 Admin Enforcement**: Rules apply to repository owner too

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed release history.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! This project uses a professional development workflow with branch protection.

### ⚠️ IMPORTANT: Branch Protection Active

**Master branch is protected** - direct pushes are blocked for everyone (including repository owner). All changes must go through the Pull Request workflow.

### How to Contribute

1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/amazing-feature` (REQUIRED)
3. **Make your changes** and ensure tests pass: `.\build\Build.ps1 -Test`
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request** via GitHub web interface
7. **Wait for CI/CD** to complete (tests + security scan + build)
8. **Get code review approval** (1 reviewer required)
9. **Merge** when all status checks pass and conversations resolved

### Status Checks Required

- ✅ **Unit Tests**: All Pester tests must pass (12 tests)
- ✅ **Security Scan**: PowerShell Script Analyzer must show zero issues
- ✅ **Build Success**: Packaging and signing must complete successfully
- ✅ **Code Review**: 1 approval required from project maintainers

### Development Setup

```powershell
# Clone and set up
git clone https://github.com/justinkowarsch/windows-system-maintenance.git
cd windows-system-maintenance

# Create feature branch (REQUIRED for contributions)
git checkout -b feature/my-contribution

# Run tests
.\build\Build.ps1 -Test

# Build everything (tests, signs, packages)
.\build\Build.ps1 -All

# Push feature branch and create PR
git push origin feature/my-contribution
# Then create PR via GitHub web interface
```

### Testing Branch Protection

```powershell
# This will fail (as expected) - master branch is protected:
git push origin master  # ❌ Error: failed to push some refs

# This works - feature branch workflow:
git push origin feature/my-branch  # ✅ Success
# Create PR → CI runs → Review → Merge
```

## 📞 Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/justinkowarsch/windows-system-maintenance/issues)
- **GitHub Discussions**: [Community support and ideas](https://github.com/justinkowarsch/windows-system-maintenance/discussions)
- **Documentation**: See `docs/` directory (coming soon)
- **Logs**: Check `data/logs/` for detailed operation logs

---

**🎯 Optimized for Windows 11 gaming/coding workstations**  
_Fortnite • Unity Development • LLM Projects • SVG Graphics_
