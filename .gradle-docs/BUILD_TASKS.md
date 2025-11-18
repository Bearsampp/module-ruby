# Gradle Build Tasks Reference

## Overview

This document provides detailed information about all available Gradle tasks for the Bearsampp Ruby module.

## Task Categories

### Build Tasks

Tasks related to building and packaging the Ruby module.

#### `release`

**Description**: Main release task that builds and packages the Ruby module.

**Usage**:
```bash
# Interactive mode (prompts for version)
gradle release

# Non-interactive mode (specify version)
gradle release -PbundleVersion=3.4.5

# Build latest version
gradle release -PbundleVersion=*
```

**Dependencies**:
- `clean` - Cleans previous build artifacts
- `resolveVersion` - Resolves which version to build
- `packageRelease` - Packages the build into an archive

**Output**:
- Archive: `bearsampp-build/tools/ruby/<release>/bearsampp-ruby-<version>-<release>.7z`
- Hash files: `.md5`, `.sha1`, `.sha256`, `.sha512`

**Example**:
```bash
gradle release -PbundleVersion=3.4.5
```

---

#### `releaseBuild`

**Description**: Executes the core build process (download, extract, configure, install RubyGems).

**Usage**:
```bash
gradle releaseBuild -PbundleVersion=3.4.5
```

**Process**:
1. Resolves bundle path from `bin/` or `bin/archived/`
2. Downloads Ruby binaries (if not cached)
3. Extracts Ruby binaries
4. Copies base Ruby files
5. Copies configuration files
6. Processes RubyGems installation
7. Updates paths in Ruby scripts

**Dependencies**:
- `resolveVersion`

---

#### `resolveVersion`

**Description**: Resolves which Ruby version to build (interactive or from property).

**Usage**:
```bash
# Interactive mode
gradle resolveVersion

# Non-interactive mode
gradle resolveVersion -PbundleVersion=3.4.5

# Latest version
gradle resolveVersion -PbundleVersion=*
```

**Interactive Example**:
```
Available ruby versions (index, version, location):
----------------------------------------------------------------------
   1. 2.7.6        [bin/archived]
   2. 2.7.8        [bin/archived]
   3. 3.4.5        [bin]
----------------------------------------------------------------------

Enter version to build (index or version string): 3
```

**Output**: Stores selected version in `.gradle-bundleVersion` file

---

#### `packageRelease`

**Description**: Packages the prepared Ruby build into an archive.

**Usage**:
```bash
gradle packageRelease -PbundleVersion=3.4.5
```

**Dependencies**:
- `resolveVersion`
- `releaseBuild`
- `assertVersionResolved`
- `packageRelease7z` or `packageReleaseZip` (based on `bundle.format`)

**Output**: Creates archive in `bearsampp-build/tools/ruby/<release>/`

---

#### `packageRelease7z`

**Description**: Packages the build into a .7z archive.

**Usage**:
```bash
gradle packageRelease7z -PbundleVersion=3.4.5
```

**Requirements**:
- 7-Zip must be installed
- Or `7Z_HOME` environment variable set

**Archive Structure**:
```
bearsampp-ruby-3.4.5-2025.8.16.7z
└── ruby3.4.5/
    ├── bin/
    ├── lib/
    ├── share/
    └── bearsampp.conf
```

---

#### `packageReleaseZip`

**Description**: Packages the build into a .zip archive.

**Usage**:
```bash
gradle packageReleaseZip -PbundleVersion=3.4.5
```

**Note**: Used when `bundle.format=zip` in `build.properties`

---

#### `generateHashes`

**Description**: Generates hash files for the packaged archive.

**Usage**:
```bash
gradle generateHashes -PbundleVersion=3.4.5
```

**Generated Files**:
- `bearsampp-ruby-<version>-<release>.7z.md5`
- `bearsampp-ruby-<version>-<release>.7z.sha1`
- `bearsampp-ruby-<version>-<release>.7z.sha256`
- `bearsampp-ruby-<version>-<release>.7z.sha512`

**Hash Format**:
```
<hash> <filename>
```

---

#### `clean`

**Description**: Cleans build artifacts and temporary files.

**Usage**:
```bash
gradle clean
```

**Removes**:
- `build/` directory
- `bearsampp-build/tmp/` directory
- `.gradle-bundleVersion` file

---

### Verification Tasks

Tasks for verifying the build environment and configuration.

#### `verify`

**Description**: Verifies that the build environment is properly configured.

**Usage**:
```bash
gradle verify
```

**Checks**:
- Java 8+ is installed
- `build.properties` exists
- `releases.properties` exists
- `bin/` directory exists

**Example Output**:
```
Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     releases.properties
  [PASS]     bin directory
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.
```

---

#### `validateProperties`

**Description**: Validates that `build.properties` contains all required properties.

**Usage**:
```bash
gradle validateProperties
```

**Required Properties**:
- `bundle.name`
- `bundle.release`
- `bundle.type`
- `bundle.format`

**Example Output**:
```
[SUCCESS] All required properties are present:
    bundle.name = ruby
    bundle.release = 2025.8.16
    bundle.type = tools
    bundle.format = 7z
```

---

#### `assertVersionResolved`

**Description**: Internal task that ensures version is resolved before packaging.

**Usage**: Automatically called by packaging tasks

---

### Help Tasks

Tasks that provide information about the build system.

#### `info`

**Description**: Displays comprehensive build configuration information.

**Usage**:
```bash
gradle info
```

**Shows**:
- Project information
- Bundle properties
- All configured paths
- Java and Gradle versions
- Available task groups
- Quick start commands

**Example Output**:
```
================================================================
          Bearsampp Module Ruby - Build Info
================================================================

Project:        module-ruby
Version:        2025.8.16
Description:    Bearsampp Module - ruby

Bundle Properties:
  Name:         ruby
  Release:      2025.8.16
  Type:         tools
  Format:       7z

Paths:
  Project Dir:  E:/Bearsampp-development/module-ruby
  Root Dir:     E:/Bearsampp-development
  Build Base:   E:/Bearsampp-development/bearsampp-build
  Output Dir:   E:/Bearsampp-development/bearsampp-build/tools/ruby/2025.8.16
  ...
```

---

#### `tasks`

**Description**: Lists all available Gradle tasks.

**Usage**:
```bash
gradle tasks

# Show all tasks including internal ones
gradle tasks --all
```

---

#### `listVersions`

**Description**: Lists all available Ruby versions in `bin/` and `bin/archived/` directories.

**Usage**:
```bash
gradle listVersions
```

**Example Output**:
```
Available ruby versions (index, version, location):
------------------------------------------------------------
   1. 2.7.6        [bin/archived]
   2. 2.7.8        [bin/archived]
   3. 3.0.6        [bin/archived]
   4. 3.4.5        [bin]
------------------------------------------------------------
Total versions: 4

To build a specific version:
  gradle release -PbundleVersion=3.4.5
```

---

#### `listReleases`

**Description**: Lists all available releases from `releases.properties`.

**Usage**:
```bash
gradle listReleases
```

**Example Output**:
```
Available Ruby Releases:
--------------------------------------------------------------------------------
  2.7.6      -> https://github.com/Bearsampp/module-ruby/releases/download/...
  2.7.8      -> https://github.com/Bearsampp/module-ruby/releases/download/...
  3.4.5      -> https://github.com/Bearsampp/module-ruby/releases/download/...
--------------------------------------------------------------------------------
Total releases: 12
```

---

#### `rubyInfo`

**Description**: Displays Ruby-specific build information.

**Usage**:
```bash
gradle rubyInfo
```

**Shows**:
- RubyGems installation process
- Path update process
- Configuration files
- Useful commands

---

### Utility Tasks

Internal utility tasks used by other tasks.

#### `cleanupTempFiles`

**Description**: Cleans up temporary Gradle-specific files after build.

**Usage**: Automatically called after `release` task

**Removes**:
- `.gradle-bundleVersion` file

---

## Task Dependencies

### Release Task Flow

```
release
├── clean
├── resolveVersion
└── packageRelease
    ├── resolveVersion
    ├── releaseBuild
    │   └── resolveVersion
    ├── assertVersionResolved
    │   └── resolveVersion
    └── packageRelease7z (or packageReleaseZip)
        ├── assertVersionResolved
        └── releaseBuild
```

### Finalized By

```
release
├── finalizedBy: generateHashes
└── finalizedBy: cleanupTempFiles
```

## Common Task Combinations

### Full Release Build

```bash
gradle release -PbundleVersion=3.4.5
```

Executes: `clean` → `resolveVersion` → `releaseBuild` → `packageRelease` → `generateHashes` → `cleanupTempFiles`

### Verify Before Build

```bash
gradle verify
gradle release -PbundleVersion=3.4.5
```

### List and Build

```bash
gradle listVersions
gradle release -PbundleVersion=3.4.5
```

### Clean and Rebuild

```bash
gradle clean
gradle release -PbundleVersion=3.4.5
```

Note: `clean` is automatically called by `release`, so this is redundant but explicit.

## Task Properties

### Common Properties

| Property | Description | Example |
|----------|-------------|---------|
| `-PbundleVersion` | Specifies which version to build | `-PbundleVersion=3.4.5` |
| `-PbundleVersion=*` | Builds the latest version | `-PbundleVersion=*` |

### Gradle Options

| Option | Description | Example |
|--------|-------------|---------|
| `--info` | Show info-level logging | `gradle release --info` |
| `--debug` | Show debug-level logging | `gradle release --debug` |
| `--stacktrace` | Show stack traces on errors | `gradle release --stacktrace` |
| `--console=plain` | Disable colored output | `gradle release --console=plain` |
| `--no-daemon` | Don't use Gradle daemon | `gradle release --no-daemon` |

## Task Execution Examples

### Example 1: Interactive Build

```bash
$ gradle release

Available ruby versions (index, version, location):
----------------------------------------------------------------------
   1. 2.7.6        [bin/archived]
   2. 2.7.8        [bin/archived]
   3. 3.4.5        [bin]
----------------------------------------------------------------------

Enter version to build (index or version string): 3

Selected version: 3.4.5

Processing bundle: ruby3.4.5
Version: 3.4.5
...
[SUCCESS] Release build completed successfully for version 3.4.5
```

### Example 2: Non-Interactive Build

```bash
$ gradle release -PbundleVersion=3.4.5

Selected version: 3.4.5

Processing bundle: ruby3.4.5
Version: 3.4.5
Source folder: E:/Bearsampp-development/bearsampp-build/tmp/extract/ruby/3.4.5
...
[SUCCESS] Release build completed successfully for version 3.4.5
```

### Example 3: Build Latest Version

```bash
$ gradle release -PbundleVersion=*

Resolved latest version: 3.4.5

Processing bundle: ruby3.4.5
...
[SUCCESS] Release build completed successfully for version 3.4.5
```

### Example 4: Verify Environment

```bash
$ gradle verify

Verifying build environment for module-ruby...

Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     releases.properties
  [PASS]     bin directory
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.
```

## Troubleshooting Tasks

### Check Task Dependencies

```bash
gradle release --dry-run
```

Shows what tasks would be executed without actually running them.

### Debug Task Execution

```bash
gradle release -PbundleVersion=3.4.5 --info
```

Shows detailed information about task execution.

### Force Task Re-execution

```bash
gradle release -PbundleVersion=3.4.5 --rerun-tasks
```

Forces all tasks to run even if they're up-to-date.

## Performance Tips

### Use Gradle Daemon

The Gradle daemon improves build performance by keeping Gradle running in the background.

```bash
# Daemon is enabled by default
gradle release -PbundleVersion=3.4.5

# Disable daemon if needed
gradle release -PbundleVersion=3.4.5 --no-daemon
```

### Parallel Execution

For future enhancements, Gradle supports parallel task execution:

```bash
gradle release -PbundleVersion=3.4.5 --parallel
```

### Build Cache

Gradle's build cache can speed up builds:

```bash
gradle release -PbundleVersion=3.4.5 --build-cache
```

## See Also

- [GRADLE_MIGRATION.md](GRADLE_MIGRATION.md) - Migration guide from Ant to Gradle
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Troubleshooting guide
