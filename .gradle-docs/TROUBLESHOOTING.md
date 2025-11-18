# Troubleshooting Guide

## Overview

This guide helps you diagnose and fix common issues with the Bearsampp Ruby module build system.

## Common Issues

### Build Issues

#### Issue: Gradle Command Not Found

**Symptoms**:
```
'gradle' is not recognized as an internal or external command
```

**Causes**:
- Gradle not installed
- Gradle not in PATH

**Solutions**:

1. **Install Gradle**:
   ```bash
   # Windows (using Chocolatey)
   choco install gradle
   
   # Or download from https://gradle.org/install/
   ```

2. **Add Gradle to PATH**:
   ```bash
   # Windows
   setx PATH "%PATH%;C:\Gradle\gradle-7.6\bin"
   ```

3. **Use Gradle Wrapper** (recommended):
   ```bash
   # Download wrapper
   gradle wrapper --gradle-version 7.6
   
   # Use wrapper
   gradlew.bat release -PbundleVersion=3.4.5
   ```

---

#### Issue: Java Not Found

**Symptoms**:
```
ERROR: JAVA_HOME is not set and no 'java' command could be found
```

**Causes**:
- Java not installed
- JAVA_HOME not set

**Solutions**:

1. **Install Java**:
   - Download from https://adoptium.net/
   - Install JDK 8 or higher

2. **Set JAVA_HOME**:
   ```bash
   # Windows
   setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-11.0.16.101-hotspot"
   setx PATH "%PATH%;%JAVA_HOME%\bin"
   ```

3. **Verify Installation**:
   ```bash
   java -version
   ```

---

#### Issue: 7-Zip Not Found

**Symptoms**:
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Causes**:
- 7-Zip not installed
- 7-Zip not in PATH or 7Z_HOME

**Solutions**:

1. **Install 7-Zip**:
   - Download from https://www.7-zip.org/
   - Install to default location

2. **Set 7Z_HOME** (if installed in non-standard location):
   ```bash
   # Windows
   setx 7Z_HOME "C:\Program Files\7-Zip"
   ```

3. **Add to PATH**:
   ```bash
   # Windows
   setx PATH "%PATH%;C:\Program Files\7-Zip"
   ```

4. **Verify Installation**:
   ```bash
   7z
   ```

---

#### Issue: Version Not Found

**Symptoms**:
```
Bundle version not found in bin/ or bin/archived/: ruby3.4.5
```

**Causes**:
- Version directory doesn't exist
- Typo in version number
- Version in wrong location

**Solutions**:

1. **List Available Versions**:
   ```bash
   gradle listVersions
   ```

2. **Check Directory Structure**:
   ```bash
   # Should exist
   bin/ruby3.4.5/
   # Or
   bin/archived/ruby3.4.5/
   ```

3. **Create Version Directory**:
   ```bash
   mkdir bin/ruby3.4.5
   mkdir bin/ruby3.4.5/rubygems
   ```

4. **Use Correct Version Format**:
   ```bash
   # Correct
   gradle release -PbundleVersion=3.4.5
   
   # Incorrect
   gradle release -PbundleVersion=ruby3.4.5
   ```

---

#### Issue: Build Properties Not Found

**Symptoms**:
```
build.properties not found
```

**Causes**:
- File deleted or moved
- Wrong working directory

**Solutions**:

1. **Check Current Directory**:
   ```bash
   pwd  # Linux/Mac
   cd   # Windows
   ```

2. **Navigate to Project Root**:
   ```bash
   cd E:/Bearsampp-development/module-ruby
   ```

3. **Verify File Exists**:
   ```bash
   ls build.properties  # Linux/Mac
   dir build.properties # Windows
   ```

4. **Recreate File** (if missing):
   ```properties
   bundle.name=ruby
   bundle.release=2025.8.16
   bundle.type=tools
   bundle.format=7z
   ```

---

### Download Issues

#### Issue: Download Failed

**Symptoms**:
```
Failed to download Ruby binaries: Connection refused
```

**Causes**:
- No internet connection
- Firewall blocking
- URL not accessible
- Proxy issues

**Solutions**:

1. **Check Internet Connection**:
   ```bash
   ping google.com
   ```

2. **Test URL Directly**:
   ```bash
   curl -I https://github.com/oneclick/rubyinstaller2/releases/download/...
   ```

3. **Configure Proxy** (if behind proxy):
   ```properties
   # gradle.properties
   systemProp.http.proxyHost=proxy.company.com
   systemProp.http.proxyPort=8080
   systemProp.https.proxyHost=proxy.company.com
   systemProp.https.proxyPort=8080
   ```

4. **Manual Download**:
   - Download Ruby manually
   - Extract to `bearsampp-build/tmp/extract/ruby/<version>/`

---

#### Issue: RubyGems Download Failed

**Symptoms**:
```
Could not download RubyGems from: https://rubygems.org/downloads/...
```

**Causes**:
- Invalid URL in rubygems.properties
- RubyGems.org down
- Network issues

**Solutions**:

1. **Verify URL**:
   ```bash
   curl -I https://rubygems.org/downloads/rubygems-update-3.4.0.gem
   ```

2. **Update rubygems.properties**:
   ```properties
   # bin/ruby3.4.5/rubygems/rubygems.properties
   rubygems = https://rubygems.org/downloads/rubygems-update-3.4.0.gem
   ```

3. **Manual Download**:
   - Download gem file manually
   - Place in `bin/ruby3.4.5/rubygems/rubygems-update.gem`

---

### Extraction Issues

#### Issue: Extraction Failed

**Symptoms**:
```
7-Zip extraction failed with exit code: 2
```

**Causes**:
- Corrupted archive
- Insufficient disk space
- Permission issues

**Solutions**:

1. **Check Disk Space**:
   ```bash
   # Windows
   wmic logicaldisk get size,freespace,caption
   ```

2. **Verify Archive**:
   ```bash
   7z t archive.7z
   ```

3. **Re-download Archive**:
   ```bash
   # Delete cached archive
   del bearsampp-build\tmp\downloads\ruby\*.7z
   
   # Rebuild
   gradle release -PbundleVersion=3.4.5
   ```

4. **Check Permissions**:
   - Run as Administrator (Windows)
   - Check folder permissions

---

#### Issue: Ruby Directory Not Found

**Symptoms**:
```
Could not find Ruby directory in extracted archive
```

**Causes**:
- Archive structure different than expected
- Extraction incomplete
- Wrong archive downloaded

**Solutions**:

1. **Check Archive Structure**:
   ```bash
   7z l archive.7z
   ```

2. **Expected Structure**:
   ```
   rubyinstaller-3.4.5-x64/
   └── bin/
       └── ruby.exe
   ```

3. **Manual Extraction**:
   ```bash
   # Extract manually
   7z x archive.7z -o"bearsampp-build/tmp/extract/ruby/3.4.5"
   
   # Verify ruby.exe exists
   dir bearsampp-build\tmp\extract\ruby\3.4.5\bin\ruby.exe
   ```

---

### Installation Issues

#### Issue: RubyGems Installation Failed

**Symptoms**:
```
RubyGems installation failed with exit code: 1
```

**Causes**:
- Ruby not properly extracted
- install.bat script error
- Permission issues

**Solutions**:

1. **Verify Ruby Executable**:
   ```bash
   bearsampp-build\tmp\bundles_prep\tools\ruby\ruby3.4.5\bin\ruby.exe --version
   ```

2. **Check install.bat**:
   ```bash
   # Verify file exists
   dir bin\ruby3.4.5\rubygems\install.bat
   ```

3. **Run Manually**:
   ```bash
   cd bearsampp-build\tmp\bundles_prep\tools\ruby\ruby3.4.5\rubygems
   install.bat
   ```

4. **Check Logs**:
   - Look for error messages in console output
   - Enable debug logging: `gradle release --debug`

---

#### Issue: RubyGems Update Failed

**Symptoms**:
```
RubyGems update failed with exit code: 1
```

**Causes**:
- Network issues
- Incompatible RubyGems version
- Ruby installation incomplete

**Solutions**:

1. **Skip Update** (temporary):
   - Comment out update step in build.gradle
   - Use installed RubyGems version

2. **Manual Update**:
   ```bash
   cd bearsampp-build\tmp\bundles_prep\tools\ruby\ruby3.4.5\bin
   gem update --system
   ```

3. **Check RubyGems Version**:
   ```bash
   gem --version
   ```

---

### Packaging Issues

#### Issue: Archive Creation Failed

**Symptoms**:
```
7-Zip compression failed with exit code: 2
```

**Causes**:
- Insufficient disk space
- File in use
- Permission issues

**Solutions**:

1. **Check Disk Space**:
   ```bash
   # Need at least 500MB free
   wmic logicaldisk get size,freespace,caption
   ```

2. **Close Programs**:
   - Close any programs using Ruby files
   - Close file explorer windows

3. **Run as Administrator**:
   ```bash
   # Windows: Run PowerShell as Administrator
   gradle release -PbundleVersion=3.4.5
   ```

4. **Check Output Directory**:
   ```bash
   # Ensure directory exists and is writable
   mkdir bearsampp-build\tools\ruby\2025.8.16
   ```

---

#### Issue: Hash Generation Failed

**Symptoms**:
```
Archive not found for hashing: ...
```

**Causes**:
- Archive creation failed
- Archive deleted
- Wrong path

**Solutions**:

1. **Verify Archive Exists**:
   ```bash
   dir bearsampp-build\tools\ruby\2025.8.16\*.7z
   ```

2. **Check Archive Path**:
   - Verify `bundle.release` in build.properties
   - Verify `bundleVersion` is correct

3. **Rebuild**:
   ```bash
   gradle clean
   gradle release -PbundleVersion=3.4.5
   ```

---

### Path Issues

#### Issue: Paths Not Updated

**Symptoms**:
- Archive contains absolute paths
- Ruby scripts reference build directory

**Causes**:
- updateRubyPaths function not working
- Binary files being processed
- Encoding issues

**Solutions**:

1. **Verify Path Replacement**:
   ```bash
   # Extract archive
   7z x bearsampp-ruby-3.4.5-2025.8.16.7z
   
   # Check for absolute paths (should find none)
   grep -r "E:/Bearsampp-development" ruby3.4.5/bin/
   
   # Check for Bearsampp paths (should find many)
   grep -r "BEARSAMPP_LIN_PATH" ruby3.4.5/bin/
   ```

2. **Debug Path Replacement**:
   ```groovy
   // Add to updateRubyPaths function
   println "Processing file: ${file.name}"
   println "Original path: ${originalPath}"
   println "Replacement path: ${bearsamppPath}"
   ```

3. **Manual Path Replacement**:
   ```bash
   # Use sed or PowerShell to replace paths
   (Get-Content file.bat) -replace 'E:/Bearsampp-development/...', '~BEARSAMPP_LIN_PATH~/tools/ruby/ruby3.4.5' | Set-Content file.bat
   ```

---

### Configuration Issues

#### Issue: Invalid build.properties

**Symptoms**:
```
Missing required properties: bundle.name
```

**Causes**:
- Property missing
- Property empty
- Syntax error

**Solutions**:

1. **Validate Properties**:
   ```bash
   gradle validateProperties
   ```

2. **Check Required Properties**:
   ```properties
   bundle.name=ruby
   bundle.release=2025.8.16
   bundle.type=tools
   bundle.format=7z
   ```

3. **Fix Syntax**:
   - No spaces around `=`
   - No quotes around values
   - One property per line

---

#### Issue: Invalid rubygems.properties

**Symptoms**:
```
RubyGems URL not found in rubygems.properties
```

**Causes**:
- Property missing
- Wrong property name
- File not found

**Solutions**:

1. **Check File Exists**:
   ```bash
   dir bin\ruby3.4.5\rubygems\rubygems.properties
   ```

2. **Verify Content**:
   ```properties
   rubygems = https://rubygems.org/downloads/rubygems-update-3.4.0.gem
   ```

3. **Property Name**:
   - Must be exactly `rubygems`
   - Case-sensitive

---

## Debugging Techniques

### Enable Debug Logging

```bash
gradle release -PbundleVersion=3.4.5 --debug > build.log 2>&1
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

### Task-Specific Debugging

```bash
# Run only specific task
gradle releaseBuild -PbundleVersion=3.4.5 --info

# Skip tasks
gradle release -PbundleVersion=3.4.5 -x generateHashes
```

### Add Debug Output

```groovy
// Add to build.gradle
tasks.register('debugInfo') {
    doLast {
        println "Project Dir: ${projectDir}"
        println "Build Base: ${buildBasePath}"
        println "Bundle Name: ${bundleName}"
        println "Bundle Version: ${project.findProperty('bundleVersion')}"
    }
}
```

## Performance Issues

### Issue: Build Too Slow

**Symptoms**:
- Build takes more than 10 minutes
- Download/extraction very slow

**Solutions**:

1. **Enable Gradle Daemon**:
   ```properties
   # gradle.properties
   org.gradle.daemon=true
   ```

2. **Enable Parallel Execution**:
   ```properties
   # gradle.properties
   org.gradle.parallel=true
   ```

3. **Increase Memory**:
   ```properties
   # gradle.properties
   org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
   ```

4. **Use Build Cache**:
   ```properties
   # gradle.properties
   org.gradle.caching=true
   ```

5. **Check Network Speed**:
   ```bash
   # Test download speed
   curl -o test.zip https://speed.hetzner.de/100MB.bin
   ```

---

### Issue: High Memory Usage

**Symptoms**:
- OutOfMemoryError
- System becomes unresponsive

**Solutions**:

1. **Increase Heap Size**:
   ```properties
   # gradle.properties
   org.gradle.jvmargs=-Xmx4g
   ```

2. **Close Other Programs**:
   - Close browsers
   - Close IDEs
   - Close other memory-intensive programs

3. **Use 64-bit Java**:
   ```bash
   java -version
   # Should show "64-Bit"
   ```

---

## Error Messages

### Common Error Messages and Solutions

| Error Message | Cause | Solution |
|---------------|-------|----------|
| `bundleVersion property not set` | Version not specified | Add `-PbundleVersion=3.4.5` |
| `Bundle folder not found` | Version directory missing | Create `bin/ruby<version>/` |
| `ruby.exe not found` | Download/extraction failed | Check download and extraction |
| `7-Zip not found` | 7-Zip not installed | Install 7-Zip |
| `Archive not found for hashing` | Packaging failed | Check packaging step |
| `RubyGems installation failed` | Installation error | Check install.bat and logs |
| `Could not fetch ruby.properties` | Network error | Check internet connection |
| `Prepared folder not found` | Build not run | Run `releaseBuild` first |

---

## Getting Help

### Before Asking for Help

1. **Check this guide** for your specific issue
2. **Enable debug logging** and review output
3. **Try clean build**: `gradle clean release`
4. **Verify environment**: `gradle verify`
5. **Check documentation** in `.gradle-docs/`

### Information to Provide

When asking for help, provide:

1. **Gradle version**: `gradle --version`
2. **Java version**: `java -version`
3. **OS version**: `ver` (Windows) or `uname -a` (Linux/Mac)
4. **Command used**: e.g., `gradle release -PbundleVersion=3.4.5`
5. **Error message**: Full error output
6. **Debug log**: `gradle release --debug > build.log 2>&1`
7. **build.properties**: Content of file
8. **Directory structure**: `tree bin` or `ls -R bin`

### Where to Get Help

1. **Documentation**:
   - [BUILD_TASKS.md](.gradle-docs/BUILD_TASKS.md)
   - [DEVELOPMENT.md](.gradle-docs/DEVELOPMENT.md)
   - [GRADLE_MIGRATION.md](.gradle-docs/GRADLE_MIGRATION.md)

2. **GitHub Issues**:
   - https://github.com/Bearsampp/module-ruby/issues

3. **Bearsampp Community**:
   - https://bearsampp.com/

4. **Gradle Forums**:
   - https://discuss.gradle.org/

---

## Preventive Measures

### Best Practices

1. **Always use version control**:
   ```bash
   git status
   git commit -m "Before build"
   ```

2. **Verify before building**:
   ```bash
   gradle verify
   ```

3. **Use clean builds**:
   ```bash
   gradle clean release
   ```

4. **Keep backups**:
   - Backup `bin/` directory
   - Backup `build.properties`

5. **Test in isolation**:
   - Use separate build directory
   - Don't modify source files during build

### Regular Maintenance

1. **Update Gradle**:
   ```bash
   gradle wrapper --gradle-version 7.6
   ```

2. **Update Java**:
   - Keep JDK up to date
   - Use LTS versions

3. **Clean old builds**:
   ```bash
   gradle clean
   # Or manually delete bearsampp-build/tmp/
   ```

4. **Verify checksums**:
   ```bash
   # Verify downloaded files
   Get-FileHash file.7z -Algorithm SHA256
   ```

---

## See Also

- [BUILD_TASKS.md](BUILD_TASKS.md) - Task reference
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide
- [GRADLE_MIGRATION.md](GRADLE_MIGRATION.md) - Migration guide
