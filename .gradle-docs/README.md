# Gradle Build System Documentation

## Overview

This directory contains comprehensive documentation for the Bearsampp Ruby module Gradle build system.

## Documentation Files

### [BUILD_TASKS.md](BUILD_TASKS.md)
**Complete reference for all Gradle tasks**

Learn about:
- All available tasks
- Task usage and examples
- Task dependencies
- Command-line options
- Task properties
- Common task combinations

**Read this if you**:
- Want to know what tasks are available
- Need detailed task documentation
- Want to understand task dependencies
- Need usage examples

---

### [DEVELOPMENT.md](DEVELOPMENT.md)
**Developer guide for working on the build system**

Learn about:
- Prerequisites and setup
- Project structure
- Build process internals
- Adding new Ruby versions
- Modifying the build process
- Testing and debugging
- Code style guidelines
- Version control workflow

**Read this if you**:
- Are developing the build system
- Want to add new features
- Need to modify existing tasks
- Want to understand the internals

---

### [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
**Solutions for common issues**

Learn about:
- Common build issues
- Download and extraction problems
- Installation errors
- Packaging issues
- Configuration problems
- Debugging techniques
- Performance optimization
- Getting help

**Read this if you**:
- Encounter build errors
- Need to debug issues
- Want to optimize performance
- Need help with specific problems

---

## Quick Start

### First Time Setup

1. **Verify environment**:
   ```bash
   gradle verify
   ```

2. **List available versions**:
   ```bash
   gradle listVersions
   ```

3. **Build a version**:
   ```bash
   gradle release -PbundleVersion=3.4.5
   ```

### Common Commands

```bash
# Interactive build (prompts for version)
gradle release

# Non-interactive build
gradle release -PbundleVersion=3.4.5

# Build latest version
gradle release -PbundleVersion=*

# List available tasks
gradle tasks

# Show build information
gradle info

# Verify environment
gradle verify

# Clean build artifacts
gradle clean
```

## Documentation Structure

```
.gradle-docs/
├── README.md                 # This file - documentation index
├── BUILD_TASKS.md            # Complete task reference
├── DEVELOPMENT.md            # Developer guide
├── TROUBLESHOOTING.md        # Troubleshooting guide
└── CONVERSION_SUMMARY.md     # Conversion summary
```

## Getting Started

### For Users

1. Read [BUILD_TASKS.md](BUILD_TASKS.md) to learn about available tasks
2. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) if you encounter issues
3. Review [CONVERSION_SUMMARY.md](CONVERSION_SUMMARY.md) for conversion details

### For Developers

1. Read [DEVELOPMENT.md](DEVELOPMENT.md) for setup and guidelines
2. Review [BUILD_TASKS.md](BUILD_TASKS.md) to understand existing tasks
3. Use [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for debugging

## Key Concepts

### Bundle Version

The Ruby version to build (e.g., `3.4.5`). Can be:
- Specified explicitly: `-PbundleVersion=3.4.5`
- Selected interactively: `gradle release` (prompts)
- Latest version: `-PbundleVersion=*`

### Bundle Release

The release date/version of the build (e.g., `2025.8.16`). Configured in `build.properties`.

### Build Paths

- **Project Dir**: `E:/Bearsampp-development/module-ruby`
- **Build Base**: `E:/Bearsampp-development/bearsampp-build` (configurable)
- **Temp Dir**: `bearsampp-build/tmp/`
- **Output Dir**: `bearsampp-build/tools/ruby/<release>/`

### Configuration Files

- **build.properties**: Main build configuration
- **releases.properties**: Release URLs
- **gradle.properties**: Gradle settings
- **rubygems.properties**: RubyGems download URL (per version)

## Build Process Overview

```
1. Version Resolution
   ├── Interactive prompt or -PbundleVersion
   └── Validates version exists

2. Download & Extract
   ├── Downloads Ruby binaries from modules-untouched
   ├── Extracts to bearsampp-build/tmp/extract/
   └── Caches for future builds

3. Preparation
   ├── Copies Ruby binaries
   ├── Copies configuration files
   ├── Installs RubyGems
   └── Updates paths in scripts

4. Packaging
   ├── Creates .7z or .zip archive
   └── Outputs to bearsampp-build/tools/ruby/<release>/

5. Hash Generation
   └── Generates MD5, SHA1, SHA256, SHA512 hashes
```

## Task Categories

### Build Tasks
- `release` - Main release build
- `releaseBuild` - Core build logic
- `packageRelease` - Package into archive
- `generateHashes` - Generate hash files
- `clean` - Clean build artifacts

### Verification Tasks
- `verify` - Verify build environment
- `validateProperties` - Validate build.properties
- `assertVersionResolved` - Ensure version is resolved

### Help Tasks
- `info` - Display build information
- `tasks` - List all tasks
- `listVersions` - List available versions
- `listReleases` - List releases
- `rubyInfo` - Ruby-specific information

## Examples

### Example 1: First Build

```bash
# Verify environment
$ gradle verify
[SUCCESS] All checks passed!

# List available versions
$ gradle listVersions
Available ruby versions:
  1. 3.4.5        [bin]

# Build version
$ gradle release -PbundleVersion=3.4.5
[SUCCESS] Release build completed successfully for version 3.4.5
```

### Example 2: Interactive Build

```bash
$ gradle release

Available ruby versions (index, version, location):
----------------------------------------------------------------------
   1. 2.7.6        [bin/archived]
   2. 3.4.5        [bin]
----------------------------------------------------------------------

Enter version to build (index or version string): 2

Selected version: 3.4.5
[SUCCESS] Release build completed successfully for version 3.4.5
```

### Example 3: Build Latest

```bash
$ gradle release -PbundleVersion=*

Resolved latest version: 3.4.5
[SUCCESS] Release build completed successfully for version 3.4.5
```

## Troubleshooting Quick Reference

| Issue | Quick Fix |
|-------|-----------|
| Gradle not found | Install Gradle or use wrapper |
| Java not found | Install JDK 8+ and set JAVA_HOME |
| 7-Zip not found | Install 7-Zip or set 7Z_HOME |
| Version not found | Check `gradle listVersions` |
| Download failed | Check internet connection |
| Build failed | Run `gradle clean release` |

For detailed troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Additional Resources

### External Documentation

- [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
- [Groovy Documentation](https://groovy-lang.org/documentation.html)
- [Bearsampp Documentation](https://bearsampp.com/)

### Tools

- [Gradle Build Tool](https://gradle.org/)
- [7-Zip](https://www.7-zip.org/)
- [Ruby](https://www.ruby-lang.org/)
- [RubyGems](https://rubygems.org/)

### Community

- [Bearsampp GitHub](https://github.com/Bearsampp)
- [Gradle Forums](https://discuss.gradle.org/)

## Contributing

When contributing to the build system:

1. Read [DEVELOPMENT.md](DEVELOPMENT.md) for guidelines
2. Test your changes thoroughly
3. Update documentation as needed
4. Follow code style conventions
5. Submit pull request with clear description

## Support

For help:

1. Check this documentation
2. Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. Enable debug logging: `gradle release --debug`
4. Report issues on GitHub

## Version History

### 2025.8.16
- Initial Gradle build system
- Comprehensive documentation
- Interactive version selection
- Automatic hash generation
- Environment verification
- Ruby-specific build processes

## License

This documentation is part of the Bearsampp project and follows the same license.

---

**Last Updated**: 2025.8.16  
**Gradle Version**: 7.6+  
**Java Version**: 8+
