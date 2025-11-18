# Development Guide

## Overview

This guide provides information for developers working on the Bearsampp Ruby module build system.

## Prerequisites

### Required Software

1. **Java Development Kit (JDK) 8 or higher**
   - Download: https://adoptium.net/
   - Verify: `java -version`

2. **Gradle 6.0 or higher**
   - Download: https://gradle.org/install/
   - Verify: `gradle --version`
   - Or use Gradle Wrapper (recommended)

3. **7-Zip**
   - Download: https://www.7-zip.org/
   - Required for .7z archive creation
   - Set `7Z_HOME` environment variable (optional)

4. **Git**
   - Download: https://git-scm.com/
   - For version control

### Optional Software

1. **IntelliJ IDEA** or **VS Code**
   - For editing Gradle build files
   - Better syntax highlighting and auto-completion

2. **Ruby** (for testing)
   - To test the built Ruby installations
   - Not required for building

## Project Structure

```
module-ruby/
├── .gradle-docs/           # Documentation (this directory)
│   ├── GRADLE_MIGRATION.md
│   ├── BUILD_TASKS.md
│   ├── DEVELOPMENT.md
│   └── TROUBLESHOOTING.md
├── bin/                    # Ruby version configurations
│   ├── archived/           # Archived versions
│   │   ├── ruby2.7.6/
│   │   │   ├── rubygems/
│   │   │   │   ├── install.bat
│   │   │   │   └── rubygems.properties
│   │   │   └── bearsampp.conf
│   │   └── ...
│   └── ruby3.4.5/          # Current version
│       ├── rubygems/
│       └── bearsampp.conf
├── img/                    # Images
│   └── Bearsampp-logo.svg
├── build.gradle            # Gradle build script
├── build.properties        # Build configuration
├── releases.properties     # Release URLs
├── gradle.properties       # Gradle properties
├── .editorconfig          # Editor configuration
├── LICENSE
└── README.md
```

## Configuration Files

### build.properties

Main build configuration file.

```properties
bundle.name=ruby
bundle.release=2025.8.16
bundle.type=tools
bundle.format=7z
#build.path = C:/Bearsampp-build
```

**Properties**:
- `bundle.name`: Module name (ruby)
- `bundle.release`: Release version (date-based)
- `bundle.type`: Module type (tools, bins, apps)
- `bundle.format`: Archive format (7z or zip)
- `build.path`: Optional custom build path

### releases.properties

Maps Ruby versions to download URLs.

```properties
3.4.5 = https://github.com/Bearsampp/module-ruby/releases/download/2025.8.16/bearsampp-ruby-3.4.5-2025.8.16.7z
```

**Format**: `<version> = <url>`

### gradle.properties

Gradle-specific configuration.

```properties
# Gradle settings
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
```

## Build Process

### High-Level Flow

1. **Version Resolution** (`resolveVersion`)
   - Interactive or from `-PbundleVersion`
   - Validates version exists in `bin/` or `bin/archived/`

2. **Download & Extract** (`releaseBuild`)
   - Downloads Ruby binaries from modules-untouched
   - Extracts to `bearsampp-build/tmp/extract/ruby/<version>`
   - Caches for future builds

3. **Preparation** (`releaseBuild`)
   - Copies Ruby binaries to prep directory
   - Copies configuration files
   - Processes RubyGems installation
   - Updates paths in scripts

4. **Packaging** (`packageRelease`)
   - Creates .7z or .zip archive
   - Includes version folder at root
   - Outputs to `bearsampp-build/tools/ruby/<release>/`

5. **Hash Generation** (`generateHashes`)
   - Generates MD5, SHA1, SHA256, SHA512 hashes
   - Creates sidecar files

### Detailed Steps

#### 1. Version Resolution

```groovy
tasks.register('resolveVersion') {
    // Interactive prompt or -PbundleVersion
    // Validates version exists
    // Stores in .gradle-bundleVersion file
}
```

**Input**: User selection or `-PbundleVersion` property
**Output**: `.gradle-bundleVersion` file

#### 2. Ruby Binary Download

```groovy
def downloadAndExtractRuby(String version, File destDir) {
    // 1. Fetch ruby.properties from modules-untouched
    // 2. Get download URL for version
    // 3. Download .7z archive
    // 4. Extract using 7-Zip
    // 5. Find Ruby directory (contains bin/ruby.exe)
    // 6. Return Ruby directory path
}
```

**Input**: Ruby version (e.g., "3.4.5")
**Output**: Extracted Ruby directory

#### 3. RubyGems Installation

```groovy
def processRubyGems(File rubygemsDir, File rubyPrepPath) {
    // 1. Read rubygems.properties
    // 2. Download rubygems-update.gem
    // 3. Copy install.bat
    // 4. Execute install.bat (gem install rubygems-update.gem)
    // 5. Execute update_rubygems.bat (gem update --system)
    // 6. Verify installation (gem --version)
    // 7. Clean up rubygems directory
}
```

**Input**: 
- `rubygemsDir`: Source directory with rubygems.properties and install.bat
- `rubyPrepPath`: Target Ruby installation directory

**Output**: RubyGems installed in Ruby installation

#### 4. Path Updates

```groovy
def updateRubyPaths(File rubyPrepPath, String bundleVersion) {
    // 1. Iterate through bin/ directory
    // 2. Skip .dll and .exe files
    // 3. Replace absolute paths with Bearsampp placeholders
    // 4. Format: ~BEARSAMPP_LIN_PATH~/tools/ruby/ruby<version>
}
```

**Replacements**:
- `E:/Bearsampp-development/bearsampp-build/tmp/...` → `~BEARSAMPP_LIN_PATH~/tools/ruby/ruby3.4.5`

#### 5. Archive Creation

```groovy
tasks.register('packageRelease7z') {
    // 1. Find 7-Zip executable
    // 2. Create command: 7z a -t7z <archive> <folder>
    // 3. Execute from prep directory
    // 4. Verify archive created
}
```

**Archive Structure**:
```
bearsampp-ruby-3.4.5-2025.8.16.7z
└── ruby3.4.5/
    ├── bin/
    │   ├── ruby.exe
    │   ├── gem.bat
    │   └── ...
    ├── lib/
    ├── share/
    └── bearsampp.conf
```

## Adding a New Ruby Version

### Step 1: Create Version Directory

```bash
mkdir bin/ruby3.5.0
```

### Step 2: Create Configuration Files

**bin/ruby3.5.0/bearsampp.conf**:
```ini
rubyVersion = "3.5.0"
rubyExe = "ruby.exe"
```

**bin/ruby3.5.0/rubygems/rubygems.properties**:
```properties
rubygems = https://rubygems.org/downloads/rubygems-update-3.5.0.gem
```

**bin/ruby3.5.0/rubygems/install.bat**:
```batch
@echo off
set RUBYBINPATH=%~dp0..\bin
pushd %RUBYBINPATH%
set RUBYBINPATH=%CD%
popd

CALL "%RUBYBINPATH%\gem.cmd" install rubygems-update.gem --local --no-document
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

"%RUBYBINPATH%\gem.cmd" update --system --no-document
```

### Step 3: Build the Version

```bash
gradle release -PbundleVersion=3.5.0
```

### Step 4: Test the Build

```bash
# Extract the archive
7z x bearsampp-build/tools/ruby/2025.8.16/bearsampp-ruby-3.5.0-2025.8.16.7z

# Test Ruby
cd ruby3.5.0/bin
ruby --version
gem --version
```

### Step 5: Add to releases.properties

```properties
3.5.0 = https://github.com/Bearsampp/module-ruby/releases/download/2025.8.16/bearsampp-ruby-3.5.0-2025.8.16.7z
```

## Modifying the Build Process

### Adding a New Task

```groovy
tasks.register('myNewTask') {
    group = 'custom'
    description = 'My custom task'
    
    doLast {
        println "Executing my custom task"
        // Task logic here
    }
}
```

### Adding Task Dependencies

```groovy
tasks.register('myTask') {
    dependsOn 'resolveVersion'
    
    doLast {
        // Task logic
    }
}
```

### Adding a Helper Function

```groovy
// Helper: My custom function
def myHelperFunction(String param) {
    println "Processing: ${param}"
    // Function logic
    return result
}
```

### Modifying Existing Tasks

```groovy
// Extend existing task
tasks.named('releaseBuild') {
    doLast {
        // Additional logic after releaseBuild
        println "Custom post-build step"
    }
}
```

## Testing

### Unit Testing

Currently, the build system doesn't have unit tests. Future enhancement:

```groovy
// Add to build.gradle
plugins {
    id 'groovy'
}

dependencies {
    testImplementation 'org.spockframework:spock-core:2.0-groovy-3.0'
}

test {
    useJUnitPlatform()
}
```

### Integration Testing

Test the full build process:

```bash
# Test interactive build
gradle release

# Test non-interactive build
gradle release -PbundleVersion=3.4.5

# Test latest version build
gradle release -PbundleVersion=*

# Test with different formats
# Edit build.properties: bundle.format=zip
gradle release -PbundleVersion=3.4.5
```

### Manual Testing

1. **Build a version**:
   ```bash
   gradle release -PbundleVersion=3.4.5
   ```

2. **Extract the archive**:
   ```bash
   7z x bearsampp-build/tools/ruby/2025.8.16/bearsampp-ruby-3.4.5-2025.8.16.7z
   ```

3. **Test Ruby**:
   ```bash
   cd ruby3.4.5/bin
   ruby --version
   gem --version
   gem list
   ```

4. **Verify paths**:
   ```bash
   # Check that paths are replaced
   grep -r "BEARSAMPP_LIN_PATH" ruby3.4.5/bin/
   
   # Should NOT find absolute paths
   grep -r "E:/Bearsampp-development" ruby3.4.5/bin/
   ```

5. **Verify hashes**:
   ```bash
   # Windows PowerShell
   Get-FileHash bearsampp-ruby-3.4.5-2025.8.16.7z -Algorithm MD5
   Get-FileHash bearsampp-ruby-3.4.5-2025.8.16.7z -Algorithm SHA256
   
   # Compare with .md5 and .sha256 files
   ```

## Debugging

### Enable Debug Logging

```bash
gradle release -PbundleVersion=3.4.5 --debug
```

### Enable Info Logging

```bash
gradle release -PbundleVersion=3.4.5 --info
```

### Enable Stack Traces

```bash
gradle release -PbundleVersion=3.4.5 --stacktrace
```

### Dry Run

```bash
gradle release -PbundleVersion=3.4.5 --dry-run
```

### Debug Specific Task

```groovy
tasks.register('myTask') {
    doLast {
        logger.lifecycle("Lifecycle message")
        logger.info("Info message")
        logger.debug("Debug message")
        
        println "Standard output"
        System.err.println "Error output"
    }
}
```

## Performance Optimization

### Enable Gradle Daemon

```properties
# gradle.properties
org.gradle.daemon=true
```

### Enable Parallel Execution

```properties
# gradle.properties
org.gradle.parallel=true
```

### Enable Build Cache

```properties
# gradle.properties
org.gradle.caching=true
```

### Configure Memory

```properties
# gradle.properties
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
```

## Code Style

### Groovy Conventions

1. **Indentation**: 4 spaces
2. **Line Length**: 120 characters max
3. **Naming**:
   - Tasks: camelCase (e.g., `releaseBuild`)
   - Functions: camelCase (e.g., `downloadFile`)
   - Variables: camelCase (e.g., `bundleName`)
   - Constants: UPPER_SNAKE_CASE (e.g., `DEFAULT_VERSION`)

### Comments

```groovy
// Single-line comment

/*
 * Multi-line comment
 * Describes complex logic
 */

/**
 * Documentation comment
 * Used for functions and tasks
 */
```

### Task Structure

```groovy
tasks.register('taskName') {
    group = 'category'
    description = 'Task description'
    
    // Dependencies
    dependsOn 'otherTask'
    
    // Configuration
    def variable = 'value'
    
    // Execution
    doFirst {
        // Pre-execution logic
    }
    
    doLast {
        // Main execution logic
    }
}
```

## Version Control

### Git Workflow

1. **Create feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes**:
   ```bash
   # Edit files
   gradle verify
   gradle release -PbundleVersion=3.4.5
   ```

3. **Commit changes**:
   ```bash
   git add build.gradle
   git commit -m "feat: add new feature"
   ```

4. **Push changes**:
   ```bash
   git push origin feature/my-feature
   ```

5. **Create pull request**

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style
- `refactor`: Code refactoring
- `test`: Tests
- `chore`: Maintenance

**Example**:
```
feat: add support for Ruby 3.5.0

- Add Ruby 3.5.0 configuration
- Update RubyGems to 3.5.0
- Add tests for new version

Closes #123
```

## Continuous Integration

### GitHub Actions Example

```yaml
name: Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: windows-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Set up JDK 11
      uses: actions/setup-java@v2
      with:
        java-version: '11'
        distribution: 'adopt'
    
    - name: Setup Gradle
      uses: gradle/gradle-build-action@v2
    
    - name: Verify build
      run: gradle verify
    
    - name: Build Ruby 3.4.5
      run: gradle release -PbundleVersion=3.4.5
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v2
      with:
        name: ruby-build
        path: bearsampp-build/tools/ruby/
```

## Troubleshooting Development Issues

### Issue: Gradle Not Found

**Solution**: Install Gradle or use Gradle Wrapper

```bash
# Download Gradle Wrapper
gradle wrapper --gradle-version 7.6

# Use wrapper
./gradlew release -PbundleVersion=3.4.5
```

### Issue: Build Fails with "Version Not Found"

**Solution**: Ensure version directory exists

```bash
# Check available versions
gradle listVersions

# Create version directory if needed
mkdir bin/ruby3.4.5
```

### Issue: RubyGems Installation Fails

**Solution**: Check rubygems.properties URL

```bash
# Verify URL is accessible
curl -I https://rubygems.org/downloads/rubygems-update-3.4.0.gem

# Update rubygems.properties if needed
```

### Issue: Path Replacement Not Working

**Solution**: Check path format in updateRubyPaths function

```groovy
// Debug path replacement
def updateRubyPaths(File rubyPrepPath, String bundleVersion) {
    println "Original path: ${rubyPrepPath.absolutePath}"
    println "Target path: ~BEARSAMPP_LIN_PATH~/tools/ruby/ruby${bundleVersion}"
    // ... rest of function
}
```

## Resources

### Documentation

- [Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
- [Groovy Documentation](https://groovy-lang.org/documentation.html)
- [Bearsampp Documentation](https://bearsampp.com/)

### Tools

- [Gradle Build Tool](https://gradle.org/)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/)
- [VS Code](https://code.visualstudio.com/)
- [7-Zip](https://www.7-zip.org/)

### Community

- [Bearsampp GitHub](https://github.com/Bearsampp)
- [Gradle Forums](https://discuss.gradle.org/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/gradle)

## See Also

- [BUILD_TASKS.md](BUILD_TASKS.md) - Task reference
- [GRADLE_MIGRATION.md](GRADLE_MIGRATION.md) - Migration guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Troubleshooting guide
