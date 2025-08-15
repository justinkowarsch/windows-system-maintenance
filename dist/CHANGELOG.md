# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-08-14

### Added
- **Git Repository Structure**: Professional repository organization with proper directory structure
- **Enhanced Retry Logic**: 3-attempt cleanup with progressive delays (1s → 2s → 3s)
- **Individual File Cleanup**: Graceful degradation when bulk operations fail
- **HP Service Guardian**: Automatic monitoring and disabling of HP bloatware services
- **VS Code Integration**: Complete workspace configuration with tasks, debugging, and extensions
- **Comprehensive Logging**: File-based logging with proper timestamp handling
- **Professional Documentation**: README, API docs, installation guides
- **Testing Framework**: Pester test structure for unit and integration testing
- **Build System**: Scripts for building, signing, and packaging

### Changed
- **Write-Log Function**: Fixed function order and variable scoping issues
- **Configuration Management**: Separated default and user configurations
- **Project Structure**: Migrated from scattered files to organized repository
- **Versioning System**: Implemented semantic versioning with automated tracking

### Fixed
- **Logging System**: Resolved variable scoping issues causing silent failures
- **Module Detection**: Fixed Windows Defender module detection warnings
- **Function Order**: Resolved PowerShell function definition order issues

### Security
- **Code Signing**: Prepared infrastructure for script signing
- **Configuration Isolation**: User configs separated from version control
- **Registry Backup**: Enhanced registry operation safety

## [1.0.0] - 2025-08-13

### Added
- Initial system maintenance script
- Basic retry logic for file operations
- HP service management
- PowerShell profile integration
- Configuration system
- Logging infrastructure

### Features
- Quick cleanup functionality
- Full maintenance operations
- Game optimization
- Development environment cleanup
- System health reporting