# Windows System Maintenance

> Professional-grade PowerShell system maintenance scripts for Windows 11 gaming/coding workstations

[![PowerShell](https://img.shields.io/badge/PowerShell-7.5.2-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-11-blue.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- **🔄 Enhanced Retry Logic**: 3-attempt cleanup with progressive delays and individual file processing
- **🛡️ HP Service Guardian**: Automatic monitoring and disabling of HP bloatware services  
- **📊 Smart Scheduling**: Usage-aware maintenance timing with Windows integration
- **📝 Comprehensive Logging**: Detailed operation logs with full audit trails
- **🔒 Safety Systems**: Registry backup, rollback capabilities, and safety checks
- **⚡ Performance Optimized**: Designed for gaming/coding workstations with RTX 4070 + 32GB RAM

## 🚀 Quick Start

### Installation
```powershell
# Clone or download to your code directory
git clone <repository-url> C:\Users\<username>\code\windows-system-maintenance

# Run installation helper
.\tools\Install-MaintenanceSystem.ps1
```

### Daily Usage
```powershell
qc          # Quick cleanup with HP monitoring
fm          # Full maintenance  
hpchk       # HP Service Guardian check
nordfix     # NordVPN network reset
Show-Health # System status
```

## 📁 Project Structure

```
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

## 🧪 Testing

```powershell
# Run all tests
Invoke-Pester -Path .\tests

# Run specific test suite  
Invoke-Pester -Path .\tests\unit\SystemMaintenance.Tests.ps1
```

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

## 🛡️ Security

- All scripts are digitally signed with local certificates
- Registry operations include automatic backup
- Comprehensive rollback system for all changes
- No elevation required for standard operations

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed release history.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

This is a personal system maintenance project. For issues or suggestions, please create an issue in the repository.

## 📞 Support

- **Documentation**: See `docs/` directory
- **Logs**: Check `data/logs/` for detailed operation logs
- **Issues**: Use GitHub issues for bug reports

---

**🎯 Optimized for Windows 11 gaming/coding workstations**  
*Fortnite • Unity Development • LLM Projects • SVG Graphics*